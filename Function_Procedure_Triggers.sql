/* Nombre: Roberto Rochaalter 
Fecha: 28/04/2026
Tema: Trigger
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


create or replace function fn_actualizar_sueldo()
returns trigger as $$
begin
    new.salario := old.salario + new.salario;
	raise notice 'Nuevo salario: %', NEW.salario;
    return new;
end;
$$ language plpgsql;

create trigger trg_sueldo_actualizado
before update on tbl_empleados
for each row
execute function fn_actualizar_sueldo();

UPDATE tbl_empleados 
SET salario = -200 
WHERE nombre = 'Roberto Rocha';


select * from tbl_empleados;








create or replace function fn_actualizacion_sueldo()
returns trigger as $$
begin
	if (old.salario != new.salario) then
	new.fecha_actualizacion_sueldo := current_timestamp;
	end if;
	return new;
end;
$$ language plpgsql;


create trigger trg_actulizar_sueldo
before update on tbl_empleados
for each row
execute PROCEDURE fn_actualizacion_sueldo();



select * from tbl_empleados;

UPDATE tbl_empleados SET salario = 1500 WHERE id = 1;