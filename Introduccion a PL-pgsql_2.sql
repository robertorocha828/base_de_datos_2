/* Nombre: Roberto Rochaalter 
Fecha: 07/04/2026
Tema: Introduccion a PS/PGSQLalter 
Docente: Ing.Christian Rivadeneira*/


/* Crear tabla*/
-- Crear la tabla empleados

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

--
SELECT * FROM empleados


-- Ejercicio 1: Craer bloque PL/pgsql 
do $$
begin
	raise notice 'Bienvenido al curso PL/pgsql, Roberto';
end $$;


-- Ejercicio 2: Craer bloque PL/pgsql que declare una variable y le asigne un valor
do $$
declare
mensaje text := 'Hola, este es un mensaje desde PL/pgsql';
mensaje2 text := 'Bienvenido a base de datos 2';
begin
	raise notice '%. %', mensaje, mensaje2;
end $$;


-- Asigancion de diferentes tipos de datos
do $$
declare
	nombre text := 'Luciana';
	apellido text := 'Perez';
	sexo text := 'Femenino';
	edad int := 30;
	salario NUMERIC (10, 2):= 1500.00;
	activo boolean := true;
begin
	raise notice 'Nombre: %, Apellido: %, Sexo: %, Edad: %, Salario: %, Activo: %', nombre, apellido, sexo, edad, salario,activo;
end $$;

-- Calculo salario anual de un empleado
do $$
declare
	salario_mensual numeric(10, 2) := 3000.00;
	salario_anual numeric(10, 2);
begin
	salario_anual := salario_mensual * 12;
	raise notice 'El salario anual es: %', salario_anual;
end $$;

/*Tema 3: Control de flujo*/
-- Usar una estructura condicional if para verificar si un empleado esta activo
do $$
declare
	empleado_activo boolean := true;
begin
	if empleado_activo then
		raise notice 'El empleado esta activo';
	else
		raise notice 'El empleado no esta activo';
	end if;
end $$;

do $$
declare
	empleado_salario numeric(10, 2) := 2500;
begin
	if empleado_salario > 3000 then
		raise notice 'Buen salario';
	else
		raise notice 'Mal salario';
	end if;
end $$;


-- Usar un bucle for para mostrar los numeros del 1 al 5
do $$
begin
	for i in 1..5 loop
		raise notice 'Numero: %', i;
	end loop;
end $$;


/*Tema 4: Funciones
Crear una funcion que devuelva el salario anual de un empleado*/
create or replace function calcular_salario_anual(salario_mensual numeric) returns numeric as $$
begin
	return salario_mensual * 12;
end ;
$$ language plpgsql;
-- llamar funcion
select calcular_salario_anual(5000.00);

-- identificar variables i:intrada. o: salida
create or replace function i_calcular_salario_anual(salario_mensual numeric) returns numeric as $$
begin
	return salario_mensual * 12;
end ;
$$ language plpgsql;
select i_calcular_salario_anual(5000.00);


--------------Revisar
/* Crear una funcion que devuelva el nombre y salario de un empleado por su ID*/
drop function obtener_empleado;
create or replace function obtener_empleado(id_empleado int) returns table(nombres text, salarios numeric) as $$
begin
	return query select nombres, salarios from empleados where id = id_empleado;
end;
$$ language plpgsql;
-- llamar a la funcion
select * from obtener_empleado(3);





/* Tema 5: Procedimiento almacenado
 Crear un procedimiento alamacenado para aumentar el salario de un empleado
 */
create or replace procedure aumentar_salario(id_empleado int, aumento numeric) as $$
begin
	update empleados set salario = salario + aumento where id = id_empleado;
end;
$$ language plpgsql;
--llamar al procedimiento
call aumentar_salario(1, 1000.00);

-- normal
update empleados set salario = salario + 800.00 where id = id_empleado;
select * from empleados;

















	
	


