--Seleccionar las cuentas con saldo negativo

SELECT account_id FROM cuenta WHERE balance < 0;


--Seleccionar el nombre, apellido y edad de los clientes que tengan en el
--apellido la letra Z

SELECT customer_name as nombre, customer_surname as apellido,
CAST (ROUND((julianday('now') - Julianday(cliente.dob))/365) AS INT) as edad
FROM cliente WHERE apellido like '%z%';


--Seleccionar el nombre, apellido, edad y nombre de sucursal de las personas
--cuyo nombre sea “Brendan” y el resultado ordenarlo por nombre de sucursal

SELECT customer_name as nombre, customer_surname as apellido,
CAST (ROUND((julianday('now') - Julianday(cliente.dob))/365) AS INT) as edad,
branch_id as sucursal
FROM cliente WHERE nombre='Brendan' ORDER BY sucursal;


--Seleccionar de la tabla de préstamos, los préstamos con un importe mayor
--a $80.000 y los préstamos prendarios utilizando la unión de
--tablas/consultas (recordar que en las bases de datos la moneda se guarda
--como integer, en este caso con 2 centavos)

SELECT loan_id as 'Id de prestamo',cast(loan_total as float)/100 as valor,
loan_type as 'Tipo de prestamo',loan_date as 'fecha de prestamo',
customer_id as 'Id de cliente'
from prestamo 
WHERE valor > 80000 OR loan_type='PRENDARIO'
order by valor;


--Seleccionar los prestamos cuyo importe sea mayor que el importe medio de
--todos los prestamos

SELECT * FROM prestamo WHERE loan_total>(SELECT AVG(loan_total) FROM prestamo);


--Contar la cantidad de clientes menores a 50 años

SELECT COUNT(*) FROM cliente WHERE CAST 
(ROUND((julianday('now') - Julianday(cliente.dob))/365) AS INT) < 50;


--Seleccionar las primeras 5 cuentas con saldo mayor a 8.000$

SELECT account_id,cast(balance as float)/100 AS saldo  
FROM cuenta WHERE saldo > 8000 
LIMIT 5;


--Seleccionar los préstamos que tengan fecha en abril, junio y agosto,
--ordenándolos por importe

SELECT * FROM prestamo 
WHERE strftime('%m',loan_date) = '04' OR 
strftime('%m',loan_date) = '06' or 
strftime('%m',loan_date) = '08';


--Obtener el importe total de los prestamos agrupados por tipo de préstamos.
--Por cada tipo de préstamo de la tabla préstamo, calcular la suma de sus
--importes. Renombrar la columna como loan_total_accu

SELECT loan_type,cast((SUM(loan_total))as float)/100 as
loan_total_accu
FROM prestamo GROUP BY loan_type;