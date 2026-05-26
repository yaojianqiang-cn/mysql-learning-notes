# 练习四：综合练习

> ⭐⭐⭐⭐ 难度：综合
> 📊 题目数量：20题

## 学习目标

- 综合运用所有学过的 SQL 语法
- 能够编写复杂的多条件查询
- 理解 SQL 语句的执行顺序和逻辑

---

## 题目列表

### 1. 查询北京男生的所有信息
**考点**：多条件 AND

<details>
<summary>查看答案</summary>

```sql
SELECT * FROM students WHERE gender = '男' AND city = '北京';
```
</details>

---

### 2. 查询成绩大于 85 的学生，按年龄升序
**考点**：WHERE + ORDER BY

<details>
<summary>查看答案</summary>

```sql
SELECT * FROM students WHERE score > 85 ORDER BY age;
```
</details>

---

### 3. 统计每个城市男生的人数
**考点**：WHERE + GROUP BY

<details>
<summary>查看答案</summary>

```sql
SELECT city, COUNT(*) AS num_men FROM students WHERE gender = '男' GROUP BY city;
```
</details>

---

### 4. 统计每个城市男女的平均分
**考点**：多列 GROUP BY

<details>
<summary>查看答案</summary>

```sql
SELECT city, gender, AVG(score) AS avg_score FROM students GROUP BY city, gender;
```
</details>

---

### 5. 查询平均分最高的城市
**考点**：GROUP BY + ORDER BY + LIMIT

<details>
<summary>查看答案</summary>

```sql
SELECT city, AVG(score) AS avg_score FROM students GROUP BY city ORDER BY avg_score DESC LIMIT 1;
```
</details>

---

### 6. 查询 2025 年 1 月已完成订单总金额
**考点**：WHERE 多条件 + 日期范围

<details>
<summary>查看答案</summary>

```sql
SELECT SUM(amount) AS total_amount 
FROM orders 
WHERE status = '已完成' 
  AND create_time BETWEEN '2025-01-01' AND '2025-01-31';
```
</details>

---

### 7. 统计每个用户已完成订单总金额
**考点**：WHERE + GROUP BY + SUM

<details>
<summary>查看答案</summary>

```sql
SELECT user_id, SUM(amount) AS total_amount 
FROM orders 
WHERE status = '已完成' 
GROUP BY user_id;
```
</details>

---

### 8. 查询已完成订单总金额大于 300 的用户
**考点**：WHERE + GROUP BY + HAVING

<details>
<summary>查看答案</summary>

```sql
SELECT user_id, SUM(amount) AS total_amount 
FROM orders 
WHERE status = '已完成' 
GROUP BY user_id 
HAVING total_amount > 300;
```
</details>

---

### 9. 查询每个城市成绩大于 80 的学生人数
**考点**：WHERE + GROUP BY + COUNT

<details>
<summary>查看答案</summary>

```sql
SELECT city, COUNT(*) AS num_students 
FROM students 
WHERE score > 80 
GROUP BY city;
```
</details>

---

### 10. 查询每个性别最高、最低分
**考点**：GROUP BY + MAX + MIN

<details>
<summary>查看答案</summary>

```sql
SELECT gender, MAX(score) AS max_score, MIN(score) AS min_score 
FROM students 
GROUP BY gender;
```
</details>

---

### 11. 统计每个用户取消的订单数量
**考点**：WHERE + GROUP BY

<details>
<summary>查看答案</summary>

```sql
SELECT user_id, COUNT(*) AS canceled_orders 
FROM orders 
WHERE status = '已取消' 
GROUP BY user_id;
```
</details>

---

### 12. 查询年龄 18-19 岁、成绩大于 80 的学生
**考点**：WHERE 多条件 + BETWEEN

<details>
<summary>查看答案</summary>

```sql
SELECT name, age, score 
FROM students 
WHERE score > 80 AND age BETWEEN 18 AND 19;
```
</details>

---

### 13. 按城市分组，统计总分，只显示总分 > 150 的城市
**考点**：GROUP BY + HAVING

<details>
<summary>查看答案</summary>

```sql
SELECT city, SUM(score) AS total_score 
FROM students 
GROUP BY city 
HAVING total_score > 150;
```
</details>

---

### 14. 查询订单金额大于 100 的已完成订单，按金额降序
**考点**：WHERE + ORDER BY

<details>
<summary>查看答案</summary>

```sql
SELECT * FROM orders 
WHERE amount > 100 AND status = '已完成' 
ORDER BY amount DESC;
```
</details>

---

### 15. 统计每个城市男生、女生各多少人
**考点**：多列 GROUP BY

<details>
<summary>查看答案</summary>

```sql
SELECT city, gender, COUNT(*) AS total_persons 
FROM students 
GROUP BY city, gender 
ORDER BY city;
```
</details>

---

### 16. 查询平均分大于 80、人数≥2 的城市
**考点**：GROUP BY + HAVING 多条件

<details>
<summary>查看答案</summary>

```sql
SELECT city, AVG(score) AS avg_score, COUNT(*) AS num_humans 
FROM students 
GROUP BY city 
HAVING avg_score > 80 AND num_humans >= 2;
```
</details>

---

### 17. 找出订单最多的用户
**考点**：GROUP BY + ORDER BY + LIMIT

<details>
<summary>查看答案</summary>

```sql
SELECT user_id, COUNT(*) AS total_orders 
FROM orders 
GROUP BY user_id 
ORDER BY total_orders DESC 
LIMIT 1;
```
</details>

---

### 18. 计算所有已完成订单的总金额、平均金额
**考点**：WHERE + 多个聚合函数

<details>
<summary>查看答案</summary>

```sql
SELECT SUM(amount) AS sum_amount, AVG(amount) AS avg_amount 
FROM orders 
WHERE status = '已完成';
```
</details>

---

### 19. 查询上海、深圳女生的平均分
**考点**：WHERE 多条件 + GROUP BY

<details>
<summary>查看答案</summary>

```sql
SELECT city, AVG(score) AS avg_score 
FROM students 
WHERE city IN ('上海', '深圳') AND gender = '女' 
GROUP BY city;
```
</details>

---

### 20. 统计每个城市 18 岁学生的人数
**考点**：WHERE + GROUP BY

<details>
<summary>查看答案</summary>

```sql
SELECT city, COUNT(*) AS total_students 
FROM students 
WHERE age = 18 
GROUP BY city;
```
</details>

---

## 综合知识点总结

### SQL 执行顺序
```
FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT
```

### 常用组合模式

#### 模式1：筛选 + 排序
```sql
SELECT * FROM 表 WHERE 条件 ORDER BY 列 DESC;
```

#### 模式2：分组统计
```sql
SELECT 分组列, 聚合函数 FROM 表 GROUP BY 分组列;
```

#### 模式3：分组过滤
```sql
SELECT 分组列, 聚合函数 
FROM 表 
GROUP BY 分组列 
HAVING 聚合条件;
```

#### 模式4：完整流程
```sql
SELECT 列, 聚合函数
FROM 表
WHERE 原始条件
GROUP BY 分组列
HAVING 分组条件
ORDER BY 排序列
LIMIT 数量;
```

---

## 参考答案文件

完整的 SQL 脚本：[exercise-04-answers.sql](./exercise-04-answers.sql)
