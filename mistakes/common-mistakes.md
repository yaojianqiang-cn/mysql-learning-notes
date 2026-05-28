# MySQL 常见错误总结

> ⚠️ 记录学习过程中遇到的典型错误和注意事项

---

## 错误1：HAVING 中嵌套聚合函数

### ❌ 错误示例
```sql
-- 错误！HAVING 中不能直接嵌套聚合函数
SELECT city, AVG(score) AS avg_score 
FROM students 
GROUP BY city 
HAVING MAX(avg_score) > 80;
```

### ✅ 正确写法
```sql
-- 正确！直接使用别名或表达式
SELECT city, AVG(score) AS avg_score 
FROM students 
GROUP BY city 
HAVING avg_score > 80;
```

### 💡 原因分析
- HAVING 后面必须是**条件判断表达式**
- 不能只写一个聚合函数，需要有比较操作符（>、<、= 等）

---

## 错误2：WHERE 中使用聚合函数

### ❌ 错误示例
```sql
-- 错误！WHERE 中不能使用聚合函数
SELECT city, COUNT(*) 
FROM students 
WHERE COUNT(*) >= 2 
GROUP BY city;
```

### ✅ 正确写法
```sql
-- 正确！分组过滤应该用 HAVING
SELECT city, COUNT(*) AS num_students
FROM students 
GROUP BY city 
HAVING num_students >= 2;
```

### 💡 原因分析
- **WHERE**：分组前过滤**原始行**，此时还没有分组，无法使用聚合函数
- **HAVING**：分组后过滤**分组结果**，此时聚合函数已经计算完成

---

## 错误3：HAVING 缺少条件判断

### ❌ 错误示例
```sql
-- 错误！HAVING 后面不能只写函数
SELECT gender, AVG(score) AS avg_score 
FROM students 
GROUP BY gender 
HAVING MAX(score);
```

### ✅ 正确写法
```sql
-- 正确！HAVING 后必须是完整的条件表达式
SELECT gender, AVG(score) AS avg_score 
FROM students 
GROUP BY gender 
HAVING avg_score >= 85;
```

### 💡 关键点
- `HAVING avg_score > 80` ✅ 合法（有比较操作）
- `HAVING MAX(avg_score)` ❌ 不合法（只是函数，没有条件判断）

---

## 错误4：混淆 WHERE 和 HAVING 的执行顺序

### 📋 执行顺序
```
FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY
```

### 💡 记忆技巧
1. **WHERE** 在分组前执行 → 过滤原始数据
2. **HAVING** 在分组后执行 → 过滤分组结果

### 示例对比
```sql
-- 场景：查询已完成订单数 >= 2 的用户

-- 先用 WHERE 过滤已完成的订单
-- 再用 HAVING 过滤订单数量
SELECT user_id, COUNT(*) AS sum_orders 
FROM orders 
WHERE status = '已完成'      -- 第1步：过滤原始行
GROUP BY user_id             -- 第2步：分组
HAVING sum_orders >= 2;      -- 第3步：过滤分组结果
```

---

## 错误5：GROUP BY 使用不当

### ❌ 错误示例
```sql
-- 错误！SELECT 中的非聚合列必须出现在 GROUP BY 中
SELECT city, name, COUNT(*) 
FROM students 
GROUP BY city;
```

### ✅ 正确写法
```sql
-- 正确！要么加入 GROUP BY，要么使用聚合函数
SELECT city, COUNT(*) 
FROM students 
GROUP BY city;

-- 或者
SELECT city, name, score
FROM students;
```

### 💡 MySQL 严格模式
在严格模式下，SELECT 列表中的非聚合列必须出现在 GROUP BY 子句中。

---

## 易混淆概念对比

### WHERE vs HAVING

| 特性 | WHERE | HAVING |
|------|-------|--------|
| 执行时机 | 分组前 | 分组后 |
| 过滤对象 | 原始数据行 | 分组后的结果 |
| 聚合函数 | ❌ 不能用 | ✅ 可以用 |
| 语法位置 | GROUP BY 之前 | GROUP BY 之后 |
| 性能 | 先过滤，数据量小 | 后过滤，数据量大 |

### 使用建议
- 能用 WHERE 解决的，优先用 WHERE（性能更好）
- 需要对聚合结果过滤时，必须使用 HAVING

---

## 聚合函数速查

| 函数 | 作用 | 返回值 |
|------|------|--------|
| COUNT(*) | 统计行数 | 整数 |
| SUM(列) | 求和 | 数值 |
| AVG(列) | 平均值 | 数值 |
| MAX(列) | 最大值 | 同列类型 |
| MIN(列) | 最小值 | 同列类型 |

### 注意事项
- 聚合函数会忽略 NULL 值（COUNT(*) 除外）
- AVG 计算时会自动处理 NULL

---

## 学习建议

1. **理解执行顺序**：牢记 SQL 的执行顺序，这是避免错误的根本
2. **先 WHERE 后 HAVING**：养成先过滤原始数据的习惯
3. **多写多练**：通过实际练习加深理解
4. **查看执行计划**：使用 `EXPLAIN` 分析查询

---

## JOIN 常见错误

### 错误6：非聚合列未出现在 GROUP BY 中

#### ❌ 错误示例
```sql
-- 错误！product_name 不在 GROUP BY 中
SELECT 
    u.username, 
    oi.product_name,          -- 非聚合列
    COUNT(o.order_id)
FROM users u, orders_join o, order_items oi
WHERE u.user_id = o.user_id
  AND o.order_id = oi.order_id
GROUP BY u.user_id, u.username;  -- 缺少 oi.product_name
```

#### ✅ 正确写法
```sql
-- 正确：把所有非聚合列加入 GROUP BY
SELECT 
    u.username, 
    oi.product_name,
    COUNT(o.order_id)
FROM users u
INNER JOIN orders_join o ON u.user_id = o.user_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY u.user_id, u.username, oi.product_name;
```

#### 💡 原因分析
在 MySQL 的 `ONLY_FULL_GROUP_BY` 模式下，SELECT 里的非聚合列必须全部出现在 GROUP BY 子句中。

---

### 错误7：用 SUM 做计数

#### ❌ 错误示例
```sql
-- 错误：SUM() 会把 order_id 当成数字相加
SELECT 
    u.username, 
    IFNULL(SUM(o.order_id), 0) AS num_orders
FROM users u 
LEFT JOIN orders_join o ON u.user_id = o.user_id
GROUP BY u.user_id;
```

#### ✅ 正确写法
```sql
-- 正确：使用 COUNT() 统计行数
SELECT 
    u.username, 
    IFNULL(COUNT(o.order_id), 0) AS num_orders
FROM users u 
LEFT JOIN orders_join o ON u.user_id = o.user_id
GROUP BY u.user_id, u.username;
```

#### 💡 原因分析
`SUM()` 是求和函数，会把 order_id 当成数字相加，不是计数。统计数量必须用 `COUNT()`。

---

### 错误8：应该用 LEFT JOIN 却用了 INNER JOIN

#### ❌ 错误示例
```sql
-- 错误：INNER JOIN 会过滤掉无订单的用户
SELECT u.username, COUNT(o.order_id) AS num_orders
FROM users u
INNER JOIN orders_join o ON u.user_id = o.user_id
GROUP BY u.user_id, u.username;
```

#### ✅ 正确写法
```sql
-- 正确：使用 LEFT JOIN 保留所有用户
SELECT 
    u.username, 
    IFNULL(COUNT(o.order_id), 0) AS num_orders
FROM users u
LEFT JOIN orders_join o ON u.user_id = o.user_id
GROUP BY u.user_id, u.username;
```

#### 💡 原因分析
题目要求 "包括无订单用户"，但 INNER JOIN 只返回匹配的记录，无订单的用户被过滤掉了。

---

### 错误9：在 LEFT JOIN 后使用 WHERE 过滤右表

#### ❌ 错误示例
```sql
-- 错误：WHERE 过滤导致 LEFT JOIN 失效
SELECT u.username, o.order_id, o.status
FROM users u
LEFT JOIN orders_join o ON u.user_id = o.user_id
WHERE o.status = '已完成';  -- 这里会过滤掉 NULL 记录
```

#### ✅ 正确写法
```sql
-- 正确：把过滤条件移到 ON 子句
SELECT u.username, o.order_id, o.status
FROM users u
LEFT JOIN orders_join o ON u.user_id = o.user_id AND o.status = '已完成';
```

#### 💡 原因分析
WHERE 子句在 JOIN 之后执行，会把右表为 NULL 的记录过滤掉，导致 LEFT JOIN 失效。

---

## 子查询常见错误

### 错误10：标量子查询返回多行

#### ❌ 错误示例
```sql
-- 错误：= 只能匹配单个值，子查询可能返回多行
SELECT username FROM users
WHERE user_id = (
  SELECT user_id FROM orders 
  WHERE order_id IN (
    SELECT order_id FROM order_items WHERE product_name = '键盘'
  )
);
```

#### ✅ 正确写法
```sql
-- 正确：用 IN 适配多结果场景
SELECT username FROM users
WHERE user_id IN (
  SELECT user_id FROM orders 
  WHERE order_id IN (
    SELECT order_id FROM order_items WHERE product_name = '键盘'
  )
);
```

#### 💡 原因分析
`=` 用于标量子查询（返回单行单列），`IN` 用于列表子查询（返回多行）。当业务场景是"一对多"时，必须用 `IN`。

---

### 错误11：用 >= ALL 求最大值

#### ❌ 错误示例
```sql
-- 错误：>= ALL 虽然能工作，但不符合练习目标
SELECT * FROM orders WHERE amount >= ALL (SELECT amount FROM orders);
```

#### ✅ 正确写法
```sql
-- 正确：用 MAX() 标量子查询，逻辑更直观
SELECT * FROM orders WHERE amount = (SELECT MAX(amount) FROM orders);
```

#### 💡 原因分析
`MAX()` 是标准的求最大值函数，语义清晰，且更符合 WHERE 子查询的练习目标。

---

### 错误12：内层子查询用 HAVING 过滤

#### ❌ 错误示例
```sql
-- 错误：不符合 FROM 子句子查询 + WHERE 的要求
SELECT * FROM (
    SELECT u.username, SUM(o.amount) tl_amount
    FROM users u JOIN orders o ON u.user_id = o.user_id
    GROUP BY u.username
    HAVING tl_amount > 200
) t;
```

#### ✅ 正确写法
```sql
-- 正确：派生表 + 外层 WHERE 过滤
SELECT * FROM (
    SELECT u.username, SUM(o.amount) tl_amount
    FROM users u JOIN orders o ON u.user_id = o.user_id
    GROUP BY u.username
) t WHERE t.tl_amount > 200;
```

#### 💡 原因分析
题目要求 FROM 子句子查询 + WHERE，核心是先通过子查询生成派生表，再对派生表进行过滤，而不是在内层用 HAVING 直接过滤。

---

### 错误13：视图字段歧义，未加别名

#### ❌ 错误示例
```sql
-- 错误：amount 字段有歧义（订单金额还是商品单价？）
CREATE VIEW v_order_detail AS
SELECT o.order_id, u.username, oi.product_name, oi.quantity, o.amount
FROM orders o 
JOIN users u ON o.user_id = u.user_id 
JOIN order_items oi ON o.order_id = oi.order_id;
```

#### ✅ 正确写法
```sql
-- 正确：加别名消除歧义
CREATE OR REPLACE VIEW v_order_detail AS
SELECT 
  o.order_id AS 订单号, 
  u.username AS 用户姓名, 
  oi.product_name AS 商品名, 
  oi.quantity AS 数量, 
  o.amount AS 订单总金额
FROM orders o 
JOIN users u ON o.user_id = u.user_id 
JOIN order_items oi ON o.order_id = oi.order_id;
```

#### 💡 原因分析
视图字段应尽量用别名消除歧义，同时 `CREATE OR REPLACE VIEW` 是更规范的写法，避免视图已存在时报错。

---

## 错误速查表

| 错误现象 | 可能原因 | 解决方案 |
|---------|---------|---------|
| not in GROUP BY clause | 非聚合列未加入 GROUP BY | 把所有 SELECT 中的非聚合列加入 GROUP BY |
| 统计结果异常大 | 用了 SUM 而不是 COUNT | 计数用 COUNT()，求和用 SUM() |
| 只有一行结果 | 遗漏 GROUP BY | 添加 GROUP BY 子句 |
| IFNULL 语法错误 | 中间有空格或参数过多 | 写成 IFNULL(expr, 0)，只传两个参数 |
| 缺少无订单用户 | 用了 INNER JOIN | 改用 LEFT JOIN |
| 关联结果不对 | 表别名引用错误 | 检查表别名和关联条件 |
| 子查询返回多行 | 用 = 而不是 IN | 列表子查询用 IN，标量子查询用 = |
| 视图创建失败 | 视图已存在 | 用 CREATE OR REPLACE VIEW |
| 字段歧义 | 多表有同名字段 | 加别名明确字段含义 |
| 排名函数传参 | ROW_NUMBER(amount) | ROW_NUMBER() 是无参函数，括号内不写字段 |
| 窗口函数用在 WHERE | 直接 WHERE rn <= 2 | 窗口函数需嵌套子查询/CTE 后再过滤 |
| 移动窗口关键字拼写 | current now | 正确写法为 CURRENT ROW |
| CTE 字段名引用错误 | 外层用了错误的字段名 | 外层引用必须与内层 CTE 定义的字段名一致 |

---

## 窗口函数常见错误

### 错误14：排名函数括号内写字段名

#### ❌ 错误示例
```sql
-- 错误：ROW_NUMBER/RANK/DENSE_RANK 是无参函数
SELECT *, ROW_NUMBER(amount) OVER (ORDER BY amount DESC) AS rn FROM sales;
```

#### ✅ 正确写法
```sql
-- 正确：括号内为空，排序在 OVER 中指定
SELECT *, ROW_NUMBER() OVER (ORDER BY amount DESC) AS rn FROM sales;
```

#### 💡 原因分析
ROW_NUMBER()、RANK()、DENSE_RANK() 都是**无参函数**，排序规则通过 OVER 子句中的 ORDER BY 指定，而不是写在函数参数中。

---

### 错误15：窗口函数直接用在 WHERE 中

#### ❌ 错误示例
```sql
-- 错误：窗口函数不能直接用在 WHERE 子句中
SELECT *, ROW_NUMBER() OVER (PARTITION BY category ORDER BY amount DESC) AS rn
FROM sales
WHERE rn <= 2;
```

#### ✅ 正确写法
```sql
-- 正确：嵌套子查询，先计算窗口函数，再外层过滤
SELECT * FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY category ORDER BY amount DESC) AS rn
    FROM sales
) t WHERE rn <= 2;
```

#### 💡 原因分析
SQL 执行顺序：FROM → WHERE → GROUP BY → HAVING → **窗口函数** → ORDER BY。窗口函数在 WHERE 之后执行，因此 WHERE 中无法引用窗口函数的别名。

---

### 错误16：移动窗口关键字拼写错误

#### ❌ 错误示例
```sql
-- 错误：CURRENT ROW 拼写为 current now
SELECT *, AVG(amount) OVER (ORDER BY sale_date ROWS BETWEEN 1 PRECEDING AND current now) AS moving_avg
FROM sales;
```

#### ✅ 正确写法
```sql
-- 正确：关键字为 CURRENT ROW
SELECT *, AVG(amount) OVER (ORDER BY sale_date ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS moving_avg
FROM sales;
```

#### 💡 原因分析
窗口范围的关键字是固定语法：`CURRENT ROW`、`UNBOUNDED PRECEDING`、`UNBOUNDED FOLLOWING`、`N PRECEDING`、`N FOLLOWING`，拼写错误会导致语法报错。

---

### 错误17：CTE 字段名引用不一致

#### ❌ 错误示例
```sql
-- 错误：内层 CTE 定义的是 category_total，外层误写为 category
WITH t1 AS (
    SELECT *, SUM(amount) OVER (PARTITION BY category) AS category_total FROM sales
)
SELECT *, amount / category AS percent FROM t1;
```

#### ✅ 正确写法
```sql
-- 正确：外层引用必须与内层定义的字段名一致
WITH t1 AS (
    SELECT *, SUM(amount) OVER (PARTITION BY category) AS category_total FROM sales
)
SELECT *, ROUND(amount * 100 / category_total, 2) AS percent FROM t1;
```

#### 💡 原因分析
CTE 或子查询中定义的列别名，在外层查询中必须使用完全相同的名称引用，笔误会导致 "Unknown column" 错误。

---

### 错误18：嵌套子查询内部多加分号

#### ❌ 错误示例
```sql
-- 错误：子查询内部的分号会导致 SQL 提前结束
SELECT * FROM (
    SELECT *, ROW_NUMBER() OVER (ORDER BY amount DESC) AS rn FROM sales;
) t WHERE rn <= 2;
```

#### ✅ 正确写法
```sql
-- 正确：子查询内部不加分号
SELECT * FROM (
    SELECT *, ROW_NUMBER() OVER (ORDER BY amount DESC) AS rn FROM sales
) t WHERE rn <= 2;
```

#### 💡 原因分析
分号是 SQL 语句的结束符，嵌套子查询内部加分号会导致外层 SQL 被截断，引发语法错误。

---

## 相关练习

- [练习三：GROUP BY + HAVING](../exercises/exercise-03-group-having/)
- [练习四：综合练习](../exercises/exercise-04-comprehensive/)
- [练习五：JOIN 关联查询](../exercises/exercise-05-join/)
- [练习六：子查询、视图与临时表](../exercises/exercise-06-subquery-view/)
- [练习七：窗口函数](../exercises/exercise-07-window-function/)
