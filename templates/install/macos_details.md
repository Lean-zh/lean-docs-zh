# 在 MacOS 上进行受控的 Lean 4 安装

请注意，这些是由社区提供的遗留说明。安装 Lean 和创建项目的推荐方法是遵循 [Lean 官方文档](https://docs.lean-lang.org/lean4/doc/quickstart.html) 中的说明。

## 遗留说明

本文档解释了在 MacOS 上为 Lean 进行更受控的安装流程。在主[安装页面](macos.html)中描述了一种更快捷的方法，但它需要更多的信任。

如果你遇到困难，请到[聊天室](https://leanprover.zulipchat.com/)寻求帮助。

我们需要设置 Lean、一个了解 Lean 的编辑器，以及 [`mathlib`](https://github.com/leanprover-community/mathlib4/)（数学库）。

我们将安装一个名为 [`elan`](https://github.com/leanprover/elan) 的小程序，而不是直接安装 Lean，它会根据每个项目的需要自动提供正确版本的 Lean。建议所有用户都这样做。

安装 `elan` 和 mathlib 支持工具
---

1.  获取你架构的[最新版本](https://github.com/leanprover/elan/releases/latest)，
    解压它，并运行其中包含的安装程序。

    安装程序会告诉你它将在哪里安装 `elan`（默认为 `~/.elan`），
    并询问你是否编辑 shell 配置以扩展 `PATH`。可以通过 `elan self uninstall` 卸载 `elan`，这应该会撤销这些更改。

（我们不鼓励使用 `homebrew` 提供的 `elan-init` 包，因为用户经常发现它落后于官方版本的更新。我们尤其不鼓励使用名为 `lean` 的 `homebrew` 公式，它会安装一个固定版本的 Lean。）

2.  通过运行 `elan toolchain install stable`，使用 `elan` 安装最新稳定版的 `lean`。你还可以通过运行 `elan default stable`，将新安装的版本设置为在项目（下文讨论）之外运行时获取的默认 `lean` 版本。

安装和配置编辑器
---

有三种可以与 Lean 一起使用的编辑器：VS Code、emacs 和 neovim。
本文档描述了使用 VS Code 的方法，它目前对 Lean 的支持最好。
对于 emacs，请查看 https://github.com/leanprover/lean4-mode。
对于 neovim，请查看 https://github.com/Julian/lean.nvim)

1. 安装 [VS Code](https://code.visualstudio.com/)。
2. 启动 VS Code。
3. 点击屏幕左侧边栏中的扩展图标 ![(image of icon)](img/new-extensions-icon.png)
   （或在旧版本中是 ![(image of icon)](img/extensions-icon.png)）（或按 <kbd>⇧ Shift</kbd><kbd>⌘ Command</kbd><kbd>X</kbd>) 并搜索 `leanprover`。
4. 选择 `lean4` 扩展（唯一名称为 `leanprover.lean4`）。
5. 点击“安装”（在旧版本的 VS Code 中，之后你可能需要点击“重新加载”）
6. 验证 Lean 是否正常工作，例如，通过保存一个名为 `test.lean` 的文件并输入 `#eval 1+1`。
   在 `#eval 1+1` 下方应该会出现一条绿线，将鼠标悬停在上面时，你应该能看到显示的 `2`。

## Lean 项目

你现在可以阅读关于创建和使用 [Lean 项目](project.html) 的说明了