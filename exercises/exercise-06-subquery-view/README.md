# 练习六：子查询、视图与临时表

> ⭐ 难度：进阶  
> 📊 题目数量：15题（子查询10题 + 视图/临时表5题）

## 学习目标

- 掌握 WHERE 子查询（标量子查询、列表子查询）
- 掌握 FROM 子句子查询（派生表）
- 理解关联子查询的执行逻辑
- 学会创建和使用视图
- 学会创建和使用临时表

---

## 🗂️ 数据表结构

### users（用户表）
| 字段 | 类型 | 说明 |
|------|------|------|
| user_id | INT | 主键 |
| username | VARCHAR(20) | 用户名 |
| city | VARCHAR(20) | 城市 |

### orders（订单表）
| 字段 | 类型 | 说明 |
|------|------|------|
| order_id | INT | 主键 |
| user_id | INT | 用户ID（外键） |
| amount | DECIMAL(10,2) | 订单金额 |
| create_time | DATE | 创建时间 |
| status | VARCHAR(10) | 订单状态 |

### order_items（订单明细表）
| 字段 | 类型 | 说明 |
|------|------|------|
| item_id | INT | 主键 |
| order_id | INT | 订单ID（外键） |
| product_name | VARCHAR(50) | 商品名称 |
| quantity | INT | 数量 |
| price | DECIMAL(10,2) | 单价 |

### products（商品表）
| 字段 | 类型 | 说明 |
|------|------|------|
| product_id | INT | 主键 |
| product_name | VARCHAR(50) | 商品名称 |
| price | DECIMAL(10,2) | 价格 |
| category | VARCHAR(20) | 分类 |

---

## 🎯 题库一：子查询练习

### 题目 1
**查询「订单金额大于所有订单平均金额」的订单信息（WHERE 子查询）**

<details>
<summary>💡 提示</summary>
使用标量子查询 `(SELECT AVG(amount) FROM orders)` 获取平均值，再用 > 比较
</details>

---

### 题目 2
**查询「和订单号 101 金额相同」的所有订单（WHERE 子查询）**

<details>
<summary>💡 提示</summary>
使用标量子查询获取订单101的金额，再用 = 匹配
</details>

---

### 题目 3
**查询「购买过键盘」的用户姓名（WHERE 子查询 + IN）**

<details>
<summary>💡 提示</summary>
多层子查询：先查 order_items 中商品名为'键盘'的 order_id，再查 orders 中对应 user_id，最后用 IN 查 users
</details>

---

### 题目 4
**查询「没有购买过任何商品」的用户姓名（WHERE 子查询 + NOT IN）**

<details>
<summary>💡 提示</summary>
使用 `NOT IN (SELECT DISTINCT user_id FROM orders)` 找出没有订单的用户
</details>

---

### 题目 5
**查询「订单金额大于用户自己的平均订单金额」的订单（关联子查询）**

<details>
<summary>💡 提示</summary>
关联子查询：子查询中使用 `WHERE o2.user_id = o1.user_id` 计算当前用户的平均值
</details>

---

### 题目 6
**查询每个用户的订单总数，用 FROM 子句的子查询实现**

<details>
<summary>💡 提示</summary>
先用子查询统计每个用户的订单数生成派生表，再与 users 表 JOIN
</details>

---

### 题目 7
**查询每个用户的订单总金额，且只显示总金额大于 200 的用户（FROM 子句子查询 + WHERE）**

<details>
<summary>💡 提示</summary>
子查询生成包含用户和总金额的派生表，外层用 WHERE 过滤
</details>

---

### 题目 8
**查询「购买过数码类商品」的用户姓名（多层子查询）**

<details>
<summary>💡 提示</summary>
三层子查询：products(数码类) → order_items → orders → users
</details>

---

### 题目 9
**查询「订单金额最高」的订单信息（WHERE 子查询）**

<details>
<summary>💡 提示</summary>
使用 `(SELECT MAX(amount) FROM orders)` 获取最大值
</details>

---

### 题目 10
**查询每个城市的订单平均金额，且只显示平均金额大于所有订单平均值的城市（FROM 子句子查询）**

<details>
<summary>💡 提示</summary>
子查询按城市分组统计平均值，外层 WHERE 与全局平均值比较
</details>

---

## 🎯 题库二：视图与临时表

### 题目 11
**创建视图 v_user_orders，包含用户姓名、订单号、订单金额、订单状态**

<details>
<summary>💡 提示</summary>
使用 `CREATE VIEW v_user_orders AS SELECT ...`，JOIN users 和 orders 表
</details>

---

### 题目 12
**通过视图 v_user_orders 查询所有「已完成」的订单**

<details>
<summary>💡 提示</summary>
直接对视图使用 `WHERE status = '已完成'`
</details>

---

### 题目 13
**创建临时表 temp_user_order_stats，统计每个用户的订单总数和总金额**

<details>
<summary>💡 提示</summary>
使用 `CREATE TEMPORARY TABLE ... AS SELECT ...`，LEFT JOIN 保留所有用户
</details>

---

### 题目 14
**从临时表 temp_user_order_stats 中查询订单总数≥2 的用户**

<details>
<summary>💡 提示</summary>
直接查询临时表，使用 `WHERE order_count >= 2`
</details>

---

### 题目 15
**创建视图 v_order_items_detail，包含订单号、用户姓名、商品名、数量、金额**

<details>
<summary>💡 提示</summary>
三表 JOIN：orders + users + order_items，使用 `CREATE OR REPLACE VIEW`
</details>

---

## 📊 练习统计

| 练习模块 | 题目数量 | 难度 |
|---------|---------|------|
| WHERE 子查询 | 5 | ⭐⭐⭐ 进阶 |
| FROM 子句子查询 | 3 | ⭐⭐⭐ 进阶 |
| 关联子查询 | 1 | ⭐⭐⭐⭐ 综合 |
| 多层子查询 | 1 | ⭐⭐⭐⭐ 综合 |
| 视图与临时表 | 5 | ⭐⭐⭐ 进阶 |

---

## 🔗 相关链接

- [常见错误总结](../../mistakes/common-mistakes.md)
- [数据库初始化脚本](../../setup/init.sql)
- [参考答案](./exercise-06-answers.sql)
