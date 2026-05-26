# GitHub 动手实践指南

## 📋 实践目标

本指南将带你完成一个完整的GitHub工作流程：**创建仓库 → 本地开发 → 推送代码 → 协作开发**。

---

## 🎯 实践前准备

### 你需要准备：

1. ✅ 已注册的GitHub账号
2. ✅ 安装Git（Windows用户建议安装Git Bash）

### 验证Git安装：

打开终端（Windows用PowerShell或Git Bash），输入：

```bash
git --version
```

如果显示版本号（如 `git version 2.40.0`），说明安装成功。

---

## 🚀 实践一：创建你的第一个仓库

### 步骤1：在GitHub网页创建仓库

1. 登录 GitHub.com
2. 点击右上角 **+** → **New repository**
3. 填写信息：

```
Repository name: my-first-project
Description: 这是我学习GitHub的第一个项目
Public/Private: 选择 Private（练习用）
☑ Add a README file
☑ Add .gitignore: 选择 Node
```

4. 点击 **Create repository**

### 步骤2：克隆仓库到本地

在终端中执行（替换为你的用户名）：

```bash
git clone https://github.com/你的用户名/my-first-project.git
```

### 步骤3：进入项目目录

```bash
cd my-first-project
```

### 步骤4：创建并编辑文件

创建你的第一个JavaScript文件：

```bash
echo "// 我的第一个GitHub项目
console.log('Hello, GitHub!');" > hello.js
```

---

## 🎯 实践二：Git基本操作

### 步骤1：查看当前状态

```bash
git status
```

你会看到 `hello.js` 显示为红色（未跟踪文件）。

### 步骤2：添加文件到暂存区

```bash
git add hello.js
```

或者添加所有文件：

```bash
git add .
```

### 步骤3：提交到本地仓库

```bash
git commit -m "添加 hello.js 文件"
```

### 步骤4：查看提交历史

```bash
git log
```

你会看到类似：

```
commit a1b2c3d4e5f6...
Author: 你的用户名 <你的邮箱>
Date:   Thu May 21 10:00:00 2025 +0800

    添加 hello.js 文件
```

### 步骤5：推送到GitHub

```bash
git push origin main
```

现在刷新你的GitHub仓库页面，就能看到 `hello.js` 文件了！

---

## 🎯 实践三：分支管理

### 为什么需要分支？

分支让你可以在不影响主线的情况下开发新功能。

### 步骤1：创建新分支

```bash
git checkout -b feature/add-goodbye
```

这会创建并切换到新分支 `feature/add-goodbye`。

### 步骤2：在新分支添加文件

```bash
echo "// 新功能：再见函数
function goodbye() {
    console.log('再见!');
}
goodbye();" > goodbye.js
```

### 步骤3：提交分支修改

```bash
git add .
git commit -m "添加 goodbye.js 新功能"
```

### 步骤4：推送到远程

```bash
git push origin feature/add-goodbye
```

### 步骤5：创建Pull Request

1. 打开你的GitHub仓库页面
2. 会看到黄色提示：**Compare & pull request**
3. 点击它，填写：
   - Title: `添加再见功能`
   - Description: `这是一个新功能的演示`
4. 点击 **Create pull request**

### 步骤6：合并分支

1. 在Pull Request页面点击 **Merge pull request**
2. 点击 **Confirm merge**

### 步骤7：切回主分支并更新

```bash
git checkout main
git pull origin main
```

---

## 🎯 实践四：团队协作演练

### 场景：Fork并贡献开源项目

#### 步骤1：Fork仓库

1. 访问任意公开仓库（如你自己的 `my-first-project`）
2. 点击右上角 **Fork** 按钮
3. 选择你的账号

#### 步骤2：克隆Fork的仓库

```bash
git clone https://github.com/你的用户名/my-first-project.git
cd my-first-project
```

#### 步骤3：创建新分支

```bash
git checkout -b fix/typo-fix
```

#### 步骤4：修改文件并提交

```bash
# 编辑 README.md 修改一些内容
git add .
git commit -m "修复README中的错别字"
```

#### 步骤5：推送到你的Fork

```bash
git push origin fix/typo-fix
```

#### 步骤6：创建Pull Request

1. 在你的Fork仓库页面会看到提示
2. 点击 **Compare & pull request**
3. 选择目标仓库（原仓库）
4. 填写说明并提交

---

## 🎯 实践五：GitHub Pages托管网站

### 步骤1：在仓库中创建HTML文件

```bash
cd my-first-project
echo "<!DOCTYPE html>
<html>
<head>
    <title>我的网站</title>
</head>
<body>
    <h1>欢迎访问我的GitHub Pages网站！</h1>
    <p>这是我学习GitHub的成果。</p>
</body>
</html>" > index.html
```

### 步骤2：提交并推送

```bash
git add .
git commit -m "添加 index.html"
git push origin main
```

### 步骤3：启用GitHub Pages

1. 在仓库页面点击 **Settings**
2. 滚动到 **GitHub Pages** 部分
3. Source 选择 **Deploy from a branch**
4. Branch 选择 **main**
5. 点击 **Save**

### 步骤4：访问你的网站

几分钟后，访问：
```
https://你的用户名.github.io/my-first-project
```

---

## 📊 常用Git命令速查表

| 命令 | 作用 |
|------|------|
| `git init` | 初始化新仓库 |
| `git clone url` | 克隆远程仓库 |
| `git status` | 查看状态 |
| `git add .` | 添加所有文件到暂存区 |
| `git commit -m "消息"` | 提交到本地仓库 |
| `git push origin main` | 推送到远程仓库 |
| `git pull origin main` | 拉取远程更新 |
| `git branch` | 查看分支 |
| `git checkout -b name` | 创建并切换新分支 |
| `git checkout main` | 切换到主分支 |
| `git merge branch-name` | 合并分支 |
| `git log` | 查看提交历史 |
| `git diff` | 查看文件差异 |

---

## 🎯 实践检查清单

完成以下所有任务来巩固你的GitHub技能：

- [ ] 创建新仓库
- [ ] 克隆仓库到本地
- [ ] 创建并提交新文件
- [ ] 推送代码到GitHub
- [ ] 创建新分支
- [ ] 提交分支修改
- [ ] 创建Pull Request
- [ ] 合并Pull Request
- [ ] Fork他人仓库
- [ ] 使用GitHub Pages发布网页

---

## 💡 下一步学习建议

1. **深入学习Git**：掌握 `rebase`、`stash`、`reset` 等高级命令
2. **学习GitHub Actions**：自动化你的工作流程
3. **参与开源项目**：找到你感兴趣的项目贡献代码
4. **创建个人作品集**：整理并展示你的项目

---

*祝你学习愉快！🚀*
