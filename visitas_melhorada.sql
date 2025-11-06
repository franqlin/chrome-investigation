SELECT
    T1.id AS url_id,
    T1.url AS current_url,
    T1.title AS current_title,
    datetime(T2.visit_time/1000000 + strftime('%s', '1601-01-01'), 'unixepoch', 'localtime') AS visit_datetime,
    T2.visit_duration/1000 AS visit_duration_seconds,
    T2.transition AS raw_transition_value, -- Valor original do bitmask
    -- Aplica a máscara bit a bit (T2.transition & 255) e traduz o resultado
    CASE (T2.transition & 255)
        WHEN 0 THEN 'LINK (Clique em Link)'
        WHEN 1 THEN 'TYPED (Digitado na Barra)'
        WHEN 2 THEN 'AUTO_BOOKMARK (Favorito/Bookmark)'
        WHEN 3 THEN 'AUTO_SUBFRAME (Sub-frame Automático)'
        WHEN 4 THEN 'MANUAL_SUBFRAME (Sub-frame Manual)'
        WHEN 5 THEN 'GENERATED (Autocompletar/Gerado)'
        WHEN 6 THEN 'AUTO_TOPLEVEL (Redirecionamento/Automático)'
        WHEN 7 THEN 'FORM_SUBMIT (Envio de Formulário)'
        WHEN 8 THEN 'RELOAD (Recarregamento)'
        WHEN 9 THEN 'KEYWORD (Pesquisa por Palavra-chave)'
        WHEN 10 THEN 'KEYWORD_GENERATED (Pesquisa Gerada)'
        ELSE 'OUTRO (' || (T2.transition & 255) || ')'
    END AS transition_type,
    -- Informações da URL de Origem (from_url)
    T4.url AS from_url,
    T4.title AS from_title
FROM
    urls AS T1 -- URL atual
INNER JOIN
    visits AS T2 ON T1.id = T2.url -- Visita atual
LEFT JOIN
    visits AS T3 ON T2.from_visit = T3.id -- Visita de origem (T3.id é o from_visit)
LEFT JOIN
    urls AS T4 ON T3.url = T4.id -- URL de origem (T4.id é o T3.url)
ORDER BY
    T2.visit_time ASC;
