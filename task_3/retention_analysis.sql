WITH client_cohorts AS (
    SELECT 
        id_client,
        DATE_TRUNC('month', MIN(tran_time))::date AS cohort_month
    FROM transact
    GROUP BY id_client
),
client_activity AS (
    SELECT DISTINCT
        id_client,
        DATE_TRUNC('month', tran_time)::date AS activity_month
    FROM transact
),
cohort_activity AS (
    SELECT 
        c.cohort_month,
        a.activity_month,
        (EXTRACT(YEAR FROM a.activity_month) - EXTRACT(YEAR FROM c.cohort_month)) * 12 +
        (EXTRACT(MONTH FROM a.activity_month) - EXTRACT(MONTH FROM c.cohort_month)) AS period_number,
        c.id_client
    FROM client_cohorts c
    JOIN client_activity a ON c.id_client = a.id_client
    WHERE a.activity_month >= c.cohort_month
),
cohort_sizes AS (
    SELECT 
        cohort_month,
        COUNT(DISTINCT id_client) AS cohort_size
    FROM client_cohorts
    GROUP BY cohort_month
)
SELECT 
    cs.cohort_month,
    cs.cohort_size,
    ca.period_number,
    COUNT(DISTINCT ca.id_client) AS active_clients,
    ROUND(COUNT(DISTINCT ca.id_client)::numeric / cs.cohort_size * 100, 2) AS retention_rate_pct
FROM cohort_activity ca
JOIN cohort_sizes cs ON ca.cohort_month = cs.cohort_month
GROUP BY 
    cs.cohort_month,
    cs.cohort_size,
    ca.period_number
ORDER BY 
    cs.cohort_month,
    ca.period_number;