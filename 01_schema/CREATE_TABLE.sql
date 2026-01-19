CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,        
    first_name VARCHAR(50) NOT NULL,   
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,         
    registration_date DATE DEFAULT CURRENT_DATE,
    city VARCHAR(50)
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10, 2)               
);