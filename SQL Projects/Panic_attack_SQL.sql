-- Checking for duplicates.
with duplicate_check AS(
	SELECT  COUNT(*) 
	FROM public.panic_attacks
	GROUP BY id, age, gender, panic_attack_frequency, duration_minutes, "trigger", heart_rate, 
	         sweating, shortness_of_breath, dizziness, chest_pain, trembling, medical_history, 
	         medication, caffeine_intake, exercise_frequency, sleep_hours, alcohol_consumption, 
	         smoking, therapy, panic_score
	HAVING COUNT(*) > 1
)
select * from duplicate_check

--Checking for unique values in key columns.
SELECT 'gender' , STRING_AGG(distinct gender, '  ||  ')						AS unique_values
FROM panic_attacks
UNION 
SELECT 'trigger', STRING_AGG(distinct trigger, '  ||  ') 					AS unique_values
FROM panic_attacks  
UNION 
SELECT 'medical_history', STRING_AGG(distinct medical_history, '  ||  ') 	AS unique_values
FROM panic_attacks


-- Checking for empty (NULL) values
SELECT COUNT(*)
FROM public.panic_attacks
WHERE age IS NULL
   OR gender IS NULL
   OR panic_attack_frequency IS NULL
   OR duration_minutes IS NULL
   OR "trigger" IS NULL
   OR heart_rate IS NULL
   OR sweating IS NULL
   OR shortness_of_breath IS null
   OR dizziness IS NULL
   OR chest_pain IS null
   OR trembling IS NULL
   OR medical_history IS NULL
   OR medication IS NULL
   OR caffeine_intake IS NULL
   OR exercise_frequency IS NULL
   OR sleep_hours IS NULL
   OR alcohol_consumption IS NULL
   OR smoking IS NULL
   OR therapy IS null
   OR panic_score IS null

   
-- Average panic severity score relative to patient illnesses, noting that more than 70% of patients suffer from depression or anxiety disorders.
SELECT medical_history 
	, COUNT(medical_history) 		
	, ROUND (avg(panic_score),2) 	AS AVG_attack_power
FROM panic_attacks
GROUP BY 1


-- Dependence of gender and age category on the average attack duration, attack frequency, and panic attack severity. No significant differences observed. 
SELECT gender  
	, CASE 
		WHEN age BETWEEN 18 AND 30 THEN '18-30'
		WHEN age BETWEEN 30 AND 40 THEN '30-40'
		WHEN age BETWEEN 40 AND 50 THEN '40-50'
		WHEN age BETWEEN 50 AND 64 THEN '50-64'
	END 										AS age_category
	, ROUND (avg(duration_minutes),2) 			AS AVG_attack_duration_second
	, ROUND (avg(panic_attack_frequency),2) 	AS AVG_frequency_of_panic_attack
	, ROUND (avg(panic_score),2) 				as AVG_attack_power
	, ROUND (STDDEV_POP(panic_score),2) 
FROM public.panic_attacks
where panic_attack_frequency > 0
GROUP BY 1, 2 
ORDER BY 1, 2


-- Checking whether panic attack severity depends on its average duration. No significant differences observed.
select panic_score
	, count(*) 
	, ROUND (avg(duration_minutes),2) 			AS AVG_attack_duration_second
from public.panic_attacks
group by 1
order by 1 asc



-- Checking the impact of age category and sleep duration on the average frequency of panic attacks and the difference from the median value. No significant differences observed.
SELECT  
    CASE  
        WHEN age BETWEEN 18 AND 29 THEN '18-29'  
        WHEN age BETWEEN 30 AND 39 THEN '30-39'  
        WHEN age BETWEEN 40 AND 49 THEN '40-49'  
        WHEN age BETWEEN 50 AND 64 THEN '50-64'  
    END 																AS age_category 
    , CASE  
	    WHEN sleep_hours <4 THEN '<4'  
        WHEN sleep_hours BETWEEN 4 AND 5.9 THEN '4-6'  
        WHEN sleep_hours BETWEEN 6 AND 7.9 THEN '6-8'  
        WHEN sleep_hours > 8 THEN '>8'  
    END 																AS sleep_hours  
    , ROUND(AVG(panic_attack_frequency),2) 								AS avg_panic_attack_frequency
    , ROUND(STDDEV_POP(panic_score),2) 									AS standard_deviation 
    , PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY panic_attack_frequency) AS median_panic_attack_frequency  
FROM panic_attacks  
GROUP BY 1, 2  
ORDER BY  ROUND(AVG(panic_attack_frequency),2) DESC;



-- Does smoking negatively affect patients, or does it act more as a calming agent? No significant differences observed.
SELECT CASE
		WHEN smoking = TRUE THEN 'smokes'
		WHEN smoking = FALSE THEN 'does not smoke'
	END											
	, ROUND (AVG(panic_score),2) 				AS AVG_attack_power
	, ROUND (AVG(duration_minutes),2) 			AS AVG_duration_minutes
	, ROUND (AVG(panic_attack_frequency),2) 	AS AVG_panic_attack_frequency
FROM panic_attacks
GROUP BY 1




















