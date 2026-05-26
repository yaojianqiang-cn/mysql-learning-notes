-- ============================================
-- 练习二：ORDER BY + 聚合函数 (15题)
-- ============================================

USE db_students;

-- 1. 查询所有学生，按成绩降序排序
SELECT * FROM students ORDER BY score DESC;

-- 2. 查询所有学生，按年龄升序、成绩降序
SELECT * FROM students ORDER BY age ASC, score DESC;

-- 3. 统计学生总人数
SELECT COUNT(*) AS count_students FROM students;

-- 4. 统计女生人数
SELECT COUNT(*) AS count_students_girls FROM students WHERE gender = '女';

-- 5. 计算所有学生的平均分
SELECT AVG(score) AS avg_score FROM students;

-- 6. 找出最高成绩
SELECT MAX(score) AS max_score FROM students;

-- 7. 找出最低成绩
SELECT MIN(score) AS min_score FROM students;

-- 8. 计算北京学生的总分
SELECT SUM(score) AS sum_score FROM students WHERE city = '北京';

-- 9. 统计订单总数
SELECT COUNT(*) AS count_orders FROM orders;

-- 10. 计算所有订单总金额
SELECT SUM(amount) AS sum_amount FROM orders;

-- 11. 计算已完成订单的平均金额
SELECT AVG(amount) AS avg_amount_finished FROM orders WHERE status = '已完成';

-- 12. 找出最大订单金额
SELECT MAX(amount) AS max_amount FROM orders;

-- 13. 统计用户 1 的订单数量
SELECT user_id, COUNT(*) AS count_orders FROM orders WHERE user_id = 1;

-- 14. 查询每个城市的学生人数
SELECT city, COUNT(*) AS num_students FROM students GROUP BY city;

-- 15. 查询每个性别的平均分
SELECT gender, AVG(score) AS avg_score FROM students GROUP BY gender;
