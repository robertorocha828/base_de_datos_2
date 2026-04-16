/* Nombre: Roberto Rochaalter 
Fecha: 16/04/2026
Tema: 
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







/*Enunciado
Crear una funcion que determine si una persona es:
menor de edad <18
adulto (18-64) 
adulto mayor (65+)*/

create or replace function clasificar_edad(edad int) returns text as $$
begin
	if edad < 18 then
		return 'Menor de edad';
	elsif edad between 18 and 64 then
		return 'Adulto';
	else
		return 'Adulto mayor';
	end if;
end;
$$ language plpgsql

--llamar a la funcion 
select clasificar_edad(20)

-- Estado - votaciones
create or replace function estado_votacion(edad int) returns text as $$
begin
	if edad < 16 then
		return 'No se encuentra habilitado para sufragar';
	elseif > 65 then
		return 'Habilitado pero opcional';

	else
		return 'habilitado para sufragar ';
	end if;
end;
$$ language plpgsql

--llamar a la funcion 
select estado_votacion(20) as estado



/*EJERCICIO: CASE WHEN THEN ELSE END AS
 */
create or replace function categorizar_edad_case (edad int) returns text as $$
begin
	return case 
			when edad < 18 then 'Menor de edad'
			when edad between 18 and 64 then 'Adulto'
			else 'Adulto mayor'
			end;
end;
$$ language plpgsql

-- llmar a la funcion
select categorizar_edad_case(17)


/* > 7 reprobado
 * 7 - 8 bueno
 * 9 - 10 exlente 
 */
	
	create or replace function estado_notas(nota numeric) returns text as $$
	begin
		return case
				when nota < 7 then 'Reprobado'
				when nota between 7 and 8 then 'Bueno'
				when nota between 9 and 10 then 'Excelente'
				else 'Nota no valida'
				end;
	end;
	$$ language plpgsql
	-- llamar a la funcion
	select estado_notas(11)

	
/*Implementacion de funciones con consulta*/

create table tbl_personas(
id serial primary key,
nombre varchar(50),
edad int
);

insert into tbl_personas(nombre,edad) values
('Pedro',20),
('Luis',25),
('Edison',28),
('Renato',67),
('Solange',22)
	
/* Uso funciones*/
 select
 nombre,
 edad,
 clasificar_edad(edad) as categoria
 from tbl_personas;

/* con funcion case*/

select
nombre,
edad,
categorizar_edad_case(edad) as categoria_case
from tbl_personas


/* >10 frio
 * 10 - 25 templado
 * 25 calor
 */

create or replace function fn_claificacion_temperatura(temperatura int) returns text as $$
begin
	if temperatura < 10 then
		return 'Frio';
	elseif temperatura between 10 and 25 then
		return 'Templado';
	else
		return 'Calor';
	end if;
end ;
$$ language plpgsql


create table tbl_temperatura(
id serial primary key,
temperatura int
);


insert into tbl_temperatura(temperatura) values
(20),
(5),
(28),
(7),
(22)


-- case
create or replace function fn_claificacion_temperatura_case(temperatura int) returns text as $$
begin
	return case 
			when temperatura < 10 then 'Frio'
			when temperatura between 10 and 25 then'Templado'
			else 'Calor'
			end;
end ;
$$ language plpgsql
