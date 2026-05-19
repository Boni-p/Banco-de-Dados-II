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

START TRANSACTION;

UPDATE contas
SET saldo = saldo + 50
WHERE id = 1;

COMMIT;

SELECT CONNECTION_ID(), @@autocommit;

SHOW CREATE TABLE contas;