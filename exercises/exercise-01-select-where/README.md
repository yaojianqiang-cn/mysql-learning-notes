# 练习一：SELECT + WHERE 基础查询

> ⭐ 难度：入门
> 📊 题目数量：15题

## 学习目标

- 掌握 SELECT 语句的基本用法
- 学会使用 WHERE 子句进行条件过滤
- 理解 AND、OR、BETWEEN、IN 等操作符

---

## 题目列表

### 1. 查询所有学生的姓名和成绩
**要求**：只显示姓名和成绩两列

<details>
<summary>查看答案</summary>

```sql
SELECT name, score FROM students;
```
</details>

---

### 2. 查询所有学生信息，只显示前 5 条
**要求**：显示所有列，但只返回前5条记录

<details>
<summary>查看答案</summary>

```sql
SELECT * FROM students LIMIT 5;
```
</details>

---

### 3. 查询成绩大于 80 分的学生
**要求**：显示所有信息

<details>
<summary>查看答案</summary>

```sql
SELECT * FROM students WHERE score > 80;
```
</details>

---

### 4. 查询年龄等于 18 岁的学生
**要求**：显示所有信息

<details>
<summary>查看答案</summary>

```sql
SELECT * FROM students WHERE age = 18;
```
</details>

---

### 5. 查询性别为女且城市在北京的学生
**要求**：使用 AND 连接两个条件

<details>
<summary>查看答案</summary>

```sql
SELECT * FROM students WHERE gender = '女' AND city = '北京';
```
</details>

---

### 6. 查询成绩在 70~90 之间的学生
**要求**：使用 BETWEEN 操作符

<details>
<summary>查看答案</summary>

```sql
SELECT * FROM students WHERE score BETWEEN 70 AND 90;
```
</details>

---

### 7. 查询城市是上海或深圳的学生
**要求**：使用 IN 操作符

<details>
<summary>查看答案</summary>

```sql
SELECT * FROM students WHERE city IN ('上海', '深圳');
```
</details>

---

### 8. 查询姓名为 "张三" 的学生
**要求**：精确匹配

<details>
<summary>查看答案</summary>

```sql
SELECT * FROM students WHERE name = '张三';
```
</details>

---

### 9. 查询成绩不等于 67 分的学生
**要求**：使用 != 或 <> 操作符

<details>
<summary>查看答案</summary>

```sql
SELECT * FROM students WHERE score != 67;
-- 或
SELECT * FROM students WHERE score <> 67;
```
</details>

---

### 10. 查询年龄大于 19 岁或成绩大于 90 分的学生
**要求**：使用 OR 连接两个条件

<details>
<summary>查看答案</summary>

```sql
SELECT * FROM students WHERE age > 19 OR score > 90;
```
</details>

---

### 11. 查询已完成的订单
**要求**：筛选 status 为 '已完成' 的订单

<details>
<summary>查看答案</summary>

```sql
SELECT * FROM orders WHERE status = '已完成';
```
</details>

---

### 12. 查询订单金额大于 200 的订单
**要求**：筛选 amount > 200 的订单

<details>
<summary>查看答案</summary>

```sql
SELECT * FROM orders WHERE amount > 200;
```
</details>

---

### 13. 查询 2025-01-01 之后创建的订单
**要求**：使用日期比较

<details>
<summary>查看答案</summary>

```sql
SELECT * FROM orders WHERE create_time > '2025-01-01';
```
</details>

---

### 14. 查询用户 1 的所有订单
**要求**：筛选 user_id = 1 的订单

<details>
<summary>查看答案</summary>

```sql
SELECT * FROM orders WHERE user_id = 1;
```
</details>

---

### 15. 查询已完成且金额大于 100 的订单
**要求**：使用 AND 连接两个条件

<details>
<summary>查看答案</summary>

```sql
SELECT * FROM orders WHERE status = '已完成' AND amount > 100;
```
</details>

---

## 知识点总结

| 操作符 | 说明 | 示例 |
|--------|------|------|
| = | 等于 | `WHERE age = 18` |
| != 或 <> | 不等于 | `WHERE score != 67` |
| > | 大于 | `WHERE score > 80` |
| < | 小于 | `WHERE age < 20` |
| >= | 大于等于 | `WHERE score >= 85` |
| <= | 小于等于 | `WHERE age <= 19` |
| AND | 并且 | `WHERE gender='女' AND city='北京'` |
| OR | 或者 | `WHERE age>19 OR score>90` |
| BETWEEN | 在...之间 | `WHERE score BETWEEN 70 AND 90` |
| IN | 在集合中 | `WHERE city IN ('上海', '深圳')` |
| LIMIT | 限制条数 | `LIMIT 5` |

---

## 参考答案文件

完整的 SQL 脚本：[exercise-01-answers.sql](./exercise-01-answers.sql)
