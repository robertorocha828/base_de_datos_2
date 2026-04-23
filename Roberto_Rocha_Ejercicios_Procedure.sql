/* Nombre: Roberto Rochaalter 
Fecha: 23/04/2026
Tema: Ejercio sp
Docente: Ing.Christian Rivadeneira*/



create table tbl_empleados(
 	id serial primary key,
	nombre varchar(100),
	salario numeric,
	departamento varchar(100),
	fecha_creacion timestamp default current_timestamp
 )

 
insert into tbl_empleados(nombre, salario, departamento) values
('Roberto Rocha', 1500, 'Sistemas'),
('Hernan Varas', 1200, 'Recursos Humanos'),
('Christian Cañar', 1500, 'Sistemas'),
('Eduardo Perez', 1500, 'Programacion'),
('Josue Ruiz', 1200, 'Recursos Humanos'),
('Juan Perez', 1500, 'sistemas')


select * from tbl_empleados



-- inserción
create or replace function fn_insertar_empleado(i_nombre varchar, i_salario numeric, i_departamento varchar) 
returns text as $$
begin
    if exists(select 1 from tbl_empleados where nombre = i_nombre) then
        raise notice 'el empleado % ya existe en la tabla', i_nombre;
        return 'no éxito: el empleado ya existe';
    end if;

    insert into tbl_empleados (nombre, salario, departamento) 
    values (i_nombre, i_salario, i_departamento);
    
    raise notice 'inserción exitosa. empleado % insertado', i_nombre;
    return 'inserción exitosa';
end;
$$ language plpgsql;

--llamar a la funcion
select fn_insertar_empleado ('Juan', 2500, 'Sistemas');


/*crear un procedimiento en postgressql llamado sp_clasificar_empleado que cumpla con las siguientes condiciones:
requisitos:
1. el procedimiento debe recibir el parametro:
p_id: identificador del empleadoalter 2. debe consultar el salario del empleado desde la tabla empleados.alter 3. utilizar case, debe clasifica al empleado de la siguiente categoria:
menor a 500 bajoalter 
entre 500 y 1500 medio 
mayor a 1500 alto*/
--700
--1700
--300

-- psp_clasificacion
create or replace procedure sp_clasificar_empleado(i_id int) as $$
declare
    v_salario numeric;
    v_categoria text;
begin
    select salario into v_salario 
    from tbl_empleados 
    where id = i_id;
    v_categoria := case 
        when v_salario < 500 then 'bajo'
        when v_salario between 500 and 1500 then 'medio'
        else 'alto'
        end;
    raise notice 'empleado id: %, salario: %, categoría: %', i_id, v_salario, v_categoria;
end;
$$ language plpgsql;

-- Llamar al procedimiento
call sp_clasificar_empleado(12);


/*1. procedure: aumento salarial con CASE
cree un procedimiento llamado sp_aumneto-por_rango quer:
- reciba como parametro el id del empleado
- obtenga el salario actual del empleado
- aplique un aumento segun el siguiente criterio:
	menor a 500 el 20%
	entre 500 y 1000 el 10%
	entre 1001 y 2000 el 5%
	mayor a 2000 sin aumneto*/


create or replace procedure sp_aumento_por_rango(i_id int) as $$
declare
    v_salario_actual numeric;
    v_nuevo_salario numeric;
begin
    select salario into v_salario_actual 
    from tbl_empleados 
    where id = i_id;

    v_nuevo_salario := case 
        when v_salario_actual < 500 then v_salario_actual + (v_salario_actual * 0.20)
        when v_salario_actual between 500 and 1000 then v_salario_actual + (v_salario_actual * 0.10)
        when v_salario_actual between 1001 and 2000 then v_salario_actual + (v_salario_actual * 0.05)
        else v_salario_actual                                       
    end;
    if v_nuevo_salario > v_salario_actual then
        update tbl_empleados 
        set salario = v_nuevo_salario 
        where id = i_id;

        raise notice 'Aumento realizado al ID %. Salario anterior: %, Nuevo salario: %', 
                     i_id, v_salario_actual, v_nuevo_salario;
    else
        raise notice 'El empleado con ID % no aplica para aumento.', i_id;
    end if;
end;
$$ language plpgsql;

-- llamaos al procedimeinto
call sp_aumento_por_rango(12)














