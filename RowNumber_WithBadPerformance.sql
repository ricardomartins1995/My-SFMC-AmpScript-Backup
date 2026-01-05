SELECT
    C.SubscriberKey,
    C.EventDate
FROM 
    (
    SELECT
        A.*,
        ROW_NUMBER() OVER(PARTITION BY SubscriberKey ORDER BY EventDate DESC) AS RN
    FROM
        _Sent A WITH(NOLOCK)
    INNER JOIN
            _Job B WITH(NOLOCK)
        ON
            A.JobID = B.JobID
    WHERE
        (B.EmailName = 'Product interest - V2' OR B.EmailName = 'Product interest - AI Version')
    AND
        (
            CONVERT(DATE,A.EventDate) <= DATEADD(DAY,-1, CONVERT(DATE,GETUTCDATE()))
        AND
            CONVERT(DATE,A.EventDate) >= DATEADD(DAY,-8, CONVERT(DATE,GETUTCDATE()))
        )
    ) C
    
WHERE

    C.RN = 1
AND
    NOT EXISTS(
        SELECT 1
        FROM 
            orderDATABASEeg D WITH(NOLOCK)
        WHERE
            C.SubscriberKey = D.ID
        AND
            CONVERT(DATE,D.OrderDate) >= DATEADD(DAY, -7, CONVERT(DATE,GETUTCDATE()))
    )