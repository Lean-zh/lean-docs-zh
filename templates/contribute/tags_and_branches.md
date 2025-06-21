# Lean 的 Github 生态系统

本文档介绍了与向 Lean、Std 和 Mathlib 提交拉取请求相关的分支、标签和 CI (持续集成) 工作流。

* [你需要知道的事情](#things-you-need-to-know) 与每个人都相关
* [标签与分支](#tags-and-branches) 仅适用于正在 Lean 中进行或修复破坏性变更 (breaking changes) 的“专家”，或者想要了解 Mathlib CI 内部工作原理的人。

## 你需要知道的事情

* 如果你正在向 `leanprover/lean4` 提交一个可能涉及破坏性变更的拉取请求，请将你的 PR 变基 (rebase) 到 `nightly-with-mathlib` 分支上。这将启用与 Mathlib 的组合 CI。

* 如果你正在向 `leanprover-community/mathlib4` 提交一个拉取请求，请通过 [Zulip 聊天室](https://leanprover.zulipchat.com/#narrow/stream/287929-mathlib4/topic/github.20permission) 申请该仓库的“写入”权限，并将你的分支推送到该仓库。这将使 Mathlib 的 `.olean` 缓存能够包含你的拉取请求。

## 标签与分支

### `leanprover/lean4`

* 开发在 `master` 分支上进行。
* 稳定版本 (Stable releases) 和发布候选版本 (release candidates) 都有标签，例如 `v4.2.0` 或 `v4.3.0-rc1`。
  * 要在项目中使用这些版本之一，你的 `lean-toolchain` 文件应包含例如 `leanprover/lean4:v4.2.0`。
* 稳定版本在每个月底发布，与最后一个发布候选版本完全相同。
* 下一个版本的第一个发布候选版本在稳定版本发布后立即发布。
* 每个版本都有一个 `releases/v4.X.0` 特性分支，其中可能包含：
  * 用于发布说明的额外提交
  * 从 `master` 分支拣选 (cherry-picked) 的用于关键修复的提交，并通过发布候选版本发布。
* 我们会从 `master` 分支定期制作一个夜间构建版本 (nightly release)，它在 `leanprover/lean4-nightly` 仓库中有一个标签，例如 `nightly-2023-11-01`。
  * 要在项目中使用夜间构建版本，你的 `lean-toolchain` 文件应包含例如 `leanprover/lean4:nightly-2023-11-01`。（请注意，它不应该是 `leanprover/lean4-nightly:nightly-2023-11-01`，因为 `elan` 在此处应用了一些特殊逻辑。）
* 在 `leanprover/lean4` 上有一个 `nightly` 分支，它跟踪用于构建夜间构建版本的最新提交。
* 每个 PR 在成功构建后都会自动获得一个工具链。该 PR 随后将被标记为 `toolchain-available`。要在项目中使用 PR #NNNN，你的 `lean-toolchain` 文件应包含 `leanprover/lean4-pr-releases:pr-release-NNNN`。
* 对于任何可能影响 Std 或 Mathlib 的 PR，你应将你的 PR 基于 `nightly-with-mathlib` 分支的 HEAD。在这种情况下，系统会创建一个 `lean-pr-testing-NNNN` Mathlib 分支（下文详述），并且来自此分支的结果会通过评论报告在 PR 讨论中。

### `leanprover/std4` (又名 'Std')

* 开发在 `main` 分支上进行。
* Std 在其 `lean-toolchain` 中使用最新的稳定版本或发布候选版本。
  * 因为我们在发布 `v4.X.0` 后立即发布 `v4.X+1.0-rc1`，所以 Std 停留在稳定版本上的时间非常短暂。
* `main` 分支上第一个使用新工具链的提交会被打上该工具链版本号的标签（例如 `v4.2.0`）。
* 有一个 `stable` 分支，它跟踪 `v4.X.0` 标签。
* Std 有一个 `bump/v4.X.0` 分支，用于适配即将发布的 Lean 稳定版本，
  * 其中包含了为适配经维护者批准的破坏性变更所做的修改
  * 并且将使用一个 `leanprover-lean4:nightly-YYYY-MM-DD` 工具链。
* Std 有一个 `nightly-testing` 分支，它
  * 使用最近的夜间构建版本（自动更新）
  * 所有来自 `main` 的提交都会自动合并到此分支
  * 任何来自 `bump/v4.X.0` 的变更可以手动合并到此分支
  * 可能包含任何其他提交，包括未经审查的提交，以保持 `nightly-testing` 分支能够在新近的夜间构建版本上正常工作。
* `nightly-testing` 分支上的 CI 失败会由一个机器人报告到 Zulip 的私有 "Mathlib reviewers" 频道。
* `nightly-testing` 分支上的 CI 成功会导致创建一个 `nightly-testing-YYYY-MM-DD` 标签来匹配该提交，如果此标签尚不存在。
  * 因此，如果 `nightly-testing-YYYY-MM-DD` 存在，我们知道在该提交上：
    * `lean-toolchain` 是 `leanprover/lean4:nightly-YYYY-MM-DD`，并且
    * CI 成功。
* 当需要修改 Std 以适配 Lean 中的破坏性变更时，你需要创建一个分支，并稍后从该分支开启一个 PR。（注意，以下步骤在 Mathlib 中是自动的，但对于 Std 需要手动完成。）
  * 如果变更是于 `leanprover/lean4#NNNN` 中进行的，那么 Std 的适配分支应命名为 `lean-pr-testing-NNNN`。
  * Std 适配分支应基于标签 `nightly-testing-YYYY-MM-DD`，其中 `YYYY-MM-DD` 是你的 Lean PR 所基于的夜间构建版本的日期。
  * 如果 `nightly-testing-YYYY-MM-DD` 标签尚不存在，你将需要等待（并可能迁移到后续的夜间构建版本）。如需帮助，请联系 @semorrison。
  * 理想情况下，你应将 `lean-pr-testing-NNNN` 分支推送到 Std 的主仓库；如果需要，我们可以提供写入权限。
  * 此分支上的 `lean-toolchain` 必须包含 `leanprover/lean4-pr-releases:pr-release-NNNN`。
  * 你可以从 `lean-pr-testing-NNNN` 分支开启一个 PR，无论是在进行必要的适配之前还是之后。
  * 开启 PR 时，请记得将基底分支设置为 `nightly-testing`。
  * 请为该 PR 贴上 `v4.X.0` 和 'depends on core changes' 标签。（或者，如果你没有写入权限，可以请求他人代劳。）
  * 一旦 Lean PR 被合并并发布在夜间构建版本中，Std 的适配 PR
    * 应将其 `lean-toolchain` 更新为 `leanprover/lean4:nightly-YYYY-MM-DD`
    * 其变更可根据需要手动合并到 `nightly-testing` 以保持 `nightly-testing` 的正常工作（不要更改基底分支并合并该 PR，我们仍然需要它）。
  * 一旦 Std 适配 PR 被批准，维护者会将其合并到 `bump/v4.X.0`（而不是 `nightly-testing-YYYY-MM-DD`）。
* 总是允许将 `bump/v4.X.0` 合并到 `nightly-testing`，但反之则不行。（`bump/v4.X.0` 的变更已经过审查，但 `nightly-testing` 的变更可能没有。）
* 当需要将 Std 更新到新的 Lean 版本时，*理想情况下*，所需要做的就是创建一个新的 PR，内容为将 `bump/v4.X.0` 压合性合并 (squash merging) 到 `main`。

### `leanprover-community/mathlib4` (又名 'Mathlib')

* 上述关于 Std 的所有内容都适用于 Mathlib，除了：
  * 开发在 `master` 分支上进行。
  * 所有对 Mathlib 的 PR 都应从 Mathlib 仓库自身的分支创建。
    * 这是 Mathlib 的 `.olean` 缓存机制所要求的。
    * 请在 [Zulip 聊天室](https://leanprover.zulipchat.com/#narrow/stream/287929-mathlib4/topic/github.20permission) 上请求 Mathlib 的“写入”权限。请写一句话介绍你的背景和计划。
* `nightly-testing-*` 标签和 `bump/v4*` 分支是写保护的，因此只能通过 PR、维护者或相关机器人进行修改。
* 请注意，Mathlib 的 `nightly-testing` 分支可以根据需要使用 Std 的 `nightly-testing` 分支。
* 类似地，Mathlib 的 `bump/v4.X.0` 分支可以根据需要使用 Std 的 `bump/v4.X.0` 分支。
* 对于任何通过 CI 并且基于夜间构建版本的 Lean PR，系统都会自动创建 `lean-pr-testing-NNNN` 分支。（这与 Std 不同，Std 的这些分支必须手动创建。）
* 如果 Std 也经历了破坏，那么 `lean-pr-testing-NNNN` 分支上的 Mathlib 适配 PR 可能需要更改 Std 依赖，以使用 Std 的 `lean-pr-testing-NNNN` 分支。

### Mathlib 的夜间构建分支和 bump 分支

每个月都会有一次新的 Lean 发布，Mathlib 的目标是尽快迁移到新的 Lean 版本。为了使这个过程尽可能平滑，我们遵循以下流程：

* Mathlib 的 `nightly-testing` 分支使用 Lean 的夜间构建工具链版本。换句话说，该分支上的 `lean-toolchain` 文件包含类似 `leanprover/lean4:nightly-2024-09-26` 的内容。
  - 不保证此分支能够无错误地构建。
  - 对此分支的更改未经 Mathlib 维护团队审查。
  - 此分支不受保护：任何人都可以向其推送修复。
  - 此分支的目的是使 Mathlib 适配 Lean 夜间构建工具链版本的变更。
  - 通常，一个对 Lean 核心的 PR `#NNNN` 会伴随着在 `lean-pr-testing-NNNN` 分支中对 Mathlib 的适配。一旦 Lean 核心的 PR 进入了夜间构建工具链，Mathlib 的 `lean-pr-testing-NNNN` 分支就可以被合并到 `nightly-testing` 中。通常需要解决 `lean-toolchain`、`lakefile.lean` 和/或 `lake-manifest.json` 中的合并冲突。
  - 如果此分支上的 CI 失败，它会向 Zulip 上的 ["nightly-testing > Mathlib status updates"](https://leanprover.zulipchat.com/#narrow/stream/428973-nightly-testing/topic/Mathlib.20status.20updates) 发送一条消息，指出失败情况。
  - 如果此分支上的 CI 通过，则会向同一主题发送一条消息，表明成功，并给出创建 PR 以审查适配修改的说明。（见下文。）
* Mathlib 的 `bump/v4.X.Y` 分支也使用 Lean 的夜间构建工具链版本。
  - 此分支应始终能无错误地构建。
  - 对此分支的更改由 Mathlib 维护团队审查。
  - 此分支受保护：只有 Mathlib 维护者和某些机器人可以向其推送。
  - 此分支的目的是准备一个 Mathlib `master` 分支的并行版本，该版本基于即将发布的 Lean 版本构建。一旦该版本发布，`bump/v4.X.Y` 分支就会被合并到 `master` 中。这次合并基本上是原子的，因为其差异 (diff) 已经通过所有每日的适配 PR 审查过了。（见下文。）
* 当 `nightly-testing` 通过 CI 时，一个机器人会向 Zulip 发帖，并附上创建“适配 PR”以将 `nightly-testing` 上的更改合并到 `bump/v4.X.Y` 的说明。
  - 这个 PR 可以使用 Zulip 消息中指明的 `scripts/create-adaptation-pr.sh` 来准备。
  - 这个 PR 应由 Mathlib 维护团队审查。
* 在 Lean 发布周期（即一个月）的过程中，`bump/v4.X.Y` 会累积对未来 Lean 版本的适配。
  - 但 `master` 分支也会累积数千行的变更。
  - 因此，应定期将 `master` 合并到 `bump/v4.X.Y` 中。
  - 在撰写本文时，此步骤已合并到 `scripts/create-adaptation-pr.sh` 流程中。
  - 偶尔会发生合并冲突。这些冲突应当由 Mathlib 维护团队审查，尽管目前尚未做到。

### Lean 与 Mathlib 之间的组合 CI

* 对于每一个向 Lean 提交的 PR，我们都会尝试针对其生成的工具链运行 Mathlib CI。
* 为使此机制生效，你需要将你的 PR 变基 (rebase) 到 `nightly-with-mathlib` 分支。`nightly-with-mathlib` 分支指向通过了 Mathlib CI 的最新 Lean 夜间构建版本，并且在 Mathlib（也可能在 Std）上存在对应的 `nightly-testing-YYYY-MM-DD` 标签。
* 机器人会在 Mathlib 中从 `nightly-testing-YYYY-MM-DD` 标签创建一个 `lean-pr-testing-NNNN` 分支，如果该分支已存在，则向其推送一个空提交。
* 来自该 Mathlib 分支的后续 CI 结果将以评论的形式报告回 Lean PR。
* 如果你的 PR 不是从一个能成功构建 Mathlib 的夜间构建版本分支出来的，一个机器人会在你的 PR 上留言。每当你向你的 PR 推送提交时，它都会重试。
* 如果 `nightly-with-mathlib` 对你的需求来说太旧了，你可以基于 `nightly` 分支，一旦该夜间构建版本本身通过了 Mathlib CI 并且你向 PR 推送了提交，Mathlib CI 就会开始运行。
* 有可能那个夜间构建版本永远无法通过 Mathlib CI。在这种情况下，你可能需要等待 `nightly-with-mathlib` 更新，然后变基到更新后的分支上。

<img src="img/tags_and_branches.png" alt="Mathlib/Std 的分支概览" width="80%"/>