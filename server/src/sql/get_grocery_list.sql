SELECT id, name, quantity, purchased
FROM groceries
WHERE list_id = $1;
