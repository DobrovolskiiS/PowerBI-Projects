
-- провірка на дублікати
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


-- провірка на пусті значення
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

   
--середня оцінка сили паніки відносно відносно хворіб паціента, та поміти що більше 70% паціентів хворі депресією або тривожними розладами
SELECT medical_history 
	, COUNT(medical_history) 		
	, ROUND (avg(panic_score),2) 	AS AVG_attack_power
FROM panic_attacks
GROUP BY 1


-- Залежність статі і вікової категорії на середнє значення часу атаки, частоти атаки та сили панічної атаки. Жодної суттєвої різниці не помітно  
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


-- провірка чи залежність сили атаки до часу який в середнтому вона триває. Жодної суттєвої різниці не помітно 
select panic_score
	, count(*) 
	, ROUND (avg(duration_minutes),2) 			AS AVG_attack_duration_second
from public.panic_attacks
group by 1
order by 1 asc





select  count(*)
	, ROUND (avg(panic_score),2) 				as AVG_attack_power
from public.panic_attacks
where smoking = true 


SELECT COUNT(*) 								AS non_smokers_count
	, ROUND (avg(panic_score),2) 				AS AVG_attack_power
FROM panic_attacks
group by 2
--WHERE smoking = true ;

















