--- Etapa 1
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

--- Etapa 2
START TRANSACTION;

UPDATE contas
SET saldo = saldo - 100
WHERE id = 1;

UPDATE contas
SET saldo = saldo + 100
WHERE id = 2;

COMMIT;

--- Etapa 3
START TRANSACTION;

UPDATE contas
SET saldo = saldo - 50
WHERE id = 2;

UPDATE contas
SET saldo = saldo + 50
WHERE id = 3;

ROLLBACK;

START TRANSACTION;

UPDATE contas
SET saldo = saldo - 2000
WHERE id = 3;

SELECT * FROM contas WHERE id = 3;

ROLLBACK;

START TRANSACTION;

UPDATE contas
SET saldo = saldo - 100
WHERE id = 4;

UPDATE contas
SET saldo = saldo + 60
WHERE id = 1;

UPDATE contas
SET saldo = saldo + 40
WHERE id = 2;

COMMIT;

SELECT * FROM contas;

START TRANSACTION;

UPDATE contas
SET saldo = saldo - 150
WHERE id = 1;


ROLLBACK;


START TRANSACTION;

SELECT * FROM contas WHERE id = 1 FOR UPDATE;

UPDATE contas
SET saldo = saldo - 200
WHERE id = 1;

COMMIT;


DROP TABLE IF EXISTS movimentacoes;

CREATE TABLE movimentacoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    conta_origem INT,
    conta_destino INT,
    valor DECIMAL(10,2),
    data_movimentacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

START TRANSACTION;

UPDATE contas
SET saldo = saldo - 120
WHERE id = 2;

UPDATE contas
SET saldo = saldo + 120
WHERE id = 3;

INSERT INTO movimentacoes (conta_origem, conta_destino, valor)
VALUES (2, 3, 120.00);

COMMIT;


SELECT * FROM contas;
SELECT * FROM movimentacoes;

START TRANSACTION;

UPDATE contas
SET saldo = saldo - 80
WHERE id = 1;

UPDATE contas
SET saldo = saldo + 80
WHERE id = 4;

ROLLBACK;