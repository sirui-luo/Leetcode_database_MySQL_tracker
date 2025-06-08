WITH vote_values AS  
  (SELECT voter,  
          candidate,  
          1.0 / COUNT(*) OVER (PARTITION BY voter) AS vote_value  
   FROM voting_results  
   WHERE candidate IS NOT NULL  
     AND candidate <> ''), 
candidate_votes AS  
(select 
    candidate,
    round(sum(vote_value), 3) as n_votes,
    dense_rank() over (order by sum(vote_value) desc) as place
from vote_values
group by candidate
)
select candidate from candidate_votes
where place = 1

