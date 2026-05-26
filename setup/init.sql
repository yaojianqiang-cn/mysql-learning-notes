-- ============================================
-- MySQL 学习笔记 - 数据库初始化脚本
-- 创建学生数据库和相关表
-- ============================================

-- 1. 创建数据库
CREATE DATABASE IF NOT EXISTS db_students
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

-- 2. 使用数据库
USE db_students;

-- 3. 创建学生表
DROP TABLE IF EXISTS students;
CREATE TABLE students (
    id INT PRIMARY KEY COMMENT '学生ID',
    name VARCHAR(20) NOT NULL COMMENT '姓名',
    age INT COMMENT '年龄',
    gender VARCHAR(10) COMMENT '性别',
    city VARCHAR(20) COMMENT '城市',
    score INT COMMENT '成绩'
) COMMENT='学生信息表';

-- 4. 插入学生数据
INSERT INTO students VALUES
(1, '张三', 18, '男', '北京', 85),
(2, '李四', 19, '男', '上海', 92),
(3, '王五', 18, '女', '北京', 78),
(4, '赵六', 20, '女', '深圳', 95),
(5, '钱七', 19, '男', '广州', 67),
(6, '孙八', 18, '女', '上海', 88),
(7, '周九', 20, '男', '北京', 72),
(8, '吴十', 19, '女', '深圳', 90);

-- 5. 创建订单表
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    order_id INT PRIMARY KEY COMMENT '订单ID',
    user_id INT NOT NULL COMMENT '用户ID',
    amount DECIMAL(10,2) COMMENT '订单金额',
    create_time DATE COMMENT '创建时间',
    status VARCHAR(10) COMMENT '订单状态'
) COMMENT='订单信息表';

-- 6. 插入订单数据
INSERT INTO orders VALUES
(101, 1, 150.50, '2025-01-01', '已完成'),
(102, 2, 200.00, '2025-01-02', '已完成'),
(103, 1, 99.00, '2025-01-03', '已取消'),
(104, 3, 350.75, '2025-01-05', '已完成'),
(105, 2, 50.20, '2025-01-06', '已完成'),
(106, 4, 400.00, '2025-01-10', '已取消'),
(107, 1, 270.30, '2025-01-15', '已完成');

-- 7. 验证数据
SELECT '学生表数据' AS info;
SELECT * FROM students;

SELECT '订单表数据' AS info;
SELECT * FROM orders;

-- ============================================
-- SQL JOIN 练习数据库初始化
-- 数据库: sql_study_db2
-- 包含: 用户表、订单表、订单明细表
-- ============================================

CREATE DATABASE IF NOT EXISTS sql_study_db2;
USE sql_study_db2;

-- 删除已存在的表（重新初始化）
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders_join;
DROP TABLE IF EXISTS users;

-- ============================================
-- 1. 用户表 (users)
-- ============================================
CREATE TABLE users (
    user_id INT PRIMARY KEY COMMENT '用户ID',
    username VARCHAR(20) NOT NULL COMMENT '用户名',
    city VARCHAR(20) COMMENT '所在城市'
) COMMENT='用户表';

INSERT INTO users VALUES
(1, '张三', '北京'),
(2, '李四', '上海'),
(3, '王五', '深圳'),
(4, '赵六', '广州'),
(5, '孙七', '北京');

-- ============================================
-- 2. 订单表 (orders_join)
-- ============================================
CREATE TABLE orders_join (
    order_id INT PRIMARY KEY COMMENT '订单ID',
    user_id INT NOT NULL COMMENT '用户ID',
    amount DECIMAL(10,2) COMMENT '订单金额',
    create_time DATE COMMENT '创建时间',
    status VARCHAR(10) COMMENT '订单状态：已完成/已取消'
) COMMENT='订单表';

INSERT INTO orders_join VALUES
(101, 1, 150.50, '2025-01-01', '已完成'),
(102, 2, 200.00, '2025-01-02', '已完成'),
(103, 1, 99.00, '2025-01-03', '已取消'),
(104, 3, 350.75, '2025-01-05', '已完成'),
(105, 2, 50.20, '2025-01-06', '已完成'),
(106, 4, 400.00, '2025-01-10', '已取消'),
(107, 1, 270.30, '2025-01-15', '已完成');

-- ============================================
-- 3. 订单明细表 (order_items)
-- ============================================
CREATE TABLE order_items (
    item_id INT PRIMARY KEY COMMENT '明细ID',
    order_id INT NOT NULL COMMENT '订单ID',
    product_name VARCHAR(50) COMMENT '商品名称',
    quantity INT COMMENT '购买数量',
    price DECIMAL(10,2) COMMENT '单价'
) COMMENT='订单明细表';

INSERT INTO order_items VALUES
(1, 101, '笔记本', 1, 100.00),
(2, 101, '笔', 2, 25.25),
(3, 102, '键盘', 1, 200.00),
(4, 104, '显示器', 1, 350.75),
(5, 105, '鼠标', 1, 50.20),
(6, 107, '耳机', 1, 270.30);

-- 验证数据
SELECT '用户表数据' AS info;
SELECT * FROM users;

SELECT '订单表数据' AS info;
SELECT * FROM orders_join;

SELECT '订单明细表数据' AS info;
SELECT * FROM order_items;

SELECT '数据库初始化完成!' AS message;
