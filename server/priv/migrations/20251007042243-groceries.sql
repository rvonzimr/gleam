--- migration:up
CREATE TABLE grocery_lists (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL
);
CREATE TABLE groceries (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    quantity INTEGER DEFAULT 1,
    purchased BOOLEAN DEFAULT FALSE,
    list_ID INTEGER,
    FOREIGN KEY(list_id) REFERENCES grocery_lists(id)
);
--- migration:down
DROP TABLE groceries;
DROP TABLE grocery_lists;
--- migration:end
