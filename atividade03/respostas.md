Pergunta 1
Qual é o objetivo da tabela contas neste cenário prático?
### Armazenar os dados das contas dos usuários (id, nome do titular e saldo)

Pergunta 2
Quais são os saldos iniciais de cada titular antes da execução das transações?

### (1, 'Ana', 1000.00),
### (2, 'Bruno', 500.00),
### (3, 'Carlos', 300.00),
### (4, 'Daniela', 800.00);

Pergunta 3
O que aconteceu com os saldos após o COMMIT?
### Houve uma transação de 100.00 feita entre duas linhas da tabela

Pergunta 4
Por que as duas instruções UPDATE devem fazer parte da mesma transação?
### Para garantir atomicidade, consistência e isolamento das transações para que o sistema não de roolback

Pergunta 5
Por que os valores não foram alterados ao final?
### Pois o sistema efetuou um roolback

Pergunta 6
Em quais situações reais o uso de ROLLBACK seria essencial?
### Quando uma transação não pode ser concluída com sucesso e precisa ser descartada

Pergunta 7
Por que a transação foi desfeita neste caso?
### Por causa do uso do rollback

Pergunta 8
Qual problema de integridade poderia ocorrer se essa transação fosse confirmada?
### usuário com o id 3 ficou com saldo negativo

Pergunta 9
Qual conta foi debitada e quais contas foram creditadas?
### debitadas : 4, creditadas: 1, 2

Pergunta 10
Por que esse conjunto de operações também deve ser tratado como uma única transação?
### Pois todas as instruções fazem parte de uma unica operação (transferencias entre as contas)

### dessa forma as propriedades do protocolo ACID são mantidas 

Pergunta 11
Qual era o objetivo de observar o valor da conta em outra sessão antes do COMMIT?
### verificar se a sessão 2 pode ver a transação sendo feita na sessão 1 enquanto a transação ainda está em andamento

Pergunta 12
Como esse teste se relaciona com o conceito de isolamento?
### pois outra sessão não pode visualizar uma transação feita por outra sessão enquanto essa não for finalizada, caso contrário, caso houvessem quaisquer alterações feitas na transação pela sessão original, outras sessões poderiam ver os dados ainda em andamento e não finalizados, o que não garatiria a consistência dos dados

Pergunta 13
O que aconteceu com a segunda transação?
### ficou em estado de espera e não foi finalizada

Pergunta 14
Por que ela precisou esperar?
### pois a sessão 1 iniciou uma transação e não finalizou 

Pergunta 15
Qual a função do FOR UPDATE?
### bloquear as linhas de uma transação 

Pergunta 16
Por que nesse caso as transações tendem a não disputar o mesmo recurso?
### pois não dependem uma da outra para serem executadas e não estão alterando a mesma linha da tabela

Pergunta 17
O que esse teste mostra sobre concorrência em linhas diferentes da tabela?
### O SGBD gerencia o banco para que comando que não estão interferindo na mesma linha possam ser executadas em paralelo, ambas podem utilizar o mesmo recurso compartilhado se não estiverem interferindo no mesmo espaço

Pergunta 18
Qual é a importância de registrar movimentações além de atualizar os saldos?
### saber quais transações foram efetuadas mantendo em um histórico 

Pergunta 19
Por que o INSERT na tabela movimentacoes deve estar na mesma transação dos UPDATEs?
### Para que os dados da transação não sejam perdidos e haja inconsistencia, causando um rollback

Pergunta 20
O que poderia acontecer se o histórico fosse gravado, mas os saldos não fossem atualizados, ou vice-versa?
### Haveria inconsistencia dos dados, o sistema seria gravado mas os dados não seriam atualizados ou vice-versa

Pergunta 21
O que o ROLLBACK garantiu nesse cenário?
### Que as alterações feitas nas contas 1 e 4 pela transação não fossem efetuadas

Pergunta 22
Como esse teste demonstra a propriedade de atomicidade?
### Demonstra o efeito tudo ou nada da atomicidade, caso não pudessem ser efetuadas todas as etapas da transação, então o estado é revertido imediatamente, tratando todo o bloco como uma unica operação

Pergunta 23
Como verificar se o banco permaneceu consistente após todas as operações realizadas?
### Somar se o saldo total ainda permanece coerente (deve ser o mesmo antes e depois das operações)

### Verificar os registros na tabela de movimentações 

Pergunta 24
Por que a consistência do banco depende não apenas dos comandos SQL, mas também da forma como eles são agrupados em transações?
### Pois o agrupamento assegura que o banco só transite de um estado consistente para outro, garantindo a atomicidade e tratando todos os comandos como um unico evento, sem isso, o banco ficaria vulnerável a falhas que criariam dados orfãos ou saldos incorretos

Questão 25
Explique o que é uma transação em banco de dados.
### Sequência de uma ou mais operações de banco de dados (inserções, atualizações ou exclusões). Ela deve ser executada de forma atômica: ou todas as operações são concluídas com sucesso, ou nenhuma delas é aplicada

Questão 26
Descreva a diferença entre COMMIT e ROLLBACK.
### COMMIT: Finaliza a transação com sucesso, tornando todas as alterações permanentes no banco de dados e visíveis para outros usuários
### ROLLBACK: Aborta a transação, desfazendo todas as alterações realizadas desde o início da transação, retornando o banco ao seu estado original

Questão 27
Explique por que uma transferência bancária deve ser tratada como transação.
### Porque ela envolve múltiplas etapas interdependentes, p.e, debitar o valor da conta A, creditar na conta B e registrar a movimentação. Se o sistema falhar após o débito, mas antes do crédito, o dinheiro "desapareceria". A transação garante que essas etapas ocorram juntas ou não ocorram de forma alguma

Questão 28
O que pode acontecer se duas transações alterarem o mesmo dado ao mesmo tempo sem controle de concorrência?
### Podem ocorrer anomalias como a atualização perdida, onde uma transação sobrescreve os dados da outra sem considerar as mudanças feitas, resultando em dados incorretos e perda de integridade

Questão 29
Qual a relação entre transações e as propriedades ACID?
### São os critérios que garantem que as transações sejam processadas de forma confiável, definiondo o padrão de segurança que o banco de dados deve manter

Questão 30
Explique o significado da propriedade de atomicidade no contexto de uma operação bancária.
### Significa que o processo (ex: transferência) é indivisível. Se você estiver transferindo R$ 100,00, não é permitido que o banco processe a saída do dinheiro sem processar a entrada no destino

Questão 31
Explique o que significa dizer que uma transação preserva a consistência do banco de dados.
### Significa que a transação leva o banco de um estado válido para outro estado válido, mantendo a integridade do sistema

Questão 32
Descreva o papel do isolamento em ambientes com múltiplos usuários acessando o mesmo banco.
### O isolamento garante que transações simultâneas não interfiram umas nas outras, evitando que estados intermediários de uma transação sejam vistos por outras

Questão 33
Explique a importância da durabilidade após a execução de um COMMIT.
### A durabilidade garante que, uma vez que o COMMIT foi confirmado, as alterações persistam mesmo em caso de falha, os dados são gravados em disco

Questão 34
O que é controle de concorrência e por que ele é necessário?
### É o mecanismo que gerencia o acesso simultâneo de vários usuários aos mesmos dados, necessário para evitar inconsistências e garantir as propriedades ACID sejam mantidas em sistemas multiusuários 

Questão 35
Explique a função do lock em transações concorrentes.
### Serve para "reservar" um recurso (como uma linha ou tabela). Enquanto uma transação segura o lock para escrita, outras transações ficam impedidas de alterar aquele dado até que o lock seja liberado pelo COMMIT ou ROLLBACK

Questão 36
Descreva um exemplo prático em que o FOR UPDATE seja necessário.
### Em um sistema de reserva de assentos de avião, ao selecionar um lugar, o comando SELECT ... FOR UPDATE bloqueia aquela poltrona específica para o usuário enquanto ele finaliza o pagamento, impedindo que outra pessoa a compre simultaneamente

Questão 37
O que é uma atualização perdida (lost update)?
### quando duas transações leem o mesmo dado, ambas o alteram e a segunda transação a fazer o COMMIT sobrescreve a primeira, fazendo com que a alteração da primeira transação seja perdida

Questão 38
Explique por que nem toda leitura concorrente gera problema, mas algumas atualizações simultâneas sim.
### Leituras são operações passivas que não alteram o estado do dado, então múltiplos usuários podem ler a mesma informação sem conflito
### Atualizações são destrutivas/modificadoras, se feitas ao mesmo tempo no mesmo registro, elas competem para definir qual será o valor final

Questão 39
Qual é a importância de registrar operações em uma tabela de histórico dentro da mesma transação?
### Garante a rastreabilidade, se o histórico for gravado na mesma transação que a mudança de saldo, garante que toda movimentação possui uma explicação

Questão 40
Em um sistema acadêmico, cite um exemplo de operação que deveria ser tratada como transação.
### A matrícula de um aluno em uma disciplina, onde o sistema precisa: verificar se há vagas, decrementar o numero de vagas disponível da turma, inserir o aluno, e aumentar o numero de alunos inscritos na disciplina, caso alguma dessas operações falhe, nada será gravado.

Questão 41
Em um sistema de estoque, cite um exemplo de falha que poderia justificar o uso de ROLLBACK.
### Se durante a venda de 10 unidades de um produto, o sistema descobrir no meio do processo que o estoque físico está zerado ou que o cartão do cliente foi recusado, ele deve dar um ROLLBACK para que as unidades já baixadas retornem ao estoque disponível

Questão 42
Como o processamento de transações contribui para a confiabilidade de sistemas de informação?
### Ele fornece uma camada de segurança que protege os dados contra falhas de hardware, erros de software e conflitos de usuários, garantindo que a informação acessada seja integra e atualizada

Questão 43
Considerando todos os experimentos realizados, explique de forma integrada como atomicidade, consistência, isolamento e durabilidade atuam em conjunto no processamento de transações.
### A Atomicidade garante que todos os comandos (ex: retirada de saldo de uma conta e registrar em um histórico) sejam tratados como um único bloco, se qualquer falha acontecer no meio do caminho, ela garante que o banco não pare em um estado fragmentado, ("tudo ou nada")

### A Consistência garante que se as politicas como atomicidade e isolamento forem executadas da maneira correta, os dados estarão coerentes com o que se é esperado, e que não haverá qualquer inconsistência (ex: "saldo total não pode ser diferente da soma dos saldos e não pode mudar"), também mantém as restrições para validar as operações (p.e chaves estrangeiras).

### O Isolamento garante a privacidade das operações e que nenhuma operação pode acessar um dado ou alterá-lo enquanto outra operação estiver processando ele, usando mecanismos como o LOCK, por exemplo.

### A Durabilidade garante que uma vez que o sistema confirma a transação (COMMIT) essas alterações sejam salvas no disco e estejam lá mesmo que o sistema falhe em algum momento 

Questão 44
Adapte o exemplo bancário para um sistema de matrícula em disciplinas, em que uma transação deva:

verificar vaga disponível,
reduzir a quantidade de vagas,
registrar a matrícula do aluno,
Explique por que essas operações devem ocorrer na mesma transação.
### Se a verificação de vaga e a redução ocorrerem fora de uma transação, dois alunos podem consultar o banco ao mesmo tempo, ver que resta uma vaga, e ambos fizerem a matricula, sem o isolamento da transação, o sistema decrementaria a vaga duas vezes, resultando em um total de vagas negativo e um aluno matriculado indevidamente

Questão 45
Adapte o exemplo para um sistema de estoque e vendas, explicando quais operações devem ser agrupadas para evitar inconsistências.
### Verificação de Saldo em Estoque: Confirmar se o produto está disponível na quantidade desejada
### -> evitar inconsistencia onde um mesmo produto seja vendido para dois usuário diferentes
### Reserva/Baixa de Estoque (UPDATE): Decrementar a quantidade vendida do inventário
### -> evitar que caso uma compra de um produto falhe, o produto não suma do estoque
### Criação do Pedido (INSERT): Gerar o registro da venda com os itens, valores e dados do cliente
### -> se uma transação atomica falhar, o rollback devolve automaticamente os itens ao estoque, tornando-os disponiveis novamente
### Registro Financeiro/Pagamento: Vincular o status do pagamento ou gerar a fatura