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

## 错误速查表

| 错误现象 | 可能原因 | 解决方案 |
|---------|---------|---------|
| not in GROUP BY clause | 非聚合列未加入 GROUP BY | 把所有 SELECT 中的非聚合列加入 GROUP BY |
| 统计结果异常大 | 用了 SUM 而不是 COUNT | 计数用 COUNT()，求和用 SUM() |
| 只有一行结果 | 遗漏 GROUP BY | 添加 GROUP BY 子句 |
| IFNULL 语法错误 | 中间有空格或参数过多 | 写成 IFNULL(expr, 0)，只传两个参数 |
| 缺少无订单用户 | 用了 INNER JOIN | 改用 LEFT JOIN |
| 关联结果不对 | 表别名引用错误 | 检查表别名和关联条件 |

---

## 相关练习

- [练习三：GROUP BY + HAVING](../exercises/exercise-03-group-having/)
- [练习四：综合练习](../exercises/exercise-04-comprehensive/)
- [练习五：JOIN 关联查询](../exercises/exercise-05-join/)
