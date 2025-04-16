create database Tableau;
use Tableau;
select * from Tableau.`depression`;

# Working on gender column 
select gender, count(*) from Tableau.`depression`
group by gender;

SET SQL_SAFE_UPDATES = 0;

update Tableau.`depression`
set gender = 'F' where gender = 'Female';

update Tableau.`depression`
set gender = 'M' where gender = 'Male';

select * from Tableau.`depression`
where gender is null;

select * from Tableau.`depression`
where gender = '';

# Creating Age group column
select age from Tableau.`depression`
group by age
order by age desc;

alter table Tableau.`depression`
add Age_Group varchar(25);

update Tableau.`depression`
set Age_Group = 
case when Age between 18 and 24 then 'Young Adults'
else case when Age between 25 and 30 then 'Adults'
else "Early 30's" end end;

select Age_Group, count(*) from tableau.`depression`
group by Age_Group;

# Creating Index
select * from tableau.`depression`;

alter table tableau.`depression`
add Index_Column int not null auto_increment primary key;

# Depression Column - changing 0/1 to Yes or No 

select * from tableau.`depression`;

select * from information_schema.columns where table_name like 'depression';

ALTER TABLE tableau.`depression`
MODIFY COLUMN Depression VARCHAR(10);

update tableau.`depression`
set Depression = 'No' where depression = 0;

update tableau.`depression`
set Depression = 'Yes' where depression = 1;

select Depression, count(*) from tableau.`depression` group by Depression