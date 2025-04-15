# Exploratory Data Analysis 

select *
from layoffs_staging
where percentage_laid_off = 1
order by total_laid_off desc;

select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging;

select company, sum(total_laid_off)
from layoffs_staging
group by company
order by 2 desc;

select year(`date`), sum(total_laid_off)
from layoffs_staging
group by year(`date`)
order by 1 desc;

# rolling total of layoffs by month 
select substring(`date`,1,7) as `Month`, sum(total_laid_off)
from layoffs_staging
where substring(`date`,1,7) is NOT NULL
group by `Month`
order by 1 asc;

with rolling_total as 
(
select substring(`date`,1,7) as `Month`, sum(total_laid_off) as total_off
from layoffs_staging
where substring(`date`,1,7) is NOT NULL
group by `Month`
order by 1 asc
)
select `Month`, total_off,
sum(total_off) over(order by `Month`) as rolling_total1
from rolling_total;

# laid off by company per year
with company_year (company, years, total_laid_off) as 
(
select company, year(`date`), sum(total_laid_off)
from layoffs_staging
group by company, year(`date`)
), company_year_rank as
(select *, dense_rank() over(partition by years order by total_laid_off desc) as ranking
from company_year 
where years is not null
)
select *
from company_year_rank
where ranking <=5;

#the end