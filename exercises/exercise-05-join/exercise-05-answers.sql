-- ============================================
-- SQL JOIN 练习题答案
-- ============================================

USE sql_study_db2;

-- 注意：orders 表在 JOIN 练习中名为 orders_join，避免与基础练习的 orders 表冲突

-- ============================================
-- 题库一：基础 JOIN 练习（两表关联）
-- ============================================

-- 题目 1：查询每个用户的订单信息（只显示有订单的用户）
-- 解析：INNER JOIN 只返回两表匹配的记录
SELECT 
    u.username, 
    o.order_id, 
    o.amount, 
    o.create_time, 
    o.status
FROM users u
INNER JOIN orders_join o ON u.user_id = o.user_id;

-- 题目 2：查询所有用户的订单信息（包括没有订单的用户，订单字段显示 NULL）
-- 解析：LEFT JOIN 保留左表(users)所有记录，右表不匹配则为 NULL
SELECT 
    u.username, 
    o.order_id, 
    o.amount, 
    o.create_time, 
    o.status
FROM users u
LEFT JOIN orders_join o ON u.user_id = o.user_id;

-- 题目 3：查询订单金额大于 100 的用户姓名和订单金额
-- 解析：INNER JOIN + WHERE 条件过滤
SELECT 
    u.username, 
    o.amount
FROM users u
INNER JOIN orders_join o ON u.user_id = o.user_id
WHERE o.amount > 100;

-- 题目 4：查询所有已完成订单的用户姓名、订单金额和创建时间
-- 解析：INNER JOIN + WHERE 状态过滤
SELECT 
    u.username, 
    o.amount, 
    o.create_time
FROM users u
INNER JOIN orders_join o ON u.user_id = o.user_id
WHERE o.status = '已完成';

-- 题目 5：查询每个用户的订单数量（只统计有订单的用户）
-- 解析：INNER JOIN + GROUP BY + COUNT()
SELECT 
    u.username, 
    COUNT(o.order_id) AS order_count
FROM users u
INNER JOIN orders_join o ON u.user_id = o.user_id
GROUP BY u.user_id, u.username;

-- 题目 6：查询每个用户的订单数量（包括无订单用户，数量显示 0）
-- 解析：LEFT JOIN + GROUP BY + COUNT() + IFNULL()
SELECT 
    u.username, 
    IFNULL(COUNT(o.order_id), 0) AS order_count
FROM users u
LEFT JOIN orders_join o ON u.user_id = o.user_id
GROUP BY u.user_id, u.username;

-- 题目 7：查询订单金额最大的订单对应的用户姓名和订单信息
-- 解析：INNER JOIN + ORDER BY + LIMIT 1
SELECT 
    u.username, 
    o.order_id, 
    o.amount, 
    o.create_time, 
    o.status
FROM users u
INNER JOIN orders_join o ON u.user_id = o.user_id
ORDER BY o.amount DESC
LIMIT 1;

-- 题目 8：查询 "北京" 用户的所有订单（包括没有订单的北京用户）
-- 解析：LEFT JOIN + WHERE 城市过滤
SELECT 
    u.username, 
    o.order_id, 
    o.amount, 
    o.create_time, 
    o.status
FROM users u
LEFT JOIN orders_join o ON u.user_id = o.user_id
WHERE u.city = '北京';

-- 题目 9：查询已取消订单对应的用户姓名
-- 解析：INNER JOIN + WHERE 状态过滤
SELECT 
    u.username,
    o.order_id,
    o.amount
FROM users u
INNER JOIN orders_join o ON u.user_id = o.user_id
WHERE o.status = '已取消';

-- 题目 10：查询每个用户的已完成订单总金额（只显示有已完成订单的用户）
-- 解析：INNER JOIN + WHERE + GROUP BY + SUM()
SELECT 
    u.username, 
    SUM(o.amount) AS total_amount
FROM users u
INNER JOIN orders_join o ON u.user_id = o.user_id
WHERE o.status = '已完成'
GROUP BY u.user_id, u.username;

-- ============================================
-- 题库二：进阶 JOIN 练习（三表关联）
-- ============================================

-- 题目 11：查询每个订单的用户姓名、订单金额和商品明细
-- 解析：三表 INNER JOIN
SELECT 
    u.username,
    o.order_id,
    o.amount AS order_amount,
    oi.product_name,
    oi.quantity,
    oi.price
FROM users u
INNER JOIN orders_join o ON u.user_id = o.user_id
INNER JOIN order_items oi ON o.order_id = oi.order_id;

-- 题目 12：查询所有订单（包括无明细的订单）的用户姓名和商品信息
-- 解析：INNER JOIN + LEFT JOIN，保留所有订单
SELECT 
    u.username,
    o.order_id,
    o.amount,
    oi.product_name,
    oi.quantity
FROM users u
INNER JOIN orders_join o ON u.user_id = o.user_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id;

-- 题目 13：查询每个用户购买的所有商品名称和数量
-- 解析：三表 INNER JOIN，注意 GROUP BY 要包含所有非聚合列
SELECT 
    u.username,
    oi.product_name,
    SUM(oi.quantity) AS total_quantity
FROM users u
INNER JOIN orders_join o ON u.user_id = o.user_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY u.user_id, u.username, oi.product_name;

-- 题目 14：查询订单金额大于 200 的订单对应的用户、商品信息
-- 解析：三表 INNER JOIN + WHERE 金额过滤
SELECT 
    u.username,
    o.order_id,
    o.amount,
    oi.product_name,
    oi.quantity
FROM users u
INNER JOIN orders_join o ON u.user_id = o.user_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.amount > 200;

-- 题目 15：查询每个用户的商品购买总数量（只显示有购买记录的用户）
-- 解析：三表 INNER JOIN + GROUP BY + SUM(quantity)
SELECT 
    u.username,
    SUM(oi.quantity) AS total_quantity
FROM users u
INNER JOIN orders_join o ON u.user_id = o.user_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY u.user_id, u.username;

-- 题目 16：查询每个订单的商品总金额（单价 × 数量）和订单金额
-- 解析：INNER JOIN + GROUP BY + SUM(price * quantity)
SELECT 
    o.order_id,
    o.amount AS order_amount,
    SUM(oi.price * oi.quantity) AS items_total
FROM orders_join o
INNER JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, o.amount;

-- 题目 17：查询所有用户（包括无订单用户）的订单和商品明细
-- 解析：双 LEFT JOIN：users LEFT JOIN orders LEFT JOIN order_items
SELECT 
    u.username,
    o.order_id,
    oi.product_name,
    oi.quantity
FROM users u
LEFT JOIN orders_join o ON u.user_id = o.user_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id;

-- 题目 18：查询 "已完成" 订单中，购买了 "笔记本" 的用户姓名和订单信息
-- 解析：三表 INNER JOIN + WHERE 多条件过滤
SELECT 
    u.username,
    o.order_id,
    o.amount,
    o.create_time,
    oi.product_name,
    oi.quantity
FROM users u
INNER JOIN orders_join o ON u.user_id = o.user_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = '已完成'
  AND oi.product_name = '笔记本';
