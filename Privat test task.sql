# Task 1
# Створив таблицю відповідно до зразка в завданні

create table `privat_bank_test_task`
(
    `SESSION_ID` VARCHAR(50) NOT NULL,
    `CREATE_TIME` datetime,
    `CLIENT_ID` int,
    `ROLE` varchar(15),
    `PRODUCT` varchar(250), 
    `THEME` varchar(250),
    `SUM_THEME` varchar(250), 
    `DURATION` int, 
    `CLIENT_ID_JUR` int,
    PRIMARY KEY (`SESSION_ID`)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_0900_ai_ci;

select *
from privat_bank_test_task;

# вношу значення, які були вказані в прикладі
INSERT INTO `privat_bank_test_task`
(SESSION_ID, 
CREATE_TIME, 
CLIENT_ID, 
ROLE, 
PRODUCT, 
THEME, 
SUM_THEME, 
DURATION, 
CLIENT_ID_JUR)
VALUES 
('347683-34234-4324EB-232ED13', 
'2021-06-16 14:17:54', 
1083423532, 
'VIP', 
'Розрахунковий рахунок', 
'Операції по рахунку', 
'ПЕРЕВІРКА НАЯВНОСТІ КАРТ-ХОЛДУ',
'1814',
'475435436');

# 1st Question 
# вивести скільки унікальних звернень(session_id), та унікальних клієнтів(client_id)
# надійшло за кожною роллю за останні 2 місяці(минулий місяць з 1-го числа та поточний до вчорашної дати)

select 
    ROLE,
    count(distinct Session_ID) as unique_sessions,
    count(distinct Client_ID) as unqiue_clients
from privat_bank_test_task
where CREATE_TIME >= DATE_SUB(curdate(), interval 2 month)
group by role
;

# 2nd Question
# скільки було звернень в розрізі: продукт, тематика, підтематика
# та зробити зведення лише за продуктами. Період 2 місяці(минулий з 1-го числа і поточний без верхньої межі)

select
    product,
    theme,
    sum_theme,
    count(*) as total
from privat_bank_test_task
where create_time >= date_format(date_sub(curdate(), interval 1 month), '%Y-%m-01')
GROUP BY product, theme, sum_theme
order by product, total desc;

# 3rd Question
# середня тривалість діалогів в розрізі ролей(враховувати діалоги з 8(включно) до 20 години(не включно)) за попередній місяць

select 
    role,
    avg(duration) as avg_duration
from privat_bank_test_task
where 
    create_time >= date_format(date_sub(curdate(), interval 1 month), '%Y-%m-01')
    and create_time < date_format(curdate(), '%Y-%m-01')
    and hour(create_time) >= 8
    and hour(create_time) < 20
group by role
order by avg_duration desc; 

#4th Question
# топ 5 клієнтів за зверненнями та кількість їх звернень, які зверталися більше 10 раз за минулий місяць

select
    client_id,
    count(*) as counter
from privat_bank_test_task
where
    create_time >= date_format(date_sub(curdate(), interval 1 month), '%Y-%m-01')
    and create_time < date_format(curdate(), '%Y-%m-01')
group by client_id
having count(*) > 10
order by counter desc
limit 5;

# Task 2
# На основі прикладів даних у таблиці створюю тимчасову таблицю

create temporary table temporary_calls as
select
    c.call_id,
    c.date_start,
    max(case when a.attr_id = 100 then a.value END) as clid,
    max(case when a.attr_id = 200 then a.value END) as LDAP,
    MAX(case when a.attr_id = 300 then a.value end) as THEM
FROM calls c
left join calls_attr a
    on c.call_id = a.call_id
where c.date_start >= date_format(date_sub(curdate(), interval 1 month), '%Y-%m-01')
    and c.date_start < curdate() + interval 1 day
group by c.call_id, c.date_start;


# Task 3
#скопіював скрипт з сайту 
CREATE TABLE IF NOT EXISTS `docs` (
  `id` int(6) unsigned NOT NULL,
  `rev` int(3) unsigned NOT NULL,
  `content` varchar(200) NOT NULL,
  PRIMARY KEY (`id`,`rev`)
) DEFAULT CHARSET=utf8;
INSERT INTO `docs` (`id`, `rev`, `content`) VALUES
  ('1', '1', 'The earth is flat'),
  ('2', '1', 'One hundred angels can dance on the head of a pin'),
  ('1', '2', 'The earth is flat and rests on a bull\'s horn'),
  ('1', '3', 'The earth is like a ball.');
  
# мій скрипт для вирішення завдання 
  select
  	d.id,
    d.rev,
    d.content
  from docs d
  join (
    select id, max(rev) as max_rev
    from docs
    group by id
    ) t
   on d.id = t.id and d.rev = t.max_rev;



