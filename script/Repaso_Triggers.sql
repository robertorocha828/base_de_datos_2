create table tbl_cuentas(
	id serial primary key,
	titular varchar(100),
	saldo numeric(10,2),
	tipo_cuenta varchar(100)
);


insert into tbl_cuentas(titular,saldo,tipo_cuenta) values
('Roberto Rocha',1500,'ahorro'),
('Hernan Varas',2500,'ahorro'),
('Christian Cañar',1000,'corriente'),
('Eduardo Perez',500,'ahorro'),
('Josue Ruiz',1500,'ahorro');


--tabla auditoria
create table auditoria_cuentas(
	audit_id serial primary key,
	cuenta_id int,
	titular varchar(100),
	saldo numeric(10,2),
	accion char(1),
	usuario_db text,
	fecha_cambio timestamp default now()
);


create or replace function fn_auditoria_cuentas() returns trigger as $$
begin
	if tg_op = 'INSERT' then
		insert into auditoria_cuentas(cuenta_id,titular,saldo,accion,usuario_db) 
		values(new.id,new.titular,new.saldo,'I',current_user);
		return new;
	elsif tg_op = 'UPDATE' then
		insert into auditoria_cuentas(cuenta_id,titular,saldo,accion,usuario_db) 
		values(new.id,new.titular,new.saldo,'U',current_user);
		return new;
	elsif tg_op = 'DELETE' then
		insert into auditoria_cuentas(cuenta_id,titular,saldo,accion,usuario_db) 
		values(old.id,old.titular,old.saldo,'D',current_user);
		return old;
	end if;
return null;
end;
$$ language plpgsql;


create trigger trg_auditoria_cuentas
after insert or update or delete on tbl_cuentas
for each row
execute function fn_auditoria_cuentas();



select * from tbl_cuentas;
select * from  auditoria_cuentas;


insert into tbl_cuentas(titular,saldo,tipo_cuenta) values
('Roberto Delgado',1500,'corriente'),
('Hernan Gabriel',2500,'ahorro');



--validar que saldo no sea negativo
create or replace function fn_validar_saldo() returns trigger as $$
begin
	if new.saldo < 0 then
		raise exception 'No se permite saldo negativo';
	end if;
	return new;
	
end;
$$ language plpgsql;

create trigger tgr_validar_saldo
before insert or update on tbl_cuentas
for each row
execute function fn_validar_saldo();


insert into tbl_cuentas(titular,saldo,tipo_cuenta) values
('carlos Rocha',5,'ahorro');

--bloquear cuenta si es menor a 100
create or replace function fn_validar_retiro() returns trigger as $$
begin
	if new.saldo < 100 then
		raise exception 'El saldo no puede ser menor a cero';
	end if;
	return new;
end;
$$ language plpgsql;

create trigger tgr_validar_saldo_retiro
before update on tbl_cuentas
for each row
execute function fn_validar_retiro();


update tbl_cuentas
set saldo = 55
where id = 4;

select * from tbl_cuentas;


--procedure 
create or replace procedure sp_depositar_dinero(id_cueta int, monto_deposito numeric) as $$
declare
	v_saldo numeric;
	v_nuevo_saldo numeric;
begin
	if monto_deposito < 0 then
		raice exception 'El monto no puede ser menor a cero';
	end if;
	if not exists (select * from tbl_cuentas where id = id_cuenta) then 
		raise exception 'EL usuario no existe';
	end if;
	select saldo
	into v_saldo
	from tbl_cuentas
	where id = id_cuenta;
	v_nuevo_saldo := v_saldo + monto_deposito;
	update tbl_cuentas 
	set salario = v_nuevo_salario
	where id = id_cuenta;
	raise notice 'el nuevo saldo es: %', v_nuevo_saldo;
end;
$$ language plpgsql;





create table tbl_clientes(
    id serial primary key,
    nombre varchar(100),
    saldo numeric(10,2)
);


create or replace procedure sp_clasificar_cliente(i_id int, i_saldo numeric) as $$
declare
	v_clasificar text;
begin
	if not exists(select * from tbl_clientes where id = i_id) then 
		raise exception 'El cliente con la id % no existe',i_id;
	end if;
	if i_saldo <= 0 then 
		raise exception 'El saldo no puede ser menor a cero';
	end if;
	v_clasificar := case
					when saldo < 500 then 'Basico'
					when saldo < 2000 then 'Preferencial'
					else 'VIP'
					end;
	raise notice 'el cliente % cuenta con un saldo % y pertenece a ala categoria %', nombre,saldo,v_categoria;
end;
$$ language plpgsql;
$$ language plpgsql;








