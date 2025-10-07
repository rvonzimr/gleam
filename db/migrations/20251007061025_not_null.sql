-- migrate:up
ALTER TABLE groceries
ALTER COLUMN quantity SET NOT NULL,
ALTER COLUMN purchased SET NOT NULL,
ALTER COLUMN list_id SET NOT NULL;
-- migrate:down
