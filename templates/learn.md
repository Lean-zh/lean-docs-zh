# 学习 Lean 4

根据您的背景和偏好，有许多方法可以开始学习 Lean。这些方法都很有趣且有益，但也都很困难，并且偶尔会令人沮丧。证明助手 (Proof assistants) 仍然难以使用，您不能指望学一个下午就能变得精通。

本页所列的所有资源都与 Lean 4 相关。有些资源有 Lean 3 版本，但在现阶段学习 Lean 3 已经没有意义。

## 实践方法

* 无论您的背景如何，如果您想直接上手，可以玩[自然数游戏 (Natural Number Game)](https://adam.math.hhu.de/#/g/hhu-adam/NNG4)。这是一个在线交互式 Lean 教程，专注于证明自然数上基本运算的性质。
  [Lean Game Server](https://adam.math.hhu.de/#/) 上托管了各种学习游戏，包括集合论、逻辑和 Robo（一个关于本科数学的故事）。

* 如果想要更快地入门，您可以获取 [Glimpse of Lean 教程](https://github.com/PatrickMassot/GlimpseOfLean)。
  它包含四个基础文件，涵盖了使用 Lean 进行证明的一些基本方面，然后是关于初等分析、抽象拓扑和数理逻辑的独立主题文件。

* 您可以下载 [tactic 备忘单 (pdf)](https://leanprover-community.github.io/papers/lean-tactics.pdf) 作为最常用 tactic 的参考。

* 如果您希望直接从源码学习，[Lean API 文档](https://leanprover-community.github.io/mathlib4_docs/)不仅包括 `Mathlib`，还涵盖了 `Std`、`Batteries`、`Lake` 和核心编译器。
  由于 Lean 的很多部分都是通过语法扩展 (syntax extensions) 定义的，这是现有最接近综合参考手册的资料。

## 书籍

如果您更喜欢阅读书籍（带练习），有许多免费的 Lean 书籍已被证明对初学者很有用。
这些书籍以 html 或 PDF 格式提供，但通常旨在通过 VSCode 进行交互式阅读，以便随时进行 Lean 练习：

* 面向数学的标准参考是 [Mathematics in Lean](https://leanprover-community.github.io/mathematics_in_lean/)。
  您可以[下载其 pdf 版本](https://leanprover-community.github.io/mathematics_in_lean/mathematics_in_lean.pdf)，但也请参阅 [VSCode 使用说明](https://leanprover-community.github.io/mathematics_in_lean/C01_Introduction.html#getting-started))。

* [The Mechanics of Proof](https://hrmacbeth.github.io/math2001/) 也面向数学。
  它比 *Mathematics in Lean* 的节奏更温和，面向数学经验较少的读者。

* 如果您更喜欢关于类型理论基础的内容，标准参考是 [Theorem Proving in Lean](https://lean-lang.org/theorem_proving_in_lean4/)。

* 一本面向计算机科学/编程的书是 [The Hitchhiker's Guide to Logical Verification](https://raw.githubusercontent.com/blanchette/logical_verification_2023/main/hitchhikers_guide.pdf)。
  它还包含有关 Lean 类型理论的有用信息，并附有一个带练习的 VSCode 项目。

如果您想更多地关注 Lean 本身而不是如何使用 Lean，那么您可以阅读[参考手册 (reference manual)](https://lean-lang.org/doc/reference/latest/) ([旧版手册](https://lean-lang.org/lean4/doc/))。

## 元编程 (Meta-programming) 与 tactic 编写

* 如果您对作为一种编程语言的 Lean 感兴趣，那么您应该阅读 [Functional programming in Lean](https://lean-lang.org/functional_programming_in_lean/)。

* 如果您特别想进行元编程和编写 tactic，那么可以阅读 [Metaprogramming in Lean 4](https://github.com/arthurpaulino/lean4-metaprogramming-book)（至少在确认您对 Functional programming in Lean 的 monad 章节感到舒适之后）。

## 更多关于基础理论

如果您对 Lean 的基础理论感兴趣，可以先阅读[这里](https://leanprover-community.github.io/lean-perfectoid-spaces/type_theory.html)的一份非常粗略的概述。
如果您想了解更多细节，可以阅读 [HoTT book](https://homotopytypetheory.org/book/) 的第一章，忽略任何提到单价性 (univalence) 的地方。

如果您对 Lean 内核的内部机制、编写自己的 Lean 外部类型检查器或导出证明感兴趣，您可以在 [Type Checking in Lean 4](https://ammkrn.github.io/type_checking_in_lean4/) 中阅读更多内容。

另一个可能有用的资源是 Coq 文档中的[这个页面](https://coq.github.io/doc/master/refman/language/cic.html)。Coq 的基础理论与 Lean 的非常接近。需要记住的最相关的区别是：
* Lean 的 `Prop` 是证明无关的 (proof-irrelevant)，所以它更接近于上述页面中的 `SProp`。
* Lean 中的全集 (Universes) 是*非*累积的 (non-cumulative)。然而，任何类型都可以被提升到更高的全集中。
* Lean 原生支持商类型 (quotient types) 及其相关的归约规则（参见 *Theorem proving in Lean* 的[此节](https://lean-lang.org/theorem_proving_in_lean4/axioms_and_computation.html#quotients)）。

如果您能读懂上述 Coq 文档，那么您就可以阅读 Mario Carneiro 的[这篇论文](https://github.com/digama0/lean-type-theory/releases)，该论文精确地描述了 Lean 的类型理论。

请注意，理解类型理论基础对于使用 Lean 来说完全不是必需的。

## 会议

许多会议帮助欢迎新人加入 Lean 社区。
以下链接包含可能感兴趣的在线讲座和其他材料。
请注意，直到 2022 年的所有项目都使用 Lean 3，但它们仍可能包含相关信息。
* [Lean for the Curious Mathematician 2023](https://lftcm2023.github.io/tutorial/index.html)
* [Formalization of mathematics 2023](https://www.msri.org/summer_schools/1021)
* [Lean for the Curious Mathematician 2022](https://icerm.brown.edu/topical_workshops/tw-22-lean/)
* [Lean for the Curious Mathematician 2020](https://leanprover-community.github.io/lftcm2020/)

更多活动可以在[活动](events.html)页面上找到。
我们还有一个 [YouTube 频道](https://www.youtube.com/channel/UCWe5B7Ikr0AI9727doEUxPg/playlists)，其中包含上述会议的视频播放列表，以及其他包含 Lean 相关内容的会议视频。