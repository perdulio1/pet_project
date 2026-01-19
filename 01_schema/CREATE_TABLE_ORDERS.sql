CREATE TABLE orders (
      order_id SERIAL PRIMARY KEY 
    , user_id INT REFERENCES users(user_id) -- Просто REFERENCES для зв'язку
    , order_date DATE DEFAULT CURRENT_DATE  -- Додав дефолтне значення
    , total_amount NUMERIC(10, 2)           -- Виправлено друкарську помилку
);