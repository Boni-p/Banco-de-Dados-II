# Lista 01 

## Questão 1

Liste todos os alunos cadastrados.
### SELECT * from aluno

## Questão 2

Mostre apenas o nome e o curso dos alunos.
### SELECT aluno.nome, aluno.curso FROM aluno

## Questão 3

Liste os alunos do curso de Computacao.
### SELECT aluno.nome from aluno WHERE curso = 'Computacao'

## Questão 4

Liste os alunos que moram em Maringa.
### SELECT aluno.nome from aluno WHERE cidade = 'Maringa'

## Questão 5

Mostre os alunos ordenados pelo nome em ordem alfabética.
### SELECT * from aluno ORDER BY nome

## Questão 6

Mostre os alunos ordenados pelo ano de ingresso, do mais antigo para o mais recente.
### SELECT * from aluno ORder by ano_ingresso

## Questão 7

Liste os alunos que ingressaram a partir de 2022.
### SELECT * FROM aluno WHERE ano_ingresso >= 2022


## Questão 8

Liste os alunos cujo nome começa com a letra A.
### SELECT * from aluno where aluno.nome LIKE 'A%'

## Questão 9

Liste os alunos dos cursos Computacao ou Engenharia.
### SELECT * from aluno where aluno.curso = 'Computacao' or aluno.curso = 'Engenharia'

## Questão 10

Liste as disciplinas com carga horária entre 60 e 80 horas.
### SELECT * from disciplina WHERE 60 <= disciplina.carga_horaria <= 80

## Questão 11

Conte quantos alunos existem cadastrados.
### SELECT COUNT(*) FROM aluno

## Questão 12

Calcule a média das notas da tabela matricula.
### SELECT ROUND(AVG(nota)) from matricula

## Questão 13

Mostre a maior nota registrada.
### SELECT MAX(nota) from matricula

## Questão 14

Mostre a menor nota registrada.
### SELECT MIN(nota) from matricula

## Questão 15

Calcule a soma das cargas horárias de todas as disciplinas.
### SELECT SUM(carga_horaria) from disciplina

## Questão 16

Mostre a quantidade de alunos por curso.
### SELECT curso, COUNT(*) from aluno  GROUP by curso

## Questão 17

Mostre a quantidade de alunos por cidade.
### SELECT cidade, COUNT(*) from aluno  GROUP by cidade

## Questão 18

Mostre a média das notas por situação da matrícula.
### SELECT situacao, ROUND(AVG(nota),2) FROM matricula GROUP BY situacao
    

## Questão 19

Mostre quantas matrículas existem por semestre.
### SELECT semestre, COUNT(*) FROM matricula GROUP BY semestre


## Questão 20

Mostre os cursos que possuem mais de 1 aluno cadastrado.
### SELECT curso, COUNT(*) FROM aluno GROUP BY curso HAVING COUNT(*)> 1

## Questão 21

Liste o nome dos alunos e a situação de suas matrículas.
### SELECT a.nome, m.situacao FROM aluno a JOIN matricula m ON a.id = m.aluno_id

## Questão 22

Liste o nome dos alunos e o nome das disciplinas em que estão matriculados.
### SELECT a.nome, d.nome FROM aluno a JOIN matricula m ON a.id = m.aluno_id JOIN disciplina d ON d.id = m.disciplina_id

## Questão 23

Liste o nome do aluno, o nome da disciplina e a nota.
### SELECT a.nome, d.nome, m.nota 
### FROM matricula m 
### JOIN aluno a ON a.id = m.aluno_id 
### JOIN disciplina d ON d.id = m.disciplina_id

## Questão 24

Liste apenas os alunos matriculados em disciplinas do departamento Computacao.
### SELECT DISTINCT a.nome 
### FROM aluno a 
### JOIN matricula m ON a.id = m.aluno_id 
### JOIN disciplina d ON d.id = m.disciplina_id 
### WHERE d.departamento = 'Computacao'

## Questão 25

Mostre o nome dos alunos que tiveram matrícula com situação Reprovado.
### SELECT DISTINCT a.nome 
### FROM aluno a 
### JOIN matricula m ON a.id = m.aluno_id 
### WHERE m.situacao = 'Reprovado'

## Questão 26

Mostre o nome dos alunos de Computacao e as disciplinas que eles cursaram.
### SELECT DISTINCT a.nome, d.nome 
### FROM aluno a 
### JOIN matricula m ON a.id = m.aluno_id 
### JOIN disciplina d ON d.id = m.disciplina_id 
### WHERE a.curso = 'Computacao';

## Questão 27

Mostre a média de notas por aluno.
### SELECT a.nome, ROUND(AVG(m.nota), 2) 
### FROM aluno a 
### JOIN matricula m ON a.id = m.aluno_id 
### GROUP BY a.id, a.nome;

## Questão 28

Mostre a quantidade de disciplinas cursadas por cada aluno.
### SELECT a.nome, COUNT(DISTINCT m.disciplina_id) 
### FROM aluno a 
### JOIN matricula m ON a.id = m.aluno_id 
### GROUP BY a.id, a.nome;

## Questão 29

Liste os alunos cuja média de notas foi maior que 8.
### SELECT a.nome, ROUND(AVG(m.nota), 2) 
### FROM aluno a JOIN matricula m ON a.id = m.aluno_id 
### GROUP BY a.id, a.nome 
### HAVING AVG(m.nota) > 8;

## Questão 30

Mostre o departamento e a quantidade de matrículas em disciplinas de cada departamento.
### SELECT d.departamento, COUNT(*) 
### FROM matricula m 
### JOIN disciplina d ON d.id = m.disciplina_id 
### GROUP BY d.departamento;