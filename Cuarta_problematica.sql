--Listar la cantidad de clientes por nombre de sucursal ordenando de mayor a menor
SELECT branch_name AS Sucursal, CAST (count(cliente.branch_id) AS INTEGER) AS Cant_clientes
FROM cliente 
LEFT JOIN sucursal ON sucursal.branch_id = cliente.branch_id
GROUP BY cliente.branch_id ORDER BY Cant_clientes DESC;

--Obtener la cantidad de empleados por cliente por sucursal en un número real
SELECT s.branch_id,
(CAST((SELECT COUNT(*) FROM empleado e WHERE e.branch_id = s.branch_id)AS REAL)/
CAST ((SELECT COUNT(*) FROM cliente c WHERE c.branch_id = s.branch_id) AS REAL))	
AS 'empleados por cliente'
FROM sucursal s;

--Obtener la cantidad de tarjetas de crédito por tipo por sucursal
SELECT s.branch_id, 
(SELECT COUNT(*) FROM tarjetas t INNER JOIN cliente c 
ON c.customer_id = t.tarjeta_cliente_id 
WHERE t.tarjeta_tipo='CREDITO' AND c.customer_id=t.tarjeta_cliente_id
AND s.branch_id = c.branch_id) 
as 'cantidad de tarjetas de credito'
FROM sucursal s INNER JOIN cliente c ON c.branch_id=s.branch_id;

--Obtener el promedio de créditos otorgado por sucursal
SELECT s.branch_id, 
(SELECT AVG(loan_total) FROM prestamo p INNER JOIN 
cliente c ON c.customer_id = p.customer_id
AND c.branch_id = s.branch_id) as 'Promedio de prestamos'
FROM sucursal s;

--La información de las cuentas resulta critica para la compañía, 
--por eso es necesario crear una tabla denominada “auditoria_cuenta” 
--para guardar los datos movimientos, con los siguientes campos: old_id, 
--new_id, old_balance, new_balance, old_iban, new_iban, old_type, 
--new_type, user_action, created_at
create table auditoria_cuenta(
	old_id, 
	new_id,
	old_balance,
	new_balance,
	old_iban,
	new_iban,
	old_type,
	new_type,
	user_action,
	created_at
);

--Crear un trigger que después de actualizar en la tabla cuentas los 
--campos balance, IBAN o tipo de cuenta registre en la tabla auditoria
CREATE TRIGGER actualizar_cuentas
AFTER UPDATE OF balance, IBAN, cuenta_tipo
ON cuenta
BEGIN
	INSERT INTO auditoria_cuenta(
		old_id, 
		new_id,
		old_balance,
		new_balance,
		old_iban,
		new_iban,
		old_type,
		new_type,
		user_action,
		created_at)
	VALUES
		(OLD.account_id,
		 NEW.account_id,
		 OLD.balance,
		 NEW.balance,
		 old.iban,
		 new.iban,
		 OLD.cuenta_tipo,
		 NEW.cuenta_tipo,
		 'Update',
		 CURRENT_TIMESTAMP);
END;

--Restar $100 a las cuentas 10,11,12,13,14
UPDATE cuenta  SET balance= balance - 100 
where account_id=10 OR account_id=11 OR account_id=12 OR account_id=13
OR account_id=14;

--Mediante índices mejorar la performance la búsqueda de clientes por DNI
CREATE INDEX cliente_dni
ON cliente(customer_DNI);


--Crear la tabla “movimientos” con los campos de identificación del 
--movimiento, número de cuenta, monto, tipo de operación y hora
create table movimientos(
	movimiento_id INTEGER PRIMARY KEY,
	movimiento_num_cta INTEGER,
	movimiento_monto FLOAT,
	movimiento_tipo_operacion TEXT,
	movimiento_hora time);

--Mediante el uso de transacciones, hacer una transferencia de 1000$ desde la 
--cuenta 200 a la cuenta 400 o Registrar el movimiento en la tabla movimientos
END TRANSACTION;
BEGIN TRANSACTION;

UPDATE cuenta
SET balance = balance - 1000
WHERE account_id = 200;

UPDATE cuenta
SET balance = balance + 1000
WHERE account_id = 400;

INSERT INTO movimientos (movimiento_num_cta,movimiento_monto
,movimiento_tipo_operacion,movimiento_hora)
VALUES (200,1000,'transferencia -',time('now'));

INSERT INTO movimientos (movimiento_num_cta,movimiento_monto
,movimiento_tipo_operacion,movimiento_hora)
VALUES (400,1000,'transferencia +',time('now'));

COMMIT;

END TRANSACTION;
--En caso de no poder realizar la operación de forma completa, realizar un ROLLBACK