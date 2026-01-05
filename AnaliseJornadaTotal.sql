SELECT top 9999999
  jrn.JourneyName,
  jrn.VersionNumber,

  COUNT(DISTINCT s.SubscriberKey) AS ContactsSentAtLeastOneEmail,
  COUNT(s.SubscriberKey)          AS TotalSends,
  COUNT(DISTINCT o.SubscriberKey) AS UniqueOpeners,
  COUNT(o.SubscriberKey)          AS TotalOpens,
  COUNT(DISTINCT c.SubscriberKey) AS UniqueClickers,
  COUNT(c.SubscriberKey)          AS TotalClicks

FROM _Journey AS jrn
JOIN _JourneyActivity AS act
  ON jrn.VersionID = act.VersionID
JOIN _Job AS job
  ON act.JourneyActivityObjectID = job.TriggererSendDefinitionObjectID
LEFT JOIN _Sent AS s
  ON s.JobID = job.JobID
LEFT JOIN _Open AS o
  ON o.JobID = job.JobID AND o.SubscriberKey = s.SubscriberKey
LEFT JOIN _Click AS c
  ON c.JobID = job.JobID AND c.SubscriberKey = s.SubscriberKey

WHERE
  jrn.JourneyName = 'Remind Me - Confirmation'
  AND act.ActivityType IN ('EMAIL', 'EMAILV2')

GROUP BY
  jrn.JourneyName,
  jrn.VersionNumber

ORDER BY
  jrn.VersionNumber DESC
