-- ============================================
-- 练习八：综合复习 - 参考答案
-- ============================================

USE sql_review_db234;

-- ============================================
-- 一、基础 JOIN 题（5 题）
-- ============================================

-- 题目 1：查询所有订单，显示用户名、订单日期、订单总金额
-- 解析：JOIN users 和 orders 表
SELECT u.username, o.order_date, o.total_amount
FROM users u
JOIN orders o ON u.user_id = o.user_id;

-- 题目 2：查询所有订单明细，显示用户名、订单日期、商品名、分类、单价
-- 解析：三表 JOIN：users → orders → order_items
SELECT u.username, o.order_date, oi.product_name, oi.category, oi.price
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_items oi ON o.order_id = oi.order_id;

-- 题目 3：查询 "北京" 用户的所有订单信息
-- 解析：JOIN 后使用 WHERE 过滤
SELECT u.username, o.*
FROM orders o
JOIN users u ON o.user_id = u.user_id
WHERE u.city = '北京';

-- 题目 4：查询每个用户的订单总数（显示用户名和订单数）
-- 解析：LEFT JOIN 保留所有用户，COUNT 统计订单数
SELECT u.username, COUNT(o.order_id) AS order_count
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.username;

-- 题目 5：查询每个商品分类的销售总金额
-- 解析：分类总金额 = SUM(quantity * price)，不是直接用订单总金额
SELECT category, SUM(quantity * price) AS category_total
FROM order_items
GROUP BY category;

-- ============================================
-- 二、子查询题（5 题）
-- ============================================

-- 题目 6：查询订单总金额大于所有订单平均金额的订单信息
-- 解析：标量子查询获取平均值
SELECT * FROM orders
WHERE total_amount > (SELECT AVG(total_amount) FROM orders);

-- 题目 7：查询购买过 "数码" 类商品的用户姓名（用多层子查询实现）
-- 解析：多层 IN：order_items → orders → users
SELECT username FROM users
WHERE user_id IN (
    SELECT user_id FROM orders
    WHERE order_id IN (
        SELECT order_id FROM order_items WHERE category = '数码'
    )
);

-- 题目 8：查询每个用户的订单中，金额最高的订单信息
-- 解析：关联子查询，逐行比较
SELECT o1.* FROM orders o1
WHERE total_amount = (
    SELECT MAX(total_amount) FROM orders WHERE user_id = o1.user_id
);

-- 题目 9：查询订单数量最多的用户的姓名
-- 解析：⚠️ 不能用 MAX(COUNT(*))，需要子查询中转
SELECT username FROM users
WHERE user_id = (
    SELECT user_id FROM orders 
    GROUP BY user_id 
    ORDER BY COUNT(*) DESC 
    LIMIT 1
);

-- 题目 10：查询购买了超过 2 件商品的订单信息
-- 解析：子查询 + HAVING 过滤
SELECT * FROM orders
WHERE order_id IN (
    SELECT order_id FROM order_items 
    GROUP BY order_id 
    HAVING SUM(quantity) > 2
);

-- ============================================
-- 三、窗口函数基础题（5 题）
-- ============================================

-- 题目 11：给所有订单按总金额从高到低排名（用 RANK()）
-- 解析：RANK() 同分同排名，后续跳号
SELECT *, RANK() OVER(ORDER BY total_amount DESC) AS order_rank
FROM orders;

-- 题目 12：每个用户的订单，按日期排序，生成订单序号（用 ROW_NUMBER()）
-- 解析：PARTITION BY 按用户分区，ORDER BY 按日期排序
SELECT *, ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY order_date) AS order_seq
FROM orders;

-- 题目 13：按日期排序，计算所有订单的累计总金额
-- 解析：SUM() OVER(ORDER BY ...) 实现累计求和
SELECT *, SUM(total_amount) OVER(ORDER BY order_date) AS running_total
FROM orders;

-- 题目 14：每个用户的订单，按日期排序，计算该用户的累计订单金额
-- 解析：PARTITION BY user_id 分区累计
SELECT *, SUM(total_amount) OVER(PARTITION BY user_id ORDER BY order_date) AS user_running_total
FROM orders;

-- 题目 15：计算每个用户订单的移动平均金额（2 行移动平均）
-- 解析：ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
SELECT *, AVG(total_amount) OVER(PARTITION BY user_id ORDER BY order_date ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS moving_avg
FROM orders;

-- ============================================
-- 四、混合综合题（5 题）
-- ============================================

-- 题目 16：查询每个用户的订单总金额，并显示该用户在所有用户中的金额排名
-- 解析：CTE + 窗口函数排名
WITH t AS (
    SELECT u.username, SUM(total_amount) AS amt 
    FROM orders o 
    JOIN users u ON o.user_id = u.user_id 
    GROUP BY u.username, u.user_id
)
SELECT *, RANK() OVER(ORDER BY amt DESC) AS rk 
FROM t;

-- 题目 17：查询每个商品分类的销售占比（分类总金额 / 所有商品总金额）
-- 解析：⚠️ 分类总金额 = SUM(quantity * price)
WITH category_sales AS (
    SELECT category, SUM(quantity * price) AS category_total 
    FROM order_items 
    GROUP BY category
)
SELECT category, category_total, 
       ROUND(category_total / SUM(category_total) OVER(), 2) AS sales_ratio 
FROM category_sales;

-- 题目 18：查询每个用户的订单明细，显示该商品在订单中的金额占比
-- 解析：⚠️ 商品金额 = quantity * price
SELECT u.username, o.order_id, oi.product_name, oi.quantity, oi.price,
       oi.quantity * oi.price AS item_amount,
       ROUND((oi.quantity * oi.price) / SUM(oi.quantity * oi.price) OVER(PARTITION BY o.order_id), 2) AS order_item_ratio
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_items oi ON o.order_id = oi.order_id;

-- 题目 19：查询每个用户最近一笔订单的商品信息（用窗口函数实现）
-- 解析：ROW_NUMBER() 分区排序，外层过滤 rn = 1
SELECT * FROM (
    SELECT o.order_id, o.user_id, o.order_date, o.total_amount,
           oi.product_name, oi.category, oi.quantity, oi.price,
           ROW_NUMBER() OVER(PARTITION BY o.user_id ORDER BY o.order_date DESC) AS rn
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
) t 
WHERE rn = 1;

-- 题目 20：查询每个用户的订单中，金额最高的前 2 个订单明细
-- 解析：⚠️ 按 quantity * price 排序
SELECT user_id, username, product_name, category, quantity, price, item_amount FROM (
    SELECT u.user_id, u.username, oi.product_name, oi.category, oi.quantity, oi.price, 
           oi.quantity * oi.price AS item_amount,
           ROW_NUMBER() OVER(PARTITION BY o.user_id ORDER BY oi.quantity * oi.price DESC) AS rn
    FROM order_items oi 
    JOIN orders o ON oi.order_id = o.order_id 
    JOIN users u ON o.user_id = u.user_id
) t
WHERE rn <= 2;
