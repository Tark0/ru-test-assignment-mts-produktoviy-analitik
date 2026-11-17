WITH top_clients AS (
    SELECT 
        id_client
    FROM transact
    GROUP BY id_client
    ORDER BY SUM(sum_tran) DESC
    LIMIT 100
)
SELECT 
    t.id_client,
    DATE_TRUNC('month', t.tran_time)::date AS tran_month,
    SUM(t.sum_tran) AS monthly_spent
FROM transact t
JOIN top_clients tc ON t.id_client = tc.id_client
GROUP BY 
    t.id_client, 
    DATE_TRUNC('month', t.tran_time)
ORDER BY 
    t.id_client, 
    tran_month;