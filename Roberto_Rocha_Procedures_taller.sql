/* Nombre: Roberto Rochaalter 
Fecha: 28/04/2026
Tema: Procedures - taller
Docente: Ing.Christian Rivadeneira*/


create table tbl_paciente(
    id_paciente serial primary key,
    nombre1_p varchar(50),
    nombre2_p varchar(50),
    apellido1_p varchar(50),
    apellido2_p varchar(50),
    edad int,
    sexo varchar(50),
    fecha_nacimiento date,
    correo_electronico varchar(100),
    telefono varchar(20),
    tipo_sangre varchar(20) check(tipo_sangre in ('o+', 'o-', 'ab+', 'ab-', 'b+', 'b-', 'a+', 'a-', 'otro')),
    estado_civil varchar(20) check(estado_civil in ('casado', 'soltero', 'viudo', 'union_libre', 'otro')),
    estado_seguro boolean,
    ocupacion varchar(50),
    alergias varchar(50),
    sintomas varchar(100),
    observaciones text,
    est_diabetes boolean,
    fecha_ingreso timestamp default current_timestamp
);


create or replace procedure sp_insertar_paciente(
    i_nom1 varchar, 
    i_nom2 varchar, 
    i_ape1 varchar, 
    i_ape2 varchar,
    i_edad int,
    i_sexo varchar,
    i_fec_nac date,
    i_correo varchar,
    i_tel varchar,
    i_sangre varchar,
    i_est_civil varchar,
    i_seguro boolean,
    i_ocupacion varchar,
    i_alergias varchar,
    i_sintomas varchar,
    i_obs text,
    i_diabetes boolean
) as $$
begin
   insert into tbl_paciente (
        nombre1_p, nombre2_p, apellido1_p, apellido2_p, 
		edad, sexo, fecha_nacimiento, correo_electronico, 
        telefono, tipo_sangre, estado_civil, estado_seguro, 
        ocupacion, alergias, sintomas, observaciones, est_diabetes
    ) 
    values (
        i_nom1, i_nom2, i_ape1, i_ape2, 
        i_edad, i_sexo, i_fec_nac, i_correo, 
        i_tel, i_sangre, i_est_civil, i_seguro, 
        i_ocupacion, i_alergias, i_sintomas, i_obs, i_diabetes
    );

    raise notice 'Paciente % % insertado correctamente.', i_nom1, i_ape1;

end;
$$ language plpgsql;
-- llamar procedmiento
call sp_insertar_paciente('Roberto', 'Carlos', 'Rocha', 'Delgado', 
							26, 'Masculino', '1999-07-30', 'roberto@rocha.com', 
    						'0987654321', 'b+', 'soltero', false, 
    						'Estudiante', 'Ninguna', 'Sin sintomas', 'N/A', false);

call sp_insertar_paciente('Christian', 'Josue', 'Cañar', 'Muñoz', 
							24, 'Masculino', '2001-09-28', 'ian0168@cañar.com', 
    						'0982123445', 'o+', 'union_libre', true, 
    						'Estudiante', 'Ninguna', 'Sin sintomas', '1', false);

select * from tbl_paciente;



-- Actualizar 
create or replace procedure sp_actualizar_paciente(
    i_id int, 
    i_edad int,
    i_sexo varchar,
    i_correo varchar,
    i_tel varchar,
    i_est_civil varchar,
    i_seguro boolean,
    i_ocupacion varchar,
    i_alergias varchar,
    i_sintomas varchar,
    i_obs text,
    i_diabetes boolean
) as $$
begin
    update tbl_paciente 
    set 
        edad = i_edad, 
        sexo = i_sexo, 
        correo_electronico = i_correo, 
        telefono = i_tel, 
        estado_civil = i_est_civil, 
        estado_seguro = i_seguro, 
        ocupacion = i_ocupacion, 
        alergias = i_alergias, 
        sintomas = i_sintomas, 
        observaciones = i_obs, 
        est_diabetes = i_diabetes
    where id_paciente = i_id;
    raise notice 'Paciente con ID % actualizado correctamente.', i_id;
end;
$$ language plpgsql;
-- llamar procedimiento
call sp_actualizar_paciente(
    1, 26,'Masculino','nuevo_correo@mail.com', 
    '0999999999', 'casado', true, 
    'Ingeniero', 'Polvo', 'Ninguno', 'Actualización de rutina', false);


select * from tbl_paciente;

-- DELETE
create or replace procedure sp_eliminar_paciente(i_id int) as $$
begin
    delete from tbl_paciente 
    where id_paciente = i_id;
    raise notice 'Paciente con ID % eliminado correctamente.', i_id;
end;
$$ language plpgsql;
-- llamar procedimiento
call sp_eliminar_paciente(1);