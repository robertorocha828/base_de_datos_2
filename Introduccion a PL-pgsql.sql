/* Nombre: Roberto Rochaalter 
Fecha: 07/04/2026
Tema: Introduccion a PS/PGSQLalter 
Docente: Ing.Christian Rivadeneira*/

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
end $$


-- Asigancion de diferentes tipos de datos
do $$
declare
nombre text := 'Roberto Rocha';
edad int := '26';
salario numeric := '1500';
activo boolean := true;
begin
	raise notice 'Nombre: %, Edad: %, Salario: %, Activo: %', nombre, edad, salario,activo;
end $$
