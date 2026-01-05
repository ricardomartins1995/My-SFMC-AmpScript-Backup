SELECT
    L.SubscriberKey,
    L.LatestEventDate
FROM
    (
        SELECT
            A.SubscriberKey,
            MAX(A.EventDate) AS LatestEventDate
        FROM
            _Sent A WITH (NOLOCK)
        INNER JOIN
            _Job B WITH (NOLOCK)
            ON A.JobID = B.JobID
        WHERE
            B.EmailName IN ('Product interest - V2', 'Product interest - AI Version')
            AND CONVERT(DATE,A.EventDate) >= DATEADD(DAY, -8, CAST(GETUTCDATE() AS DATE))
            AND CONVERT(DATE,A.EventDate) < CAST(GETUTCDATE() AS DATE)
        GROUP BY
            A.SubscriberKey
    ) L
LEFT JOIN
    (
        SELECT DISTINCT
            D.ID AS SubscriberKey
        FROM
            orderRecieptHeader D WITH (NOLOCK)
        WHERE
            CONVERT(DATE,D.OrderDate) >= DATEADD(DAY, -7, CAST(GETUTCDATE() AS DATE))
    ) O
    ON L.SubscriberKey = O.SubscriberKey
WHERE
    O.SubscriberKey IS NULL