# 📚 MySQL 基础学习笔记

本仓库记录了 MySQL 基础查询语句的学习过程，包含从 SELECT 到 JOIN 的完整练习。

---

## 🎯 学习目标

- ✅ 掌握 SQL 基础查询语句
- ✅ 理解 WHERE、ORDER BY、GROUP BY、HAVING 的用法和区别
- ✅ 熟练运用聚合函数（COUNT、SUM、AVG、MAX、MIN）
- ✅ 掌握 INNER JOIN、LEFT JOIN 等多表关联查询
- ✅ 掌握子查询、视图与临时表的使用
- ✅ 掌握窗口函数（排名、累计、移动平均）
- ✅ 能够编写复杂的综合查询

---

## 📁 仓库结构

```
mysql-learning-notes/
├── README.md                          # 项目说明
├── setup/                             # 数据准备
│   └── init.sql                       # 数据库和表结构初始化
├── exercises/                         # 练习题库
│   ├── exercise-01-select-where/      # SELECT + WHERE 练习
│   │   ├── README.md                  # 练习题
│   │   └── exercise-01-answers.sql    # 参考答案
│   ├── exercise-02-order-aggregate/   # ORDER BY + 聚合函数
│   │   ├── README.md
│   │   └── exercise-02-answers.sql
│   ├── exercise-03-group-having/      # GROUP BY + HAVING
│   │   ├── README.md
│   │   └── exercise-03-answers.sql
│   ├── exercise-04-comprehensive/     # 综合练习
│   │   ├── README.md
│   │   └── exercise-04-answers.sql
│   ├── exercise-05-join/              # JOIN 关联查询
│   │   ├── README.md
│   │   └── exercise-05-answers.sql
│   └── exercise-06-subquery-view/     # 子查询、视图与临时表
│       ├── README.md
│       └── exercise-06-answers.sql
│   └── exercise-07-window-function/    # 窗口函数 ⭐ 新增
│       ├── README.md
│       └── exercise-07-answers.sql
├── notes/                             # 学习笔记
│   └── key-points.md                  # 知识点总结
├── mistakes/                          # 错题总结
│   └── common-mistakes.md             # 常见错误分析
└── docs/                              # 其他文档
    └── GitHub动手实践指南.md          # GitHub 使用教程
```

---

## 🗄️ 数据库说明

### 学生表 (students)
| 字段 | 类型 | 说明 |
|------|------|------|
| id | INT | 主键 |
| name | VARCHAR(20) | 姓名 |
| age | INT | 年龄 |
| gender | VARCHAR(10) | 性别 |
| city | VARCHAR(20) | 城市 |
| score | INT | 成绩 |

### 订单表 (orders)
| 字段 | 类型 | 说明 |
|------|------|------|
| order_id | INT | 主键 |
| user_id | INT | 用户ID |
| amount | DECIMAL(10,2) | 金额 |
| create_time | DATE | 创建时间 |
| status | VARCHAR(10) | 状态 |

### JOIN 练习数据库 (sql_study_db2)

#### users（用户表）
| 字段 | 类型 | 说明 |
|------|------|------|
| user_id | INT | 主键 |
| username | VARCHAR(20) | 用户名 |
| city | VARCHAR(20) | 城市 |

#### orders_join（订单表）
| 字段 | 类型 | 说明 |
|------|------|------|
| order_id | INT | 主键 |
| user_id | INT | 用户ID（外键） |
| amount | DECIMAL(10,2) | 订单金额 |
| create_time | DATE | 创建时间 |
| status | VARCHAR(10) | 状态（已完成/已取消） |

#### order_items（订单明细表）
| 字段 | 类型 | 说明 |
|------|------|------|
| item_id | INT | 主键 |
| order_id | INT | 订单ID（外键） |
| product_name | VARCHAR(50) | 商品名称 |
| quantity | INT | 数量 |
| price | DECIMAL(10,2) | 单价 |

### 子查询、视图与临时表练习数据库 (sql_study_db3)

#### users（用户表）
| 字段 | 类型 | 说明 |
|------|------|------|
| user_id | INT | 主键 |
| username | VARCHAR(20) | 用户名 |
| city | VARCHAR(20) | 城市 |

#### orders（订单表）
| 字段 | 类型 | 说明 |
|------|------|------|
| order_id | INT | 主键 |
| user_id | INT | 用户ID（外键） |
| amount | DECIMAL(10,2) | 订单金额 |
| create_time | DATE | 创建时间 |
| status | VARCHAR(10) | 订单状态 |

#### order_items（订单明细表）
| 字段 | 类型 | 说明 |
|------|------|------|
| item_id | INT | 主键 |
| order_id | INT | 订单ID（外键） |
| product_name | VARCHAR(50) | 商品名称 |
| quantity | INT | 数量 |
| price | DECIMAL(10,2) | 单价 |

#### products（商品表）
| 字段 | 类型 | 说明 |
|------|------|------|
| product_id | INT | 主键 |
| product_name | VARCHAR(50) | 商品名称 |
| price | DECIMAL(10,2) | 价格 |
| category | VARCHAR(20) | 分类 |

### 窗口函数练习数据库 (sql_study_db4)

#### sales（销售表）
| 字段 | 类型 | 说明 |
|------|------|------|
| sale_id | INT | 主键，自增 |
| sale_date | DATE | 销售日期 |
| category | VARCHAR(20) | 商品分类 |
| product_name | VARCHAR(50) | 商品名称 |
| amount | DECIMAL(10,2) | 销售额 |

---

## 🚀 快速开始

### 1. 初始化数据库

```bash
source setup/init.sql
```

### 2. 按顺序完成练习

- 从 `exercises/exercise-01-select-where/` 开始
- 每个练习都包含题目和答案

---

## 📊 练习统计

| 练习模块 | 题目数量 | 难度 |
|---------|---------|------|
| SELECT + WHERE | 15 | ⭐ 入门 |
| ORDER BY + 聚合函数 | 15 | ⭐⭐ 基础 |
| GROUP BY + HAVING | 10 | ⭐⭐⭐ 进阶 |
| 综合练习 | 20 | ⭐⭐⭐⭐ 综合 |
| JOIN 关联查询 | 18 | ⭐⭐⭐ 进阶 |
| **子查询、视图与临时表** | **15** | **⭐⭐⭐ 进阶** |
| **窗口函数** | **16** | **⭐⭐⭐⭐ 综合** |

---


## 📝 学习要点

### WHERE vs HAVING 的区别
- **WHERE**: 分组前过滤原始行
- **HAVING**: 分组后过滤分组结果

### 聚合函数
- `COUNT(*)`: 统计行数
- `SUM(列名)`: 求和
- `AVG(列名)`: 平均值
- `MAX(列名)`: 最大值
- `MIN(列名)`: 最小值

### JOIN 类型

| JOIN 类型 | 说明 |
|-----------|------|
| INNER JOIN | 只返回两表匹配的记录 |
| LEFT JOIN | 返回左表所有记录，右表不匹配则为 NULL |
| RIGHT JOIN | 返回右表所有记录，左表不匹配则为 NULL |
| FULL JOIN | 返回两表所有记录（MySQL 需用 UNION 模拟） |

---

## ⚠️ 常见错误

详见 [mistakes/common-mistakes.md](./mistakes/common-mistakes.md)

### JOIN 常见错误速查

| 错误现象 | 可能原因 | 解决方案 |
|---------|---------|---------|
| not in GROUP BY clause | 非聚合列未加入 GROUP BY | 把所有 SELECT 中的非聚合列加入 GROUP BY |
| 统计结果异常大 | 用了 SUM 而不是 COUNT | 计数用 COUNT()，求和用 SUM() |
| 缺少无订单用户 | 用了 INNER JOIN | 改用 LEFT JOIN |

---

## 📅 学习日期

- **2026-05-21：基础查询、聚合函数、分组统计**
- **2026-05-26：JOIN 关联查询**
- **2026-05-27：子查询、视图与临时表**
- **2026-05-28：窗口函数** ⭐

---

*本仓库用于个人学习记录，持续更新中...*
