-- =========================================
-- 1. LIMPEZA
-- =========================================
DROP TABLE IF EXISTS matricula;
DROP TABLE IF EXISTS aluno;
DROP TABLE IF EXISTS disciplina;
DROP TABLE IF EXISTS numeros;

-- =========================================
-- 2. TABELAS
-- =========================================
CREATE TABLE aluno (
    id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    curso VARCHAR(50) NOT NULL,
    cidade VARCHAR(50) NOT NULL,
    ano_ingresso INT NOT NULL
);

CREATE TABLE disciplina (
    id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    departamento VARCHAR(50) NOT NULL,
    carga_horaria INT NOT NULL
);

CREATE TABLE matricula (
    id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    aluno_id BIGINT NOT NULL,
    disciplina_id BIGINT NOT NULL,
    semestre VARCHAR(10) NOT NULL,
    nota DECIMAL(4,2),
    frequencia DECIMAL(5,2),
    situacao VARCHAR(20) NOT NULL,
    CONSTRAINT fk_matricula_aluno FOREIGN KEY (aluno_id) REFERENCES aluno(id),
    CONSTRAINT fk_matricula_disciplina FOREIGN KEY (disciplina_id) REFERENCES disciplina(id)
);

-- =========================================
-- 3. TABELA AUXILIAR NUMEROS
-- Gera valores de 0 até 999999
-- =========================================
DROP TABLE IF EXISTS numeros;
CREATE TABLE numeros (
    n INT NOT NULL PRIMARY KEY
);

DROP TABLE IF EXISTS digitos;
CREATE TABLE digitos (
    d INT NOT NULL PRIMARY KEY
);

INSERT INTO digitos (d)
VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);

INSERT INTO numeros (n)
SELECT
      d0.d
    + d1.d * 10
    + d2.d * 100
    + d3.d * 1000
    + d4.d * 10000
    + d5.d * 100000 AS n
FROM digitos d0
CROSS JOIN digitos d1
CROSS JOIN digitos d2
CROSS JOIN digitos d3
CROSS JOIN digitos d4
CROSS JOIN digitos d5
ORDER BY n;

DROP TABLE IF EXISTS digitos;

-- =========================================
-- 4. POPULAR DISCIPLINAS (200)
-- =========================================
INSERT INTO disciplina (nome, departamento, carga_horaria)
SELECT
    CONCAT('Disciplina ', n + 1),
    CASE
        WHEN MOD(n, 5) = 0 THEN 'Computacao'
        WHEN MOD(n, 5) = 1 THEN 'Engenharia'
        WHEN MOD(n, 5) = 2 THEN 'Matematica'
        WHEN MOD(n, 5) = 3 THEN 'Fisica'
        ELSE 'Administracao'
    END,
    CASE
        WHEN MOD(n, 3) = 0 THEN 40
        WHEN MOD(n, 3) = 1 THEN 60
        ELSE 80
    END
FROM numeros
WHERE n < 200
ORDER BY n;

-- =========================================
-- 5. POPULAR ALUNOS (100.000)
-- =========================================
INSERT INTO aluno (nome, curso, cidade, ano_ingresso)
SELECT
    CONCAT('Aluno ', n + 1),
    CASE
        WHEN MOD(n, 10) = 0 THEN 'Computacao'
        WHEN MOD(n, 10) = 1 THEN 'Engenharia'
        WHEN MOD(n, 10) = 2 THEN 'Administracao'
        WHEN MOD(n, 10) = 3 THEN 'Direito'
        WHEN MOD(n, 10) = 4 THEN 'Medicina'
        WHEN MOD(n, 10) = 5 THEN 'Arquitetura'
        WHEN MOD(n, 10) = 6 THEN 'Psicologia'
        WHEN MOD(n, 10) = 7 THEN 'Economia'
        WHEN MOD(n, 10) = 8 THEN 'Fisica'
        ELSE 'Matematica'
    END,
    CASE
        WHEN MOD(n, 8) = 0 THEN 'Maringa'
        WHEN MOD(n, 8) = 1 THEN 'Curitiba'
        WHEN MOD(n, 8) = 2 THEN 'Londrina'
        WHEN MOD(n, 8) = 3 THEN 'Cascavel'
        WHEN MOD(n, 8) = 4 THEN 'Ponta Grossa'
        WHEN MOD(n, 8) = 5 THEN 'Foz do Iguacu'
        WHEN MOD(n, 8) = 6 THEN 'Arapongas'
        ELSE 'Apucarana'
    END,
    2018 + MOD(n, 8)
FROM numeros
WHERE n < 100000
ORDER BY n;

-- =========================================
-- 6. POPULAR MATRICULAS (1.000.000)
-- =========================================
INSERT INTO matricula (aluno_id, disciplina_id, semestre, nota, frequencia, situacao)
SELECT
    MOD(n, 100000) + 1 AS aluno_id,
    MOD(n, 200) + 1 AS disciplina_id,
    CASE
        WHEN MOD(n, 4) = 0 THEN '2024-1'
        WHEN MOD(n, 4) = 1 THEN '2024-2'
        WHEN MOD(n, 4) = 2 THEN '2025-1'
        ELSE '2025-2'
    END,
    ROUND(RAND() * 10, 2) AS nota,
    ROUND(50 + RAND() * 50, 2) AS frequencia,
    CASE
        WHEN MOD(n, 10) = 0 THEN 'Reprovado'
        WHEN MOD(n, 10) = 1 THEN 'Trancado'
        ELSE 'Aprovado'
    END
FROM numeros
WHERE n < 1000000
ORDER BY n;

-- =========================================
-- 7. INDICES IMPORTANTES
-- =========================================
CREATE INDEX idx_aluno_curso ON aluno(curso);
CREATE INDEX idx_aluno_cidade ON aluno(cidade);
CREATE INDEX idx_matricula_aluno_id ON matricula(aluno_id);
CREATE INDEX idx_matricula_disciplina_id ON matricula(disciplina_id);
CREATE INDEX idx_matricula_situacao ON matricula(situacao);

-- =========================================
-- 8. ATUALIZAR ESTATISTICAS
-- =========================================
ANALYZE TABLE aluno, disciplina, matricula, numeros;

-- =========================================
-- 9. CONFERENCIA
-- =========================================
SELECT COUNT(*) AS total_numeros FROM numeros;
SELECT COUNT(*) AS total_disciplinas FROM disciplina;
SELECT COUNT(*) AS total_alunos FROM aluno;
SELECT COUNT(*) AS total_matriculas FROM matricula;

EXPLAIN ANALYZE
SELECT * FROM aluno;

EXPLAIN ANALYZE
SELECT a.id, a.nome, m.disciplina_id, m.situacao
FROM aluno a
JOIN matricula m ON a.id = m.aluno_id
WHERE a.curso = 'Computacao'
  AND m.situacao = 'Aprovado';

explain analyze
SELECT *
FROM aluno
WHERE nome LIKE '%10';



---



CREATE TABLE contas (
    id INT PRIMARY KEY,
    titular VARCHAR(100),
    saldo DECIMAL(10,2)
);

INSERT INTO contas (id, titular, saldo) VALUES
(1, 'Ana', 1000.00),
(2, 'Bruno', 500.00);

SELECT * FROM contas;

START TRANSACTION;

UPDATE contas
SET saldo = saldo - 200
WHERE id = 1;

UPDATE contas
SET saldo = saldo + 200
WHERE id = 2;

COMMIT;


START TRANSACTION;

UPDATE contas
SET saldo = saldo - 300
WHERE id = 1;

-- aqui você decide cancelar
ROLLBACK;


USE meubanco;
START TRANSACTION;
SELECT * FROM contas WHERE id = 1 FOR UPDATE;
UPDATE contas SET saldo = saldo - 200 WHERE id = 1;

SELECT * FROM disciplina;
