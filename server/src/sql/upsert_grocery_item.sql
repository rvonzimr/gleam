INSERT INTO groceries (name, quantity, list_id)
VALUES ($1, $2, $3)
ON CONFLICT (name, list_id)
DO UPDATE SET
    quantity = groceries.quantity + excluded.quantity;
