CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS items (
  id uuid UNIQUE NOT NULL DEFAULT uuid_generate_v4(),
  name text NOT NULL,
  description text NOT NULL,
  vendor text NOT NULL
);

CREATE TABLE IF NOT EXISTS orders (
  id uuid UNIQUE NOT NULL DEFAULT uuid_generate_v4(),
  items uuid[] NOT NULL,
  -- orderUser uuid NOT NULL,
  orderdate timestamptz NOT NULL DEFAULT now()
)
