
WITH blocker AS
  (SELECT session_id,
    session_serial#,
    program,
    action,
    module,
    client_id,
    session_type
  FROM v$active_session_history
  )
SELECT  DISTINCT a.blocking_session "BLOCKER_SID",
  a.session_id "WAITER_SID",
  a.PROGRAM "WAIT_PROG",
  a.sql_id "SQLID",
  substr(c.sql_text,1,55) "SQL_TEXT",
  b.program "BLOCKING_PROG",
  a.ACTION "WAIT_ACTION",
  b.action "BLOCKING_ACTION" ,
  a.CLIENT_ID "WAIT_CLIENT",
  b.client_id "BLOCKING_CLIENT",  
  b.MODULE "BLOCKING_MODULE",
  a.module "WAIT_MODULE",
  a.time_waited/1000000 "WAIT_TIME_SECS"
FROM v$active_session_history a ,
  blocker b,
  v$sql c
WHERE a.blocking_session IS NOT NULL
AND a.blocking_session    =b.session_id
AND a.sample_time > sysdate -3/24
--AND b.session_type != 'BACKGROUND'
AND a.time_waited/1000000 > 60
AND a.sql_id = c.sql_id
--AND a.session_id = 2269
/*group by
  a.blocking_session ,
  a.session_id ,
  a.PROGRAM ,
  b.program ,
  a.ACTION ,
  b.action  ,
  a.CLIENT_ID ,
  b.client_id ,  
  b.MODULE,
  a.module ,
  a.time_waited  */
;
