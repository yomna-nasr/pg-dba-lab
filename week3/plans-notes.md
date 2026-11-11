# W3-T2 Reading execution plans
- Full before and after plans are in plans-output.txt (database plan_lab, orders 1,000,000 rows, customers 100,000 rows).
- 1 Bad estimate: fixed with ANALYZE.
- 2 Seq scan: fixed with an index on orders(customer_id).
- 3 Nested loop on a large set: shown by disabling hash and merge joins, fixed by letting the planner choose.
- 4 Sort spill: fixed by raising work_mem for the session.
- 5 Function on a column: fixed with an expression index on lower(email).
