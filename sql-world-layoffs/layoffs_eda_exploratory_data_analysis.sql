/* Exploratory Data Analysis for World Layoffs dataset

Purpose: To explore and analyze the world layoffs from March 2020 to March 2023
to understand general patterns
*/

SELECT *
FROM layoffs_staging2;

-- What was the max number and max percentage of people laid off?
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2; 

-- Return all info on companies that went down (aka 100% laid off). 
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- What was the total amount of layoffs per company?
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- When was the first and last entry of this dataset?
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- What was the total amount of layoffs per industry?
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT *
FROM layoffs_staging2;

-- What was the total amount of layoffs per country?
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- What was the total amount of layoffs per year?
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- What was the total amount of layoffs per company stage?
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

-- What was the average percentage laid off per company? Note: Results are insignificant. 
SELECT company, AVG(percentage_laid_off) 
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- What is the rolling total of layoffs per month? 
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
;

WITH Rolling_total AS 
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
) 
SELECT `MONTH`, total_off, SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_total;

-- How many employees did each company lay off each year?
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

-- For each year, rank the companies by total number of layoffs in descending order.
WITH Company_Year (company, years, total_laid_off) AS 
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS 
(
SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE ranking <= 5
;











