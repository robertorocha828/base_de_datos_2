/* UNIVERSIDA UTE
NOMBRE: ROBERTO ROCHA
DOCENTE: ING CRISTIAN RIVADENEIRA MSc.
FECHA: 07/05/2026
*/

/* DESARROLLO*/

CREATE TABLE tbl_pacientes(
	id SERIAL PRIMARY KEY,
	nombre1 TEXT,
	nombre2 TEXT,
	apellido1 TEXT,
	apellido2 TEXT,
	edad NUMERIC,
	salario NUMERIC,
	sexo CHAR CHECK(sexo IN('M','F')),
	fecha_nacimiento DATE,
	correo VARCHAR,
	telefono VARCHAR,
	tipo_sangre VARCHAR CHECK(tipo_sangre IN('AB+', 'AB-', 'O+', 'O-', 'A+', 'A-', 'B+', 'B-', 'otro')),
	estado_seguro BOOLEAN,
	estado_civil VARCHAR CHECK(estado_civil IN('soltero', 'casado', 'divorciado', 'separado')),
	ocupacion VARCHAR,
	alergias VARCHAR,
	sintomas VARCHAR,
	observaciones VARCHAR,
	st_diabetes BOOLEAN,
	fecha_ingreso TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
)


/*Ejercicio 9 — Crea un procedure llamado sp_aplicar_descuento que reciba p_id y p_porcentaje NUMERIC, 
declare v_nombre1, v_salario_actual y v_salario_nuevo, valide que el porcentaje esté entre 1 y 50, 
consulte el paciente, si no existe muestre un mensaje, calcule el nuevo salario así:*/


create or replace procedure sp_aplicar_descuento(p_id int, p_porcentaje int) as $$
declare 
	v_nombre varchar;
	v_salario_actual numeric;
	v_salario_nuevo numeric;
begin
	if p_porcentaje between 1 and 50 then
		raise exception 'El porcentaje no es el adecuado';
	end if;
	if exists(select * from tbl_paciente where id = p_id) then
		raise exception 'El paciente con id % no existe',p_id;
	end if;
	select salario
	into v_salario_actual
	from tbl_pacientes
	where id = p_id;
	v_salrio_nuevo := v_salario_actual-(v_salario_actual * p_porcentaje / 100);
	update tbl_pacientes
	set salrio = v_salario_nuevo
	where id = p_id;
	raise notice 'Salario actualizado';
end;
$$ language plpgsql;

call sp_aplicar_descuento(1, 30);



	