# MySQL 基础查询知识点总结

> 📚 本笔记整理了 MySQL 基础查询的核心知识点

---

## 一、SQL 执行顺序

理解 SQL 的执行顺序是掌握查询语句的关键：

```
FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT
```

| 顺序 | 关键字 | 作用 |
|------|--------|------|
| 1 | FROM | 确定数据来源的表 |
| 2 | WHERE | 过滤原始数据行 |
| 3 | GROUP BY | 对数据进行分组 |
| 4 | HAVING | 过滤分组后的结果 |
| 5 | SELECT | 选择要显示的列 |
| 6 | ORDER BY | 对结果进行排序 |
| 7 | LIMIT | 限制返回的行数 |

---

## 二、基础查询 (SELECT)

### 2.1 基本语法
```sql
SELECT 列名1, 列名2, ...
FROM 表名;
```

### 2.2 查询所有列
```sql
SELECT * FROM 表名;
```

### 2.3 别名设置
```sql
SELECT name AS 姓名, score AS 成绩 
FROM students;
```

---

## 三、条件过滤 (WHERE)

### 3.1 比较运算符

| 运算符 | 含义 | 示例 |
|--------|------|------|
| = | 等于 | `WHERE age = 18` |
| != 或 <> | 不等于 | `WHERE score != 67` |
| > | 大于 | `WHERE score > 80` |
| < | 小于 | `WHERE age < 20` |
| >= | 大于等于 | `WHERE score >= 85` |
| <= | 小于等于 | `WHERE age <= 19` |

### 3.2 逻辑运算符

```sql
-- AND：同时满足
WHERE gender = '女' AND city = '北京'

-- OR：满足其一
WHERE age > 19 OR score > 90

-- NOT：取反
WHERE NOT city = '北京'
```

### 3.3 特殊操作符

```sql
-- BETWEEN：在范围内
WHERE score BETWEEN 70 AND 90

-- IN：在集合中
WHERE city IN ('上海', '深圳')

-- LIKE：模糊匹配（% 代表任意字符，_ 代表单个字符）
WHERE name LIKE '张%'    -- 姓张的
WHERE name LIKE '_三'    -- 第二个字是三的
```

---

## 四、排序 (ORDER BY)

### 4.1 基本排序
```sql
-- 升序（默认）
ORDER BY score ASC

-- 降序
ORDER BY score DESC
```

### 4.2 多列排序
```sql
-- 先按年龄升序，年龄相同再按成绩降序
ORDER BY age ASC, score DESC
```

---

## 五、聚合函数

| 函数 | 作用 | 示例 |
|------|------|------|
| COUNT(*) | 统计行数 | `COUNT(*)` |
| SUM(列) | 求和 | `SUM(score)` |
| AVG(列) | 平均值 | `AVG(score)` |
| MAX(列) | 最大值 | `MAX(score)` |
| MIN(列) | 最小值 | `MIN(score)` |

### 使用示例
```sql
-- 统计总人数
SELECT COUNT(*) FROM students;

-- 计算平均分
SELECT AVG(score) FROM students;

-- 最高分
SELECT MAX(score) FROM students;
```

---

## 六、分组 (GROUP BY)

### 6.1 基本分组
```sql
-- 按城市分组，统计每个城市的学生人数
SELECT city, COUNT(*) 
FROM students 
GROUP BY city;
```

### 6.2 多列分组
```sql
-- 按城市和性别分组
SELECT city, gender, COUNT(*) 
FROM students 
GROUP BY city, gender;
```

### 6.3 注意事项
- SELECT 中的非聚合列必须出现在 GROUP BY 中
- 分组后可以使用聚合函数对每个组进行计算

---

## 七、分组过滤 (HAVING)

### 7.1 基本用法
```sql
-- 查询学生人数 >= 2 的城市
SELECT city, COUNT(*) AS num
FROM students 
GROUP BY city 
HAVING num >= 2;
```

### 7.2 WHERE vs HAVING

| 特性 | WHERE | HAVING |
|------|-------|--------|
| 执行时机 | 分组前 | 分组后 |
| 作用对象 | 原始行 | 分组结果 |
| 聚合函数 | ❌ 不能用 | ✅ 可以用 |

### 7.3 组合使用
```sql
-- 查询已完成订单数 >= 2 的用户
SELECT user_id, COUNT(*) AS cnt
FROM orders
WHERE status = '已完成'    -- 先过滤原始行
GROUP BY user_id           -- 再分组
HAVING cnt >= 2;           -- 最后过滤分组结果
```

---

## 八、限制结果 (LIMIT)

```sql
-- 只返回前 5 条
LIMIT 5

-- 分页：从第 6 条开始，返回 5 条（MySQL 8.0+ 用 OFFSET）
LIMIT 5 OFFSET 5
-- 或
LIMIT 5, 5
```

---

## 九、常用组合模式

### 模式1：筛选 + 排序
```sql
SELECT * 
FROM students 
WHERE score > 80 
ORDER BY score DESC;
```

### 模式2：分组统计
```sql
SELECT city, COUNT(*) AS num, AVG(score) AS avg_score
FROM students
GROUP BY city;
```

### 模式3：分组过滤
```sql
SELECT city, AVG(score) AS avg_score
FROM students
GROUP BY city
HAVING avg_score > 80;
```

### 模式4：完整查询流程
```sql
SELECT city, COUNT(*) AS num, AVG(score) AS avg_score
FROM students
WHERE age >= 18
GROUP BY city
HAVING num >= 2
ORDER BY avg_score DESC
LIMIT 3;
```

---

## 十、常见错误

详见 [常见错误总结](../mistakes/common-mistakes.md)

### 重点提醒
1. **WHERE 中不能用聚合函数**
2. **HAVING 中必须有条件判断**
3. **GROUP BY 后 SELECT 的非聚合列必须出现在 GROUP BY 中**

---

## 十一、学习路径建议

```
SELECT 基础 → WHERE 过滤 → ORDER BY 排序 → 聚合函数 → GROUP BY 分组 → HAVING 过滤 → 综合练习
```

### 练习顺序
1. [练习一：SELECT + WHERE](../exercises/exercise-01-select-where/) - 15题
2. [练习二：ORDER BY + 聚合函数](../exercises/exercise-02-order-aggregate/) - 15题
3. [练习三：GROUP BY + HAVING](../exercises/exercise-03-group-having/) - 10题
4. [练习四：综合练习](../exercises/exercise-04-comprehensive/) - 20题

---

## 十二、快速参考卡片

### 基础查询
```sql
SELECT 列 FROM 表 WHERE 条件 ORDER BY 列 LIMIT n;
```

### 分组统计
```sql
SELECT 分组列, 聚合函数() 
FROM 表 
WHERE 条件 
GROUP BY 分组列 
HAVING 分组条件;
```

### 完整流程
```sql
SELECT 列
FROM 表
WHERE 原始条件
GROUP BY 分组列
HAVING 分组条件
ORDER BY 排序列
LIMIT 数量;
```

---

*持续更新中...*
