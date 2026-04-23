/* Nombre: Roberto Rochaalter 
Fecha: 21/04/2026
Tema: Procedures
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




create or replace function fn_insertar_empleado(p_nombre varchar, p_salario numeric, p_departamento varchar) 
returns void as  $$
begin
	update tbl_empleados set (nombre, salario, departamento) 
	values  (p_nombre, p_salario, p_departamento);
end;
$$ language plpgsql;

select fn_insertar_empleado ('Cristian Rivadeneira', 1500, 'Sistemas');
select fn_insertar_empleado('Mariana Torres', 1250, 'Contabilidad');
select fn_insertar_empleado('Roberto Gómez', 1800, 'Marketing');
select fn_insertar_empleado('Elena Vizcaíno', 950, 'Logística');
select fn_insertar_empleado('Javier Mendoza', 2200, 'Recursos Humanos');

select * from tbl_empleados;


/* actualizacion*/


create or replace function fn_actualizar_empleado(i_id int, i_nombre varchar, i_salario numeric, i_departamento varchar) 
returns void as $$
begin
    update tbl_empleados 
    set nombre = i_nombre, 
        salario = i_salario, 
        departamento = i_departamento
    where id = i_id;       
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


