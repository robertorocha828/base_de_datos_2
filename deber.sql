/* Nombre: Roberto Rochaalter 
Fecha: 21/04/2026
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
        return 'Actualizacion exitosas';
    else
        raise notice 'Empleado con id %, no encontrado', i_id;
        return 'El empleado no encontrado';
    end if;       
end;
$$ language plpgsql;

select fn_actualizar_empleado(5,'Micaela R', 1500, 'Sistemas')

select * from tbl_empleados;




-- validaciones

create or replace function fn_actualizar_empleado_(i_id int, i_nombre varchar, i_salario numeric, i_departamento varchar) 
returns text as $$
begin
    if i_salario <= 0 then
        return 'el salario no puede ser cero';
    end if;
    update tbl_empleados 
    set nombre = i_nombre, 
        salario = i_salario, 
        departamento = i_departamento
    where id = i_id;

    if found then
        return 'actualizacion exitosa';
    else
        return 'no se pudo actualizar, id no encontrado';
    end if;      
end;
$$ language plpgsql;

select fn_actualizar_empleado_(555,'Micaela R', 1500, 'Sistemas')


