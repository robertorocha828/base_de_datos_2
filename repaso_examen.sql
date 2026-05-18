
-- Eliminar tablas si existen
DROP TABLE IF EXISTS historial_clientes CASCADE;
DROP TABLE IF EXISTS auditoria_productos CASCADE;
DROP TABLE IF EXISTS detalle_ventas CASCADE;
DROP TABLE IF EXISTS ventas CASCADE;
DROP TABLE IF EXISTS productos CASCADE;
DROP TABLE IF EXISTS clientes CASCADE;


CREATE TABLE clientes(
    id_cliente SERIAL PRIMARY KEY,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    telefono VARCHAR(15),
    correo VARCHAR(100),
    fecha_registro DATE DEFAULT CURRENT_DATE
);

CREATE TABLE productos(
    id_producto SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    categoria VARCHAR(50),
    precio NUMERIC(10,2),
    stock INT,
    estado VARCHAR(20) DEFAULT 'Disponible'
);

CREATE TABLE ventas(
    id_venta SERIAL PRIMARY KEY,
    id_cliente INT,
    fecha DATE DEFAULT CURRENT_DATE,
    total NUMERIC(10,2),

    CONSTRAINT fk_cliente
    FOREIGN KEY(id_cliente)
    REFERENCES clientes(id_cliente)
);

CREATE TABLE detalle_ventas(
    id_detalle SERIAL PRIMARY KEY,
    id_venta INT,
    id_producto INT,
    cantidad INT,
    subtotal NUMERIC(10,2),

    FOREIGN KEY(id_venta)
    REFERENCES ventas(id_venta),

    FOREIGN KEY(id_producto)
    REFERENCES productos(id_producto)
);

CREATE TABLE auditoria_productos(
    id_auditoria SERIAL PRIMARY KEY,
    producto VARCHAR(100),
    stock_anterior INT,
    stock_nuevo INT,
    fecha TIMESTAMP,
    accion VARCHAR(100)
);

CREATE TABLE historial_clientes(
    id_historial SERIAL PRIMARY KEY,
    cliente VARCHAR(200),
    fecha TIMESTAMP,
    observacion VARCHAR(100)
);


/*La empresa desea agilizar el proceso de registro de nuevos clientes para evitar errores al momento
de ingresar información manual.
Desarrolle un procedimiento almacenado que permita registrar nuevos clientes en la tabla
correspondiente.
El procedimiento deberá recibir los siguientes parámetros:
 • Nombres del cliente
 • Apellidos
 • Teléfono
 • Correo electrónico
Considere lo siguiente:
 • La fecha de registro deberá asignarse automáticamente usando la fecha actual del sistema.
 • El procedimiento debe insertar la información en la tabla clientes.
 • Realice una prueba insertando un cliente nuevo. */

select * from clientes;
create or replace procedure sp_inserta_cliente(i_nombres varchar, i_apellidos varchar, i_telefono varchar, i_correo varchar) as $$
begin
	insert into clientes(nombres,apellidos,telefono,correo)
	values(i_nombres,i_apellidos,i_telefono,i_correo);
end;
$$ language plpgsql;

call sp_inserta_cliente('Roberto','Rocha','0979197158','roberto@rocha.com');

call sp_inserta_cliente('Roberto','Delgado','0979197159','roberto@gmail.com');

/*Los empleados de la tienda necesitan consultar rápidamente los productos disponibles por categoría
para facilitar la atención al cliente.
Desarrolle una función almacenada que permita buscar productos según una categoría enviada
como parámetro.
La función deberá:
 • Recibir el nombre de una categoría.
 • Mostrar:
 ◦ código del producto
 ◦ nombre del producto
 ◦ precio */


select * from productos;
drop function fn_consulta;
create or replace function fn_consulta(i_categoria varchar) returns table(id_producto int, nombre varchar, precio numeric) as $$
begin
	return query
		select p.id_producto,p.nombre,p.precio
		from productos p
		where p.categoria = i_categoria;
end;
$$ language plpgsql;

select * from fn_consulta('Tecnología');

/*Debido a cambios frecuentes de precios por promociones y ajustes comerciales, el administrador
requiere un proceso automatizado para actualizar valores de productos.
Desarrolle un procedimiento almacenado que permita modificar el precio de un producto.
El procedimiento deberá recibir:
 • código del producto
 • nuevo precio
Considere:
 • El procedimiento debe actualizar únicamente el producto indicado.
 • Realice pruebas verificando los cambios realizados.*/

select * from productos;
create or replace procedure sp_actualizar_precio(i_id_producto int, i_precio numeric) as $$
begin
	update productos
	set precio = i_precio
	where id_producto = i_id_producto;
end;
$$ language plpgsql;

call sp_actualizar_precio(4,250);



/*El departamento financiero necesita consultar rápidamente el valor total de una venta sin realizar
cálculos manuales.
Desarrolle una función almacenada que reciba el identificador de una venta y calcule
automáticamente el total.
La función deberá:
 • Recibir:
id_venta
 • Obtener la suma de los subtotales almacenados en detalle_ventas.
 • Retornar el resultado calculado.
Ejemplo:
SELECT total_venta(1);*/

select * from detalle_ventas;
create or replace function fn_total_ventas(i_id_venta int) returns numeric as $$
declare
	v_total numeric;
begin
	select sum(subtotal)
	into v_total
	from detalle_ventas
	where id_venta = i_id_venta;
	raise notice 'El producto con id % tiene un subtotal de %', i_id_venta, v_total;
return v_total;
end;
$$ language plpgsql;

select fn_total_ventas(1);


/*El encargado del inventario desea identificar productos que poseen existencias bajas para planificar
futuras compras.
Desarrolle una función almacenada que permita listar los productos cuyo stock sea menor al valor
recibido como parámetro.
La función deberá mostrar:
 • nombre del producto
 • cantidad disponible
Ejemplo:
SELECT * FROM stock_minimo(15);*/
select * from productos;
create or replace function fn_stock_minimo(i_stock int) returns table(nombre varchar, stock int) as $$
begin
	return query
	select p.nombre,p.stock
	from productos p
	where p.stock < i_stock;
end;
$$ language plpgsql;

select * from fn_stock_minimo(20);



/*La gerencia requiere mantener un historial de cambios de inventario para auditorías futuras.
Desarrolle un trigger que registre automáticamente en la tabla auditoria_productos cualquier
modificación realizada al stock de un producto.
La auditoría deberá almacenar:
 • nombre del producto
 • stock anterior
 • stock nuevo
 • fecha y hora del cambio
 • descripción de la acción realizada
Considere:
 • El registro debe generarse únicamente cuando exista una modificación del stock.
 • Utilice las variables especiales OLD y NEW.
Realice pruebas modificando el stock de un producto*/

select * from auditoria_productos;
select * from productos;
create or replace function fn_auditoria_productos() returns trigger as $$
begin
	if old.stock != new.stock then
		insert into auditoria_productos(producto,stock_anterior,stock_nuevo,fecha,accion)
		values(new.nombre,old.stock,new.stock,current_timestamp,'Actualizacion de stock');
		return new;
	end if;
end;
$$ language plpgsql;

drop  trigger trg_auditoria_producto on productos;
create trigger trg_auditoria_producto
after update on productos
for each row
execute function fn_auditoria_productos();
select * from productos;
select * from auditoria_productos;
update productos
set stock = 21
where id_producto = 1;


/*La empresa necesita almacenar un historial de nuevos clientes registrados para fines estadísticos y
de seguimiento comercial.
Desarrolle un trigger que, cada vez que se inserte un nuevo cliente, registre automáticamente la
información en la tabla historial_clientes.
Debe almacenar:
 • nombre completo
 • fecha y hora
 • observación
La observación deberá contener el mensaje:
Nuevo cliente registrado
Realice pruebas verificando los registros generados.*/
select * from historial_clientes;
select * from clientes c ;

create or replace function fn_historial_cliente() returns trigger as $$
begin
	if TG_OP = 'INSERT' then 
		insert into historial_clientes(cliente,fecha,observacion)
		values(concat(new.nombres,' ',new.apellidos),current_timestamp,'Cliente nuevo agregado');
	end if;
return new;
end;
$$ language plpgsql;

create trigger tgr_inserta_cliente
after insert on clientes
for each row
execute function fn_historial_cliente();








/*La tienda desea evitar que los empleados olviden cambiar el estado de un producto cuando se agota.
Desarrolle un trigger automático que actualice el estado del producto a:
Agotado
cuando el stock llegue exactamente a:
0
Considere:
 • El cambio debe realizarse automáticamente.
 • El usuario no debe actualizar manualmente el campo estado.
 • Realice pruebas para verificar el funcionamiento.*/
select * from productos p ;
create or replace function fn_actualizar_estado() returns trigger as $$
begin
	if new.stock = 0 then
		new.estado := 'Agotado';
	end if;
	return new;
end;
$$ language plpgsql;

drop trigger trg_actualizar_estado on productos; 
create trigger trg_actualizar_estado
before update on productos
for each row
execute function fn_actualizar_estado();

select * from productos p ;

update productos
set stock = 0
where id_producto = 4;
/*La gerencia solicita un reporte consolidado de ventas para identificar los clientes con mayores
compras.
Desarrolle una función almacenada que genere un reporte con la siguiente información:
 • nombre completo del cliente
 • fecha de la venta
 • total pagado
 • cantidad de productos adquiridos
Condiciones:
 • Ordenar los resultados de mayor a menor según el total de compra.
 • Utilizar las tablas:
 ◦ clientes
 ◦ ventas
 ◦ detalle_ventas
Ejemplo:
SELECT * FROM reporte_ventas();
Se espera un reporte organizado que facilite el análisis comercial*/

select * from clientes;
select * from ventas;
select * from detalle_ventas;
drop function fn_reporte;
create or replace function fn_reporte() returns 
table(nombres varchar, apellidos varchar, fecha date, cantidad bigint, subtotal numeric) as $$
begin
	return query
		select c.nombres,c.apellidos, v.fecha, sum(d.cantidad), sum(d.subtotal)
		from clientes c
		join ventas v on v.id_cliente = c.id_cliente 
		join detalle_ventas d on d.id_venta = v.id_venta
		group by c.nombres,c.apellidos, v.fecha;		
end;
$$ language plpgsql;


select * from fn_reporte();






