# 练习七：窗口函数

> ⭐ 难度：进阶  
> 📊 题目数量：16题（排名函数8题 + 聚合窗口函数8题）

## 学习目标

- 掌握 ROW_NUMBER()、RANK()、DENSE_RANK() 三种排名函数的区别
- 理解 PARTITION BY 分区与 GROUP BY 分组的区别
- 学会使用窗口函数实现累计求和、移动平均、占比计算
- 理解 ROWS 与 RANGE 窗口范围的差异

---

## 🗂️ 数据表结构

### sales（销售表）
| 字段 | 类型 | 说明 |
|------|------|------|
| sale_id | INT | 主键，自增 |
| sale_date | DATE | 销售日期 |
| category | VARCHAR(20) | 商品分类 |
| product_name | VARCHAR(50) | 商品名称 |
| amount | DECIMAL(10,2) | 销售额 |

---

## 🎯 题库一：排名函数

### 题目 1
**给所有销售记录按销售额从高到低，用 ROW_NUMBER() 生成全局排名**

<details>
<summary>💡 提示</summary>
`ROW_NUMBER()` 是无参函数，括号内不写字段名。语法：`ROW_NUMBER() OVER(ORDER BY amount DESC)`
</details>

---

### 题目 2
**给所有销售记录按销售额从高到低，用 RANK() 生成全局排名**

<details>
<summary>💡 提示</summary>
`RANK()` 遇到相同值会给出相同排名，后续排名跳过。例如：1,1,3,4
</details>

---

### 题目 3
**给所有销售记录按销售额从高到低，用 DENSE_RANK() 生成全局排名**

<details>
<summary>💡 提示</summary>
`DENSE_RANK()` 遇到相同值会给出相同排名，后续排名不跳过。例如：1,1,2,3
</details>

---

### 题目 4
**按商品分类分区，每个分类内按销售额从高到低，用 ROW_NUMBER() 排名**

<details>
<summary>💡 提示</summary>
使用 `PARTITION BY category` 按分类分区，再 `ORDER BY amount DESC` 排序
</details>

---

### 题目 5
**按商品分类分区，每个分类内按销售额从高到低，用 RANK() 排名**

<details>
<summary>💡 提示</summary>
`RANK() OVER(PARTITION BY category ORDER BY amount DESC)`
</details>

---

### 题目 6
**按商品分类分区，每个分类内按销售额从高到低，用 DENSE_RANK() 排名**

<details>
<summary>💡 提示</summary>
`DENSE_RANK() OVER(PARTITION BY category ORDER BY amount DESC)`
</details>

---

### 题目 7
**用窗口函数实现「每个分类销售额 Top2 的商品」（ROW_NUMBER 版本）**

<details>
<summary>💡 提示</summary>
先在子查询中用 ROW_NUMBER() 分区排名，外层用 WHERE rn <= 2 过滤
</details>

---

### 题目 8
**对比聚合函数与窗口函数：分别用两种方式，查看每个分类的总销售额**

<details>
<summary>💡 提示</summary>
聚合函数（GROUP BY）合并多行为一行；窗口函数（OVER）不合并行，附加结果到每行
</details>

---

## 🎯 题库二：聚合窗口函数

### 题目 9
**计算每个分类的总销售额，并附加到每行数据上**

<details>
<summary>💡 提示</summary>
`SUM(amount) OVER(PARTITION BY category)`
</details>

---

### 题目 10
**计算每个商品销售额在其分类中的占比**

<details>
<summary>💡 提示</summary>
用 CTE 或子查询先计算分类总额，再用 `amount / category_total` 计算占比
</details>

---

### 题目 11
**按日期排序，计算所有商品的全局累计销售额**

<details>
<summary>💡 提示</summary>
`SUM(amount) OVER(ORDER BY sale_date)`，注意默认使用 RANGE 模式
</details>

---

### 题目 12
**按分类分区，每个分类内按日期排序，计算分类内的累计销售额**

<details>
<summary>💡 提示</summary>
`SUM(amount) OVER(PARTITION BY category ORDER BY sale_date)`
</details>

---

### 题目 13
**计算每个分类的平均销售额，并附加到每行数据上**

<details>
<summary>💡 提示</summary>
`AVG(amount) OVER(PARTITION BY category)`
</details>

---

### 题目 14
**找出每个分类中，销售额高于该分类平均销售额的商品**

<details>
<summary>💡 提示</summary>
窗口函数不能直接用在 WHERE 中，需要嵌套子查询：先计算平均值，再外层过滤
</details>

---

### 题目 15
**计算移动平均：每个商品与前 1 条记录、当前记录的 2 行移动平均销售额**

<details>
<summary>💡 提示</summary>
`AVG(amount) OVER(ORDER BY sale_date ROWS BETWEEN 1 PRECEDING AND CURRENT ROW)`
</details>

---

### 题目 16
**按分类分区，计算每个分类内的 3 行移动平均销售额**

<details>
<summary>💡 提示</summary>
`AVG(amount) OVER(PARTITION BY category ORDER BY sale_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)`
</details>

---

## 📝 窗口函数核心知识点

### 基础语法

```sql
窗口函数() OVER (
    [PARTITION BY 分区列]    -- 按列分组，每个分区独立计算
    [ORDER BY 排序列]       -- 分区内的排序规则
    [ROWS/RANGE 窗口范围]    -- 计算的行范围
) AS 别名
```

### 三种排名函数对比

| 函数 | 特点 | 同分场景示例 |
|------|------|-------------|
| ROW_NUMBER() | 强制连续序号，同分不重复 | 1, 2, 3, 4 |
| RANK() | 同分同排名，后续跳过 | 1, 1, 3, 4 |
| DENSE_RANK() | 同分同排名，后续不跳过 | 1, 1, 2, 3 |

### 窗口函数 vs 聚合函数

| 特性 | 聚合函数 + GROUP BY | 窗口函数 + OVER |
|------|---------------------|-----------------|
| 行数变化 | 合并多行为一行 | 不改变原表行数 |
| WHERE 使用 | 可以直接用 | 需要嵌套子查询/CTE |
| 适用场景 | 分组统计 | 排名、累计、移动计算 |

### ROWS vs RANGE

| 模式 | 说明 | 适用场景 |
|------|------|---------|
| ROWS | 按物理行范围计算 | 移动平均、逐行累计 |
| RANGE | 按排序键值分组计算 | 默认模式，同值行视为一组 |

---

## 📊 练习统计

| 练习模块 | 题目数量 | 难度 |
|---------|---------|------|
| 排名函数（ROW_NUMBER/RANK/DENSE_RANK） | 7 | ⭐⭐⭐ 进阶 |
| 聚合函数 vs 窗口函数对比 | 1 | ⭐⭐ 基础 |
| 聚合窗口函数（累计/移动/占比） | 8 | ⭐⭐⭐⭐ 综合 |

---

## 🔗 相关链接

- [常见错误总结](../../mistakes/common-mistakes.md)
- [数据库初始化脚本](../../setup/init.sql)
- [参考答案](./exercise-07-answers.sql)
