# 如何为 mathlib 做贡献

以下是一些提示和技巧，可以使贡献过程尽可能顺利。

*   使用 [Zulip](https://leanprover.zulipchat.com/) 来在您工作之前和期间讨论您的贡献。
*   创建一个 GitHub 账户，并使用[个人设置面板](https://leanprover.zulipchat.com/#settings/profile)将您的 GitHub 用户名添加到您的 Zulip 个人资料中。我们也强烈建议您在 Zulip 上将显示名称设置为您的真实姓名。
*   遵守以下指南：
    *   为贡献者准备的[风格指南](style.html)。
    *   关于[命名约定](naming.html)的解释。
    *   [文档指南](doc.html)。

一旦您有了希望贡献的代码，您应该开启一个 PR。

## 在 mathlib 上工作

我们使用 `git` 来管理和进行 mathlib 的版本控制。

如果您之前没有使用 git 为开源项目贡献过，请参阅[Mathlib4 贡献者 Git 指南](git.html)以获取详细说明。

`master` 分支是 mathlib 的“生产”版本。
至关重要的是，master 分支中的所有内容都必须能够无错误地编译，并且没有任何 `sorry`。
为确保这一点，我们只向 `master` 提交那些通过了自动化持续集成 (Continuous Integration, "CI") 测试，并得到 mathlib 维护者批准的变更。

当您为一个新的 `mathlib` 贡献工作时，您应该在一个不同的分支上进行。
您应该在您自己的 `mathlib` 仓库的复刻 (fork) 中进行此操作。

典型工作流程：
*   要开始，您需要一个 mathlib 的本地副本。
*   首先，您需要访问 https://github.com/leanprover-community/mathlib4 并点击右上角的 "Fork"，来创建您自己的仓库复刻 (fork)。您的复刻位于 [https://github.com/USER/mathlib4](https://github.com/USER/mathlib4)。
*   现在创建一个仓库的本地克隆 (clone)。
    ```
    git clone https://github.com/leanprover-community/mathlib4.git
    cd mathlib4
    lake exe cache get
    ```
*   以上步骤只需完成一次（而不是每次贡献都做一次）。
*   现在，每当您想对 mathlib 进行新的更改时，请创建一个新分支：
    ```
    git switch -c my_new_branch   # 这会创建一个新分支并切换到该分支
    ```
*   有时您可能不想创建新分支，而是想在别人创建的或者您在不同电脑上创建的分支上工作。在这种情况下，您需要使用 `git switch their_new_branch`（注意这里没有 `-c`）。
*   进行本地更改，例如使用带有 Lean 扩展的 Visual Studio Code。
*   使用 `git commit -a`（或通过 VS Code 界面）提交您的更改。
*   如果您想在本地编译所有内容以检查是否破坏了任何东西，请运行 `lake build`。如果您修改了位于导入层级较深处的文件，这可能会花费很长时间。在您向主仓库开启 PR 后，让我们的中央 CI 服务器为您完成这项工作也是可以的。
*   如果您创建了新文件，请运行 `lake exe mk_all`。这将更新 `Mathlib.lean` 以确保所有文件都在那里被导入。
*   为了将您的更改推送回 github 上的仓库，请使用
    ```
    git push
    ```
    如果此命令抱怨远程仓库未配置，请遵循 `git` 输出中的建议并运行
    ```
    git push --set-upstream origin my_new_branch
    ```
*   一旦您向主 `mathlib` 仓库开启了 PR（见下文），持续集成 (continuous integration) 将在此时自动启动。您可以通过访问 https://github.com/leanprover-community/mathlib4/tree/my_new_branch 查看输出（如果一切正常，描述最新提交的行上会有一个绿色对勾；如果 CI 仍在工作，则是一个黄色圆圈；如果出了问题，则是一个红色叉号。点击红色叉号可以查看详情）。您也可以通过安装 [`hub`](https://hub.github.com/) 并运行 `hub ci-status` 在命令行上检查 CI 状态。
*   在 CI 完成后，您可以运行 `lake exe cache get` 来下载编译好的 oleans。


## 创建一个拉取请求 (PR)

一旦您对本地的更改感到满意，就该创建一个拉取请求 (pull request) 了。

*   如果您还没有这样做，请访问 https://leanprover.zulipchat.com/，介绍一下自己，并提及您的新 PR。

*   如果您做了很多更改/添加，请尝试创建多个包含小的、自包含片段的 PR；总的来说，越小越好！这有助于您在进行过程中获得反馈，而且审查起来也容易得多。这对新贡献者尤其重要，因为它可以防止做无用功。

*   PR 的标题和描述应遵循我们的[提交约定](commit.html)。

*   如果您要移动或删除声明，请在提交信息的底部（即在 `---` 之前）使用以下格式包含这些行：

Moves:
- Vector.* -> Mathlib.Vector.*
- ...

Deletions:
- Nat.bit1_add_bit1
- ...

任何您希望保留在 PR 提交信息之外的其他评论都应放在 `---` 下方。

## PR 的生命周期

许多审查者使用[审查队列](../queueboard/review_dashboard.html)来识别准备好审查的 PR。
以下说明将确保您的 PR 出现在该队列上；如果它没有出现在那里，可能不会受到太多关注。
也欢迎大家定期查看队列（在 Zulip 上链接为 `#queueboard`），并对自己专业领域内的 PR 进行审查。
您可以检查您的 [PR 是否在队列中](../queueboard/on_the_queue.html)，如果不在，需要做什么才能让它进入队列。

审查队列由 GitHub “标签” (labels) 控制。
在 PR 的主页上，右侧应该有一个侧边栏，包含 "reviewers"、"assignees"、"labels" 等面板。
点击 "labels" 标题可以为当前项目添加或移除标签。
（标签只能由 "GitHub collaborators" 编辑，这大致相当于“拥有写权限的人”。）任何人都可以通过在 PR 的评论中编写以下命令来编辑标签（每个命令占一行）：
- `awaiting-author` 将添加 **"awaiting-author"** 标签
- `-awaiting-author` 将移除 **"awaiting-author"** 标签
- `WIP` 将添加 **"WIP"** 标签
- `-WIP` 将移除 **"WIP"** 标签

如果您的 PR 构建成功（有一个绿色对勾），有人会在几周内“审查”它（取决于 PR 的大小；较小的 PR 会得到更快的响应）。他们可能会留下评论并添加 **"awaiting-author"** 标签。您应该处理每一条评论，一旦问题解决就点击“resolve conversation”按钮。理想情况下，每个问题都通过一次新的提交来解决，但这里没有硬性规定。一旦所有请求的更改都已实现，您应该移除 **"awaiting-author"** 标签以重新开始此过程。

有不同的人群可以审查您的 PR：任何人、[审查者](../teams/reviewers.html) 和 [维护者](../teams/maintainers.html)。
任何有建设性意见的人都可以审查您的 PR。
如果他们认为您的 PR 已准备好进入下一阶段，他们可能会在 GitHub 上留下一个“批准”的审查。
这些审查会被审查者考虑。
如果审查者认为您的 PR 已准备好被合并，他们会为您的 PR 添加 **"maintainer-merge"** 标签。
维护者使用这些标签来优先处理他们的审查。
维护者总是最终批准的人。
维护者拥有审查者的权利，但还有更进一步的权力（例如合并 PR）。
根据可用性，维护者可能是第一个查看您 PR 的审查者：在这种情况下，您的 PR 可能会在没有先被 "maintainer merge" 的情况下就被合并。
审查时间可能会因我们志愿者的可用性而异。
为了加快进程，您可以查看[审查指南](pr-review.html)并确保您的 PR 遵守它们。
如果您想明确请求审查，请在 Zulip 的 [PR reviews](https://leanprover.zulipchat.com/#narrow/channel/144837-PR-reviews/) 信息流中创建一个主题。

如果维护者批准了您的 PR，一个 **"ready-to-merge"** 标签会自动应用于该 PR。
一个名为 `bors` 的机器人将从此接手。（有关 bors 的更多详情，请参见[此处](https://github.com/leanprover-community/mathlib/blob/master/docs/contribute/bors.md)。）
该 PR 将被添加到[“合并队列”](https://mathlib-bors-ca18eefec4cb.herokuapp.com/repositories/16)中。
合并队列是自动处理的，但这需要一定的有限时间，因为它需要构建 mathlib 的分支。

在某些情况下，维护者会“委托” (delegate) 该 PR。您会看到您的 PR 现在有了一个 **"delegated"** 标签。这要么意味着有一些最终的更改被请求，但维护者相信您能完成这些更改并亲自将 PR 发送给 bors，要么是维护者想在 PR 被合并前给您最后一次检查的机会。无论哪种情况，当您准备好时，编写一条包含 “bors merge” 行的评论将使该 PR 被合并。

以下是一些其他常用的标签：

- 一个 **"WIP"**（= work in progress，正在进行中）的 PR 在被审查前还需要一些基础性工作（例如，可能还包含 `sorry`）。如果您想宣布您正在进行某项工作并期望很快完成，可以发布一个 WIP。

- 一个 **"RFC"**（= request for comment，征求意见）的 PR 是关于一个可能有争议或需要专家决定是否继续进行的更改。

- 如果您不确定 CI 是否会成功，可以添加 **"awaiting-CI"**。这会暂时在主审查队列中隐藏该 PR。当 CI 完成时，该标签会自动移除。

- 考虑添加 **"help wanted"** 标签以直接征集贡献。

- **"blocked-by-other-PR"** 标签意味着某些特定的其他 PR 应该在此 PR 被处理前得到解决。要为您的 PR 添加 "blocked-by-other-PR" 标签，请在 PR 评论中包含依赖的 PR 编号（遵循那里评论中隐藏的示例），以便他人可以一目了然地知道哪些 PR 应该被优先审查。该标签将由一个机器人自动添加，并在其他 PR 被合并后自动移除。带有此标签的 PR 不会出现在审查队列中。

- **easy** 标签应用于标记那些可以立即被批准的 PR。维护者和审查者通常会先看 easy PRs 以保持队列流动。Easy PRs 通常添加一个引理，修正文档中的拼写错误或类似情况。如果您对您的 PR 是否微不足道有任何疑问，您不应该添加此标签。特别是，如果 diff 超过 25 行，添加了任何定义或新文件，或者添加了任何与现有 `simp` 引理或实例没有直接类比的 `simp` 引理或实例，那么一个 PR 通常就**不**是 easy 的。

- **delegated** 标签意味着维护者已发出 "bors delegate"（或 "bors d+"）命令。PR 的作者现在应该在任何最终请求的更改都已做出并且 CI 成功后，自己合并该 PR。他们可以使用 "bors merge" 来做到这一点。

### 处理合并冲突

由于多个人并行地在 mathlib 上工作，有人可能在 `master` 上引入了一项与您在 PR 上提议的更改相冲突的更改。如果您的 PR 发生了这种情况，一个机器人会自动添加 **"merge-conflict"** 标签，并且您的 PR 将不会出现在审查队列中。请查看[这个 GitHub 教程](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/addressing-merge-conflicts/resolving-a-merge-conflict-on-github)关于如何使用他们的在线工具解决合并冲突。
一旦冲突解决，**"merge-conflict"** 标签将自动被移除，您的 PR 将返回审查队列。