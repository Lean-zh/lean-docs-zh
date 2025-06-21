# 如何在 Debian/Ubuntu 上安装 Lean 4

请注意，这些是由社区提供的遗留说明。安装 Lean 和创建项目的推荐方法是遵循 [Lean 官方文档](https://docs.lean-lang.org/lean4/doc/quickstart.html) 中的说明。

## 遗留说明

本文档解释了如果你正在使用源自 Debian 的 Linux 发行版（Debian 本身、Ubuntu、LMDE 等），如何开始使用 Lean 和 mathlib。

如果你遇到困难，请到[聊天室](https://leanprover.zulipchat.com/)寻求帮助。

这里我们将讨论快捷方法，但这需要你给予充分的信任。它将安装 Lean 及其支持工具 `elan` 和 `lake`，以及代码编辑器 VS Code 和其 Lean 插件，还有你可能已经拥有的其他依赖，如 `curl` 和 `git`。如果你不喜欢这种方法，有一个[详细的网页](debian_details.html)，它会将过程分解为多个有说明的阶段，并且不会要求你盲目地使用 `sudo`。

快捷方法是：打开一个终端并输入：
```bash
wget -q https://raw.githubusercontent.com/leanprover-community/mathlib4/master/scripts/install_debian.sh && bash install_debian.sh ; rm -f install_debian.sh && source ~/.profile
```

## Lean 项目

你现在可以阅读关于创建和使用[Lean 项目](project.html)的说明了。