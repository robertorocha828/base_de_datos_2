/* Nombre: Roberto Rochaalter 
Fecha: 14/04/2026
Tema: Transacciones - Triggers
Docente: Ing.Christian Rivadeneira*/


--tabals 

CREATE TABLE empleados (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    salario NUMERIC(10, 2) NOT NULL,
    fecha_contratacion DATE NOT NULL,
    activo BOOLEAN DEFAULT TRUE
);

-- Insertar algunos registros
INSERT INTO empleados (nombre, salario, fecha_contratacion, activo) VALUES
('Juan Pérez', 3000.00, '2020-01-15', TRUE),
('Ana Gómez', 3500.00, '2019-03-22', TRUE),
('Carlos Ruiz', 4000.00, '2018-07-10', FALSE),
('Laura Díaz', 3200.00, '2021-05-30', TRUE),
('Pedro Sánchez', 2800.00, '2022-02-14', TRUE);


/* Ingresar dos numeros e imprimir el resultado*/
do $$
declare
    numero1 int := 5;
    numero2 int := 6;
	resultado int := numero1 + numero2;
begin
    raise notice 'La suma es: %', resultado;
end $$;


/* Ejercio 2: Calcular la edad de un esrudiante a partir de su fecha de nacimineto */
do $$
declare
	fecha_nacimiento date := '1999-07-30';
	edad int;
	mes int;
	dia int;
begin
	edad := extract(year from age (fecha_nacimiento));
	mes := extract(month from age (fecha_nacimiento));
	dia := extract(day from age (fecha_nacimiento));
	raise notice 'La edad del estudiante es % anios, % meses y % dias',edad,mes,dia;
end $$;


/* 3 control de flujo
Ejercicio 1: usar una estructura condicional IF para determinar si un estudinate es mayro de edad */

do $$
declare
	edad int := 10;
begin
	if edad > 18 then
		raise notice 'El estudiante es mayor de edad';
	else
		raise notice 'El estudiante es menor de edad';
	end if;
end $$;


/* 4. Funciones
 * Ejercicio 1: crear una funcion que devuelva el nombre de un estudiante dado su ID
 */
create or replace function obtener_empleado(id_empleado int) return varchar as $$
declare 
	nombre_empleado varchar(100);
begin
	select nombre into nombre_empleado from empleados where id_empleado = id;
	return nombre_empleado;
end;
$$ language plpgsql;





create or replace function obtener_empleado(id_empleado int) returns table(nombres text, salarios numeric) as $$
begin
	return query select nombres, salarios from empleados where id = id_empleado;
end;
$$ language plpgsql;
-- llamar a la funcion
select * from obtener_empleado(4);








--01
create or replace function saludar(nombre varchar)
returns varchar
as $$
begin
	return 'Hola, ' || nombre || '!';
end ;
$$ language plpgsql;

-- uso
select saludar ('Cristian Rivadeneira');
select saludar ('Carlos Sanchez');
select saludar ('Estefania G');
select saludar ('Erick');



	
	


