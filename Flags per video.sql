# method 1
select 
    video_id,
    count(distinct concat(ifnull(user_firstname, ''), ' ', ifnull(user_lastname, ''))) as num_unique_users
from user_flags
where flag_id <> ''
group by video_id;


# method 2
WITH unique_users AS
  (SELECT video_id,
          CONCAT(COALESCE(user_firstname, ''), COALESCE(user_lastname, '')) AS user_identifier -- empty string
  FROM user_flags
  WHERE flag_id IS NOT NULL)
SELECT video_id,
      COUNT(DISTINCT user_identifier) AS num_unique_users
FROM unique_users
GROUP BY video_id;
