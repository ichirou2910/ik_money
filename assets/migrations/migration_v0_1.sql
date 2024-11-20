CREATE TABLE "transaction_new"
(
    id                 INTEGER primary key autoincrement,
    amount             INTEGER not null,
    title              TEXT    not null,
    description        TEXT    not null default '',
    "time"             TEXT,
    transactionStateId INTEGER not null,
    createdAt          TEXT    not null,
    updatedAt          TEXT    not null,
    deletedAt          TEXT
);

INSERT INTO "transaction_new" (amount, title, "time", transactionStateId, createdAt, updatedAt, deletedAt)
SELECT amount, description, "time", transactionStateId, createdAt,
       updatedAt, deletedAt
FROM "transaction";

DROP TABLE "transaction";

ALTER TABLE "transaction_new" RENAME TO "transaction";