-- ============================================
-- 练习七：窗口函数 - 参考答案
-- ============================================

USE sql_study_db4;

-- ============================================
-- 题库一：排名函数
-- ============================================

-- 题目 1：ROW_NUMBER() 全局排名
-- 解析：ROW_NUMBER() 是无参函数，强制连续序号，同分不重复
SELECT sale_id, category, product_name, amount,
       ROW_NUMBER() OVER (ORDER BY amount DESC) AS rn
FROM sales;

-- 题目 2：RANK() 全局排名
-- 解析：同分同排名，后续排名跳过。例如：1,1,3,4
SELECT sale_id, category, product_name, amount,
       RANK() OVER (ORDER BY amount DESC) AS rk
FROM sales;

-- 题目 3：DENSE_RANK() 全局排名
-- 解析：同分同排名，后续排名不跳过。例如：1,1,2,3
SELECT sale_id, category, product_name, amount,
       DENSE_RANK() OVER (ORDER BY amount DESC) AS dr
FROM sales;

-- 题目 4：分区内 ROW_NUMBER() 排名
-- 解析：PARTITION BY 按分类分区，每个分类内独立编号
SELECT sale_id, category, product_name, amount,
       ROW_NUMBER() OVER (PARTITION BY category ORDER BY amount DESC) AS rn
FROM sales;

-- 题目 5：分区内 RANK() 排名
-- 解析：同分类内同分同排名，后续跳过
SELECT sale_id, category, product_name, amount,
       RANK() OVER (PARTITION BY category ORDER BY amount DESC) AS rk
FROM sales;

-- 题目 6：分区内 DENSE_RANK() 排名
-- 解析：同分类内同分同排名，后续不跳过
SELECT sale_id, category, product_name, amount,
       DENSE_RANK() OVER (PARTITION BY category ORDER BY amount DESC) AS dr
FROM sales;

-- 题目 7：每个分类销售额 Top2 商品（ROW_NUMBER 版本）
-- 解析：子查询中分区排名，外层 WHERE 过滤 rn <= 2
SELECT * FROM (
    SELECT sale_id, category, product_name, amount,
           ROW_NUMBER() OVER (PARTITION BY category ORDER BY amount DESC) AS rn
    FROM sales
) t
WHERE rn <= 2;

-- 题目 8：聚合函数 vs 窗口函数对比
-- 解析：聚合函数合并多行为一行；窗口函数不合并行，附加结果到每行

-- 聚合函数（合并行）
SELECT category, SUM(amount) AS total_sales
FROM sales
GROUP BY category;

-- 窗口函数（不合并行，附加结果）
SELECT sale_id, category, product_name, amount,
       SUM(amount) OVER (PARTITION BY category) AS category_total
FROM sales;

-- ============================================
-- 题库二：聚合窗口函数
-- ============================================

-- 题目 9：每个分类的总销售额（附加到每行）
-- 解析：SUM() OVER(PARTITION BY category) 不合并行
SELECT sale_id, category, product_name, amount,
       SUM(amount) OVER (PARTITION BY category) AS category_total
FROM sales;

-- 题目 10：商品销售额在分类中的占比
-- 解析：用 CTE 先计算分类总额，再计算占比
WITH t1 AS (
    SELECT *, SUM(amount) OVER (PARTITION BY category) AS category_total
    FROM sales
)
SELECT sale_id, category, product_name, amount, category_total,
       ROUND(amount * 100 / category_total, 2) AS percent
FROM t1;

-- 题目 11：全局累计销售额
-- 解析：SUM() OVER(ORDER BY sale_date)，默认 RANGE 模式
SELECT sale_date, category, product_name, amount,
       SUM(amount) OVER (ORDER BY sale_date) AS running_total
FROM sales;

-- 题目 12：分类内累计销售额
-- 解析：PARTITION BY category 分区，ORDER BY sale_date 排序后累计
SELECT sale_date, category, product_name, amount,
       SUM(amount) OVER (PARTITION BY category ORDER BY sale_date) AS category_running_total
FROM sales;

-- 题目 13：每个分类的平均销售额（附加到每行）
-- 解析：AVG() OVER(PARTITION BY category)
SELECT sale_id, category, product_name, amount,
       AVG(amount) OVER (PARTITION BY category) AS category_avg
FROM sales;

-- 题目 14：销售额高于分类平均值的商品
-- 解析：窗口函数不能直接用在 WHERE 中，需嵌套子查询
SELECT category, product_name, amount, category_avg
FROM (
    SELECT sale_id, category, product_name, amount,
           AVG(amount) OVER (PARTITION BY category) AS category_avg
    FROM sales
) t
WHERE amount > category_avg;

-- 题目 15：2 行移动平均（当前行 + 前 1 行）
-- 解析：ROWS BETWEEN 1 PRECEDING AND CURRENT ROW，共 2 行
SELECT sale_date, category, product_name, amount,
       AVG(amount) OVER (ORDER BY sale_date ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS moving_avg
FROM sales;

-- 题目 16：分类内 3 行移动平均
-- 解析：PARTITION BY category 分区，ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
SELECT sale_date, category, product_name, amount,
       AVG(amount) OVER (PARTITION BY category ORDER BY sale_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS category_moving_avg
FROM sales;
