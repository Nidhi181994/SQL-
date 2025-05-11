-- DATA CLEANING

SELECT *
FROM layoffs;


-- 1. REMOVE DUPLICATES
-- 2. Standardize the data
-- 3. CHECK AND REMOVE VALUES(NULL OR BLANK )
-- 4. CHECK AND REMOVE any columns

-- CREATING STAGING TABLE
CREATE TABLE layoffs_staging
LIKE layoffs;

-- INSERT INTO STAGING TABLE
INSERT layoffs_staging
SELECT *
FROM layoffs;

-- testing 
SELECT * ,
ROW_NUMBER() OVER(PARTITION BY funds_raised_millions),
RANK() OVER(PARTITION BY funds_raised_millions)
from layoffs_staging;

-- Find duplicate rows 
        
    WITH duplicate_cte AS      
(
     SELECT *,
		ROW_NUMBER() OVER(
			PARTITION BY company,location,industry, total_laid_off , percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
	    FROM 
		layoffs_staging

) 
DELETE
FROM 	
duplicate_cte
WHERE 
	row_num > 1;


 -- Checking company if any null value is there
 
SELECT *
FROM layoffs_staging
WHERE company = 'Cazoo';
 
 -- we need to create new columns as row_number because duplicate_cte cannot delete the duplicate data in table 
 
 CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
		ROW_NUMBER() OVER(
			PARTITION BY company,location,industry, total_laid_off , percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
	    FROM 
		layoffs_staging;
        
        
DELETE
FROM layoffs_staging2
WHERE row_num > 1 ;

-- Standazing the data 
-- Trimimg the company columns to make it neater
 
 SELECT company , TRIM(company)
 FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

-- checking industry 

SELECT DISTINCT(industry)
 FROM layoffs_staging2
 ORDER BY 1;
 
 SELECT *
 FROM layoffs_staging2
 WHERE industry LIKE 'Crypto%';

 UPDATE layoffs_staging2
 SET industry = 'Crypto'
 WHERE industry LIKE 'Crypto%';
 
 
SELECT DISTINCT(location)
 FROM layoffs_staging2
 ORDER BY 1;
 
 -- TRAILING coming at the end of the text
SELECT DISTINCT(country), TRIM( TRAILING '.' FROM country)
 FROM layoffs_staging2
 ORDER BY 1;
 
 UPDATE layoffs_staging2
 SET country = TRIM( TRAILING '.' FROM country)
 WHERE country LIKE 'United States%';


-- Change the date format

SELECT `date`,
STR_TO_DATE(`date`,'%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`,'%m/%d/%Y');

SELECT `date`
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date`  DATE;

-- Checking of having null value or blank space in any columns if any then remove then or not remove them 
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '' ;

SELECT *
FROM layoffs_staging2
WHERE company ='Airbnb';

SELECT t1.industry,t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE(t1.industry IS NULL  OR  t2.industry = '')
AND t2.industry IS  NOT NULL;
    
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;