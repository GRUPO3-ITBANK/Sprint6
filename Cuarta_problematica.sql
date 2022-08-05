--Listar la cantidad de clientes por nombre de sucursal ordenando de mayor a menor
SELECT branch_name AS Sucursal, CAST (count(cliente.branch_id) AS INTEGER) AS Cant_clientes
FROM cliente 
LEFT JOIN sucursal ON sucursal.branch_id = cliente.branch_id
GROUP BY cliente.branch_id ORDER BY Cant_clientes DESC;

--Obtener la cantidad de empleados por cliente por sucursal en un número real