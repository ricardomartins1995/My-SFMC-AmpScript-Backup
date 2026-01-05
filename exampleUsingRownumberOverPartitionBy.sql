SELECT
    C.SubscriberKey,
    C.EventDate,
    GETUTCDATE() AS LastModifiedDate,
    1 AS ContentBlock
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
        CONVERT(DATE,A.EventDate) = DATEADD(DAY,-1,CONVERT(DATE,GETUTCDATE()))
    AND
        B.EmailName LIKE '%EMAILEXAMPLE%'
    ) C
    
WHERE
    C.RN = 1
AND
    NOT EXISTS(
        SELECT 1
        FROM 
            orderGENERICDE D WITH(NOLOCK)
        WHERE
            C.SubscriberKey = D.ID
        AND
            CONVERT(DATE,D.OrderDate) >= DATEADD(DAY, -7, CONVERT(DATE,GETUTCDATE()))
    )