/* Auditoria Triggers*/
CREATE TABLE products (
id INT GENERATED ALWAYS AS IDENTITY,
name VARCHAR(100) NOT NULL,
price NUMERIC (10,2) NOT NULL,
PRIMARY KEY(id)
);

/*visualizamos la DATA*/
SELECT * FROM products;


INSERT INTO products (name, price) values
('CocaCola', 3.5),
('Galletas ',1.5),
('Doritos', 0.65),
('Chocolate',0.5),
('Helado',1.25);


--Eliminar tabla de auditoria si xiste 
DROP TABLE IF EXISTS product_audit;

--Crear tabla de auditoria
CREATE TABLE product_audit(
	audit_id SERIAL PRIMARY KEY,
	product_id INT,
	name VARCHAR(100),
	price NUMERIC(10,2),
	action CHAR(1), --i u d
	username TEXT,
	cahnged_on TIMESTAMP DEFAULT now()
	
);

CREATE OR REPLACE FUNCTION fn_audit_product_changes()
RETURNS TRIGGER
AS $$
BEGIN
	IF tg_op = 'INSERT' THEN
		INSERT INTO product_audit(product_id,name, price,action,username)
		VALUES (NEW.id,NEW.name,NEW.price,'I',current_user);
		RETURN NEW;
	
		ELSIF tg_op = 'UPDATE' then
			INSERT INTO product_audit(product_id,name, price,action,username)
			VALUES (NEW.id,NEW.name,NEW.price,'U',current_user);
			RETURN NEW;
		ELSIF tg_op = 'DELETE' THEN
			INSERT INTO product_audit(product_id,name, price,action, username)
			VALUES (OLD.id,OLD.name,OLD.price,'D',current_user);
			RETURN OLD;
	END IF;
RETURN NULL;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER trg_audit_product
AFTER INSERT OR UPDATE OR DELETE ON products
FOR EACH ROW 
EXECUTE FUNCTION fn_audit_product_changes();


--Inserciones
INSERT INTO products (name, price) values
('RedCola', 3.5);
INSERT INTO products (name, price) values
('Cocos', 3.5);
INSERT INTO products(name,price) VALUES('Laptop', 1000);
INSERT INTO products(name,price) VALUES('Pantalla', 250);
INSERT INTO products(name,price) VALUES('Teclado', 50);
INSERT INTO products(name,price) VALUES('Celular', 1000);
INSERT INTO products(name,price) VALUES('Escritorio', 1000);


--Actualizaciones
UPDATE products
SET name = 'AguaCoco'
WHERE id =7;

UPDATE products
SET price = 1500
WHERE id = 8;

UPDATE products
SET name = 'Celular Samsung'
WHERE id = 11;


--ELiminacion
DELETE FROM products
WHERE id = 7;

DELETE FROM products
WHERE id = 8;

select * from products;
select * from product_audit;












