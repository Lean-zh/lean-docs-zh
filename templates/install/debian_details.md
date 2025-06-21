# 在 Debian/Ubuntu 上进行受控的 Lean 4 安装

请注意，这些是由社区提供的遗留说明。安装 Lean 和创建项目的推荐方法是遵循 [Lean 官方文档](https://docs.lean-lang.org/lean4/doc/quickstart.html) 中的说明。

## 遗留说明

本文档解释了在源自 Debian 的 Linux 发行版（Debian 本身、Ubuntu、LMDE 等）上为 Lean 4 和 mathlib 进行更受控的安装流程。在主[安装页面](debian.html)中描述了一种更快捷的方法，但它需要更多的信任。当然，你可以通过阅读下面将要下载的 bash 脚本来获取更多关于其运行原理的细节：[elan_init](https://github.com/leanprover/elan/blob/master/elan-init.sh)。

* Lean 本身不依赖于太多基础设施，但大多数用户所需的支持工具需要 `git` 和 `curl`。所以第一步是：
  ```bash
  sudo apt install git curl
  ```

* 下一步是安装一个名为 `elan` 的小工具，它将根据你当前项目的需求来处理 Lean 的更新（当被提问时按 Enter 键）。它将位于 `$HOME/.elan` 中，并向 `$HOME/.profile` 添加一行。
  ```bash
  curl https://elan.lean-lang.org/elan-init.sh -sSf | sh
  ```

* 有三种可以与 Lean 一起使用的编辑器：VS Code、emacs 和 neovim。推荐的选择是 [Visual Studio Code](https://code.visualstudio.com/)，它为 Lean 提供了最完整且经过充分测试的支持。
  ```bash
  wget -O code.deb https://go.microsoft.com/fwlink/?LinkID=760868
  sudo apt install ./code.deb
  rm code.deb
  code --install-extension leanprover.lean4
  ```

  现在打开 VS Code，并通过保存一个名为 `test.lean` 的文件并输入 `#eval 1+1` 来验证 Lean 是否正常工作。在 `#eval 1+1` 下方应该会出现一条绿线，将鼠标悬停在上面时，你应该能看到显示的 `2`。

  或者，你可以使用 Emacs 及其 [lean4-mode](https://github.com/leanprover/lean4-mode) 或 neovim 及其 [lean.nvim extension](https://github.com/Julian/lean.nvim)。

## Lean 项目

你现在可以阅读关于创建和使用 [Lean 项目](project.html) 的说明了。