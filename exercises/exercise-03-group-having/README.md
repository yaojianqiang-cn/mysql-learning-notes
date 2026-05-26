# 练习三：GROUP BY + HAVING

> ⭐⭐⭐ 难度：进阶
> 📊 题目数量：10题

## 学习目标

- 掌握 GROUP BY 分组查询
- 理解 HAVING 子句的用法
- 区分 WHERE 和 HAVING 的使用场景

---

## 题目列表

### 1. 统计每个城市的学生人数
**要求**：使用 GROUP BY 按城市分组

<details>
<summary>查看答案</summary>

```sql
SELECT city, COUNT(*) AS num_students FROM students GROUP BY city;
```
</details>

---

### 2. 统计每个性别的平均分
**要求**：使用 GROUP BY 和 AVG

<details>
<summary>查看答案</summary>

```sql
SELECT gender, AVG(score) AS avg_score FROM students GROUP BY gender;
```
</details>

---

### 3. 统计每个用户的订单数
**要求**：按 user_id 分组统计

<details>
<summary>查看答案</summary>

```sql
SELECT user_id, COUNT(*) AS num_orders FROM orders GROUP BY user_id;
```
</details>

---

### 4. 统计每个用户的订单总金额
**要求**：按 user_id 分组求和

<details>
<summary>查看答案</summary>

```sql
SELECT user_id, SUM(amount) AS sum_amount FROM orders GROUP BY user_id;
```
</details>

---

### 5. 查询学生人数≥2 的城市
**要求**：使用 HAVING 过滤分组结果

<details>
<summary>查看答案</summary>

```sql
SELECT city, COUNT(*) AS num_students FROM students GROUP BY city HAVING num_students >= 2;
```
</details>

---

### 6. 查询平均分≥85 的性别
**要求**：使用 HAVING 过滤平均值

<details>
<summary>查看答案</summary>

```sql
SELECT gender, AVG(score) AS avg_score FROM students GROUP BY gender HAVING avg_score >= 85;
```
</details>

---

### 7. 查询订单数≥2 的用户
**要求**：使用 HAVING 过滤计数结果

<details>
<summary>查看答案</summary>

```sql
SELECT user_id, COUNT(*) AS num_orders FROM orders GROUP BY user_id HAVING num_orders >= 2;
```
</details>

---

### 8. 查询订单总金额≥300 的用户
**要求**：使用 HAVING 过滤求和结果

<details>
<summary>查看答案</summary>

```sql
SELECT user_id, SUM(amount) AS sum_amount FROM orders GROUP BY user_id HAVING sum_amount >= 300;
```
</details>

---

### 9. 统计每个状态的订单数量
**要求**：按 status 分组统计

<details>
<summary>查看答案</summary>

```sql
SELECT status, COUNT(*) AS sum_orders FROM orders GROUP BY status;
```
</details>

---

### 10. 查询已完成订单数≥2 的用户
**要求**：结合 WHERE 和 HAVING

<details>
<summary>查看答案</summary>

```sql
SELECT user_id, COUNT(*) AS sum_orders 
FROM orders 
WHERE status = '已完成'
GROUP BY user_id 
HAVING sum_orders >= 2;
```
</details>

---

## 知识点总结

### WHERE vs HAVING 的区别

| 特性 | WHERE | HAVING |
|------|-------|--------|
| **执行时机** | 分组前 | 分组后 |
| **作用对象** | 原始数据行 | 分组后的结果 |
| **能否用聚合函数** | ❌ 不能 | ✅ 可以 |
| **语法位置** | GROUP BY 之前 | GROUP BY 之后 |

### 执行顺序
```
FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY
```

### 使用场景
- **WHERE**：过滤原始数据，减少分组的数据量
- **HAVING**：对分组后的结果进行过滤

### 典型错误
❌ 错误：在 WHERE 中使用聚合函数
```sql
-- 错误！
SELECT city, COUNT(*) FROM students WHERE COUNT(*) >= 2 GROUP BY city;
```

✅ 正确：在 HAVING 中使用聚合函数
```sql
-- 正确！
SELECT city, COUNT(*) FROM students GROUP BY city HAVING COUNT(*) >= 2;
```

---

## 参考答案文件

完整的 SQL 脚本：[exercise-03-answers.sql](./exercise-03-answers.sql)
