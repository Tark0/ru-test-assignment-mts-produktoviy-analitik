SELECT 
    id_client,
    SUM(sum_tran) AS total_spent_30d
FROM transact
WHERE tran_time >= CURRENT_DATE - INTERVAL '30 days'
  AND tran_time <= NOW()
GROUP BY id_client
ORDER BY total_spent_30d DESC;
