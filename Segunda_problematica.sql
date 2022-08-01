CREATE VIEW customer_VIEW AS
select customer_id as 'ID cliente',
branch_id as 'n° de sucursal',
customer_name as nombre,
customer_surname as 'apellido',
customer_DNI as DNI,
CAST (ROUND((julianday('now') - Julianday(cliente.dob))/365) AS INT) as edad
FROM cliente WHERE edad>40
ORDER BY  
		(CASE 
         WHEN nombre ='Anne' or nombre='Tyler' THEN edad
		 END) ASC, DNI ASC;

INSERT INTO cliente (customer_name,customer_surname,customer_DNI,branch_id,dob)
VALUES
	('Lois','Stout',47730534,80,'1984-07-07'),
	('Hall','Mcconell',52055464,45,'1968-04-30'),
	('Hilel','Mclean',43625213,77,'1993-03-28'),
	('Jin','Cooley',21207908,96,'1959-08-24'),
	('Gabriel','Harmon',57063950,27,'1976-04-01');

UPDATE cliente set branch_id = 10 
WHERE customer_id in (SELECT customer_id  FROM cliente ORDER BY customer_id desc limit 5);

DELETE FROM cliente 
WHERE customer_name= 'Noel' and customer_surname= 'David';

SELECT loan_type from prestamo ORDER BY loan_total DESC limit 1;