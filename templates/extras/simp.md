# Simp

## 概览

在本文档中，我们将解释化简策略 (simplifier tactic) [`simp`](https://leanprover-community.github.io/mathlib4_docs/Init/Tactics.html#Lean.Parser.Tactic.simp) 及其相关策略 [`dsimp`](https://leanprover-community.github.io/mathlib4_docs/Init/Tactics.html#Lean.Parser.Tactic.dsimp) 在 Lean 4 中的基本用法。

我们为如何避免“非终结性 `simp`”提供了一些指导，并简要描述了 `simp` 和 `dsimp` 的配置选项。

## 简介

Lean 有一个名为 `simp` 的“化简器”，它会查阅一个名为 **`simp` 引理** (`simp` lemmas) 的事实数据库，以（有望）简化假设和目标。该化简器是一个所谓的**条件项重写系统 (conditional term rewriting system)**：它所做的就是对于所有形如 `A = B` 或 `A ↔ B` 的适用事实，重复地将形如 `A` 的子项替换（或**重写**）为 `B`。
化简器会不停地重写，直到无法再进行重写为止。所有的 `simp` 引理都是有向的，左侧总是被右侧替换，反之则不然。

理想情况下，这个事实数据库能将表达式化简为一个范式 (normal form)。
在实践中，这通常是无法实现的（范式可能不存在，或者不存在能产生它们的重写规则集合），
但我们仍尽可能地接近这一理想。
更理想的是，我们希望这个事实数据库是**汇合的 (confluent)**，
这意味着化简器考虑重写的顺序无关紧要。
同样，我们力求在可能的情况下接近汇合性。

虽然这个系统能够完全自动地证明许多简单的陈述，但证明所有简单的陈述并不在其职责范围内，尽管这可能令人失望。

下面是一个例子（使用了 `mathlib`）。

```lean
import Mathlib.Algebra.Group.Defs

variable (G : Type) [Group G] (a b c : G)

example : a * a⁻¹ * 1 * b = b * c * c⁻¹ := by
  simp
```

人类会如何解决这个目标？他们会注意到 `a * a⁻¹ = 1`，然后 `1 * 1 = 1`，以此类推，直到他们将例子简化为 `b = b`，这显然是真的。

这也是化简器正在做的事情。事实上，如果你在示例上方添加 `set_option trace.Meta.Tactic.simp.rewrite true`，那么在 `simp` 下方会出现一条蓝色波浪下划线（在 VS Code 中），点击它会显示 `simp` 执行的重写序列：
```
[Meta.Tactic.simp.rewrite] @mul_right_inv:1000, a * a⁻¹ ==> 1

[Meta.Tactic.simp.rewrite] @mul_one:1000, 1 * 1 ==> 1

[Meta.Tactic.simp.rewrite] @one_mul:1000, 1 * b ==> b

[Meta.Tactic.simp.rewrite] @mul_inv_cancel_right:1000, b * c * c⁻¹ ==> b

[Meta.Tactic.simp.rewrite] @eq_self:1000, b = b ==> True
```
`simp?` 策略是提取 `simp` 所应用引理列表的一个有效方法。
它会建议
```lean
simp only [mul_right_inv, mul_one, one_mul, mul_inv_cancel_right]
```
这是一个 `simp` 的调用，它使用了这四个特定的引理。

要查看化简过程中成功和失败的重写，你可以使用更详细的选项 `set_option trace.Meta.Tactic.simp true`。

## Simp 引理

那么 Lean 的化简器是如何知道 `a * a⁻¹ = 1` 的呢？这是因为在 `Mathlib.Algebra.Group.Defs` 中有一个引理被标记了 `simp` 属性：

```lean
@[simp] lemma mul_right_inv (a : G) : a * a⁻¹ = 1 := ...
```

我们称带有 `simp` 属性的引理为“`simp` 引理”。以下是 mathlib 中 `simp` 引理的一些更多例子：

```lean
@[simp] theorem Nat.dvd_one {n : ℕ} : n ∣ 1 ↔ n = 1 := ...
@[simp] theorem mul_eq_zero {a b : ℕ} : a * b = 0 ↔ a = 0 ∨ b = 0 := ...
@[simp] theorem List.mem_singleton {a b : α} : a ∈ [b] ↔ a = b := ...
@[simp] theorem Set.setOf_false {a : α | False} = ∅ := ...
```

当化简器试图化简一个项 `T` 时，它会遍历当时系统已知的 `simp` 引理，如果遇到一个适用的形如 `A = B` 或 `A ↔ B` 的引理，其中 `A` 作为 `T` 的一个子表达式出现，它就会用 `B` 重写 `T` 中 `A` 的实例，然后从头开始。注意 `simp` 从最内层的项开始，向外工作：它会先化简函数的参数，然后再化简函数本身。此外，`simp` 具有一定的智能，能够避免每次都考虑*所有*的 `simp` 引理（目前在 `mathlib` 中有一万多个！）。

化简器只在一个方向上应用 `simp` 引理：如果 `A = B` 是一个 `simp` 引理，那么 `simp` 会用 `B` 替换 `A`，但不会用 `A` 替换 `B`。因此，一个 `simp` 引理应该具有其右侧比左侧更简单的特性。在这种情况下，`=` 和 `↔` 不应被视为对称运算符。以下将是一个糟糕的 `simp` 引理（如果它被允许的话）：

```lean
@[simp] lemma mul_right_inv_bad (a : G) : 1 = a * a⁻¹ := ...
```

将 `1` 替换为 `a * a⁻¹` 并不是一个明智的默认方向。更糟糕的是一个导致表达式无限增长的引理，这会导致 `simp` 无限循环：

```lean
@[simp] lemma even_worse_lemma: (1 : G) = 1 * 1⁻¹ := ...
```

在创建一个新定义时，通常也会引入 `simp` 引理，以将涉及该定义的表达式转换成一种合理的形式。一个例子是 mathlib 的 [Data.Complex.Basic](https://github.com/leanprover-community/mathlib4/blob/master/Mathlib/Data/Complex/Basic.lean)，它有将近 100 个 `simp` 引理。尽管它们根据定义就是真的，但诸如下面的定理
```lean
@[simp] lemma add_re (z w : ℂ) : (z + w).re = z.re + w.re := rfl
```
被引入，是因为它们赋予了 `simp` 化简表达式并利用已有事实的能力。
例如，这个引理将复数加法转换为实数加法。如果你允许 `simp` 使用实数加法的交换律，那么它就能够通过 `z.re + w.re = w.re + z.re` 自动证明 `(z + w).re = (w + z).re`，这是复数加法是交换性证明的一半。

Lean 内核本身是一个用于 lambda 演算的重写系统，它有一个明确的前进概念。考虑到这一点，一个有用的 `simp` 引理家族是那些在这个意义上让 `simp` 部分求值表达式的引理。例如，如果你有一个结构体类型 `foo` 并定义了一个该类型的结构体 `myFoo`，
```lean
structure Foo where n : ℕ

def myFoo : Foo where n := 37
```
那么如果你添加一个 `simp` 引理 `myFoo.n = 37`，你就赋予了化简器为 `myFoo` 求值 `Foo.n` 投影的能力，这使你无需展开 `myFoo` 的定义（默认情况下，`simp` 不会展开大多数定义）。创建这些 `simp` 引理非常普遍，以至于有一个[属性](https://leanprover-community.github.io/mathlib4_docs/Mathlib/Tactic/Simps/Basic.html#simpsAttr)可以为你自动创建它们：
```lean
@[simps] def myFoo : Foo where n := 37
```
这会生成引理 `@[simp] lemma myFoo_n : myFoo.n = 37`。

## 基本用法

*   `simp` 尝试使用当时 Lean 已知的所有 `simp` 引理来简化目标。

*   `simp [h1, h2]` 使用所有 `simp` 引理以及 `h1` 和 `h2`（它们可以是局部假设或其他因故未被标记为 `simp` 的引理）。

*   `simp [← h]` 使用所有 `simp` 引理，以及 `h : A = B`，但形式为 `B = A`（所以 `simp` 会将 `B` 重写为 `A`）。

*   `simp [-thm]` 阻止 `simp` 使用名为 `thm` 的 `simp` 引理。

*   `simp [*]` 使用所有 `simp` 引理以及所有当前的局部假设来尝试简化目标。

*   `simp at h` 尝试使用所有 `simp` 引理来简化 `h`。

*   `simp [h1] at h2 ⊢` 尝试使用 `h1` 和所有 `simp` 引理来简化 `h2` 和目标（注意：在 VS Code 中输入 `⊢` 使用 `\|-` 或 `\vdash`）。

*   `simp [*] at *`：尝试使用所有假设和所有 `simp` 引理来简化目标和所有假设。有时值得一试。

*   `simp only [h1, h2, ..., hn]` 告诉 `simp` 只使用引理 `h1`, `h2`, ...，而不是完整的 `simp` 引理集。
    （在证明中间使用 `simp only [...]` 是可以接受的，因为后续对 `simp` 集的更改不会破坏证明。）

*   `simp [↓h1]` 在进入子项之前使用 `h1`。通常，`simp` 在进入子项之后使用引理。

*   `simp [↑h1]` 在进入子项之后使用 `h1`。此语法用于标记为 `simp↓` 的引理。

请注意，某些 `simp` 引理有必须满足的额外假设。
例如，一个关于在等式两边消去一个因子的定理，只有在该因子非零的假设下才有效。如果 `h` 是假设 `P` 的一个证明，并且 `P → A = B` 是一个 `simp` 引理，那么 `simp [h]` 将在目标中用 `B` 替换 `A`。`simp` 会考虑额外假设这一事实，正是它被称为**条件**项重写系统的原因。

## Simp 范式

有时有多种方式来表达同一件事。例如，如果 `n : ℕ`，那么假设 `n ≠ 0`、`0 ≠ n`、`n > 0`、`0 < n`、`1 ≤ n` 和 `n ≥ 1` 在逻辑上都是等价的。这对于像化简器这样的重写系统来说可能会有问题。原因在于化简器使用**语法相等 (syntactic equality)**s来查找子项。如果化简器正在处理一个项 `T`，并且 `A = B` 是一个 `simp` 引理，那么，除非 `T` 的某个子项 `A'` 在语法上与 `A` 相同（大致上：它们的文本表示完全相同），否则 `simp` 通常不会注意到该规则适用，因此它不会被 `B` 重写。类似地，如果 `n` 的非零性（以一种方式陈述）是形如 `A = B` 的 `simp` 引理中的一个前置条件，而 `h` 是 `n` 的非零性（以另一种方式陈述）的一个证明，那么 `simp [h]` 可能不会用 `B` 替换 `A`。

在 `mathlib` 中处理这个问题的方法是，为表达某事物的方式一次性地固定一个*`simp` 范式*（`simp` normal form）（比如用 `0 < n` 表示非零性），然后在 Lean 中陈述引理时坚持使用这个变体。这样就省去了为每个变体编写重复引理的麻烦。为了帮助化简器，很多时候会有一些规范化引理，其唯一目的就是将表达式置于 `simp` 范式。

总的来说，如果你在编写一个引理，你应该知道表达该引理中思想的“范式”方式。如果你在编写一个关于你自己所做定义的引理，思考一下那些可以用多种方式表达的思想的范式。

`simp` 范式的一个例子是表达类型子集非空的方式。如果 `α : Type` 且 `s : Set α`，那么 `s` 的非空性可以表示为 `s.Nonempty` 和 `s ≠ ∅`。在 mathlib 中，我们努力坚持使用 `s.Nonempty` 作为范式。

另一个例子：每个有限集 `s : Finset α` 都可以被强制转换为 `Set α`，所以对于 `a : α`，`a ∈ s` 和 `a ∈ (s : Set α)` 都可以表示相同的意思。有限集成员关系的 `simp` 范式是 `a ∈ s`，此外还有一个规范化的 `simp` 引理
```lean
@[simp] lemma mem_coe {a : α} {s : Finset α} : a ∈ (s : Set α) ↔ a ∈ s := ...
```
用于将 `a ∈ (s : Set α)` 的出现替换为正确的范式。

因为化简器是从内到外工作的，先化简函数的参数再化简函数本身，所以一个 `simp` 引理在其左侧的函数参数应该处于 `simp` 范式。例如，如果 `g 0` 可以被化简，那么 `@[simp] lemma foo : f (g 0) = 0` 将永远不会被使用。
Batteries 的 `simpNF` [代码检查器 (linter)](https://leanprover-community.github.io/mathlib4_docs/Batteries/Tactic/Lint/Frontend.html) 会检查这一点（你可以通过在文件末尾放置 `#lint` 来自己运行 mathlib 对某个模块的 linter）。

## `simpa`

`simpa` 策略是 `simp` 的一个变体，用于完成一个证明——作为一个“终结策略”，如果它无法关闭目标，它就会失败。基本用法是
```lean
simpa [h1, h2] using e
```
其中 `[h1, h2]` 指的是一个可选的 `simp` 引理列表（使用与 `simp` 相同的语法），而 `e` 是一个表达式。通常，`e` 是一个假设的名称。`e` 的类型和目标都会被化简，如果它们都被化简为相同的东西，`simpa` 就会成功。

这里有一个 `simpa` 的简单例子：
```lean
example (n : ℕ) (h : n + 1 - 1 ≠ 0) : n + 1 ≠ 1 := by
  simpa using h
```
没有 `simpa`，我们可能会这样做 `simp at ⊢ h; exact h`。所谓的“非终结性 `simp`”，即那些不关闭目标的 `simp` 用法，最好避免（见下一节），而 `simpa` 是避免它们的一种方法。

如果没有 `using` 子句，`simpa` 会转而执行以下三个步骤：

1.  目标被化简。
2.  如果局部上下文中有一个名为 `this` 的假设，那么它的类型会被化简。
3.  应用 `assumption` 策略。

第 2 步是为了支持 `simpa` 跟在 `have : P` 或 `suffices : P` 之后的模式，因为这两者默认使用 `this` 作为它们引入的假设的名称。

## 非终结性 `simp`

随着 `simp` 引理被添加到库中（或从库中移除），`simp` 的行为会随时间而改变。这意味着使用 `simp` 的证明可能会被破坏，而且，除非你知道 `simp` 引理集是如何变化的，否则修复证明可能会很困难。

例如，如果一个证明看起来像
```lean
  ...
  simp
  rw [foo_eq_bar]
  ...
```
然后后来有人给 `foo_eq_bar` 添加了 `@[simp]` 属性，这个重写现在就会失败。

虽然在初始开发期间在证明中间使用 `simp`（“非终结性 `simp`”）是可以的，但经验法则是，当每个 `simp` 都完全关闭一个目标时，Lean 代码更容易维护。当这样的 `simp` 后来被破坏时，这能确保预期的目标是已知的。

有一些在证明中间使用 `simp` 的“被认可的”用法：

1) `simp only [h1, h2, ..., hn]` 来限制 `simp` 只使用给定列表中的引理，这样它就不会受到 `simp` 引理集变化的影响。提示：使用 `simp?` 来自动生成一个合适的 `simp only`。

2) 使用像 `have h : P := by ...; simp` 这样的构造来引入一个由 `simp` 证明的假设。`have` 表达式可能在证明的中间，但 `simp` 关闭了它引入的目标。

3) 如果 `simp` 把你的目标变成了 `P`，那么你可以写
```lean
  suffices : P by simpa
```
这会在当前目标之后添加一个新目标 `P`，引入一个新的假设 `this : P`，简化目标和 `this`，然后尝试用 `this` 关闭目标。`simpa` 策略**要求**一个目标被关闭，这与 `simp` 不同，这使得更容易知道它何时被破坏。源代码中显式的 `P` 有助于找到修复方法。

非终结性 `simp` 出现的一种方式是在像 `simp at ⊢ h; exact h` 这样的策略序列中。这些可以被替换为 `simpa using h`。

## `dsimp`

`dsimp` 是 `simp` 的一个变体，它只使用“定义性” `simp` 引理。这些是其证明为 `rfl` 或 `Iff.rfl` 的 `simp` 引理，也就是说，是两边根据定义相等的引理。

和 `simp` 一样，建议你不要在证明的中间使用它。然而，如果 `dsimp` 把你的目标变成了 `h`，那么 `change h` 很可能会做同样的事情。`dsimp` 的另一个常见用法是
```lean
dsimp only
```
这是 `dsimp only []` 的简写，即一个带有空 `simp` 引理集的 `dsimp`。这可以安全地在证明中间使用，并且是整理目标的一个有用方法：除其他外，它对 lambda 表达式进行 beta 归约（它会将 `(fun x => f x) 37` 变为 `f 37`）并且会归约结构体投影（它会将 `{ toFun := f, ... }.toFun` 变为 `f`）。

## 更高级的功能

### 条件解决器 (Discharger)

Lean 有以下定理：

```lean
theorem Nat.max_eq_left {a b : ℕ} (h : b ≤ a) : max a b = a
```

然而，`simp` 仅凭这个定理无法证明以下目标。

```lean
example : max (1 : ℕ) 0 = 1 := by
  simp only [Nat.max_eq_left]
-- simp made no progress
```

这是因为 `simp` 未能解决旁路条件 (side condition) `(0 : ℕ) ≤ 1`；这可以通过命令 `set_option trace.Meta.Tactic.simp.discharge true` 看到。

```lean
[Meta.Tactic.simp.discharge] @Nat.max_eq_left discharge ❌
      0 ≤ 1
```

这个旁路条件可以简单地用 `decide` 解决：

```lean
example : (0 : ℕ) ≤ 1 := by
  decide
```

如何在 `simp` 中使用这个策略来解决旁路条件呢？答案如下：

```lean
example : max (1 : ℕ) 0 = 1 := by
  simp (disch := decide) only [Nat.max_eq_left]
```


### 完整语法

这是 `dsimp` 策略的完整语法：

> `dsimp` (`?`)? (`!`)? (`(config :=` config `)`)? (`(disch :=` discharger `)`)? (`only`)? (`[`引理列表`]`)? (`at` 位置)?

其中 `( ... )?` 表示表达式的可选部分。引理列表与 `rw` 的类似，但额外地 `-引理名` 表示从 `simp` 引理集中排除一个引理。
配置选项在后续章节中描述。

如果存在 `!`，它会向配置选项中添加 `autoUnfold := true`。
如果存在 `?`，它会使 `simp` 建议一组足以完成任务的 `simp` 引理。

这是 `simp` 策略的完整语法：

> `simp` (`?`)? (`!`)? (`(config :=` config `)`)? (`(disch :=` discharger `)`)? (`only`)? (`[`由 `*` 和引理组成的列表`]`)? (`at` 位置)?

这是 `simpa` 策略的完整语法：

> `simpa` (`?`)? (`!`)? (`(config :=` config `)`)? (`(disch :=` discharger `)`)? (`only`)? (`[`由 `*` 和引理组成的列表`]`)? (`using` 表达式)?

含义与 `simp` 相同，但 `using` 可以接受任何表达式，而不仅仅是 `at` 所要求的局部常量。

### 自定义 simp 属性

使用命令 [`register_simp_attr`](https://leanprover-community.github.io/mathlib_docs/commands.html#mk_simp_attribute)，你可以创建自己的类似 `@[simp]` 的属性，但有一个关键区别：
标记为 `@[new_attr]` 的引理**不**在默认的 `simp` 引理集中。
相反，它们应该被显式包含：`simp [new_attr]`。这通常可以替代冗长的
`simp only [...]` 调用，并使代码更易于阅读。一些常见用法的例子是
[`mfld_simps`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/Tactic/Attr/Register.html#Parser.Attr.mfld_simps)，
和 [`field_simps`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/Tactic/Attr/Register.html#Parser.Attr.field_simps)。

### 配置选项

`simp` 和 `dsimp` 都可以使用记录语法 (record syntax) 接受额外的配置选项。
例如，`simp (config := { singlePass := true })` 会在 `singlePass` 配置选项设置为 true 的情况下运行 `simp`。
可以使用 `singlePass` 来避免可能发生的循环。

核心 Lean 文件 `Init/MetaTypes.lean` 在 [`Lean.Meta.DSimp.Config`](https://leanprover-community.github.io/mathlib4_docs/Init/MetaTypes.html#Lean.Meta.DSimp.Config) 和 [`Lean.Meta.Simp.Config`](https://leanprover-community.github.io/mathlib4_docs/Init/MetaTypes.html#Lean.Meta.Simp.Config) 结构体中揭示了其他配置选项。
它们中的大多数对普通用户不太相关，
其中一些没有被完全文档化。下表重现了这些选项，
其中 `simp` 或 `dsimp` 的配置选项默认值在相应的列中给出——如果不存在默认值，则该选项不可用。
“max”默认值指的是 `Lean.Meta.Simp.defaultMaxSteps`，目前为 `100000`。

| 选项 | `simp` | `dsimp` | 描述 |
| --- | --- | --- | --- |
| `maxSteps` | max | | 失败前允许的最大步骤数 |
| `maxDischargeDepth` | 2 | | 递归应用化简到旁路条件时的最大递归深度 |
| `contextual` | `false` | | 根据当前子表达式的上下文使用额外的 `simp` 引理（见下例） |
| `memoize` | `true` | | 对子项的化简结果进行缓存 |
| `singlePass` | `false` | | 每个子项最多访问一次 |
| `zeta` | `true` | `true` | 进行 zeta 归约：`let x := a; b` ↝ `b[x := a]` |
| `beta` | `true` | `true` | 进行 beta 归约：`(fun x => a) y` ↝ `a[x := y]` |
| `eta` | `true` | `true` | 允许 eta 等价：`(fun x => f x)` ↝ `f`（目前未实现） |
| `etaStruct` | `.all` | `.all` | 配置如何确定两个结构体实例之间的定义性相等。参见 [`Lean.Meta.EtaStructMode`](https://leanprover-community.github.io/mathlib4_docs/Init/MetaTypes.html#Lean.Meta.EtaStructMode) 的文档 |
| `iota` | `true` | `true` | 归约递归子 (recursors)：`Nat.recOn (succ n) Z R` ↝ `R n (Nat.recOn n Z R)` |
| `proj` | `true` | `true` | 归约投影：`Prod.fst (a, b)` ↝ `a` |
| `decide` | `false` | `false` | 通过推断一个 `Decidable p` 实例并对其进行归约，将命题 `p` 重写为 `True` 或 `False` |
| `arith` | `false` | | 简化简单的算术表达式 |
| `autoUnfold` | `false` | `false` | 使用由方程编译器生成的所有方程引理进行归约 |
| `dsimp` | `true` | | 当为 `true` 时，如果没有允许 `simp` 访问依赖参数的一致性定理，则在依赖参数上切换到 `dsimp`。当 `dsimp` 为 `false` 时，则不访问该参数。 |
| `failIfUnchanged` | `true` | `true` | 如果没有应用任何化简则失败 |
| `ground` | `false` | | 归约基础项 (ground terms)。当一个项不包含自由变量或元变量时，它是基础项。 |
| `unfoldPartialApp` | `false` | `false` | 当我们请求展开 `f` 时，即使是 `f` 的部分应用也展开 |
| `zetaDelta` | `false` | `false` | 局部定义被展开。也就是说，给定一个包含条目 `x : t := e` 的局部上下文，自由变量 `x` 会归约为 `e`。 |

`autoUnfold` 将由方程/模式匹配编译器生成的方程引理添加到 `simp` 引理集中。

`contextual` 选项赋予 `simp` 根据子表达式的周围上下文将假设视为额外 `simp` 引理的能力。例如，当它简化一个蕴含式的后件 (consequent) 时，它会暂时将前件 (antecedent) 添加为一个 `simp` 引理。这对于以下例子是必需的：
```lean
example {x y : ℕ} : x = 0 → y = 0 → x = y := by
  simp (config := { contextual := true })
```