# Concorrência, bloqueios e problemas clássicos em transações

## 6. Atividade prática

### Atividade: simular concorrência, bloqueios, espera e inconsistências em transações

#### Etapa 1. Criar o banco de teste

```sql
DROP TABLE IF EXISTS contas;

CREATE TABLE contas (
    id INT PRIMARY KEY,
    titular VARCHAR(100),
    saldo DECIMAL(10,2)
);

INSERT INTO contas (id, titular, saldo) VALUES
(1, 'Ana', 1000.00),
(2, 'Bruno', 500.00),
(3, 'Carlos', 300.00),
(4, 'Daniela', 800.00);

SELECT * FROM contas;
```

**Pergunta 1**  
Qual é a finalidade de manter dados iniciais conhecidos antes dos testes de concorrência?
### Saber quais são os dados que serão manipulados para que se possa validar as instruções após serem executadas 
### além disso, para garantir a consistência, isolamento e reprodutibilidade dos resultados e evitar corromper os dados após as instruções

**Pergunta 2**  
Por que é importante que a tabela esteja em um estado consistente antes do início dos experimentos?
### Para que não haja inconsistencia nos dados antes das instruções, conseguindo definir onde podem ocorrer falhas ou dados orfãos após a execução de uma sequencia de instruções, por exemplo   

---

#### Etapa 2. Testar bloqueio com `FOR UPDATE`

Abra duas sessões.

### Sessão 1

```sql
START TRANSACTION;

SELECT * FROM contas
WHERE id = 1
FOR UPDATE;

UPDATE contas
SET saldo = saldo - 100
WHERE id = 1;
```

Não execute `COMMIT` ainda.

### Sessão 2

```sql
START TRANSACTION;

UPDATE contas
SET saldo = saldo + 50
WHERE id = 1;
```

Agora volte para a Sessão 1 e execute:

```sql
COMMIT;
```

Depois finalize a Sessão 2 com:

```sql
COMMIT;
```

**Pergunta 3**  
O que aconteceu com a operação realizada na Sessão 2?
### A Sessão 2 ficou congelada em estado de espera. O terminal não concluiu o comando UPDATE imediatamente, permanecendo travado até que a Sessão 1 executasse o comando COMMIT

**Pergunta 4**  
Por que a segunda sessão precisou aguardar?
### Porque a sessão 1 adquiriu um Bloqueio Exclusivo sobre a linha com id = 1 ao executar o FOR UPDATE. Como a Sessão 2 tentou modificar a mesma linha, o SGBD forçou a esperar até que o bloqueio da sessão 1 fosse liberado.

**Pergunta 5**  
Qual é a função do comando `FOR UPDATE` nesse experimento?
### Congela as linhas selecionadas até que a operação em andamento finalize com o COMMIT para garantir que nao haja race condition (outra instrução altere o mesmo campo simultaneamente) 

---

#### Etapa 3. Testar acesso concorrente a registros diferentes

Abra duas sessões.

### Sessão 1

```sql
START TRANSACTION;

UPDATE contas
SET saldo = saldo - 50
WHERE id = 1;
```

### Sessão 2

```sql
START TRANSACTION;

UPDATE contas
SET saldo = saldo + 70
WHERE id = 4;
```

Finalize ambas com:

```sql
COMMIT;
```

Depois consulte:

```sql
SELECT * FROM contas;
```

**Pergunta 6**  
Por que, nesse caso, as duas transações tendem a coexistir sem espera significativa?
### Porque elas estão manipulando linhas diferentes da tabela

**Pergunta 7**  
O que esse comportamento revela sobre bloqueios em nível de linha?
### granularidade, bloqueio em nível de linha, podendo haver concorrencia desde que nao estejam alterando o mesmo valor da tabela

---

#### Etapa 4. Testar leitura durante transação não finalizada

### Sessão 1

```sql
START TRANSACTION;

UPDATE contas
SET saldo = saldo - 200
WHERE id = 2;
```

Sem confirmar ainda.

### Sessão 2

```sql
SELECT * FROM contas WHERE id = 2;
```

Depois volte para a Sessão 1 e execute:

```sql
ROLLBACK;
```

**Pergunta 8**  
Qual era o objetivo de consultar o mesmo registro em outra sessão antes do `COMMIT`?
### Testar se haveria uma leitura suja (realizada através da outra sessão)

**Pergunta 9**  
Como esse experimento se relaciona com o conceito de isolamento?
### S sessão 2 continuará vendo o saldo antigo até que a sessão 1 dê COMMIT. Como a sessão 1 deu ROLLBACK, os dados provisórios sumiram e a consistência foi mantida

---

#### Etapa 5. Testar repetição de leitura

### Sessão 1

```sql
START TRANSACTION;

SELECT * FROM contas WHERE id = 3;
```

### Sessão 2

```sql
START TRANSACTION;

UPDATE contas
SET saldo = saldo + 100
WHERE id = 3;

COMMIT;
```

Agora volte para a Sessão 1 e repita:

```sql
SELECT * FROM contas WHERE id = 3;
```

Finalize a Sessão 1:

```sql
COMMIT;
```

**Pergunta 10**  
O valor lido na Sessão 1 permaneceu o mesmo ou mudou?
### Permaneceu o mesmo, ignorando o commit da sessão 2

**Pergunta 11**  
Que tipo de fenômeno esse teste procura identificar?
### Leitura Não Repetível, que ocorre quando uma transação lê o mesmo registro duas vezes e encontra valores diferentes, porque outra transação alterou e confirmou os dados nesse intervalo

---

#### Etapa 6. Simular atualização concorrente sobre o mesmo dado

Abra duas sessões.

### Sessão 1

```sql
START TRANSACTION;

SELECT * FROM contas WHERE id = 4;

UPDATE contas
SET saldo = saldo - 100
WHERE id = 4;
```

### Sessão 2

```sql
START TRANSACTION;

SELECT * FROM contas WHERE id = 4;

UPDATE contas
SET saldo = saldo - 200
WHERE id = 4;
```

Finalize ambas com `COMMIT`, observando a ordem de execução e depois consulte:

```sql
SELECT * FROM contas WHERE id = 4;
```

**Pergunta 12**  
Por que operações concorrentes sobre o mesmo registro exigem maior controle?
### Pois há risco de colisão, onde duas operações estão tentando acessar e alterar o mesmo recurso, o resultado de uma irá ser usado na operação da outra

**Pergunta 13**  
Que inconsistência pode surgir quando duas transações tentam atualizar o mesmo dado quase ao mesmo tempo?
### Uma pode reescrever o dado mas a outra ainda pode estar acessando o dado antigo, causando inconsistência do dado (lost update)

---

#### Etapa 7. Testar espera por lock

### Sessão 1

```sql
START TRANSACTION;

SELECT * FROM contas WHERE id = 2 FOR UPDATE;
```

Mantenha a transação aberta.

### Sessão 2

```sql
START TRANSACTION;

UPDATE contas
SET saldo = saldo + 10
WHERE id = 2;
```

Agora, depois de observar a espera, volte para a Sessão 1 e execute:

```sql
COMMIT;
```

**Pergunta 14**  
Qual evidência mostra que havia um bloqueio ativo sobre o registro?
### O FOR UPDATE no final do select da sessão 1

**Pergunta 15**  
Por que a liberação do lock depende do fim da transação?
### Por conta da propriedade de Isolamento e Atomicidade, para que um dado que está sendo manipulado não seja alterado por outro

---

#### Etapa 8. Testar bloqueio com duas leituras de atualização

### Sessão 1

```sql
START TRANSACTION;

SELECT * FROM contas WHERE id = 1 FOR UPDATE;
```

### Sessão 2

```sql
START TRANSACTION;

SELECT * FROM contas WHERE id = 1 FOR UPDATE;
```

Depois finalize a Sessão 1 com:

```sql
COMMIT;
```

**Pergunta 16**  
Por que a segunda leitura com `FOR UPDATE` não pôde prosseguir imediatamente?
### Pois já há um FOR UPDATE aberto na sessão 1

**Pergunta 17**  
Em que essa situação difere de uma consulta `SELECT` comum?
### No SELECT comum a informação é consultada sem alteração na tabela, apenas mostrando os dados, que podem ser alterados a qualquer instante

---

#### Etapa 9. Simular risco de atualização perdida

Considere o seguinte cenário conceitual:

- saldo atual da conta 1 = 1000
- Transação A lê saldo 1000 e decide subtrair 100
- Transação B lê saldo 1000 e decide subtrair 200
- A grava 900
- B grava 800

**Pergunta 18**  
Qual seria o saldo correto ao final, caso ambas as operações fossem consideradas corretamente?
### 700

**Pergunta 19**  
Por que o resultado 800 caracteriza uma atualização perdida?
### Pois houve uma alteração do saldo por parte de A que não foi atualizado para ser lido por B, que leu o dado antigo, gerando inconsistência

---

#### Etapa 10. Testar inserções concorrentes em outra tabela

Crie a tabela:

```sql
DROP TABLE IF EXISTS log_operacoes;

CREATE TABLE log_operacoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(200)
);
```

Abra duas sessões.

### Sessão 1

```sql
START TRANSACTION;

INSERT INTO log_operacoes (descricao)
VALUES ('Operacao realizada pela sessao 1');
```

### Sessão 2

```sql
START TRANSACTION;

INSERT INTO log_operacoes (descricao)
VALUES ('Operacao realizada pela sessao 2');
```

Finalize ambas com `COMMIT` e consulte:

```sql
SELECT * FROM log_operacoes;
```

**Pergunta 20**  
Por que inserções em linhas diferentes nem sempre geram conflito direto?
### Porque as operações criam novos registros físicos no disco com identificadores únicos e independentes, elas não disputam o mesmo espaço ou o mesmo bloco de dados previamente alterado

**Pergunta 21**  
O que esse experimento mostra sobre concorrência quando não há disputa pelo mesmo registro?
### Quando os usuários estão adicionando dados novos ou trabalhando em ramificações diferentes, mostrando o paralelismo

---

#### Etapa 11. Simular bloqueio prolongado

### Sessão 1

```sql
START TRANSACTION;

SELECT * FROM contas WHERE id = 3 FOR UPDATE;
```

Não finalize imediatamente.

### Sessão 2

```sql
START TRANSACTION;

UPDATE contas
SET saldo = saldo + 20
WHERE id = 3;
```

**Pergunta 22**  
Quais impactos um bloqueio mantido por muito tempo pode causar em um sistema real?
### Pode haver o acumulo de operações querendo acessar um mesmo dado que está em lock, ocupando memória e gerando gargalos

**Pergunta 23**  
Por que transações longas tendem a ser indesejáveis em ambientes concorrentes?
### Pois pode haver travamentos no fluxo e conflitos de acessos entre as operações

---

#### Etapa 12. Consultar o estado final

Depois de finalizar todos os testes, execute:

```sql
SELECT * FROM contas;
SELECT * FROM log_operacoes;
```

**Pergunta 24**  
Como verificar se o banco permaneceu consistente após todos os cenários executados?
### Somar todos os valores de movimentação que sabemos que foram commitados com sucesso ao saldo inicial, cruzando os dados com a tabela de logs (log_operacoes) e checando se o saldo final atual bate exatamente com o esperado

**Pergunta 25**  
Por que a análise final dos dados é importante após testes de concorrência?
### Para identificar se foram respestadas as normas do protocolo ACID

---

## 7. Atividade dissertativa

### Questão 26
Explique o que é concorrência em banco de dados.
### É a capacidade do sistema de permitir que múltiplos usuários ou aplicações acessem, leiam e modifiquem os mesmos dados ao mesmo tempo

### Questão 27
Descreva o papel dos bloqueios no controle de concorrência.
### Os bloqueios (locks) são mecanismos internos usados pelo banco para sinalizar que um dado (linha ou tabela) está sendo usado por uma transação específica, impedindo que outras transações façam modificações no mesmo instante, ordenando o acesso de maneira segura e evitando conflitos

### Questão 28
Explique a diferença entre acessar registros iguais e registros diferentes em transações simultâneas.
### Acessar registros iguais em transações simultaneas envolve o risco de haver lost update, ou seja, uma transação pode efetuar uma operação sobre um dado que nao será lido pela proxima transação, que irá manipular o dado antigo gerando inconsistencias no banco, tendo de recorrer a mecanismos como lock wait
### Já em registros diferentes, permite o bloqueio de linha, reduzindo o risco, pois os acessos são sobre dados diferentes

### Questão 29
Por que `FOR UPDATE` é importante em determinadas operações críticas?
### Para congelar a linha para que nenhuma outra operação possa manipular o conteudo, evitando inconsistencias 

### Questão 30
O que significa dizer que uma transação ficou esperando outra liberar um recurso?
### Que a transação ficou em lock wait, esperando a operação que usou o FOR UPDATE dar COMMIT para que possa usar o dado 

### Questão 31
Explique o conceito de atualização perdida.
### Quando duas operações diferentes estão manipulando o mesmo dado e uma não ve que a outra fez alterações, usando dados não atualizados, havendo conflitos e inconsistencias

### Questão 32
Descreva por que o isolamento é essencial em sistemas multiusuário.
### Para que haja Atomicidade e Consistencia, por exemplo, para que dois usuarios nao comprem o mesmo acento no cinema ou no aviao

### Questão 33
Explique como uma leitura pode ser afetada por outra transação ainda não concluída.
### Dependendo do nível de isolamento, a leitura pode sofrer uma Leitura Suja (enxergar dados fictícios que serão cancelados via rollback), uma Leitura Não Repetível (ver dados mudarem no meio da sua própria transação) ou Leitura Fantasma (novas linhas surgirem em uma consulta de intervalo)

### Questão 34
Por que transações longas podem prejudicar o desempenho de sistemas concorrentes?
### Pois podem gerar gargalos de trafego, devido a geração de uma fila de processos suspensos aguardando um dado que está retido

### Questão 35
Qual é a relação entre concorrência e consistência dos dados?
### Quanto maior a concorrência, maior o risco de destruir a consistência

### Questão 36
Descreva um exemplo real em que duas transações possam disputar o mesmo dado.
### Dois torcedores tentando comprar exatamente a última cadeira disponível para a final de um campeonato de futebol no mesmo segundo, ou duas transferências automáticas debitando dinheiro de uma mesma conta conjunta de forma simultânea

### Questão 37
Explique por que nem toda operação simultânea gera conflito.
### Porque operações puras de leitura (CONSULTAS) NÃO ALTERAM O ESTADO DO BANCO e podem ser feitas por milhares de pessoas ao mesmo tempo, tal qual modificações que afetam tabelas ou linhas distintas não compartilham dependências lógicas

### Questão 38
Como o banco de dados contribui para impedir que alterações simultâneas corrompam os dados?
### Mecanismos de Lock e registros (logs) garantindo o protocolo ACID 

### Questão 39
Explique o que aconteceria em um sistema bancário sem mecanismos de lock.
### Por exemplo, usuários conseguiriam sacar o mesmo dinheiro múltiplas vezes em caixas diferentes

### Questão 40
Qual a importância de observar a ordem de execução das transações em testes práticos?
### Mapear a ordem de execução das transações para ter conhecimento do estado atual em que um dado deve estar, avaliando se estão ocorrendo inconsistencias ou não

---

## 8. Atividade prática com enunciado formal

### Enunciado
Um sistema bancário multiusuário precisa permitir operações simultâneas sem comprometer a integridade dos dados. Para isso, implemente testes em SQL que demonstrem:

- bloqueio explícito de registros com `FOR UPDATE`
- espera de uma transação por outra
- diferença entre concorrência em registros iguais e em registros diferentes
- risco de atualização perdida
- análise da consistência final dos dados após execuções concorrentes

### Objetivos
Ao final da atividade, o estudante deve ser capaz de:

- compreender o conceito de concorrência
- identificar situações de bloqueio
- analisar o efeito de locks em duas sessões simultâneas
- perceber quando há disputa por recursos
- discutir riscos de inconsistência em operações concorrentes
- relacionar concorrência com integridade e desempenho

```sql


-- Risco da Atualização Perdida (Lost Update)

CREATE TABLE contas (
    id INT PRIMARY KEY,
    titular VARCHAR(50),
    saldo DECIMAL(15, 2)
);

INSERT INTO contas (id, titular, saldo) VALUES 
(1, 'Alice', 1000.00),
(2, 'Bob', 1000.00);

--Sessão 1

START TRANSACTION;

SELECT saldo FROM contas WHERE id = 1;

--Sessão 2 

START TRANSACTION;

SELECT saldo FROM contas WHERE id = 1;

--Volta a sessão 1
UPDATE contas
SET saldo = 1100
WHERE id = 1;

COMMIT;

-- Volta a Sessão 2
UPDATE contas
SET saldo = 1100
WHERE id = 1;

COMMIT;

-- (Resultado: O saldo final será 1100. A atualização da Sessão 1 foi perdida e sobrescrita pela Sessão 2).



-- Prevenindo Inconsistências com FOR UPDATE (Wait)
--Sessão 1
START TRANSACTION;

SELECT saldo FROM contas WHERE id = 1 FOR UPDATE;

--Sessão 2
START TRANSACTION;

SELECT saldo FROM contas WHERE id = 1 FOR UPDATE;

--Sessão 2 ficará travado aguardando a liberação do recurso

-- na Sessão 1
UPDATE contas
SET saldo = 1100
WHERE id = 1;

COMMIT;

-- a Sessão 2 será destravada e exibirá o resultado do SELECT

-- agora, na sessão 2 
UPDATE contas
SET saldo = 1200
WHERE id = 1;

COMMIT;

-- O saldo final será 1200. A integridade foi garantida porque uma sessão esperou a outra


-- Concorrência em Registros Diferentes (Sem Disputa)

-- sessão 1
START TRANSACTION;

SELECT * FROM contas WHERE id = 1 FOR UPDATE;

-- sessão 2
START TRANSACTION;

SELECT * FROM contas WHERE id = 2 FOR UPDATE;

-- Nenhuma sessão fica travada, pois estão acessando IDs diferentes

-- Voltando na sessão 1
UPDATE contas
SET saldo = 900
WHERE id = 1;

COMMIT;

-- Finalizando a sessão 2
--sessão 2:
UPDATE contas
SET saldo = 1500
WHERE id = 2;

COMMIT;

-- As atualizações ocorrem simultaneamente, preservando o máximo de desempenho do banco de dados

```

### Tarefa final
Com base nos testes realizados, produza um texto explicando:

- o que é concorrência em banco de dados
### A concorrência é a capacidade de um sistema de banco de dados permitir que múltiplos usuários ou sessões leiam, insiram e atualizem dados ao mesmo tempo

- como funcionam os locks
### Quando uma transação avisa que vai modificar um registro (usando um FOR UPDATE ou executando um UPDATE direto), o banco de dados coloca uma "trava de segurança" temporária naquela linha específica
### Enquanto a trava estiver ativa: Nenhuma outra transação pode alterar ou colocar sua própria trava naquele mesmo registro
### Liberação: A trava só é removida quando a transação original é finalizada, seja confirmando as mudanças (COMMIT) ou desfazendo-as (ROLLBACK)

- por que algumas transações precisam esperar
### A espera é a operação que o banco de dados faz para manter a integridade. Por exemplo, quando a Sessão 2 tentou bloquear a conta da Alice que já estava bloqueada pela Sessão 1, o banco de dados colocou a Sessão 2 em uma fila de espera. Se o sistema não forçasse essa espera e permitisse a execução simultânea irrestrita no mesmo recurso, os dados colidiriam, resultando em cálculos matemáticos errados

- o que é atualização perdida
### É uma falha de consistência que ocorre quando a concorrência não é devidamente controlada. Ocorre quando:

### duas transações leem o mesmo valor inicial (ex: Saldo = 1000)

### ambas fazem cálculos em memória baseadas nesse valor lido (ex: 1000 + 100 = 1100)

### ambas gravam o resultado final de volta no banco
### o resultado é que a transação que gravar por último sobrescreve e apaga (perde) o trabalho da primeira, fazendo com que depósitos ou saques simplesmente "desapareçam" da conta do cliente

- por que o isolamento é importante
### O isolamento garante que transações concorrentes funcionem como se estivessem sozinhas no sistema
### garante que uma transação não enxergue o trabalho incompleto de outra. Sem isolamento, a Sessão B poderia ler um saldo que a Sessão A acabou de alterar, mas que a Sessão A logo em seguida decide cancelar (ROLLBACK). Se a Sessão B basear seus cálculos nesse dado "fantasma"

- como o banco preserva a consistência em acessos simultâneos
### O banco bloqueia apenas a linha exata que está sendo alterada (a conta da Alice), deixando todas as outras linhas (a conta do Bob) totalmente livres para outras pessoas operarem simultaneamente.

### Ao detectar duas sessões querendo alterar a mesma linha, ele atua como árbitro, pausando uma e dando prioridade à outra, resolvendo o conflito cronologicamente.

### O banco garante que um conjunto de operações só se torne oficial e visível para todos os outros usuários após o COMMIT. Até lá, o banco preserva o estado anterior dos dados para quem precisar apenas ler a informação.

---

## 9. Questão integradora

### Questão 41
Considerando todos os experimentos realizados, explique de forma integrada como concorrência, bloqueios e isolamento atuam juntos para evitar inconsistências no banco de dados.
### Para garantir a integridade dos dados quando múltiplos usuários acessam o sistema simultaneamente, o SGBD usa:
### - o controle de concorrencia para gerenciar a execução de multiplas transações ao mesmo tempo para que se dois usuarios tentem alterar o mesmo dado(comprar a mesma poltrona no filme) ao mesmo tempo o sistema ira salvar apenas umas das ações 
### - usa o bloqueio pra quando uma transação precisa alterar um dado, ele bloqueia aquela linha da tabela para que nenhuma outra operação possa alterar ela
### - observação: podem haver os casos de bloqueio Exclusivo (escritas simultaneas sobre o mesmo dado (bloqueia a outra operação)) e bloqueio Compartilhado (leitura (SELECT) ou linhas diferentes)
### - o isolamento garante que uma operação feita não seja vista pela outra até que seja finalizada

---

## 10. Desafio adicional

### Questão 42
Adapte os testes realizados para um sistema de estoque em que dois usuários tentam vender o mesmo produto simultaneamente. Explique quais riscos existem e como o banco pode evitá-los.
### Dois usuários tentam vender simultaneamente a última unidade de um produto (ex: id_produto = 99, quantidade = 1)
### Ambos os processos consultam o estoque, veem que há 1 unidade disponível, aprovam a venda e reduzem o valor. O estoque final fica negativo (-1) ou o mesmo produto físico é vendido de forma duplicada para dois clientes diferentes
### solução: Implementar um bloqueio pessimista no ato da checagem

```sql
START TRANSACTION;
-- O FOR UPDATE impede que o segundo vendedor leia o estoque até o primeiro decidir se vende ou desiste
SELECT quantidade FROM estoque WHERE id_produto = 99 FOR UPDATE;
-- Sistema valida: quantidade > 0? Se sim, prossegue:
UPDATE estoque SET quantidade = quantidade - 1 WHERE id_produto = 99;
COMMIT;
```

### Questão 43
Adapte os testes para um sistema de matrícula acadêmica, em que duas pessoas tentam ocupar a última vaga da mesma disciplina ao mesmo tempo.
### Dois estudantes clicam juntos para ocupar a última vaga de uma disciplina (id_disciplina = 10, vagas_disponiveis = 1)
### Ambas as sessões leem vagas_disponiveis = 1. Ambas inserem o registro na tabela de matrículas e diminuem a vaga para 0. O limite da turma é estourado sem o consentimento da coordenação


### Questão 44
Explique como você organizaria um experimento prático no VS Code com duas sessões para demonstrar espera por lock a outros estudantes.
### Exemplo da atividade pratica 8

### Questão 45
Compare um cenário com controle de concorrência e outro sem controle de concorrência, destacando os impactos sobre a confiabilidade dos dados.
### um sistema de venda de ingressos para um show, onde restam apenas 2 ingressos disponíveis e 2 usuários clicam no botão "Comprar" exatamente no mesmo tempo
### sem controle um usuário poderia comprar os dois ingressos, sobrando 0 ingressos e outro poderia comprar 1, ficando com -1 ingressos
### com controle de concorrencia, o sgbd pegaria a transação do primeiro usuario, congelaria a do segundo, apos o primeiro usuario ter comprado os dois ingressos, finaliza a transação e atualiza a quantidade de ingressos no estoque, como ficou com zero ingressos, da ROLLBACK na transação do segundo