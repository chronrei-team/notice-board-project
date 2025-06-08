drop index idx_users_createdAt;
drop INDEX idx_users_status;
drop INDEX idx_users_role;
CREATE INDEX "idx_users_role_createdAt" ON "users" (
	"role",
	"createdAt"	DESC
);
CREATE INDEX "idx_users_status_createdAt" ON "users" (
	"status",
	"createdAt"	DESC
)