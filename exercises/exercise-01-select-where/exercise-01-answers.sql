-- ============================================
-- 练习一：SELECT + WHERE 基础查询 (15题)
-- ============================================

USE db_students;

-- 1. 查询所有学生的姓名和成绩
SELECT name, score FROM students;

-- 2. 查询所有学生信息，只显示前 5 条
SELECT * FROM students LIMIT 5;

-- 3. 查询成绩大于 80 分的学生
SELECT * FROM students WHERE score > 80;

-- 4. 查询年龄等于 18 岁的学生
SELECT * FROM students WHERE age = 18;

-- 5. 查询性别为女且城市在北京的学生
SELECT * FROM students WHERE gender = '女' AND city = '北京';

-- 6. 查询成绩在 70~90 之间的学生
SELECT * FROM students WHERE score BETWEEN 70 AND 90;

-- 7. 查询城市是上海或深圳的学生
SELECT * FROM students WHERE city IN ('上海', '深圳');

-- 8. 查询姓名为 "张三" 的学生
SELECT * FROM students WHERE name = '张三';

-- 9. 查询成绩不等于 67 分的学生
SELECT * FROM students WHERE score != 67;
-- 或
-- SELECT * FROM students WHERE score <> 67;

-- 10. 查询年龄大于 19 岁或成绩大于 90 分的学生
SELECT * FROM students WHERE age > 19 OR score > 90;

-- 11. 查询已完成的订单
SELECT * FROM orders WHERE status = '已完成';

-- 12. 查询订单金额大于 200 的订单
SELECT * FROM orders WHERE amount > 200;

-- 13. 查询 2025-01-01 之后创建的订单
SELECT * FROM orders WHERE create_time > '2025-01-01';

-- 14. 查询用户 1 的所有订单
SELECT * FROM orders WHERE user_id = 1;

-- 15. 查询已完成且金额大于 100 的订单
SELECT * FROM orders WHERE status = '已完成' AND amount > 100;
