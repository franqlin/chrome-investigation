SELECT
    T1.url,
    T1.title,
    -- Calcula a duração total em segundos
    SUM(T2.visit_duration) / 1000 AS total_duration_seconds,
    -- Opcional: Formata a duração total em um formato HH:MM:SS para melhor leitura
    TIME(SUM(T2.visit_duration) / 1000, 'unixepoch') AS total_duration_formatted
FROM
    urls AS T1
INNER JOIN
    visits AS T2
ON
    T1.id = T2.url
GROUP BY
    T1.url, T1.title
ORDER BY
    total_duration_seconds DESC
LIMIT 5;
