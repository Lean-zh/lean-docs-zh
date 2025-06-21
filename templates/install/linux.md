# 在 Linux 上安装 Lean 4

请注意，这些是由社区提供的遗留说明。安装 Lean 和创建项目的推荐方法是遵循 [Lean 官方文档](https://docs.lean-lang.org/lean4/doc/quickstart.html) 中的说明。

## 遗留说明

本文档解释了如何在通用的 Linux 发行版上开始使用 Lean 和 mathlib（对于 Debian 及其派生发行版如 Ubuntu，有[一个专门的页面](debian.html)）。

以下所有命令都应在终端中输入。

* Lean 本身不依赖于太多基础设施，但大多数用户所需的支持工具需要 `git` 和 `curl`。所以第一步是获取它们。

* 下一步是安装一个名为 [`elan`](https://github.com/leanprover/elan) 的小工具，它将根据你当前项目的需求来处理 Lean 的更新（当被提问时按 Enter 键）。它将位于 `$HOME/.elan` 中，并向 `$HOME/.profile` 添加一行。
  ```bash
  curl https://elan.lean-lang.org/elan-init.sh -sSf | sh
  ```

* 你还需要一个带有 Lean 插件的代码编辑器。推荐的选择是 [Visual Studio Code](https://code.visualstudio.com/)，它目前拥有最好的 Lean 支持。
  其他选择是使用 Emacs 及其 [lean4-mode](https://github.com/leanprover/lean4-mode)
  或 neovim 及其 [lean.nvim extension](https://github.com/Julian/lean.nvim)。

  1. 安装 [VS Code](https://code.visualstudio.com/)。
  2. 启动 VS Code。
  3. 点击屏幕左侧边栏中的扩展图标 ![(image of icon)](img/new-extensions-icon.png)
     （或在旧版本中是 ![(image of icon)](img/extensions-icon.png)） (或按 <kbd>Shift</kbd><kbd>Ctrl</kbd><kbd>X</kbd>) 并搜索 `leanprover`。
  4. 选择 `lean4` 扩展（唯一名称为 `leanprover.lean4`）。
  5. 点击“安装”（在旧版本的 VS Code 中，之后你可能需要点击“重新加载”）
  6. 验证 Lean 是否正常工作，例如，通过保存一个名为 `test.lean` 的文件并输入 `#eval 1+1`。
    在 `#eval 1+1` 下方应该会出现一条绿线，将鼠标悬停在上面时，你应该能看到显示的 `2`。

## Lean 项目

你现在可以阅读关于创建和使用 [Lean 项目](project.html) 的说明了