# 练习二：ORDER BY + 聚合函数

> ⭐⭐ 难度：基础
> 📊 题目数量：15题

## 学习目标

- 掌握 ORDER BY 排序语句
- 熟练运用聚合函数：COUNT、SUM、AVG、MAX、MIN
- 理解多列排序的用法

---

## 题目列表

### 1. 查询所有学生，按成绩降序排序
**要求**：成绩从高到低排列

<details>
<summary>查看答案</summary>

```sql
SELECT * FROM students ORDER BY score DESC;
```
</details>

---

### 2. 查询所有学生，按年龄升序、成绩降序
**要求**：先按年龄从小到大，年龄相同再按成绩从高到低

<details>
<summary>查看答案</summary>

```sql
SELECT * FROM students ORDER BY age ASC, score DESC;
```
</details>

---

### 3. 统计学生总人数
**要求**：使用 COUNT 函数

<details>
<summary>查看答案</summary>

```sql
SELECT COUNT(*) AS count_students FROM students;
```
</details>

---

### 4. 统计女生人数
**要求**：结合 WHERE 和 COUNT

<details>
<summary>查看答案</summary>

```sql
SELECT COUNT(*) AS count_students_girls FROM students WHERE gender = '女';
```
</details>

---

### 5. 计算所有学生的平均分
**要求**：使用 AVG 函数

<details>
<summary>查看答案</summary>

```sql
SELECT AVG(score) AS avg_score FROM students;
```
</details>

---

### 6. 找出最高成绩
**要求**：使用 MAX 函数

<details>
<summary>查看答案</summary>

```sql
SELECT MAX(score) AS max_score FROM students;
```
</details>

---

### 7. 找出最低成绩
**要求**：使用 MIN 函数

<details>
<summary>查看答案</summary>

```sql
SELECT MIN(score) AS min_score FROM students;
```
</details>

---

### 8. 计算北京学生的总分
**要求**：使用 SUM 函数，筛选北京学生

<details>
<summary>查看答案</summary>

```sql
SELECT SUM(score) AS sum_score FROM students WHERE city = '北京';
```
</details>

---

### 9. 统计订单总数
**要求**：使用 COUNT 函数

<details>
<summary>查看答案</summary>

```sql
SELECT COUNT(*) AS count_orders FROM orders;
```
</details>

---

### 10. 计算所有订单总金额
**要求**：使用 SUM 函数

<details>
<summary>查看答案</summary>

```sql
SELECT SUM(amount) AS sum_amount FROM orders;
```
</details>

---

### 11. 计算已完成订单的平均金额
**要求**：结合 WHERE 和 AVG

<details>
<summary>查看答案</summary>

```sql
SELECT AVG(amount) AS avg_amount_finished FROM orders WHERE status = '已完成';
```
</details>

---

### 12. 找出最大订单金额
**要求**：使用 MAX 函数

<details>
<summary>查看答案</summary>

```sql
SELECT MAX(amount) AS max_amount FROM orders;
```
</details>

---

### 13. 统计用户 1 的订单数量
**要求**：结合 WHERE 和 COUNT

<details>
<summary>查看答案</summary>

```sql
SELECT user_id, COUNT(*) AS count_orders FROM orders WHERE user_id = 1;
```
</details>

---

### 14. 查询每个城市的学生人数
**要求**：使用 GROUP BY 分组统计

<details>
<summary>查看答案</summary>

```sql
SELECT city, COUNT(*) AS num_students FROM students GROUP BY city;
```
</details>

---

### 15. 查询每个性别的平均分
**要求**：使用 GROUP BY 和 AVG

<details>
<summary>查看答案</summary>

```sql
SELECT gender, AVG(score) AS avg_score FROM students GROUP BY gender;
```
</details>

---

## 知识点总结

### ORDER BY 排序
| 用法 | 说明 | 示例 |
|------|------|------|
| ASC | 升序（默认） | `ORDER BY age ASC` |
| DESC | 降序 | `ORDER BY score DESC` |
| 多列排序 | 按多个字段排序 | `ORDER BY age ASC, score DESC` |

### 聚合函数
| 函数 | 作用 | 示例 |
|------|------|------|
| COUNT(*) | 统计行数 | `SELECT COUNT(*) FROM students` |
| SUM(列名) | 求和 | `SELECT SUM(score) FROM students` |
| AVG(列名) | 平均值 | `SELECT AVG(score) FROM students` |
| MAX(列名) | 最大值 | `SELECT MAX(score) FROM students` |
| MIN(列名) | 最小值 | `SELECT MIN(score) FROM students` |

### GROUP BY 分组
- 用于将数据按指定列分组
- 通常与聚合函数一起使用
- 语法：`SELECT 列名, 聚合函数 FROM 表 GROUP BY 列名`

---

## 参考答案文件

完整的 SQL 脚本：[exercise-02-answers.sql](./exercise-02-answers.sql)
