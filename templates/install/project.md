# Lean 项目

安装 Lean 后，要使用它，你*必须*创建或下载一个 Lean 项目 (Lean project)。
推荐的创建或安装项目的方式是在 Visual Studio Code (VS Code) 内部进行。
在 VS Code 中，点击右上角的 `∀` 符号（如果 Lean 已安装，该符号应该可见），然后选择“新建项目 (New Project)”或“打开项目 (Open Project)”。

如果你尚未安装 Lean，那么推荐的方法是遵循 [Lean 官方文档](https://docs.lean-lang.org/lean4/doc/quickstart.html) 中的说明。

## 为什么需要项目？

通常，如果你只是在文本编辑器中打开单个 `.lean` 文件并尝试用 Lean 编译它，你会得到一堆令人困惑的错误。
每个非平凡的 Lean 代码段都需要存在于一个 *Lean 项目*（有时也称为 Lean 包 (Lean package)）内部。
一个“Lean 项目”不仅仅是一个你命名为“我的 Lean 资料”的文件夹。
相反，它是一个包含一些非常特定东西的文件夹：特别是一个 *git 仓库 (git repository)* 和一个 `lakefile.lean` 或 `lakefile.toml` 文件，该文件收集了关于项目依赖的信息，例如包括应该使用的 Lean 版本。

## 遗留说明

这些遗留说明给出了如何手动安装项目的命令行解释。

如果你有兴趣为 mathlib 做贡献，你只需要设置一次 Lean 项目，这个项目可以用于你所有的贡献——你不需要为每个新贡献都设置一个新的 Lean 项目。

所有这些的设置和管理都由一个名为 `lake` 的程序完成（这是 `lean` 和 `make` 的合成词）。
本页描述了这个工具的基本用法，对于日常使用应该足够了。
如果这不能满足你的需求，你可以阅读完整的 [lake 文档](https://github.com/leanprover/lean4/blob/master/src/lake/README.md)。

## 使用现有项目

假设你想在一个现有项目上工作。作为例子，我们将使用 [《Mathematics in Lean》这本书](https://github.com/leanprover-community/mathematics_in_lean)。
打开一个终端。

* 如果你自安装 Lean 和 mathlib 后没有重新登录过，你可能需要先根据你的操作系统输入 `source ~/.profile` 或
  `source ~/.bash_profile`。
  如果你在 Windows 上，并且不知道如何操作，另一个选择是重启你的电脑。

* 前往你希望存放这个包的目录。你不需要自己创建新文件夹，下一个命令会为你创建一个 `mathematics_in_lean` 子文件夹。

* 运行 `git clone https://github.com/leanprover-community/mathematics_in_lean.git`。

* 运行 `cd mathematics_in_lean`

* 运行 `lake exe cache get` （注意：此命令目前仅在将 `mathlib4` 作为依赖项导入的项目中有效）

* 启动 VS Code，可以通过你的应用程序菜单，或者输入
  `code .`。（MacOS 用户需要一次性的[额外步骤](https://code.visualstudio.com/docs/setup/mac#_launching-from-the-command-line)才能从命令行启动 VS Code。）

* 如果你是从菜单启动 VS Code，在主屏幕或文件菜单中，点击“打开文件夹 (Open folder)”（在 Mac 上仅为“打开 (Open)”），然后选择 `mathematics_in_lean` 文件夹（**而不是**它的某个子文件夹）。

* 使用左侧的文件浏览器，在 `MIL` 中探索你想要的任何内容。
  关于如何完成本书中的练习，请参阅 [MIL 说明](https://github.com/leanprover-community/mathematics_in_lean/blob/master/README.md)
  以获取建议。

## 创建 Lean 项目

我们现在将创建一个依赖于 mathlib 的新项目。下面的
命令应该在终端中输入。

* 前往你希望在 `my_project` 子文件夹中创建项目的文件夹，然后输入 `lake +leanprover/lean4:nightly-2024-04-24 new my_project math`。不必担心前一个命令中的日期，它确保你将使用一个足够新的 `lake` 版本，但对你的项目将使用的 `lean` 版本没有影响。如果你收到
  错误消息说 `lake` 是一个未知命令，并且
  你自安装 Lean 后没有重新登录过，那么
  你可能需要先输入 `source ~/.profile` 或 `source ~/.bash_profile`。
命令末尾的关键字 `math` 会将 `mathlib4` 添加到你项目的依赖中，这样你就可以在项目文件中使用 `import Mathlib`。

* 进入 `my_project` 文件夹并输入 `lake update`。
  * 遇到 `curl: (35) schannel: next InitializeSecurityContext failed` 错误的 Windows 用户应阅读[此说明](#troubleshooting)。

* 启动 VS Code，可以通过你的应用程序菜单，或者输入
  `code .` 命令。

* 如果你是通过菜单启动 VS Code 的：在主屏幕上，或者在
  文件菜单中，点击“打开文件夹”（在 Mac 上，仅为“打开”），然后
  选择 `my_project` 文件夹（**而不是**它的子文件夹）。

* 你的 Lean 代码现在应该放在扩展名为 `.lean` 的文件中，
  位于 `my_project/MyProject/` 或其子文件夹中。在 VS Code 左侧的文件浏览器中，
  你可以右键点击 `MyProject`，选择
  `新建文件`，然后输入文件名以在那里创建一个文件。

如果你想确保一切正常，可以从创建，比如说 `my_project/MyProject/Test.lean` 开始，内容如下：
```lean
import Mathlib.Topology.Basic

#check TopologicalSpace
```
当光标在最后一行时，VS Code 的右侧部分应该会显示一个“Lean Infoview”区域，内容为：
`TopologicalSpace.{u} (α : Type u) : Type u`。

请注意，你可以在项目中导入你自己的文件。例如，如果你创建了一个
文件 `my_project/MyProject/Definitions.lean`，你可以用 `import MyProject.Definitions` 来开始一个新文件
`my_project/MyProject/Lemmas.lean`。

如果，由于某种原因，你碰巧丢失了“Lean Infoview”区域，你
可以用 <kbd>Ctrl</kbd>-<kbd>Shift</kbd>-<kbd>Enter</kbd>
（在 MacOS 上是 <kbd>Cmd</kbd>-<kbd>Shift</kbd>-<kbd>Enter</kbd>）让它回来。
另外，你可以使用 <kbd>Ctrl</kbd>-<kbd>Shift</kbd>-<kbd>p</kbd>
（在 MacOS 上是 <kbd>Cmd</kbd>-<kbd>Shift</kbd>-<kbd>p</kbd>）在 VS Code 中获取 Lean 文档，然后，
在出现的文本字段中，输入“lean doc”并按 <kbd>Enter</kbd>。
然后点击“Mathematics in Lean”或“Theorem Proving in Lean”并开始享用。

## 更新项目中的 Mathlib

如果你有一个依赖于 Mathlib 的项目，并且想要更新到最新版本的 Lean 和 Mathlib，你需要执行两个步骤：
* 将你仓库中的 `lean-toolchain` 文件更新到最新版本。你可以在你仓库的根目录中运行以下命令来自动完成此操作。
```
curl -L https://raw.githubusercontent.com/leanprover-community/mathlib4/master/lean-toolchain -o lean-toolchain
```
* 运行 `lake update`。这将为你更新 Lean、Mathlib 并下载新的 Mathlib 缓存。（注意：在使用 `leanblueprint`/`doc-gen` 的项目上，你目前必须运行 `lake -R -Kenv=dev update`）。

然后你应该检查你仓库中的所有文件是否仍然可以编译。
你可以通过运行 `lake exe mk_all && lake build` 来做到这一点。

更多关于 Lake 的信息可以在[这里](https://github.com/leanprover/lean4/tree/master/src/lake)找到。

## 为 mathlib 做贡献

请参见[如何为 mathlib 做贡献](https://leanprover-community.github.io/contribute/index.html)。

## 故障排除

* 一些 Windows 用户报告在运行 `lake exe cache get` 时出现类似以下的错误：

```
  curl: (35) schannel: next InitializeSecurityContext failed: Unknown error (0x80092012) - The revocation function was unable to check revocation for the certificate
```

如果你看到这个错误，你可能有一个扫描每个下载文件的杀毒程序，这导致了错误。
请禁用你的杀毒程序，然后运行 `lake exe cache get!`。
感叹号会强制 `lake` 重新下载在运行此命令之前下载失败的缓存文件。
（如果你对禁用杀毒软件感到不适，可以尝试遵循[这些说明](https://leanprover.zulipchat.com/#narrow/stream/287929-mathlib4/topic/lake.20exe.20cache.20get.20errors/near/389019448)
然后运行 `lake exe cache get!`）。
之后你可以重新开启你的杀毒程序。
然而，一些用户也报告说杀毒程序在正常使用期间会显著减慢 Lean 的速度。
如果 Lean 比预期的要慢，要么关闭你的杀毒程序，要么告诉它忽略/允许 `lean.exe` 的操作。

* 有时在 Windows 下安装/更新 Lean 时会下载一个损坏的 Lean 版本。如果发生这种情况，将导致错误
```
uncaught exception: no such file or directory (error code: 2)
```
如果发生这种情况，你可以通过以下两个步骤手动删除你损坏的 Lean 版本：
  - 前往你的用户文件夹并导航到 `.elan > toolchains`（通常是 `C:\Users\<username>\.elan\toolchains`），然后删除有问题的工具链。
  - 前往 `.elan > update-hashes`（例如 `C:\Users\<username>\.elan\update-hashes`）并删除同名文件。
下次你在使用该工具链的仓库中调用 `lake update`、`lake exe cache get`、`lake build` 或在 VSCode 中打开一个 Lean 文件时，该工具链将自动重新下载。

* 如果你想清理 Lean 文件，它们存储在以下位置。
  - 项目的依赖项位于该项目的 `.lake` 文件夹中。
  - Lean 工具链存储在 `~/.elan/toolchains` 中。你可以安全地从这里删除旧的工具链。每当你删除工具链时，你也应该从 `~/.elan/update-hashes` 中删除相应的文件。
  - 压缩和编译的 Mathlib 文件存储在 `~/.cache/mathlib` 中。这些可以安全地删除。
  - Lean 3 用户可能在他们的用户目录中还有一个 `.mathlib` 文件夹。