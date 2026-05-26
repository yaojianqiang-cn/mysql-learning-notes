# 📝 SQL JOIN 练习题

## 📋 练习说明

本练习涵盖 SQL JOIN 的核心知识点：
- **INNER JOIN**：只返回匹配的行
- **LEFT JOIN**：返回左表所有行，右表不匹配则为 NULL
- **多表 JOIN**：三表及以上关联查询
- **JOIN + 聚合函数**：结合 GROUP BY 进行统计

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
| status | VARCHAR(10) | 状态（已完成/已取消） |

### order_items（订单明细表）
| 字段 | 类型 | 说明 |
|------|------|------|
| item_id | INT | 主键 |
| order_id | INT | 订单ID（外键） |
| product_name | VARCHAR(50) | 商品名称 |
| quantity | INT | 数量 |
| price | DECIMAL(10,2) | 单价 |

---

## 🎯 题库一：基础 JOIN 练习（两表关联）

### 题目 1
**查询每个用户的订单信息（只显示有订单的用户）**

<details>
<summary>💡 提示</summary>
使用 INNER JOIN，只返回 users 和 orders 中 user_id 匹配的记录
</details>

---

### 题目 2
**查询所有用户的订单信息（包括没有订单的用户，订单字段显示 NULL）**

<details>
<summary>💡 提示</summary>
使用 LEFT JOIN，以 users 表为主表，保留所有用户记录
</details>

---

### 题目 3
**查询订单金额大于 100 的用户姓名和订单金额**

<details>
<summary>💡 提示</summary>
使用 INNER JOIN + WHERE 条件过滤
</details>

---

### 题目 4
**查询所有已完成订单的用户姓名、订单金额和创建时间**

<details>
<summary>💡 提示</summary>
使用 INNER JOIN + WHERE status = '已完成'
</details>

---

### 题目 5
**查询每个用户的订单数量（只统计有订单的用户）**

<details>
<summary>💡 提示</summary>
使用 INNER JOIN + GROUP BY + COUNT()
</details>

---

### 题目 6
**查询每个用户的订单数量（包括无订单用户，数量显示 0）**

<details>
<summary>💡 提示</summary>
使用 LEFT JOIN + GROUP BY + COUNT() + IFNULL()
</details>

---

### 题目 7
**查询订单金额最大的订单对应的用户姓名和订单信息**

<details>
<summary>💡 提示</summary>
使用 INNER JOIN + ORDER BY + LIMIT 1
</details>

---

### 题目 8
**查询 "北京" 用户的所有订单（包括没有订单的北京用户）**

<details>
<summary>💡 提示</summary>
使用 LEFT JOIN + WHERE city = '北京'
</details>

---

### 题目 9
**查询已取消订单对应的用户姓名**

<details>
<summary>💡 提示</summary>
使用 INNER JOIN + WHERE status = '已取消'
</details>

---

### 题目 10
**查询每个用户的已完成订单总金额（只显示有已完成订单的用户）**

<details>
<summary>💡 提示</summary>
使用 INNER JOIN + WHERE + GROUP BY + SUM()
</details>

---

## 🎯 题库二：进阶 JOIN 练习（三表关联）

### 题目 11
**查询每个订单的用户姓名、订单金额和商品明细**

<details>
<summary>💡 提示</summary>
使用三表 INNER JOIN：users → orders → order_items
</details>

---

### 题目 12
**查询所有订单（包括无明细的订单）的用户姓名和商品信息**

<details>
<summary>💡 提示</summary>
使用 INNER JOIN + LEFT JOIN，保留所有订单
</details>

---

### 题目 13
**查询每个用户购买的所有商品名称和数量**

<details>
<summary>💡 提示</summary>
使用三表 INNER JOIN，注意 GROUP BY 要包含所有非聚合列
</details>

---

### 题目 14
**查询订单金额大于 200 的订单对应的用户、商品信息**

<details>
<summary>💡 提示</summary>
使用三表 INNER JOIN + WHERE o.amount > 200
</details>

---

### 题目 15
**查询每个用户的商品购买总数量（只显示有购买记录的用户）**

<details>
<summary>💡 提示</summary>
使用三表 INNER JOIN + GROUP BY + SUM(quantity)
</details>

---

### 题目 16
**查询每个订单的商品总金额（单价 × 数量）和订单金额**

<details>
<summary>💡 提示</summary>
使用 INNER JOIN + GROUP BY + SUM(price * quantity)
</details>

---

### 题目 17
**查询所有用户（包括无订单用户）的订单和商品明细**

<details>
<summary>💡 提示</summary>
使用双 LEFT JOIN：users LEFT JOIN orders LEFT JOIN order_items
</details>

---

### 题目 18
**查询 "已完成" 订单中，购买了 "笔记本" 的用户姓名和订单信息**

<details>
<summary>💡 提示</summary>
使用三表 INNER JOIN + WHERE status = '已完成' AND product_name = '笔记本'
</details>

---

## ✅ 查看答案

答案文件：[exercise-05-answers.sql](./exercise-05-answers.sql)

---

## 📊 练习统计

| 练习模块 | 题目数量 | 难度 |
|---------|---------|------|
| 基础 JOIN（两表） | 10 | ⭐⭐ 基础 |
| 进阶 JOIN（三表） | 8 | ⭐⭐⭐ 进阶 |

---

## 🔗 相关链接

- [常见错误总结](../../mistakes/common-mistakes.md)
- [数据库初始化脚本](../../setup/init.sql)
