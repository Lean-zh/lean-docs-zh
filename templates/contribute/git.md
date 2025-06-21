# Mathlib4 贡献者 Git 指南

本指南专为不熟悉 git 但希望为 mathlib4 库做出贡献的数学家设计。
贡献通过拉取请求 (pull request) 进行。我们将逐步介绍基本的工作流程。
请注意，网络上还有许多其他指南描述了如何通过拉取请求为开源项目做贡献。

本指南分为三个主要部分：

1.  [**一次性设置**](#part-1-one-time-setup) (首次开始贡献时执行一次)
2.  [**日常工作流程**](#part-2-daily-workflow) (进行贡献时的常用操作)
3.  [**附加信息**](#additional-information)

## 先决条件

开始之前，请确保您已具备：

-   电脑上安装了 Git
-   [一个 GitHub 账户](https://docs.github.com/en/get-started/start-your-journey/creating-an-account-on-github)
-   （可选但推荐）安装了 [GitHub CLI 工具 (`gh`)](https://cli.github.com/)

---

# 第一部分：一次性设置

这些步骤仅在您首次开始为 mathlib4 做贡献时需要执行一次。

## 步骤 1：在 GitHub 上复刻 (Fork) 仓库

首先，您需要创建一份您自己的 mathlib4 仓库副本（即复刻）：

1.  访问 https://github.com/leanprover-community/mathlib4
2.  点击右上角的 "Fork" 按钮
3.  选择您的 GitHub 账户作为目标。建议保持 "copy the master branch only" (仅复制 master 分支) 的勾选状态。
4.  等待 GitHub 创建您的复刻

**您只需执行此步骤一次。**
您可以为许多不同的分支和拉取请求重复使用您的复刻。

## 步骤 2：获取仓库的本地副本

您在上一步中创建的复刻是 mathlib4 的一个“远程”副本，它位于 GitHub 的服务器上。
现在，您需要在您的计算机上设置 mathlib4 的本地副本（也称为“克隆”）。

根据您是否已有 mathlib4 的克隆，您有两种选择：

### 选项 A：如果您还没有克隆过 mathlib4

#### 方法 1：使用 GitHub CLI（推荐）

在以下 shell 命令中，将 `YOUR_USERNAME` 替换为您的 GitHub 用户名：

```bash
gh repo clone YOUR_USERNAME/mathlib4
cd mathlib4
```

#### 方法 2：手动克隆

在以下 shell 命令中，将 `YOUR_USERNAME` 替换为您的 GitHub 用户名，以将您的复刻（而不是原始仓库）克隆到当前工作目录下名为 `mathlib4` 的目录中，然后导航到该目录：

```bash
git clone https://github.com/YOUR_USERNAME/mathlib4.git
cd mathlib4
```

这会自动将您的复刻设置为 `origin` 远程仓库，这正是我们想要的。

### 选项 B：如果您已经克隆了 mathlib4

如果您已经从原始仓库克隆了一份（例如，通过 Lean 4 VS Code 扩展创建的），您可以重复使用它。只需导航到您现有的 mathlib4 目录：

```bash
cd path/to/your/existing/mathlib4
```

#### 配置 GitHub CLI（如果已安装）

如果您安装了 GitHub CLI，请将默认仓库设置为主仓库 mathlib4：

```bash
gh repo set-default leanprover-community/mathlib4
```

这可以确保 `gh pr checkout` 等 GitHub CLI 命令将与主 mathlib4 仓库而不是您的复刻一起工作。

## 步骤 3：正确设置远程仓库 (Remotes)

远程仓库的设置取决于您在上面选择了哪个选项：

### 如果您使用 GitHub CLI 克隆了您的复刻（选项 A，方法 1）

`gh` 已经为您完成了这一步。

### 如果您未使用 GitHub CLI 克隆您的复刻（选项 A，方法 2）

您需要将原始仓库添加为 `upstream`：

```bash
git remote add upstream https://github.com/leanprover-community/mathlib4.git
```

### 如果您使用了现有的克隆（选项 B）

您需要重命名现有的远程仓库并添加您的复刻。
将 `YOUR_USERNAME` 替换为您的 GitHub 用户名：

```bash
git remote rename origin upstream
git remote add origin https://github.com/YOUR_USERNAME/mathlib4.git
```

### 验证您的远程仓库

无论您选择哪个选项，都请验证您的远程仓库设置是否正确：

```bash
git remote -v
```

您应该会看到：

```
origin    https://github.com/YOUR_USERNAME/mathlib4.git (fetch)
origin    https://github.com/YOUR_USERNAME/mathlib4.git (push)
upstream  https://github.com/leanprover-community/mathlib4.git (fetch)
upstream  https://github.com/leanprover-community/mathlib4.git (push)
```

## 步骤 4：配置 Master 分支

首先，从上游仓库获取分支：

```bash
git fetch upstream
```

然后确保您的 `master` 分支跟踪 `upstream/master`：

```bash
git branch --set-upstream-to=upstream/master master
```

## 步骤 5：为您的工作流配置 Git

### 设置默认推送行为

配置 git 默认将新分支推送到 `origin`：

```bash
git config push.default current
git config push.autoSetupRemote true
```

### 防止意外提交到 Master（可选但推荐）

为避免意外直接提交到 `master`，您可以设置一个 pre-commit 钩子。
首先，创建钩子文件：

```bash
mkdir -p .git/hooks
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/sh
branch="$(git rev-parse --abbrev-ref HEAD)"
if [ "$branch" = "master" ]; then
  echo "You can't commit directly to master branch"
  exit 1
fi
EOF
```

然后使其可执行：

```bash
chmod +x .git/hooks/pre-commit
```

---

# 第二部分：日常工作流程

这些是您在进行贡献时会经常使用的操作。

## 创建和处理新分支

### 保持您的 Master 分支最新

**在创建新分支之前执行此操作**，以确保您正在使用最新的更改：

```bash
git switch master
git pull
```

### 创建一个新分支

然后创建并切换到一个新分支：

```bash
git switch -c my-feature-branch
```

当您首次推送该分支时，它将自动跟踪 `origin/my-feature-branch`。

### 基于另一个 PR 进行工作

如果您打算让您的工作依赖于另一个 PR：

1.  通过运行 `git switch <pr-branch-name>` 检出相关的 PR 分支（如果是您自己的 PR），或者如果您打算在别人的 PR 之上工作，请遵循下方 [`处理他人的 PR`](#working-with-others-prs) 部分的说明。
2.  运行 `git pull` 以确保您与此拉取请求保持同步。
3.  运行 `git switch -c my-feature-branch` 以在当前分支之上创建一个新分支。


## 推送您的分支并开启一个 PR

### 推送您的分支

在做出更改和提交之后：

```bash
git push
```

### 开启一个拉取请求 (Pull Request)

1.  前往您在 GitHub 上的复刻：`https://github.com/YOUR_USERNAME/mathlib4`
2.  您应该会看到一个建议您为最近的推送开启 PR 的横幅
3.  点击 "Compare & pull request"
4.  填写 PR 的标题和描述
5.  点击 "Create pull request"

或者，如果您没有看到该横幅，您也可以访问 https://github.com/leanprover-community/mathlib4/compare，然后点击 `compare across forks`。
您需要在“head repository”下拉菜单中选择您的复刻，并在“compare”下拉菜单中选择您想要合并的分支。

## 处理他人的 PR

请注意，即使只是在 VS Code 中打开来自不受信任的人的分支中的 Lean 代码，也可能最终在您的计算机上执行代码！
请查看[附加信息部分的安全警告](#-security-warning)。

### 方法 1：使用 GitHub CLI（推荐）

这比手动方法简单得多。要检出 PR #1234：

```bash
gh pr checkout 1234
```

这会自动处理远程仓库设置和分支检出。

要切换回您的分支：

```bash
git switch my-feature-branch
```

### 方法 2：手动检出

要手动检出别人的 PR，首先将他们的复刻添加为远程仓库（将 `USERNAME` 替换为他们的 GitHub 用户名）：

```bash
git remote add contributor-name https://github.com/USERNAME/mathlib4.git
```

然后获取他们的分支：

```bash
git fetch contributor-name
```

最后，检出他们的分支：

```bash
git checkout contributor-name/their-branch-name
```

（远程仓库可以使用 `git remote remove <contributor-name>` 移除。）

要切换回您的分支：

```bash
git switch my-feature-branch
```

## 授予协作者访问权限

如果您想允许他人直接推送到您的 PR 分支：

1.  前往您的复刻：`https://github.com/YOUR_USERNAME/mathlib4`
2.  点击 "Settings" 标签页
4.  点击 "Collaborators" （您可能需要重新验证身份）
5.  输入他们的 GitHub 用户名
6.  选择 "Write" 权限级别
7.  发送邀请

一旦他们接受，他们就可以在遵循 ["基于另一个 PR 进行工作"](#basing-work-on-another-pr) 中的一种方法后，使用 `git push` 直接推送到您的 PR 分支。

---

# 附加信息

## ⚠️ 安全警告

**重要提示**：当您授予某人对您的复刻的协作者访问权限时，或者当您检出并运行他人的代码时，您可能正在您的计算机上运行未经审查的代码。请仅与您信任的人合作，因为他们提交的代码可能包含会在构建过程中运行的恶意内容。

## 获取帮助

如果您遇到问题或对 git 工作流程有疑问，请在 [Lean Zulip chat](https://leanprover.zulipchat.com) 的 `#new users` 信息流中提问。社区非常乐于助人并欢迎提问！

## 快速参考

以下是您将最常使用的一些命令的摘要。

更新 master：

```bash
git switch master
git pull
```

在当前分支之上创建一个新分支：

```bash
git switch -c new-branch-name
```

推送您的分支并设置跟踪：

```bash
git push origin new-branch-name
```

如果您已按照[上述指南设置了默认推送选项](#set-default-push-behavior)，那么以下命令就足够了：
```bash
git push
```

检出他人的 PR：

```bash
gh pr checkout PR_NUMBER
```

检查远程仓库配置：

```bash
git remote -v
```

检查您当前所在的分支：

```bash
git branch
```

切换到不同的分支进行工作：

```bash
git switch your-branch-name
```

## 常见问题排查

**问题**："Your branch is behind 'upstream/master'"
**解决方案**：
```bash
git switch master
git pull
```

**问题**："fatal: The current branch has no upstream branch"
**解决方案**：
```bash
git push --set-upstream origin branch-name
```

**问题**：意外提交到了您的 master 分支副本
**解决方案**：将提交移动到一个新分支：
```bash
git branch new-branch-name
git switch master
git reset --hard upstream/master
git switch new-branch-name
```

## 附加资源

*   [The git glossary (git 术语表)](https://git-scm.com/docs/gitglossary)
*   [Everyday git commands (日常 git 命令)](https://git-scm.com/docs/giteveryday)
*   [The git user manual (git 用户手册)](https://git-scm.com/docs/user-manual)