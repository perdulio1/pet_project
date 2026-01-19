CREATE TABLE order_items(
	 item_id SERIAL PRIMARY KEY
	,order_id INT REFERENCES orders(order_id)
	,product_id INT REFERENCES products(product_id)
	,quantity INT 
	,price_at_purchase NUMERIC(10,2)
);