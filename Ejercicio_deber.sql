/* Nombre: Roberto Rochaalter 
Fecha: 21/04/2026
Tema: Ejercio calculo impuesto predial
Docente: Ing.Christian Rivadeneira*/


/*Pago impuesto predial
tabla propiedades (precios de casas) valor y nuemro de metroa 
10 a 50  m 10% valor de de la propiedad 
50 a 100 m 20%
100 en adelante 30% de la propiedad*/
 create table tbl_impuesto_predial(
 	id serial primary key,
	valor_propiedad int,
	tamano_propiedad_m2 int
 )

 
insert into tbl_impuesto_predial(valor_propiedad, tamano_propiedad_m2) values
(30000, 55),
(85000, 82),
(125000,180),
(55300, 42)

select * from tbl_impuesto_predial


create or replace function fn_calculo_impuesto_predial(costo int, superficie int) returns int as $$
begin
	if superficie between 10 and 50 then
		return costo*0.10;
	elseif superficie between 51 and 100 then
		return costo*0.20;
	else
		return costo*0.30;
	end if;
end;
$$ language plpgsql;


select 
valor_propiedad,
tamano_propiedad_m2,
fn_calculo_impuesto_predial(valor_propiedad, tamano_propiedad_m2) as calculo_impuesto_predial
from tbl_impuesto_predial;







 