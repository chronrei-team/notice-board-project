CREATE TABLE "user_suspend" (
	"id"	TEXT,
	"suspendedAt"	TEXT NOT NULL,
	"suspendedEndAt"	TEXT,
	"reason"	TEXT,
	PRIMARY KEY("id"),
	FOREIGN KEY("id") REFERENCES "users"("id") ON DELETE CASCADE
);

