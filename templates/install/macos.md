# 如何在 MacOS 上安装 Lean 4

请注意，这些是由社区提供的遗留说明。安装 Lean 和创建项目的推荐方法是遵循 [Lean 官方文档](https://docs.lean-lang.org/lean4/doc/quickstart.html) 中的说明。

## 遗留说明

本文档解释了如果你正在使用 MacOS，如何开始使用 Lean 4。

如果你遇到困难，请到[聊天室](https://leanprover.zulipchat.com/)寻求帮助。

## 安装 Lean 4

这里我们将讨论快捷方法，但这需要你给予充分的信任。它将安装 Lean 及其支持工具 `elan` 和 `lake`，以及代码编辑器 VS Code 和其 Lean 插件。如果你不喜欢这种方法，有一个[详细的网页](macos_details.html)，它会将过程分解为多个有说明的阶段，并且不会要求你盲目地使用 `sudo`。

快捷方法是：打开一个终端并输入：
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/leanprover-community/mathlib4/master/scripts/install_macos.sh)" && source ~/.profile
```
## Lean 项目

你现在可以阅读关于创建和使用[Lean 项目](project.html)的说明了

如果你在打开新终端时遇到任何 `command not found` 错误，从 MacOS 注销再重新登录应该可以解决问题。