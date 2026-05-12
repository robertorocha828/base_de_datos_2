/* trigger*/
drop table empleados;
create table if not exists empleados (
id serial primary key,
nombre varchar(100) not null,
salario decimal (10,2),
email varchar(100)

);


insert into empleados (nombre, salario, email) values
('Juan Pérez', 850, 'alguien@gmail.com'),
('Carlos López', 920, 'alguien1@gmail.com'),
('Josue Sánchez', 780, 'alguien2@gmail.com'),
('Ana Torres', 750, 'alguien3@gmail.com'),
('Luis Gómez', 670, 'alguien4@gmail.com');

select * from empleados;

create or replace function fn_validar_salario()
returns trigger as $$
begin
	if new.salario < 0 then
		raise exception 'El salario no puede ser negativo';
	end if;
	return new;
end;
$$ language plpgsql;

-- craecion de trigger 

create trigger trg_validar_salario
before insert or update on empleados
for each row execute function fn_validar_salario();

insert into empleados (nombre, salario, email) values('Pedro Ruiz', -500, 'alguien5@gmail.com');


-- insertar empleado
create or replace function fn_insertar_empleado()
returns trigger as $$
begin
    raise notice 'Se agrego un nuevo empleado con el nombre: %', new.nombre;
    return new;
end;
$$ language plpgsql;


-- insertar empleado
create trigger trg_insert_empleado
after insert on empleados
for each row execute function fn_insertar_empleado();


insert into empleados (nombre, salario, email)
values ('Armando Perez', 900, 'alguien6@gmail.com');


--actualizacion
update empleados 
set salario = 1500
where id = 8;


select * from empleados;


-- validar email
create or replace function fn_validar_email()
returns trigger as $$
begin
    if new.email is null 
       or new.email !~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$' then
        raise exception 'Correo electrónico inválido';
    end if;

    return new;
end;
$$ language plpgsql;

create trigger trg_validar_email
before insert or update on empleados
for each row
execute function fn_validar_email();


insert into empleados (nombre, salario, email)
values ('Carlos Ruiz', 1000, 'carlos@gmail.com');






