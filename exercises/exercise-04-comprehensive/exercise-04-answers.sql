-- ============================================
-- 练习四：综合练习 (20题)
-- ============================================

USE db_students;

-- 1. 查询北京男生的所有信息
SELECT * FROM students WHERE gender = '男' AND city = '北京';

-- 2. 查询成绩大于 85 的学生，按年龄升序
SELECT * FROM students WHERE score > 85 ORDER BY age;

-- 3. 统计每个城市男生的人数
SELECT city, COUNT(*) AS num_men FROM students WHERE gender = '男' GROUP BY city;

-- 4. 统计每个城市男女的平均分
SELECT city, gender, AVG(score) AS avg_score FROM students GROUP BY city, gender;

-- 5. 查询平均分最高的城市
SELECT city, AVG(score) AS avg_score FROM students GROUP BY city ORDER BY avg_score DESC LIMIT 1;

-- 6. 查询 2025 年 1 月已完成订单总金额
SELECT SUM(amount) AS total_amount 
FROM orders 
WHERE status = '已完成' 
  AND create_time BETWEEN '2025-01-01' AND '2025-01-31';

-- 7. 统计每个用户已完成订单总金额
SELECT user_id, SUM(amount) AS total_amount 
FROM orders 
WHERE status = '已完成' 
GROUP BY user_id;

-- 8. 查询已完成订单总金额大于 300 的用户
SELECT user_id, SUM(amount) AS total_amount 
FROM orders 
WHERE status = '已完成' 
GROUP BY user_id 
HAVING total_amount > 300;

-- 9. 查询每个城市成绩大于 80 的学生人数
SELECT city, COUNT(*) AS num_students 
FROM students 
WHERE score > 80 
GROUP BY city;

-- 10. 查询每个性别最高、最低分
SELECT gender, MAX(score) AS max_score, MIN(score) AS min_score 
FROM students 
GROUP BY gender;

-- 11. 统计每个用户取消的订单数量
SELECT user_id, COUNT(*) AS canceled_orders 
FROM orders 
WHERE status = '已取消' 
GROUP BY user_id;

-- 12. 查询年龄 18-19 岁、成绩大于 80 的学生
SELECT name, age, score 
FROM students 
WHERE score > 80 AND age BETWEEN 18 AND 19;

-- 13. 按城市分组，统计总分，只显示总分 > 150 的城市
SELECT city, SUM(score) AS total_score 
FROM students 
GROUP BY city 
HAVING total_score > 150;

-- 14. 查询订单金额大于 100 的已完成订单，按金额降序
SELECT * FROM orders 
WHERE amount > 100 AND status = '已完成' 
ORDER BY amount DESC;

-- 15. 统计每个城市男生、女生各多少人
SELECT city, gender, COUNT(*) AS total_persons 
FROM students 
GROUP BY city, gender 
ORDER BY city;

-- 16. 查询平均分大于 80、人数≥2 的城市
SELECT city, AVG(score) AS avg_score, COUNT(*) AS num_humans 
FROM students 
GROUP BY city 
HAVING avg_score > 80 AND num_humans >= 2;

-- 17. 找出订单最多的用户
SELECT user_id, COUNT(*) AS total_orders 
FROM orders 
GROUP BY user_id 
ORDER BY total_orders DESC 
LIMIT 1;

-- 18. 计算所有已完成订单的总金额、平均金额
SELECT SUM(amount) AS sum_amount, AVG(amount) AS avg_amount 
FROM orders 
WHERE status = '已完成';

-- 19. 查询上海、深圳女生的平均分
SELECT city, AVG(score) AS avg_score 
FROM students 
WHERE city IN ('上海', '深圳') AND gender = '女' 
GROUP BY city;

-- 20. 统计每个城市 18 岁学生的人数
SELECT city, COUNT(*) AS total_students 
FROM students 
WHERE age = 18 
GROUP BY city;
