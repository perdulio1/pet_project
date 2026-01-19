
DROP TABLE IF EXISTS public.order_items;
DROP TABLE IF EXISTS public.orders;
DROP TABLE IF EXISTS public.products;
DROP TABLE IF EXISTS public.users;

CREATE TABLE public.users (
    user_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    registration_date DATE DEFAULT CURRENT_DATE,
    city VARCHAR(50)
);

CREATE TABLE public.products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price NUMERIC(10,2)
);

CREATE TABLE public.orders (
    order_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES public.users(user_id),
    order_date DATE DEFAULT CURRENT_DATE,
    total_amount NUMERIC(10,2)
);

CREATE TABLE public.order_items (
    item_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES public.orders(order_id),
    product_id INTEGER REFERENCES public.products(product_id),
    quantity INTEGER,
    price_at_purchase NUMERIC(10,2)
);

INSERT INTO public.users (user_id, first_name, last_name, email, registration_date, city) VALUES
(1, 'Олексій', 'Коваленко', 'oleksii@email.com', '2025-01-01', 'Kyiv'),
(2, 'Марія', 'Петренко', 'maria@email.com', '2025-01-10', 'Lviv'),
(3, 'Іван', 'Сидорчук', 'ivan@email.com', '2025-01-15', 'Odesa'),
(4, 'Анна', 'Мельник', 'anna@email.com', '2025-01-20', 'Kyiv');

INSERT INTO public.products (product_id, product_name, category, price) VALUES
(1, 'Laptop Pro 15', 'Electronics', 1200.00),
(2, 'Wireless Mouse', 'Electronics', 25.50),
(3, 'Mechanical Keyboard', 'Electronics', 80.00),
(4, 'Office Chair', 'Furniture', 150.00),
(5, 'Coffee Maker', 'Appliances', 60.00);

INSERT INTO public.orders (order_id, user_id, order_date, total_amount) VALUES
(1, 1, '2025-01-12', 1225.50),
(2, 1, '2026-01-13', 1000.50),
(3, 2, '2026-01-13', 1200.00),
(4, 3, '2025-01-12', 1760.00),
(5, 3, '2025-01-12', 1460.00),
(6, 4, '2025-01-12', 1560.00),
(7, 4, '2025-01-12', 1760.00),
(8, 2, '2025-02-12', 1960.00);

INSERT INTO public.order_items (item_id, order_id, product_id, quantity, price_at_purchase) VALUES
(1, 1, 1, 1, 1200.00),
(2, 1, 2, 1, 25.50),
(3, 2, 1, 1, 1200.00),
(4, 3, 1, 1, 1200.00),
(5, 4, 3, 2, 80.00),
(6, 5, 4, 1, 150.00),
(7, 6, 5, 1, 60.00),
(8, 7, 2, 2, 25.50),
(9, 8, 4, 1, 150.00);

SELECT setval('users_user_id_seq', (SELECT max(user_id) FROM users));
SELECT setval('products_product_id_seq', (SELECT max(product_id) FROM products));
SELECT setval('orders_order_id_seq', (SELECT max(order_id) FROM orders));
SELECT setval('order_items_item_id_seq', (SELECT max(item_id) FROM order_items));