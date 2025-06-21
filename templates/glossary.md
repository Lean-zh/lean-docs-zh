<div class="alert alert-info">
<p>
我们目前正在更新 Lean 社区网站，以介绍 Lean 4 的使用方法，但您今天在这里找到的大部分信息仍然是关于 Lean 3 的。
</p>
<p>
我们非常欢迎为本页面提供 Lean 4 更新的拉取请求。页面底部有一个链接。
</p>
<p>
请访问 <a href="https://leanprover.zulipchat.com">leanprover zulip</a>，并在此过渡期间寻求您需要的任何帮助！
</p>
<p>
Lean 3 的网站已被<a href="https://leanprover-community.github.io/lean3/">归档</a>。如果您需要链接到 Lean 3 的特定资源，请链接到那里。
</p>
</div>

# Lean 术语表

本文档收集了在 Lean 社区中可能遇到的术语的简短解释。

虽然下面的许多条目都有精确的技术定义，但我们更倾向于解释它们在日常交流中的用法，并链接了额外的参考资料以供进一步了解。

下面的一些内部链接指向尚未添加的条目，因此在它们完成之前，这些链接不会导向条目定义。
要请求在此术语表中添加新条目，请随时[提交一个 issue](https://github.com/leanprover-community/leanprover-community.github.io/issues/new?title=Add%20a%20glossary%20entry%20for%20)。

此页面上的条目可以通过锚点链接进行链接（例如 `https://leanprover-community.github.io/glossary.html#widget`）。
对于某些条目，还有一些更易于输入的附加锚点，可以在条目标题之前找到——例如，[`#heavy-rfl`](#heavy-rfl) 将导向 “heavy `rfl` / heavy `refl`” 条目。
如果条目标题很长、包含反引号或难以输入，新术语条目的作者应考虑添加这些附加锚点。

### attribute (属性)

一个或多个可以应用于 Lean [声明 (declaration)](#declaration) 的标签或标记，它们可能会影响该声明的行为或其他与之交互的 Lean 对象的行为。
属性可以在 [core Lean](#core-lean)、[mathlib](#mathlib) 或任何 Lean 代码中定义。

应用属性的方法是在声明命令前加上 `@[name-of-attribute]`，或者之后使用 `attribute` 命令，如 `attribute [name-of-attribute] name-of-declaration`。

例如，`@[simp]` 属性将一个声明（通常是 `lemma`、`theorem` 或 `def`）标记为 [simp 引理 (simp lemma)](#simp-lemma)。

##### 另请参阅

* [mathlib 属性文档](https://leanprover-community.github.io/mathlib_docs/attributes.html)，列出了在 [mathlib](#mathlib) 中定义和使用的属性

* [*The Lean Reference Manual* 的 5.4 节](https://lean-lang.org/reference/other_commands.html#attributes)，列出了在 [core lean](#core-lean) 中定义的属性

### beta reduction (beta 归约)

在 [依赖类型理论 (dependent type theory)](#dependent-type-theory)（以及 Lean 的实现）中的一种特定简化操作，可作为判断两个 [项 (term)](#term) 是否 [定义性相等 (definitionally equal)](#defeq) 的一部分来执行。

更准确地说，它是将 `(λ x, t) a` 这样的表达式简化为 `t[a/x]` 的过程，其中 `t` 中出现的变量 `x` 已被替换为 `a`。

##### 另请参阅

* [Theorem Proving in Lean 的 2.3 节](https://lean-lang.org/theorem_proving_in_lean/dependent_type_theory.html#function-abstraction-and-evaluation)

### big operators

[mathlib](#mathlib) 的[代数库](https://leanprover-community.github.io/mathlib_docs/algebra/big_operators/basic.html)中的一个 [locale](#locale)，通过 `open_locale big_operators` 启用。

它使用 `∑` 和 `∏` 字符定义了有限和与积的表示法。

### binder (绑定符)

形如 `(a : α)`、`[a : α]` 或 `{a : α}` 的表达式，其中 `a` 是任意标识符，`α` 是类型。作为各种 Lean 语法元素（[声明](#declaration)、`fun`、量词等）的一部分，它们代表将在语法元素或声明主体内绑定的标识符。

每种类型的绑定符对于它是将被隐式绑定（调用者不传递）、显式绑定还是通过[类型类推断 (typeclass inference)](#typeclass-inference) 绑定，有着不同的含义。

在某些地方，特别是在 `def` 中，允许定义不带括号的“简单”绑定符，例如绑定符 `a`（无显式类型）。

### bundled vs unbundled (捆绑式与非捆绑式)

给定一个具有属性 `P` 的数学对象 `O`，捆绑 `P` 指的是创建一个 Lean [结构体 (structure)](#structure)，该结构体除了定义 `O` 所需的字段外，还包含一个 `P` 的证明作为其字段之一。

相反，非捆绑式结构体仅包含 `O` 的定义，并另外创建一个可应用于 `O` 的项的 `is_P` 命题。

举一个具体的例子，一个[群同态 (group homomorphism)](https://en.wikipedia.org/wiki/Group_homomorphism) 可以看作是群之间的一个映射 `φ: G → H`，以及一个证明 `h : φ(a * b) = φ(a) * φ(b)`。
一个捆绑式的群同态将同时包含 `φ` 和 `h` 作为字段，而非捆绑式的则只包含 `φ`，并有一个单独的 `is_group_homomorphism` [声明](#declaration) 用于证明 `h`。

出于性能、风格或实现相关的原因，可能会偏好捆绑或非捆绑，也存在一些灰色地带，即部分捆绑结构体的某些部分，而保留其他部分为非捆绑。
[mathlib](#mathlib) 中的[类型类 (type classes)](#class) 主要是半捆绑的，通常只将[载体 (carrier)](#carrier) 类型本身非捆绑。
mathlib 中的态射（morphism）更常是完全捆绑的，尽管两种方法的痕迹都存在，并在下面的资源中进行了讨论。

##### 另请参阅

* [The Lean Mathematical Library](https://arxiv.org/pdf/1910.09336.pdf) (PDF) 的 4.1.1 节 (Bundled Type Classes) 和 4.1.2 节 (Bundled Morphisms)，这篇由 mathlib 社区撰写的论文描述了 [mathlib](#mathlib) 的许多架构和设计选择。

### cache (缓存)

通常指每次提交推送到 [mathlib](#mathlib) 仓库时，由其[持续集成 (continuous integration)](#continuous-integration) 构建的一组共享的预构建 [`olean` 文件](#olean-file)。

其目的是为了避免每个 [mathlib](#mathlib) 用户在本地构建（或重新构建）相同的 Lean 文件，因为这可能需要大量时间（在一台中等配置的计算机上需要数小时）。

缓存是在上述的持续集成中构建的，通常 mathlib 用户使用 [`leanproject`](#leanproject) 来获取其构建文件。

### `calc` 模式

一个由涉及 `trans` [属性](#attribute) 标记的传递关系（如 `=`、`<` 等）表达式的连续变换序列组成的[模式 (mode)](#mode)。
它通过 `calc` 关键字进入。

##### 另请参阅

* [ `calc` 模式社区文档](https://leanprover-community.github.io/extras/calc.html)

### carrier (载体)

对于一个将类型 `T` 与一些表示为附加字段的额外数学结构[捆绑](#bundled-vs-unbundled)在一起的 Lean [结构体](#structure)（例如 [`Group`](https://leanprover-community.github.io/mathlib_docs/algebra/category/Group/basic.html#Group)），它是指底层元素的类型 `T`。

对于一个将集合 `S` 与一些表示为附加字段的额外属性[捆绑](#bundled-vs-unbundled)在一起的 Lean [结构体](#structure)（例如 [`subgroup`](https://leanprover-community.github.io/mathlib_docs/group_theory/subgroup/basic.html#subgroup)），它是指底层集合 `S`。

### class (类)

更完整地说是 *typeclass* (或 *type class*)，即类型类。

一种 Lean [结构体](#structure)，其[实例 (instance)](#instance) 可以通过[类型类推断](#typeclass-inference)来检索。

这与面向对象语言中的 *class* 用法不同——函数式编程语言中的这个词源于 [Haskell 的类型类](https://en.wikipedia.org/wiki/Type_class)。

### code linter (代码 linter)

**代码 linter** 是一种 [linter](#lint)，它试图在 [mathlib](#mathlib) 的 Lean 代码中寻找无意的错误。
具体来说，mathlib 包含[一组 Lean 程序](https://leanprover-community.github.io/mathlib4_docs/Std/Tactic/Lint/Frontend.html)，用于检查新 mathlib 代码中可能引入的各种潜在问题。
有时会引入新的 linter 来检测其他类型的错误。
Mathlib 的[持续集成](#continuous-integration)确保任何此类新代码都通过了定义的 linter。
可以通过使用 `nolint` [属性](#attribute)来为特定代码禁用 linting。
一些早于 CI 代码 linter 的 linter 失败记录在一个自动生成的 [nolint 文件](https://github.com/leanprover-community/mathlib4/blob/master/scripts/nolints.json)中；随着这些错误的修复，该文件的长度应随时间趋于零。

### `conv` 模式

[tactic 模式](#tactic-mode)的一个子模式，它有助于在假设或[目标 (goal)](#goal) 内导航，以便重写或简化其中的目标部分。
它通过 `conv` 关键字从 tactic 模式进入。

##### 另请参阅

* [ `conv` 模式社区文档](https://leanprover-community.github.io/extras/conv.html)

### core Lean

与 [mathlib](#mathlib) 或其他社区编写的 Lean 代码相区别，core Lean（或“核心库”）指的是随 Lean 发行版本身提供的 Lean 部分。

历史上，mathlib 项目本身也是 core Lean 的一部分，后来为了加快开发速度，被分离成一个独立维护的项目。

即使在分离之后，一些基础的[声明](#declarations)仍然是 core Lean 的一部分。
有时，如果与新开发的 mathlib 代码冲突，一些引理和定义仍会从核心社区 Lean 3 仓库中移除或迁移到 mathlib 中。

当前 core Lean 3 的部分可以在 [Lean 3 社区仓库](https://github.com/leanprover-community/lean/tree/master/library)中找到，而 Lean 4 的部分则在[类似的位置](https://github.com/leanprover/lean4/tree/master/src)。

### declaration (声明)

Lean 环境中单个的 Lean 运行时对象。

或者，不明确地指，任何可能定义或声明此类对象的 Lean 命令。

这类命令的例子有 `def`、`theorem`、`constant` 或 `example` 命令（在 Lean 3 中还有 `lemma` 命令）等。

更多细节可以在 [Lean 文档](https://lean-lang.org/lean4/doc/declarations.html#basic-declarations)中找到。

### dependent type theory (依赖类型理论)

一种[类型理论 (type theory)](#type-theory)，其中你还可以有依赖于参数的类型，例如“日历月份的天数”类型，其具体值取决于特定的月份，因为不同月份有不同的天数。
更多例子可以在下面的资源中找到。
Lean 对依赖类型理论的实现基于所谓的*构造演算 (Calculus of Constructions)*，使其既可用于复杂的数学推理，也可用于软件验证。

##### 另请参阅

* [Theorem Proving in Lean 的第 2 节](https://lean-lang.org/theorem_proving_in_lean/dependent_type_theory.html)，其中讨论了 Lean 的特定版本的依赖类型理论

* [维基百科的构造演算](https://en.wikipedia.org/wiki/Calculus_of_constructions)，提供了对构造演算的进一步概述

* [nLab 的依赖类型理论](https://ncatlab.org/nlab/show/dependent+type+theory)，对依赖类型理论的一般性处理

* [Mike Shulman 的《赞美依赖类型》](https://golem.ph.utexas.edu/category/2010/03/in_praise_of_dependent_types.html)

* [Andrej Bauer 对“是什么让依赖类型理论比集合论更适合证明助手？”的回答](https://mathoverflow.net/a/376973)

### diamond (菱形问题)

在类型类[实例 (instance)](#instance)图中发现的某个[类 (class)](#class)存在多个冲突的[项 (term)](#term)。
菱形问题很可能在[类型类推断 (typeclass inference)](#typeclass-inference) 期间引起问题，因为类型类推断试图构造该类的单个项，因此可能无法做到。
当不加限定时，“菱形问题”通常指这种不受欢迎的情况，其中菱形中非 [`defeq`](#defeq) 的项可能会导致错误，产生无法通过 `refl` 证明的[目标 (goal)](#goal)，或者可能根本无法证明相等。
在 [mathlib](#mathlib) 中，由于其众多的[层级 (hierarchies)](#hierarchy)，菱形问题很常见。
修复或缓解菱形问题通常涉及重构问题类的字段或实例优先级。
跨库边界的菱形问题——例如，类型类图的一部分位于 mathlib 中，而另一部分位于依赖于 mathlib 并添加了新实例或类的库中——可能特别难以修复或避免，除非进行修改。

##### 另请参阅

* [mathlib 关于 `AddMonoid` 和 `Monoid` 的设计说明](https://leanprover-community.github.io/mathlib4_docs/Mathlib/Algebra/Group/Defs.html#Design-note-on-AddMonoid-and-Monoid)，这是一个规避菱形问题的具体例子

* [遗忘继承 (Forgetful Inheritance)](https://leanprover-community.github.io/mathlib_docs/notes.html#forgetful%20inheritance)，同样来自 mathlib 文档，讨论了在类型上存在“更丰富”和更贫乏结构的情况下避免菱形问题的一般模式。

<a name="dot-notation"></a>

### dot notation / generalized field notation / generalized projections (点表示法 / 广义字段表示法 / 广义投影)

允许像 `((foo a b c).bar x.y).baz` 这样表示法的语法糖。

Lean 对语法 `foo.bar` 提供了两种解释：它可以表示 `foo` 命名空间中的声明 `bar`，也可以是广义字段表示法。我们在此详细解释后者。

假设 `foo` 的类型为 `C x1 ... xn`，其中 `C` 是某个常量，`x1 ... xn` 是任意的，并且上下文中有一个名为 `C.bar` 的声明，它接受一个类型为 `C x1 ... xn` 的参数。那么 `foo.bar` 是 `C.bar foo` 的语法糖。对于形如 `foo.bar _ ... _` 的调用，其中带有（隐式或显式）参数，Lean 足够智能，可以展开为 `C.bar _ ... foo _ ... _`，以确保所有类型都匹配。在这些例子中，`foo` 也可以是一个更复杂的表达式，例如 `(foo bar baz).quux` 中的函数应用。

### `equiv`

与数学上的相等性不同，[`equiv`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/Logic/Equiv/Defs.html) 允许定义类型的等价或全等关系。
需要注意的一个重要事项是，一个 `equiv` [持有数据，而不仅仅是一个证明](#bundled-vs-unbundled)。

### goal (目标)

在 Lean 中交互式证明定理的上下文中，指每个正在进行证明的目标陈述。

或者更广泛地说，从类型理论的角度看，指需要展示一个[项 (term)](#term) 的单个类型。
对于命题，展示一个[项](#term)等价于前述的证明概念。

### golfing (“打高尔夫”)

一种使某段可工作的代码尽可能短的尝试或努力；在 Lean 的上下文中，通常是缩短或优化证明的长度。
“打高尔夫”的证明通常使用 [term 模式 (term mode)](#term-mode)，并且通常优先考虑简洁性而非可读性。
这种模糊化通常被有意或有利地用来向读者表明一个证明是机械的或琐碎的。

<a name="heavy-rfl"></a>

### heavy `rfl` / heavy `refl`

指当 Lean 对 `rfl`（或 `refl`）进行求值时执行缓慢的用法。
当要求 `rfl` 一次性执行许多步骤的定义性归约时，就会出现 heavy `rfl`，这会产生一个虽然很小但需要 Lean 进行大量计算以确保其类型检查通过的证明项。

[这个 Zulip 讨论](https://leanprover.zulipchat.com/#narrow/stream/113488-general/topic/refl.20taking.2020.20seconds) 中有一个特别慢的例子。

### hierarchy (层级)

在一个相关的数学领域内，一系列逐渐受到更多约束的[类型类 (typeclasses)](#class) 的集合。
在 [mathlib](#mathlib) 中，我们有**代数层级** (`semiring`, `ring`, `field`, ...)，**序层级** (`preorder`, `partial_order`, `linear_order`, ...)，**拓扑层级** (`t1_space`, `t2_space`, `normal_space`, ...)，**范畴层级** (`preadditive`, `abelian`, `monoidal`, ...)，还有**标量层级** (`mul_action`, `distrib_mul_action`, `module`, ...)，**范数层级**，以及前面这些层级的交集，如**序-代数层级**、**拓扑-代数层级**等。

### HoTT

**同伦类型论 (Homotopy Type Theory)**，一种[类型理论 (type theory)](#type-theory)，其特点是包含一个额外的**单价公理 (univalence axiom)**，该公理精确地阐述了这样一个概念：两种被认为是等价的类型的不同实现，在数学意义上也是相等的。

在 Lean 2 中，[core Lean](#core-lean) 本身就原生支持一个并行的[基于同伦类型论的库](https://github.com/leanprover/lean2/blob/8072fdf9a0b31abb9d43ab894d7a858639e20ed7/hott/hott.md)。

Lean 3 的[内核 (kernel)](#kernel) 引入了单例消除 (singleton elimination)，这与 HoTT 的单价公理不一致。
因此，core Lean 3 不再附带 HoTT 库。Lean 4 也不附带。
Gabriel Ebner 和其他贡献者在[一个外部项目](https://github.com/gebner/hott3)中为 Lean 3 制作了 Lean 2 HoTT 库的部分移植。

举一个具体的例子，自然数类型有许多[定义](https://en.wikipedia.org/wiki/Natural_number#Formal_definitions)，这些定义可以被看作是构造等价的数学对象。
Core Lean 有一个它们的[类皮亚诺实现](https://leanprover-community.github.io/mathlib_docs/init/core.html#nat)，而 [mathlib](#mathlib) 还有一个额外的[基于二进制表示的实现](https://leanprover-community.github.io/mathlib_docs/data/num/basic.html#pos_num)，并证明了它们是等价的。
鉴于 Lean **没有**单价公理，这两种类型是等价的，但它们作为类型并不能被证明是**相等**的。
一个基于 HoTT 的语言（或库）会另外称这些类型为相等。

<a name="intervals"></a>

### `Icc`, `Ico`, `Ioc`, `Ioo`, `Ici`, `Ioi`, `Iic`, `Iio`

[mathlib](#mathlib) 中用于指代 8 种数学区间的简写。
共有 `8` 种区间，取决于区间的每一端是*c*losed（闭）、*o*pen（开）还是延伸到*i*nfinity（无穷）。
通过将每个区间命名为 `I` + 左端结束方式 + 右端结束方式，使得名称变得紧凑。
`Iii`，在命名约定中将指两端都为无穷的区间，目前尚未使用。

##### 另请参阅

* [mathlib 的 `data.set.intervals.unordered_interval`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/Data/Set/Intervals/UnorderedInterval.html)，它在这些区间之上构建了无序区间（其中端点可以按任意顺序指定）。

### infoview (信息视图)

在交互式编辑 Lean 文件的上下文中，一个显示增量的[目标 (goal)](#goal) 状态、诊断信息、错误和 Lean [小部件 (widgets)](#widget) 输出的窗口或界面。

### instance (实例)

两个密切相关的概念之一：

* 一个由 `def`、`lemma` 或其他[声明](#declaration)所接受的[类 (class)](#class) 参数，它被方括号（`[]`）括起来，以便在声明被使用时由[类型类推断](#typeclass-inference)系统解析。
* 一个用同名的 `instance` 命令创建的[声明](#declaration)，或者等效地，一个被 `instance` [属性](#attributes)标记的声明，这两种方式都将该声明注册到类型类推断系统中以供上述使用。
作为一个具体的例子，[mathlib](#mathlib) 为 `ℝ` 定义了一个 `linear_order` 的实例，从而使得实数可以用 `<` 进行比较。

### kernel (内核)

在 Lean 的实现（以及更广泛的[证明助手 (proof assistants)](https://en.wikipedia.org/wiki/Proof_assistant#System_comparison)）的上下文中，内核是验证每个证明正确性的核心组件。

Lean 的内核实现相对于 Lean 的 [tactic](#tactic) 实现代码[1^]，或者当然是相对于 [mathlib](#mathlib) 的大小来说，是相对较小的，这使得人们可以更有信心地认为证明没有错误，而不依赖于庞大或复杂的高级构造。

[1^]: 这种相对的小巧，以及因此带来的独立可验证性，被称为证明助手实现的 *de Bruijn 准则 (de Bruijn criterion)*。

##### 另请参阅

* [Lean 4 的内核实现](https://github.com/leanprover/lean4/tree/master/src/kernel)

* [Lean 3 的内核实现](https://github.com/leanprover-community/lean/tree/master/src/kernel)

* [Henk Barendregt 和 Freek Wiedijk 的《计算机数学的挑战》（2005）](https://royalsocietypublishing.org/doi/full/10.1098/rsta.2005.1650)

* [Andrej Bauer 对“是什么让依赖类型理论比集合论更适合证明助手？”的回答中的“证明助手的组成部分”](https://mathoverflow.net/a/376973)

### Lean Together

一个为 Lean 用户社区、其 [mathlib](#mathlib) 库用户以及更广泛的定理证明器社区举办的[年度会议](https://leanprover-community.github.io/lt2021/)。

往届活动的演讲或报告已在[社区 YouTube 频道](https://www.youtube.com/channel/UCWe5B7Ikr0AI9727doEUxPg)上分享。

### lint

*linter* 是一个寻找代码中难以发现的错误的小程序。
[mathlib](#mathlib) 定义了[样式 linter (style linters)](#style-linter) 和[代码 linter (code linters)](#code-linter)。
当提交拉取请求时，Mathlib 会在每次[CI 运行](#continuous-integration)时进行 linting。

### mathlib

一个为 Lean 4 打造的[大型、社区维护的数学集合](https://github.com/leanprover-community/mathlib4)。

### mathlib3

一个已弃用的 Lean 3 数学库。

### mathport

一个用于将 Lean 3 代码自动或半自动翻译为 Lean 4 代码的[工具](https://github.com/leanprover/mathport/)。
它包括从 Lean 3 源文件全自动生成 Lean 4 [olean 文件](#olean-file)（*binport*），以及尽力将 Lean 3 源代码翻译为 Lean 4 源代码（*synport*）。
从 mathport 工作以及 [mathlib4](#mathlib4) 中获得的经验常常导致对 mathlib 的反向移植更改，以使 Lean 3 代码进入更具未来兼容性的状态。

### mode (模式)

在编写 Lean 代码的上下文中，一组相关的语法元素或关键字，它们使得某种特定风格的形式化推理或[证明项 (proof terms)](#proof-term) 的构建变得高效。
Lean，特别是限制在 [mathlib](#mathlib) 中时，有少数几种这样的模式——[tactic 模式 (tactic-mode)](#tactic-mode)、[term 模式 (term-mode)](#term-mode)、[calc 模式 (calc-mode)](#calc-mode) 和 [conv 模式 (conv-mode)](#conv-mode)。
特定的模式可能使解决特定类型的[目标 (goal)](#goal) 变得更容易。
然而，一个证明通常可以在构造[证明项](#proof-term)的过程中混合使用各种模式。

### module (模块)

包含 Lean 源代码的单个文件。

不要与数学中的 `module`（即向量空间的推广）相混淆。

### module docstring (模块文档字符串)

[模块](#module)级别的注释，总结了文件中可以找到的内容。
我们要求每个文件都有一个，但[一些旧文件](https://github.com/leanprover-community/mathlib4/blob/master/scripts/style-exceptions.txt)仍然没有。

### MWE

*Minimal Working Example (最小工作示例)*，一种通过将 Lean 代码片段简化为其基本部分，同时仍能被他人运行，从而更容易获得帮助的方法。

更多信息可以在 [MWE 页面](mwe.html)上找到。

### non-terminal `simp` (非终止 `simp`)

对 `simp` tactic 的一次调用，它既不是在特定[子目标](#goal)上调用的最后一个 tactic，也没有使用 `simp only` 来明确限制它考虑的 [simp 引理](#simp-lemma)。
应避免使用非终止的 `simp`，因为它们难以维护，因为随着 mathlib 随时间增加或修改 `simp` 引理集合，它们的行为或运行时间会发生变化。

##### 另请参阅

`simp` 文档的 ["non-terminal `simp`" 部分](https://leanprover-community.github.io/extras/simp.html#non-terminal-codesimpcodes)

### olean file (olean 文件)

由 Lean 在构建 Lean [模块](#module)时产生的缓存的、已编译的二进制文件。
`olean` 文件与构建它们的特定 Lean 版本相关联，并且它们的文件名与它们对应的模块相匹配（因此名为 `foo.lean` 的文件将有对应的 `foo.olean` 文件）。
构建 `olean` 文件可以手动完成（例如，通过 `lean --make foo.lean`），但对于像 [mathlib](#mathlib) 这样的协作项目，它们是通过 [CI](#continuous-integration) 作为共享的 [olean 缓存](#cache)构建的，然后每个 mathlib 用户可以简单地检索它们。

### orange bar of hell (地狱橙条)

在 VSCode（或其他编辑器）中交互式编辑 Lean 通常响应相当迅速。

然而，**地狱橙条**指的是偶尔出现在 Lean 文件侧边栏的橙色条不消失或不更新的情况。
通常这些条表示 Lean 仍在评估文件的哪些部分，但如果这些条持续存在，则表明没有取得进展。
通常可以通过关闭任何不活动的编辑器选项卡，然后打开 VSCode 命令面板（`ctrl-shift-p` 或 `cmd-shift-p`）并运行 `Lean: Restart` 来解决这些问题。
出现这种情况的另一个常见原因是，由于[缓存](#cache)的 [olean 文件](#olean-file)集合不匹配，Lean 不得不（重新）编译所有导入的 [mathlib](#mathlib) 文件。
在这些情况下，确保通过 `leanpkg configure && leanproject get-mathlib-cache` 正确下载 mathlib 缓存应该可以解决问题。

### propeq

**Propositional equality (命题相等性)**。两个[项 (term)](#term) `a b : α` 是命题相等的，如果我们能证明 `a = b`。
这比[定义性相等](#defeq)和[语法相等](#syntactical-equality)要弱。

##### 另请参阅

[Xena Project 的《相等性、规范和实现》](https://xenaproject.wordpress.com/2020/07/03/equality-specifications-and-implementations/)

### `simp` lemma (simp 引理)

一个被标记了[属性](#attribute)的引理，使其能与 `simp` tactic 一同使用。

好的 `simp` 引理引导 `simp` tactic 将复杂表达式简化为更简单的表达式，通常能达到 `simp` tactic 本身就能解决许多目标的程度。

更多细节可以在 [mathlib 的 `simp` 文档](https://leanprover-community.github.io/extras/simp.html#simp-lemmas)中找到。

### `simp`-normal form (`simp`-范式)

[mathlib](#mathlib) 内部的一种约定，用于以单一的常规形式表达具有多种等价形式的命题。

例子和更多细节可以在 [`simp` 页面](simp.html#simp-normal-form)上找到。

### style linter (样式 linter)

*样式 linter* 是一种 [linter](#lint)，它试图确保 [mathlib](#mathlib) 中代码的统一外观或风格，而不影响其工作行为。
具体来说，mathlib 包含[一个简短的 Python 程序](https://github.com/leanprover-community/mathlib4/blob/master/scripts/lint-style.py)，该程序检查例如行长是否小于 100 个字符，每个文件是否都有[模块文档字符串](#module-docstring)等。
Mathlib 的[持续集成](#continuous-integration)确保新代码通过定义的 linter。
允许的样式 linting 异常存储在仓库内的[样式异常文件](https://github.com/leanprover-community/mathlib4/blob/master/scripts/style-exceptions.txt)中。

### tactic mode (tactic 模式)

一种 Lean [模式 (mode)](#mode)，其特点是依赖于一系列的 [tactic](#tactic)，这些 tactic 通常能促成与纸笔推理非常相似的证明，尽管常常使用复杂的 tactic 来自动化证明中繁琐的部分。
有多种方法可以[进入 tactic 模式](https://lean-lang.org/theorem_proving_in_lean/tactics.html#entering-tactic-mode)。
它可以从 [term 模式](#term-mode)通过 `by` 关键字进入，尽管在 Lean 3 中，当其主体由多个命令组成时，最常见的是通过 `begin...end` 代码块进入。
其他模式也可以穿插其中，通常是为了协作产生一个易于理解、高效、简短或可读的整体证明。
最终，一个 tactic 模式块的结果是一个[项 (term)](#term)，由其内部的 tactic 组装而成。

##### 另请参阅

* [Theorem Proving in Lean 的第 5 节](https://lean-lang.org/theorem_proving_in_lean/tactics.html)，其中讨论了 tactic，以及进入和退出 tactic 模式

* [`show_term` tactic](https://leanprover-community.github.io/mathlib_docs/tactic/show_term.html)，可以揭示组装好的[项](#term)

* [mathlib tactic 文档](https://leanprover-community.github.io/mathlib_docs/tactics.html)，包含 tactic 的全面列表

### term mode (term 模式)

一种 Lean [模式 (mode)](#mode)，通过使用函数式子表达式来组装单个[项 (term)](#term)。
与 [tactic 模式](#tactic-mode)相比，term 模式的证明通常长度较短，但对人类来说可能更难阅读。
有多种方法可以进入 term 模式。
[声明](#declaration)的主体以 term 模式开始，或者在 [tactic 模式](#tactic-mode)中，通常使用 `exact` [tactic](#tactic) 进入。
高效的 term 模式证明通常有助于[代码“打高尔夫”](#golfing)。

诸如 `have`、`suffices` 和 `show` 之类的命令可用于编写比裸证明项更易读的结构化 term 模式证明。

### TPIL

“Theorem Proving in Lean”，由 Jeremy Avigad、Leonardo de Moura 和 Soonho Kong 编写的免费在线教科书，旨在“教您在 Lean 中开发和验证证明”。
该书从对 Lean 中使用的[类型理论](https://lean-lang.org/theorem_proving_in_lean/dependent_type_theory.html)的简单介绍开始，接着解释了诸如 [tactic](https://lean-lang.org/theorem_proving_in_lean/tactics.html)、[归纳类型](https://lean-lang.org/theorem_proving_in_lean/inductive_types.html)和[类型类](https://lean-lang.org/theorem_proving_in_lean/type_classes.html)等主题。

### type theory (类型理论)

一个具有两种基本对象——[项 (term)](#term) 和类型——的形式系统。
它也可能指研究这类语言的领域，因为特定类型理论可能包含的各种附加属性或特性之间存在细微差别。

Lean 的[依赖](#dependent-type-theory)类型理论是其数学基础系统，与集合论相对。
在集合论的基础上，所有对象在形式上都是由一种单一的基本对象——集合——构建的。人们推理构造出的集合是否是其他集合的成员。
这种成员关系的概念可以对任何两个形式集合提出，这可能使一些陈述在形式上有意义，即使它们对人类来说在数学上是无意义的——比如问数字 2 是否是数字 37 的成员（其中数字是[集合论定义的](https://en.wikipedia.org/wiki/Set-theoretic_definition_of_natural_numbers)）。
相比之下，在类型理论中，每个项都有一个关联的类型，陈述或命题本身也是如此。
例如，我们有自然数类型（在 [mathlib](#mathlib) 中是 `ℕ`），或命题类型（`Prop`），或 `2 + 2 = 4` 的*证明*的类型，或从 `ℕ` 到 `Prop` 的函数类型（`ℕ → Prop`），并且可以构造这些类型的项——比如分别是项 `2`、`2 + 2 = 37`、`rfl` 和 `λ n, true`。
然而，并非每个项都*是*一个类型，因此与前述的集合论困难相反，如果这样做没有意义，人们就不能构造询问 37 是否是*类型* 2 的陈述。

### unicode abbreviation (Unicode 缩写)

在编辑 Lean 文件的上下文中，缩写是一种使用描述性快捷方式输入通常在标准键盘布局上找不到的符号的方法。

例如，不等号“≠”可以使用序列 `\neq` 输入。

完整的缩写列表（及其替换）可以在 [`vscode-lean4` 仓库](https://github.com/leanprover/vscode-lean4/blob/master/vscode-lean4/src/abbreviation/abbreviations.json)中找到。

### whnf

一个 Lean 表达式如果满足下面链接资源中提到的若干规范化标准，则处于*弱头范式 (weak head normal form)*，通常缩写为 `whnf`。
不严谨地说，处于 whnf 的表达式其最外层部分已被求值，但内部子表达式可能尚未被求值。

它也可能指将表达式归约为这种形式的命令。

##### 另请参阅

* [Programming in Lean 的 8.4 节](https://lean-lang.org/programming_in_lean/#08_Writing_Tactics.html)，该节仍在撰写中，但将涵盖 `whnf`
* [什么是弱头范式？ - Stack Overflow](https://stackoverflow.com/questions/6872898/what-is-weak-head-normal-form)
* [弱头范式 - Haskell 维基](https://wiki.haskell.org/Weak_head_normal_form)

### widget (小部件)

一个可扩展的框架，用于通过 Lean 代码定义交互式的、组件化的图形元素，这些元素在交互式定理证明期间呈现在[信息视图 (infoview)](#infoview)中。

小部件也可能指由上述框架呈现的单个图形元素。

小部件提供了一种机制，用于显示在交互式定理证明过程中更新的附加上下文或信息。

Lean 3 和 Lean 4 都支持此功能，尽管开箱即用的功能有所不同。

##### 另请参阅

* [Lean Together 2021: Widgets, interactive output in VSCode](https://www.youtube.com/watch?v=8NUBQEZYuis)，这是 Edward Ayers 在 [Lean Together 2021](#lean-together) 上的一个演示，展示了小部件所能实现的一些功能
* [The Lean 3 Widget Server Protocol](https://github.com/leanprover-community/lean/blob/master/doc/widget_server.md)，一份旨在提供更适合学习小部件实现细节的底层协议信息的文档