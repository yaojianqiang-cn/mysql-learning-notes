-- ============================================
-- 练习三：GROUP BY + HAVING (10题)
-- ============================================

USE db_students;

-- 1. 统计每个城市的学生人数
SELECT city, COUNT(*) AS num_students FROM students GROUP BY city;

-- 2. 统计每个性别的平均分
SELECT gender, AVG(score) AS avg_score FROM students GROUP BY gender;

-- 3. 统计每个用户的订单数
SELECT user_id, COUNT(*) AS num_orders FROM orders GROUP BY user_id;

-- 4. 统计每个用户的订单总金额
SELECT user_id, SUM(amount) AS sum_amount FROM orders GROUP BY user_id;

-- 5. 查询学生人数≥2 的城市
SELECT city, COUNT(*) AS num_students FROM students GROUP BY city HAVING num_students >= 2;

-- 6. 查询平均分≥85 的性别
SELECT gender, AVG(score) AS avg_score FROM students GROUP BY gender HAVING avg_score >= 85;

-- 7. 查询订单数≥2 的用户
SELECT user_id, COUNT(*) AS num_orders FROM orders GROUP BY user_id HAVING num_orders >= 2;

-- 8. 查询订单总金额≥300 的用户
SELECT user_id, SUM(amount) AS sum_amount FROM orders GROUP BY user_id HAVING sum_amount >= 300;

-- 9. 统计每个状态的订单数量
SELECT status, COUNT(*) AS sum_orders FROM orders GROUP BY status;

-- 10. 查询已完成订单数≥2 的用户
SELECT user_id, COUNT(*) AS sum_orders 
FROM orders 
WHERE status = '已完成'
GROUP BY user_id 
HAVING sum_orders >= 2;
