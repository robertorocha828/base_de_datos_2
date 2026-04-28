/* Nombre: Roberto Rochaalter 
Fecha: 23/04/2026
Tema: Deber - Procedures
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

-- Insersion
create or replace function fn_insertar_empleado(i_nombre varchar, i_salario numeric, i_departamento varchar) returns text as $$
begin
    if exists(select * from tbl_empleados where nombre = i_nombre) then
        raise notice 'El empleado % ya exixte en la tabla', i_nombre;
    end if;
    insert into tbl_empleados (nombre, salario, departamento) 
    values (i_nombre, i_salario, i_departamento);
    raise notice 'Inserción existosa. Empleado % insertado', i_nombre;
end;
$$ language plpgsql;

-- lamar a la funcion
select fn_insertar_empleado ('Cristin Rivadeneira', 1500, 'Sistemas');
select fn_insertar_empleado('Mariana Torres', 1250, 'Contabilidad');
select fn_insertar_empleado('Roberto Gómez', 1800, 'Marketing');
select fn_insertar_empleado('Elena Vizcaíno', 950, 'Logística');
select fn_insertar_empleado('Javier Mendoza', 2200, 'Recursos Humanos');


/* actualizacion*/
create or replace function fn_actualizar_empleado(i_id int, i_nombre varchar, i_salario numeric, i_departamento varchar) 
returns text as $$
begin
    update tbl_empleados 
    set nombre = i_nombre, 
        salario = i_salario, 
        departamento = i_departamento
    where id = i_id;
	if found then
		raise notice 'Empleado con id %, actualizado', i_id;
        return 'Actualizacion exitosas';
    else
        raise notice 'Empleado con id %, no encontrado', i_id;
        return 'Empleado no encontrado';
    end if;       
end;
$$ language plpgsql;

--Llamar funcion
select fn_actualizar_empleado(5,'Micaela R', 1500, 'Sistemas');
select fn_actualizar_empleado(16, 'Josue Ruiz Delgado', 1200, 'Recursos Humanos');
select fn_actualizar_empleado(12, 'Roberto Rocha', 1800, 'Sistemas');
select fn_actualizar_empleado(4, 'Eduardo Perez', 1500, 'Sistemas');
select fn_actualizar_empleado(2, 'Hernan Varas', 1600, 'Gerencia');

select * from tbl_empleados;


-- eliminacion
create or replace function fn_eliminacion_empleado (i_id int) returns text as $$
begin
    if not exists(select * from tbl_empleados where id = i_id) then
        raise notice 'el empleado con la id %, no existe', i_id;
    end if;
    delete from tbl_empleados where id = i_id;
    raise notice 'Empleado con la id %, eliminado correctamente', i_id;
end;
$$ language plpgsql;

-- llamar funcion
select fn_eliminacion_empleado(5);
select fn_eliminacion_empleado(12);
select fn_eliminacion_empleado(16);
select fn_eliminacion_empleado(4);
select fn_eliminacion_empleado(2);










    if not exists(select 1 from tbl_paciente where id_paciente = i_id) then
        raise exception 'El paciente con ID % no existe.', i_id;
    end if;



exception 
    when check_violation then
        raise exception 'Error de validación: Revisa el tipo de sangre (%) o estado civil (%).', i_sangre, i_est_civil;
    when others then
        raise exception 'Error inesperado: %', SQLERRM;





    -- 1. Verificamos si el paciente existe
    if not exists(select 1 from tbl_paciente where id_paciente = i_id) then
        raise notice 'El paciente con ID % no existe, no se puede eliminar.', i_id;
    else



    exception 
    when others then
        raise exception 'Ocurrió un error al intentar eliminar: %', SQLERRM;