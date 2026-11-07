CREATE TABLE IF NOT EXISTS products (
    id BIGSERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    description TEXT NOT NULL,
    price NUMERIC(10, 2) NOT NULL CHECK (price >= 0)
);

INSERT INTO products (name, description, price) VALUES
    ('Trail Backpack', 'A lightweight day pack for weekend hikes.', 79.00),
    ('Insulated Bottle', 'A stainless steel bottle for hot or cold drinks.', 24.50),
    ('Compact Lantern', 'A rechargeable lantern for campsites and cabins.', 39.95)
ON CONFLICT (name) DO NOTHING;

