--- migration:up
ALTER TABLE groceries
ALTER COLUMN quantity SET NOT NULL,
ALTER COLUMN purchased SET NOT NULL,
ALTER COLUMN list_id SET NOT NULL;
--- migration:down
ALTER TABLE groceries
ALTER COLUMN quantity DROP NOT NULL,
ALTER COLUMN purchased DROP NOT NULL,
ALTER COLUMN list_id DROP NOT NULL;
--- migration:end
