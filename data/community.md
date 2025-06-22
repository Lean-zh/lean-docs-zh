# 认识社区

Lean 社区相当多元化。我们有很多来自数学领域的用户，一些来自计算机科学，还有少数来自物理等其他领域。大多数用户是学生或学者，但也有一些在业界工作的数据科学家和软件工程师。

一些由社区成员组成的[团队](teams.html)负有指定的职责。

下面的地图可以帮助你找到地理位置上离你近的社区成员。

<div id="userMap"></div>

如果你想将自己添加到上面的地图中，可以在你的 Zulip 个人资料中设置 `latitude` 和 `longitude` 字段；你可以通过在地图上右键单击来找到你的坐标。地图将在 24 小时内，即网站下一次构建时更新。我们建议你提供工作或学习所在主要建筑的坐标，而不是你的居住地。

## Lean Zulip 聊天

我们社区的主要聚集地是一个[Zulip 聊天实例](https://leanprover.zulipchat.com)。你无需注册即可浏览最热门“频道”上的公开讨论。

我们欢迎你注册 Zulip 聊天，这样你就可以参与讨论。我们强烈建议你使用真实姓名作为显示名称。我们也很欢迎你在[**新成员**频道](https://leanprover.zulipchat.com/#narrow/stream/113489-new-members)中简短地介绍自己。

我们欢迎来自任何专业水平的用户提问。在新成员频道提出你的第一个问题，可以确保得到的回答不会假设你对 Lean 有很多了解。但我们也欢迎你使用更专业的频道。请开启新的讨论话题，而不是在不相关的话题下提问。如果你需要代码方面的帮助，可能会被要求提供一个“最小工作示例”([MWE](mwe.html))。同时也要注意 [XY 问题 (XY problems)](https://mywiki.wooledge.org/XyProblem)：尽量提供足够的上下文。

要发布内联代码片段，请用单反引号将其括起来：`` `my code here` ``。如果你的代码本身包含反引号，请用比其所含数量更多的反引号将其括起来：``` `` my`code`contains`backticks `` ```。

较长的代码片段应放在两行都包含三个反引号的行之间，如下所示：
````md
```
def n : myNat := 5
#check n
```
````

你可以使用 `$$` 来包裹内联 LaTeX，并使用
````md
```math
my LaTeX code here
```
````

用于显示块级数学公式。

## GitHub

继 Zulip 之后，下一个聚集点是 GitHub，它托管了所有的[社区代码仓库](https://github.com/leanprover-community)。特别是，[mathlib 的拉取请求 (pull requests)](https://github.com/leanprover-community/mathlib4/pulls)页面是查看我们正在进行的工作的好地方。你也可以在我们的[博客](/blog/)上阅读最近的工作。

贡献的方式有很多：开发新的数学理论，为现有理论添加和编写文档，开发支持性软件工具，以及审查他人提出的贡献。如果你想为我们的项目做贡献，可以阅读我们的[贡献指南](contribute/index.html)。

## 社区准则

我们致力于发展一个开放和包容的社区，欢迎每个人的参与。任何形式的冒犯、歧视或攻击性行为都将不被容忍。我们采用[贡献者契约行为准则 (Contributor Covenant Code of Conduct)](https://www.contributor-covenant.org/version/2/0/code_of_conduct/)。这些准则适用于 [Lean Zulip 聊天](https://leanprover.zulipchat.com/)和 [leanprover-community GitHub 组织](https://github.com/leanprover-community/)。

为澄清上述内容：可能导致被 Lean 社区 Zulip 暂停或封禁的行为包括骚扰、歧视或不尊重行为、持续发布离题或破坏性帖子、重复发布低质量内容、利用社区完成课程作业或工作任务、使用马甲账户 (sock-puppet accounts)、大量使用人工智能 (AI) 而不注明来源、私信垃圾信息 (DM spam) 以及无视版主指导。此列表并非详尽无遗，维护者在用户管理方面保留广泛的自由裁量权。

重复违规将导致临时封禁，如果行为持续，封禁时长将会增加。恶劣的个别事件将导致永久封禁。

[行为准则团队](/teams/coc.html)是报告任何疑虑的第一联系点。我们还提供一个[匿名表格](https://docs.google.com/forms/d/e/1FAIpQLSdEjlFqJQV65F-yzRHl-lyWAt7TSUW1axPiQK3RyV67iu1h6Q/viewform)来举报违反社区准则的事件。

我们鼓励在出现不受欢迎的行为时采取降级处理策略。如果你发现有人违反了我们的行为准则，请不要以同样的方式回应；相反，应采取行动纠正该行为，例如向版主报告。