--QUESTAO 1 - Liste todos os alunos cadastrados.
--SELECT * from aluno

--QUESTAO 2 - Mostre apenas o nome e o curso dos alunos.
--SELECT aluno.nome, aluno.curso FROM aluno

--QUESTAO 3 - Liste os alunos do curso de Computacao.
--SELECT aluno.nome from aluno WHERE curso = 'Computacao'

--QUESTAO 4 - Liste os alunos que moram em Maringa
--SELECT aluno.nome from aluno WHERE cidade = 'Maringa'

--QUESTAO 5 - Mostre os alunos ordenados pelo nome em ordem alfabética.
--SELECT * from aluno ORDER BY nome

--QUESTAO 6 - Mostre os alunos ordenados pelo ano de ingresso, do mais antigo para o mais recente.
--SELECT * from aluno ORder by ano_ingresso

--QUESTAO 7 - Liste os alunos que ingressaram a partir de 2022.
--SELECT * FROM aluno WHERE ano_ingresso >= 2022

--QUESTAO 8 - Liste os alunos cujo nome começa com a letra A.
--SELECT * from aluno where aluno.nome LIKE 'A%'

--QUESTAO 9 - Liste os alunos dos cursos Computacao ou Engenharia.
--SELECT * from aluno where aluno.curso = 'Computacao' or aluno.curso = 'Engenharia'

--QUESTAO 10 - Liste as disciplinas com carga horária entre 60 e 80 horas.
--SELECT * from disciplina WHERE 60 <= disciplina.carga_horaria <= 80

--QUESTAO 11 - Conte quantos alunos existem cadastrados.
--SELECT COUNT(*) FROM aluno

--QUESTAO 12 - Calcule a média das notas da tabela matricula.
--SELECT ROUND(AVG(nota)) from matricula

--QUESTAO 13 - Mostre a maior nota registrada.
--SELECT MAX(nota) from matricula

--QUESTAO 14 - Mostre a menor nota registrada.
--SELECT MIN(nota) from matricula

--QUESTAO 15 - Calcule a soma das cargas horárias de todas as disciplinas.
--SELECT SUM(carga_horaria) from disciplina

--QUESTAO 16 - Mostre a quantidade de alunos por curso.
SELECT curso, COUNT(*) from aluno  GROUP by curso
