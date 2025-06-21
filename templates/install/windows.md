# 在 Windows 上安装 Lean 4

请注意，这些是由社区提供的遗留说明。安装 Lean 和创建项目的推荐方法是遵循 [Lean 官方文档](https://docs.lean-lang.org/lean4/doc/quickstart.html) 中的说明。

## 遗留说明

本文档解释了如何开始使用 Lean 4 和 mathlib。

如果你遇到困难，请到[聊天室](https://leanprover.zulipchat.com/)寻求帮助。

<!--
TODO: make a new video walkthrough.
There is a [video walkthrough](https://www.youtube.com/watch?v=y3GsHIe4wZ4) of these instructions on YouTube.
-->

我们需要设置 Lean、一个了解 Lean 的编辑器，以及 `mathlib4`（标准库）。
我们将依赖一个名为 [`elan`](https://github.com/leanprover/elan) 的小程序，而不是直接安装 Lean，它会根据每个项目的需要自动提供正确版本的 Lean。建议所有用户都这样做。

## 安装 `Visual Studio Code`

我们建议所有人都使用 `VS Code` 作为在 Lean 中工作的编辑器。
你可以从 [https://code.visualstudio.com/download](https://code.visualstudio.com/download) 为你的操作系统安装 `VS Code`。

## 安装 `git`

Lean 4 项目之间的依赖是通过指向 git 仓库的指针实现的，所以你需要在你的电脑上安装 `git`。

你可能已经设置好了，这种情况下你可以跳过这一步。

否则，我们建议你安装 [`Git for Windows`](https://gitforwindows.org/)。
安装过程中你会被问到许多问题，我们建议你对所有问题都接受默认设置，*除了*默认编辑器，你应该选择 `Visual Studio Code`，而不是默认的 `vi`。

我们建议运行 `git config --global core.autocrlf input` 以确保你不会更改所编辑文本文件的换行符。

## 在 `VS Code` 中安装 `lean4` 扩展

打开 `VS Code`，在屏幕左侧边缘的“活动栏 (activity bar)”中点击“扩展 (extension)”图标 ![(image of icon)](img/new-extensions-icon.png)。

在出现的搜索框中，输入 `lean4`，然后选择出现的 `lean4` 扩展，并点击安装按钮。

## 设置 `elan` 和 `lean`

你可以让 `VS Code` 扩展为你安装 `elan` 和 `lean`，也可以手动安装。我们建议让扩展来做，但两种方法的说明都会给出。

### 让扩展安装 `elan` 和 `lean`

在 `File` 菜单下，选择 `New text file`。
一个标记为 `Untitled-1` 的新窗口将会出现。

在这个窗口中会有一个提示说 `Select a language`，你应该点击它并选择 `Lean4`。
（或者你也可以在屏幕右下角找到 `VS Code` 显示 `Plain text` 的地方，在这里更改语言，或者按 `ctrl+shift+p` 打开命令面板 (command palette)，并选择 `Change language mode`。）

一旦你将语言设置为 `Lean4`，屏幕右下角会出现一个对话框，内容为 `Failed to start 'lean' language server`，并带有一个 `Install Lean using Elan` 按钮。

点击这个按钮，在 `VS Code` 内的终端窗口中，你应该能看到安装过程开始。
下载和安装 `Lean` 大约需要一分钟。

当它完成后，回到 `Untitled-1` 编辑器，并输入

```lean
#eval 18 + 19
```

如果你看到 `#eval` 下方出现蓝色下划线，并且在右侧的 `Lean info view` 面板中显示结果 `37`，那么你已经成功安装了 Lean 4！

你可以跳到前面阅读关于创建和使用 [Lean 项目](project.html) 的说明。
这个页面将向你展示如何使用 mathlib4（Lean 的主要数学库），或者如何在一个依赖 mathlib4 的新的或现有的项目上工作。

### 自己安装 `elan`

打开命令提示符 (`cmd`) 并执行以下命令：

```shell
curl -O --location https://elan.lean-lang.org/elan-init.ps1
powershell -ExecutionPolicy Bypass -f elan-init.ps1
del elan-init.ps1
```

或者你也可以打开一个 `git bash` 窗口，并运行

```shell
curl https://elan.lean-lang.org/elan-init.sh -sSf | sh
```

无论哪种情况，安装 `elan` 大约需要一分钟。
之后，在 `VS Code` 中你可以打开一个文本文件，并将语言设置为 `Lean4`（或者直接以 `.lean` 扩展名保存它），然后尝试

```lean
#eval 18 + 19
```

如上所述，来检查 Lean 是否对你有响应。

你现在可以阅读关于创建和使用 [Lean 项目](project.html) 的说明了。