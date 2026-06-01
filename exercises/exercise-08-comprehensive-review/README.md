# 练习八：综合复习

> ⭐ 难度：综合  
> 📊 题目数量：20题（JOIN 5题 + 子查询 5题 + 窗口函数 5题 + 混合综合 5题）

## 学习目标

- 综合运用 JOIN、子查询、窗口函数解决复杂业务问题
- 理解聚合函数嵌套的限制与替代方案
- 掌握订单明细类数据的正确计算方法
- 熟练运用窗口函数进行排名、累计、占比计算

---

## 🗂️ 数据表结构

### users（用户表）
| 字段 | 类型 | 说明 |
|------|------|------|
| user_id | INT | 主键，自增 |
| username | VARCHAR(50) | 用户名 |
| city | VARCHAR(50) | 城市 |

### orders（订单表）
| 字段 | 类型 | 说明 |
|------|------|------|
| order_id | INT | 主键，自增 |
| user_id | INT | 用户ID（外键） |
| order_date | DATE | 订单日期 |
| total_amount | DECIMAL(10,2) | 订单总金额 |

### order_items（订单明细表）
| 字段 | 类型 | 说明 |
|------|------|------|
| item_id | INT | 主键，自增 |
| order_id | INT | 订单ID（外键） |
| product_name | VARCHAR(50) | 商品名称 |
| category | VARCHAR(20) | 商品分类 |
| quantity | INT | 数量 |
| price | DECIMAL(10,2) | 单价 |

---

## 🎯 一、基础 JOIN 题（5 题）

### 题目 1
**查询所有订单，显示用户名、订单日期、订单总金额**

<details>
<summary>💡 提示</summary>
JOIN users 和 orders 表，注意选择正确的关联字段
</details>

---

### 题目 2
**查询所有订单明细，显示用户名、订单日期、商品名、分类、单价**

<details>
<summary>💡 提示</summary>
三表 JOIN：users → orders → order_items
</details>

---

### 题目 3
**查询 "北京" 用户的所有订单信息**

<details>
<summary>💡 提示</summary>
JOIN 后使用 WHERE city = '北京' 过滤
</details>

---

### 题目 4
**查询每个用户的订单总数（显示用户名和订单数）**

<details>
<summary>💡 提示</summary>
LEFT JOIN 保留所有用户，COUNT(o.order_id) 统计订单数
</details>

---

### 题目 5
**查询每个商品分类的销售总金额**

<details>
<summary>💡 提示</summary>
注意：分类总金额 = SUM(quantity * price)，不是直接用订单总金额
</details>

---

## 🎯 二、子查询题（5 题）

### 题目 6
**查询订单总金额大于所有订单平均金额的订单信息**

<details>
<summary>💡 提示</summary>
标量子查询：(SELECT AVG(total_amount) FROM orders)
</details>

---

### 题目 7
**查询购买过 "数码" 类商品的用户姓名（用多层子查询实现）**

<details>
<summary>💡 提示</summary>
多层 IN：order_items → orders → users
</details>

---

### 题目 8
**查询每个用户的订单中，金额最高的订单信息**

<details>
<summary>💡 提示</summary>
关联子查询：WHERE total_amount = (SELECT MAX(...) FROM orders WHERE user_id = o.user_id)
</details>

---

### 题目 9
**查询订单数量最多的用户的姓名**

<details>
<summary>💡 提示</summary>
⚠️ 注意：不能直接用 MAX(COUNT(*))，需要子查询中转或窗口函数
</details>

---

### 题目 10
**查询购买了超过 2 件商品的订单信息**

<details>
<summary>💡 提示</summary>
子查询：SELECT order_id FROM order_items GROUP BY order_id HAVING SUM(quantity) > 2
</details>

---

## 🎯 三、窗口函数基础题（5 题）

### 题目 11
**给所有订单按总金额从高到低排名（用 RANK()）**

<details>
<summary>💡 提示</summary>
RANK() OVER(ORDER BY total_amount DESC)
</details>

---

### 题目 12
**每个用户的订单，按日期排序，生成订单序号（用 ROW_NUMBER()）**

<details>
<summary>💡 提示</summary>
ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY order_date)
</details>

---

### 题目 13
**按日期排序，计算所有订单的累计总金额**

<details>
<summary>💡 提示</summary>
SUM(total_amount) OVER(ORDER BY order_date)
</details>

---

### 题目 14
**每个用户的订单，按日期排序，计算该用户的累计订单金额**

<details>
<summary>💡 提示</summary>
SUM(total_amount) OVER(PARTITION BY user_id ORDER BY order_date)
</details>

---

### 题目 15
**计算每个用户订单的移动平均金额（2 行移动平均）**

<details>
<summary>💡 提示</summary>
AVG(total_amount) OVER(PARTITION BY user_id ROWS BETWEEN 1 PRECEDING AND CURRENT ROW)
</details>

---

## 🎯 四、混合综合题（5 题）

### 题目 16
**查询每个用户的订单总金额，并显示该用户在所有用户中的金额排名**

<details>
<summary>💡 提示</summary>
CTE 或子查询先统计每个用户的总金额，再用 RANK() 排名
</details>

---

### 题目 17
**查询每个商品分类的销售占比（分类总金额 / 所有商品总金额）**

<details>
<summary>💡 提示</summary>
⚠️ 注意：分类总金额 = SUM(quantity * price)，占比 = 分类金额 / 全局金额
</details>

---

### 题目 18
**查询每个用户的订单明细，显示该商品在订单中的金额占比**

<details>
<summary>💡 提示</summary>
⚠️ 注意：商品金额 = quantity * price，占比 = 商品金额 / 订单总金额
</details>

---

### 题目 19
**查询每个用户最近一笔订单的商品信息（用窗口函数实现）**

<details>
<summary>💡 提示</summary>
ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY order_date DESC)，外层 WHERE rn = 1
</details>

---

### 题目 20
**查询每个用户的订单中，金额最高的前 2 个订单明细**

<details>
<summary>💡 提示</summary>
⚠️ 注意：按 quantity * price 排序，不是按 price 排序
</details>

---

## 📊 练习统计

| 练习模块 | 题目数量 | 难度 |
|---------|---------|------|
| 基础 JOIN | 5 | ⭐⭐ 基础 |
| 子查询 | 5 | ⭐⭐⭐ 进阶 |
| 窗口函数基础 | 5 | ⭐⭐⭐ 进阶 |
| 混合综合 | 5 | ⭐⭐⭐⭐⭐ 综合 |

---

## 🔗 相关链接

- [常见错误总结](../../mistakes/common-mistakes.md)
- [数据库初始化脚本](../../setup/init.sql)
- [参考答案](./exercise-08-answers.sql)
