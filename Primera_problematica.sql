CREATE TABLE tipos_clientes(
	tipo_id INTEGER NOT NULL PRIMARY KEY ,
	tipo_nombre VARCHAR(50) NOT NULL);
	

INSERT INTO tipos_clientes (tipo_nombre) 
VALUES
('CLASSIC'),
('GOLD'),
('BLACK');


CREATE TABLE tipos_cuentas(
	tipo_id INTEGER NOT NULL PRIMARY KEY ,
	tipo_cuenta VARCHAR(50) NOT NULL);
	
INSERT INTO tipos_cuentas (tipo_cuenta) 
VALUES
('Caja de ahorro en pesos'),
('Caja de ahorro en dólares'),
('Cuenta Corriente');

CREATE TABLE marcas_tarjetas(
	marca_id INTEGER NOT NULL PRIMARY KEY ,
	marca_tarjeta VARCHAR(50) NOT NULL);
	
INSERT INTO marcas_tarjetas (marca_tarjeta) 
VALUES
('MASTERCARD'),
('VISA'),
('AMERICAN EXPRESS');

CREATE TABLE tarjetas(
	tarjeta_id INTEGER NOT NULL PRIMARY KEY,
	tarjeta_numero VARCHAR(20) NOT NULL,
	tarjeta_cvv INTEGER(3) NOT NULL,
	tarjeta_fecha_otorgamiento DATE NOT NULL,
	tarjeta_fecha_expiracion DATE NOT NULL,
	tarjeta_tipo VARCHAR(25) NOT NULL);

ALTER TABLE tarjetas ADD tarjeta_marca_id INTEGER REFERENCES marcas_tarjetas(marca_id);
ALTER TABLE tarjetas ADD tarjeta_cliente_id INTEGER REFERENCES cliente(customer_id);

CREATE TABLE direcciones(
	direccion_id INTEGER NOT NULL PRIMARY KEY,
	direccion_calle VARCHAR(50) NOT NULL,
	direccion_numero INTEGER(8) NOT NULL,
	direccion_ciudad VARCHAR(60) NOT NULL,
	direccion_provincia VARCHAR(60) NOT NULL,
	direccion_pais VARCHAR (60) NOT NULL);