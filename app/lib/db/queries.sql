-- name: getAllEvents
SELECT *
FROM events
WHERE id IN (
  SELECT event_id
  FROM members
  WHERE user_id = $1::UUID
);

-- name: getAllEventMembers
SELECT *
FROM members
WHERE event_id IN (
  SELECT event_id
  FROM members
  WHERE user_id = $1::UUID
);

-- name: getEventLinks
SELECT *
FROM links
WHERE event_id = $1::UUID;
