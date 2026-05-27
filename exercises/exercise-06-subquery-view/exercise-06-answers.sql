-- ============================================
-- 练习六：子查询、视图与临时表 - 参考答案
-- ============================================

USE sql_study_db3;

-- ============================================
-- 题库一：子查询练习
-- ============================================

-- 题目 1：查询「订单金额大于所有订单平均金额」的订单信息（WHERE 子查询）
-- 解析：标量子查询获取平均值，外层 WHERE 比较
SELECT * FROM orders 
WHERE amount > (SELECT AVG(amount) FROM orders);

-- 题目 2：查询「和订单号 101 金额相同」的所有订单（WHERE 子查询）
-- 解析：标量子查询获取订单101的金额
SELECT * FROM orders 
WHERE amount = (SELECT amount FROM orders WHERE order_id = 101);

-- 题目 3：查询「购买过键盘」的用户姓名（WHERE 子查询 + IN）
-- 解析：多层子查询，用 IN 适配多结果场景
SELECT username FROM users 
WHERE user_id IN (
    SELECT user_id FROM orders 
    WHERE order_id IN (
        SELECT order_id FROM order_items WHERE product_name = '键盘'
    )
);

-- 题目 4：查询「没有购买过任何商品」的用户姓名（WHERE 子查询 + NOT IN）
-- 解析：NOT IN 找出在 orders 表中不存在的 user_id
SELECT username FROM users 
WHERE user_id NOT IN (SELECT DISTINCT user_id FROM orders);

-- 题目 5：查询「订单金额大于用户自己的平均订单金额」的订单（关联子查询）
-- 解析：关联子查询逐行执行，o2.user_id = o1.user_id 实现逐行关联
SELECT o1.* FROM orders o1
WHERE o1.amount > (
    SELECT AVG(amount) FROM orders o2 WHERE o2.user_id = o1.user_id
);

-- 题目 6：查询每个用户的订单总数，用 FROM 子句的子查询实现
-- 解析：派生表 + JOIN
SELECT u.username, o.order_count
FROM users u
JOIN (
    SELECT user_id, COUNT(*) AS order_count 
    FROM orders 
    GROUP BY user_id
) o ON u.user_id = o.user_id;

-- 题目 7：查询每个用户的订单总金额，且只显示总金额大于 200 的用户（FROM 子句子查询 + WHERE）
-- 解析：派生表生成统计结果，外层 WHERE 过滤
SELECT * FROM (
    SELECT u.username, SUM(o.amount) AS total_amount
    FROM users u 
    JOIN orders o ON u.user_id = o.user_id
    GROUP BY u.username
) t
WHERE t.total_amount > 200;

-- 题目 8：查询「购买过数码类商品」的用户姓名（多层子查询）
-- 解析：三层子查询：products → order_items → orders → users
SELECT username FROM users 
WHERE user_id IN (
    SELECT user_id FROM orders 
    WHERE order_id IN (
        SELECT order_id FROM order_items 
        WHERE product_name IN (
            SELECT product_name FROM products WHERE category = '数码'
        )
    )
);

-- 题目 9：查询「订单金额最高」的订单信息（WHERE 子查询）
-- 解析：标量子查询获取最大值
SELECT * FROM orders 
WHERE amount = (SELECT MAX(amount) FROM orders);

-- 题目 10：查询每个城市的订单平均金额，且只显示平均金额大于所有订单平均值的城市（FROM 子句子查询）
-- 解析：派生表按城市统计，外层与全局平均值比较
SELECT city, avg_amount FROM (
    SELECT u.city, AVG(o.amount) AS avg_amount
    FROM users u 
    JOIN orders o ON u.user_id = o.user_id
    GROUP BY u.city
) t
WHERE t.avg_amount > (SELECT AVG(amount) FROM orders);

-- ============================================
-- 题库二：视图与临时表
-- ============================================

-- 题目 11：创建视图 v_user_orders，包含用户姓名、订单号、订单金额、订单状态
-- 解析：CREATE OR REPLACE VIEW 是更规范的写法
CREATE OR REPLACE VIEW v_user_orders AS
SELECT 
    u.username, 
    o.order_id, 
    o.amount, 
    o.status
FROM users u 
JOIN orders o ON u.user_id = o.user_id;

-- 题目 12：通过视图 v_user_orders 查询所有「已完成」的订单
-- 解析：直接对视图进行过滤
SELECT * FROM v_user_orders WHERE status = '已完成';

-- 题目 13：创建临时表 temp_user_order_stats，统计每个用户的订单总数和总金额
-- 解析：临时表仅当前会话可见，会话结束自动删除
CREATE TEMPORARY TABLE temp_user_order_stats AS
SELECT 
    u.username, 
    COUNT(o.order_id) AS order_count, 
    SUM(o.amount) AS total_amount 
FROM users u 
LEFT JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.username;

-- 题目 14：从临时表 temp_user_order_stats 中查询订单总数≥2 的用户
-- 解析：直接查询临时表
SELECT * FROM temp_user_order_stats WHERE order_count >= 2;

-- 题目 15：创建视图 v_order_items_detail，包含订单号、用户姓名、商品名、数量、金额
-- 解析：三表 JOIN，使用别名消除歧义
CREATE OR REPLACE VIEW v_order_items_detail AS
SELECT 
    o.order_id AS 订单号, 
    u.username AS 用户姓名, 
    oi.product_name AS 商品名, 
    oi.quantity AS 数量, 
    o.amount AS 订单总金额,
    oi.price AS 商品单价
FROM orders o 
JOIN users u ON o.user_id = u.user_id
JOIN order_items oi ON o.order_id = oi.order_id;
