---
type: resource
aliases: [Snippets]
---
# Commands

## SQL
Count the accounts with no activity since 2023 (old CRM export).
```sql
SELECT COUNT(*) FROM accounts WHERE last_activity < '2023-01-01';
```
