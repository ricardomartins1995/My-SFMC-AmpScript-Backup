SELECT EmailId, 
Count(*) 
FROM AI_Email_Performance with(nolock)
GROUP BY EmailId
HAVING Count(*) > 1