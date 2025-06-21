# 库样式指南

除了[命名约定 (naming conventions)](naming.html)之外，Lean 库中的文件通常遵循以下指南和约定。拥有统一的风格可以更方便地浏览库和阅读内容，但这些是作为指南而非硬性规定。

### 变量约定

- `u`, `v`, `w`, ... 用于全域 (universes)
- `α`, `β`, `γ`, ... 用于泛型类型
- `a`, `b`, `c`, ... 用于命题 (propositions)
- `x`, `y`, `z`, ... 用于泛型类型的元素
- `h`, `h₁`, ...     用于假设
- `p`, `q`, `r`, ... 用于谓词 (predicates) 和关系 (relations)
- `s`, `t`, ...      用于列表
- `s`, `t`, ...      用于集合 (sets)
- `m`, `n`, `k`, ... 用于自然数 (natural numbers)
- `i`, `j`, `k`, ... 用于整数 (integers)

具有数学内容的类型使用通常的数学符号表示，通常用大写字母（`G` 表示群，`R` 表示环，`K` 或 `𝕜` 表示域，`E` 表示向量空间……）。
旧文件中没有遵循此约定，其中所有类型都使用希腊字母。欢迎提交重命名这些文件中类型变量的拉取请求 (pull requests)。

### 行长

行长不应超过 100 个字符。这使得文件更易于阅读，尤其是在小屏幕或小窗口中。
如果你使用 VS Code 编辑，会有一个视觉标记指示 100 个字符的限制。

### 文件头与导入

文件头应包含版权信息、对文件做出重大贡献的所有作者列表以及内容描述。在文件头之后立即进行所有 `import`，中间不要有换行，每行一个导入。

```lean
/-
Copyright (c) 2024 Joe Cool. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Joe Cool
-/
import Mathlib.Data.Nat.Basic
import Mathlib.Algebra.Group.Defs
```

（提示：如果你在 VS Code 中编辑 mathlib，可以输入 `copy` 然后按 <kbd>TAB</kbd> 来生成版权头的骨架。）

关于作者列表：即使只有一个作者，也请使用 `Authors`。行尾不要加句号，并使用逗号（`, `）分隔所有作者姓名（因此不要在倒数第二和最后一位作者之间使用 `and`）。
对于何种贡献有资格被列入，我们没有严格的规定。总的来说，我们希望在对 Lean 代码的设计或开发有疑问时，可以联系到列表中的这些人。

### 模块文档字符串

在版权头和导入之后，请添加一个模块文档字符串 (module docstring)（用 `/-!` 和 `-/` 分隔），其中包含

- 文件的标题，
- 内容的摘要（主要定义和定理、证明技巧等）
- 文件中使用的符号（如果有的话）
- 对文献的引用（如果有的话）

总的来说，模块文档字符串应该看起来像这样：
```markdown
/-!
# Foo 和 bar

在这个文件中，我们介绍 `foo` 和 `bar`，这是 xyzzyology 理论中的两个核心概念。

## 主要结果

- `exists_foo`: 关于 `foo` 的主要存在性定理。
- `bar_of_foo_of_baz`: 给定一个 `foo` 和一个 `baz` 来构造一个 `bar`。
  如果此文档字符串超过一行，后续行应缩进两个空格（根据 markdown 语法要求）。
- `bar_eq`    : 关于 `bar` 的主要分类定理。

## 符号

 - `|_|` : Barrification 运算符，请参见 `bar_of_foo`。

## 参考文献

关于 Xyzzyology 的原始记述，请参见 [Thales600BC]。
-/
```

新的文献条目应添加到 `docs/references.bib` 中。

更多建议和示例，请参见我们的[文档要求](doc.html)。

### 结构化定义与定理

所有声明（例如 `def`, `lemma`, `theorem`, `class`, `structure`, `inductive`, `instance` 等）和命令（例如 `variable`, `open`, `section`, `namespace`, `notation` 等）都被视为顶层，这些词应该在文档中左对齐。特别地，打开一个命名空间 (namespace) 或节 (section) 不会导致该命名空间或节的内容缩进。
（注意：在 VS Code 中，将鼠标悬停在任何声明上，如 `def Foo ...`，将显示其完全限定名，例如，如果 `Foo` 是在 `MyNamespace` 命名空间打开时声明的，则会显示 `MyNamespace Foo`。）

这些指南适用于以 `def`、`lemma` 和 `theorem` 开头的声明。
对于“定理陈述”，也应理解为“定义的类型”；对于“证明”，也应理解为“定义体”。

在 ":"、":=" 或中缀运算符的两侧使用空格。将它们放在换行符之前，而不是下一行的开头。

在下文中，没有明确指出数量的“缩进 (indent)”意味着“额外缩进 2 个空格”。

在陈述定理之后，我们将后续证明中的行缩进 2 个空格。
```lean
open Nat
theorem nat_case {P : Nat → Prop} (n : Nat) (H1 : P 0) (H2 : ∀ m, P (succ m)) : P n :=
  Nat.recOn n H1 (fun m IH ↦ H2 m)
```

如果定理陈述需要多行，则将后续行缩进 4 个空格。
证明仍然只缩进 2 个空格（**不是** 6 = 4 + 2）。
当在策略模式 (tactic mode) 下提供证明时，`by` 放置在第一个 tactic **之前**的那一行；但是，`by` 不应该单独占一行。
在实践中，这意味着你经常会在定理陈述的末尾看到 `:= by`。
```lean
import Mathlib.Data.Nat.Basic

theorem le_induction {P : Nat → Prop} {m}
    (h0 : P m) (h1 : ∀ n, m ≤ n → P n → P (n + 1)) :
    ∀ n, m ≤ n → P n := by
  apply Nat.le.rec
  · exact h0
  · exact h1 _

def decreasingInduction {P : ℕ → Sort*} (h : ∀ n, P (n + 1) → P n) {m n : ℕ} (mn : m ≤ n)
    (hP : P n) : P m :=
  Nat.leRecOn mn (fun {k} ih hsk => ih <| h k hsk) (fun h => h) hP
```

当一个证明项 (proof term) 接受多个参数时，将一些参数放在后续行上会更清晰，并且通常是必要的。在这种情况下，缩进每个参数。这个规则，即额外缩进两个空格，在任何项跨越多行时都普遍适用。
```lean
open Nat
axiom zero_or_succ (n : Nat) : n = zero ∨ n = succ (pred n)
theorem nat_discriminate {B : Prop} {n : Nat} (H1: n = 0 → B) (H2 : ∀ m, n = succ m → B) : B :=
  Or.elim (zero_or_succ n)
    (fun H3 : n = zero ↦ H1 H3)
    (fun H3 : n = succ (pred n) ↦ H2 (pred n) H3)
```
不要让括号孤立；让它们与参数保持在一起。

这是一个更长的例子。
```lean
import Mathlib.Init.Data.List.Lemmas

open List
variable {T : Type}

theorem mem_split {x : T} {l : List T} : x ∈ l → ∃ s t : List T, l = s ++ (x :: t) :=
  List.recOn l
    (fun H : x ∈ [] ↦ False.elim ((mem_nil_iff _).mp H))
    (fun y l ↦
      fun IH : x ∈ l → ∃ s t : List T, l = s ++ (x :: t) ↦
      fun H : x ∈ y :: l ↦
      Or.elim (eq_or_mem_of_mem_cons H)
        (fun H1 : x = y ↦
          Exists.intro [] (Exists.intro l (by rw [H1]; rfl)))
        (fun H1 : x ∈ l ↦
          let ⟨s, (H2 : ∃ t : List T, l = s ++ (x :: t))⟩ := IH H1
          let ⟨t, (H3 : l = s ++ (x :: t))⟩ := H2
          have H4 : y  ::  l = (y :: s) ++ (x :: t) := by rw [H3]; rfl
          Exists.intro (y :: s) (Exists.intro t H4)))
```

一个简短的声明可以写在单行上：
```lean
open Nat
theorem succ_pos : ∀ n : Nat, 0 < succ n := zero_lt_succ

def square (x : Nat) : Nat := x * x
```

当理由很短时，`have` 可以放在单行上。
```lean
example (n k : Nat) (h : n < k) : ... :=
  have h1 : n ≠ k := ne_of_lt h
  ...
```
当理由太长时，你应该把它放在下一行，并额外缩进两个空格。
```lean
example (n k : Nat) (h : n < k) : ... :=
  have h1 : n ≠ k :=
    ne_of_lt h
  ...
```
当 `have` 的理由使用策略模式时，`by` 应该放在同一行，无论理由是否跨越多行。
```lean
example (n k : Nat) (h : n < k) : ... :=
  have h1 : n ≠ k := by apply ne_of_lt; exact h
  ...

example (n k : Nat) (h : n < k) : ... :=
  have h1 : n ≠ k := by
    apply ne_of_lt
    exact h
  ...
```

当参数本身长到需要换行时，对第一行之后的每一行都使用额外的缩进，如下例所示：
```lean
import Mathlib.Data.Nat.Basic

theorem Nat.add_right_inj {n m k : Nat} : n + m = n + k → m = k :=
  Nat.recOn n
    (fun H : 0 + m = 0 + k ↦ calc
      m = 0 + m := Eq.symm (zero_add m)
      _ = 0 + k := H
      _ = k     := zero_add _)
    (fun (n : Nat) (IH : n + m = n + k → m = k) (H : succ n + m = succ n + k) ↦
      have H2 : succ (n + m) = succ (n + k) := calc
        succ (n + m) = succ n + m   := Eq.symm (succ_add n m)
        _            = succ n + k   := H
        _            = succ (n + k) := succ_add n k
      have H3 : n + m = n + k := succ.inj H2
      IH H3)
```

在类或结构体定义中，字段缩进 2 个空格，并且每个字段都应该有文档字符串，如下所示：

```lean
structure PrincipalSeg {α β : Type*} (r : α → α → Prop) (s : β → β → Prop) extends r ↪r s where
  /-- 主段的上确界 -/
  top : β
  /-- 序嵌入的像是满足 `s b top` 的元素 `b` 的集合 -/
  down' : ∀ b, s b top ↔ ∃ a, toRelEmbedding a = b

class Module (R : Type u) (M : Type v) [Semiring R] [AddCommMonoid M] extends
    DistribMulAction R M where
  /-- 标量乘法对右侧的加法满足分配律。 -/
  protected add_smul : ∀ (r s : R) (x : M), (r + s) • x = r • x + s • x
  /-- 标量乘零得零。 -/
  protected zero_smul : ∀ x : M, (0 : R) • x = 0
```

在定义中使用接受多个参数的构造函数时，参数要对齐，如下所示：

```lean
theorem Ordinal.sub_eq_zero_iff_le {a b : Ordinal} : a - b = 0 ↔ a ≤ b :=
  ⟨fun h => by simpa only [h, add_zero] using le_add_sub a b,
   fun h => by rwa [← Ordinal.le_zero, sub_le, add_zero]⟩
```

### 实例

在提供结构体的项或类的实例时，应使用 `where` 语法以避免需要使用封闭的花括号，如下所示：

```lean
instance instOrderBot : OrderBot ℕ where
  bot := 0
  bot_le := Nat.zero_le
```

如果已经存在一个实例 `instBot`，那么可以写成

```lean
instance instOrderBot : OrderBot ℕ where
  __ := instBot
  bot_le := Nat.zero_le
```

### 冒号左侧的假设

通常，如果证明以引入这些变量开始，那么将参数放在冒号左侧比放在全称量词或蕴含式中更受青睐。例如：

```lean
example (n : ℝ) (h : 1 < n) : 0 < n := by linarith
```

比以下写法更受青睐

```lean
example (n : ℝ) : 1 < n → 0 < n := fun h ↦ by linarith
```

以及

```lean
example (n : ℕ) : 0 ≤ n := dec_trivial __Nat.zero_le n
```

比以下写法更受青睐

```lean
example : ∀ (n : ℕ), 0 ≤ n := Nat.zero_le
```

### 绑定符

在绑定符后使用一个空格：
```lean
example : ∀ α : Type, ∀ x : α, ∃ y, y = x :=
  fun (α : Type) (x : α) ↦ Exists.intro x rfl
```

### 匿名函数

Lean 有几种很好的语法选项来声明匿名函数 (anonymous functions)。对于非常简单的函数，可以使用居中点作为函数参数，例如用 `(· ^ 2)` 表示平方函数。然而，有时需要按名称引用参数（例如，如果它们在函数体中多处出现）。Lean 的默认写法是 `fun x => x * x`，但箭头 `↦`（通过 `\mapsto` 输入）也是有效的。在 mathlib 中，美化打印器会显示 `↦`，我们在源代码中也略微偏好这种写法。lambda 符号 `λ x ↦ x * x` 虽然语法上有效，但在 mathlib 中是不允许的，我们倾向于使用 `fun` 关键字。

### 计算

在编写计算性证明方面有一定的灵活性，尽管 `calc` 本身的语法要求强制了一些规则。然而，这里有一些通用指南。

与 `by` 一样，`calc` 关键字应放置在计算开始**之前**的那一行，并且计算部分需要缩进。所涉及的任何关系（例如 `=` 或 `≤`）都应逐行对齐。用作占位符以指示计算继续的下划线 `_` 应左对齐。

至于理由部分，不必对齐 `:=` 符号，但如果表达式足够短，这样做会很好看。第一个关系两侧的项可以放在一行或分开放置，这可以由表达式的大小决定。

一个足以容纳较长表达式的恰当风格示例如下：

```lean
import Init.Data.List.Basic

open List

theorem reverse_reverse : ∀ (l : List α), reverse (reverse l) = l
  | []       => rfl
  | (a :: l) => calc
      reverse (reverse (a :: l))
        = reverse (reverse l ++ [a]) := by rw [reverse_cons]
      _ = reverse [a] ++ reverse (reverse l) := reverse_append _ _
      _ = reverse [a] ++ l := by rw [reverse_reverse l]
      _ = a :: l := rfl
```

然而，由于表达式和证明相对较短，在这种情况下，以下风格可能更可取。

```lean
import Init.Data.List.Basic

open List

theorem reverse_reverse : ∀ (l : List α), reverse (reverse l) = l
  | []       => rfl
  | (a :: l) => calc
      reverse (reverse (a :: l)) = reverse (reverse l ++ [a])         := by rw [reverse_cons]
      _                          = reverse [a] ++ reverse (reverse l) := reverse_append _ _
      _                          = reverse [a] ++ l                   := by rw [reverse_reverse l]
      _                          = a :: l                             := rfl
```

### 策略模式

如前所述，当打开一个策略块 (tactic block) 时，`by` 放置在策略块开始**之前**那行的末尾，但不能单独占一行。
策略块内的所有内容都应缩进，如下所示：

```lean
theorem continuous_uncurry_of_discreteTopology [DiscreteTopology α] {f : α → β → γ}
    (hf : ∀ a, Continuous (f a)) : Continuous (uncurry f) := by
  apply continuous_iff_continuousAt.2
  rintro ⟨a, x⟩
  change map _ _ ≤ _
  rw [nhds_prod_eq, nhds_discrete, Filter.map_pure_prod]
  exact (hf a).continuousAt
```

可以混合使用项模式和策略模式，如下所示：
```lean
theorem Units.isUnit_units_mul {M : Type*} [Monoid M] (u : Mˣ) (a : M) :
    IsUnit (↑u * a) ↔ IsUnit a :=
  Iff.intro
    (fun ⟨v, hv⟩ => by
      have : IsUnit (↑u⁻¹ * (↑u * a)) := by exists u⁻¹ * v; rw [← hv, Units.val_mul]
      rwa [← mul_assoc, Units.inv_mul, one_mul] at this)
    u.isUnit.mul
```

当新的目标作为旁生条件 (side conditions) 或步骤出现时，它们需要缩进并以一个聚焦圆点 `·`（通过 `\.` 输入）为前缀；该圆点本身不缩进。
```lean
import Mathlib.Algebra.Group.Basic

theorem exists_npow_eq_one_of_zpow_eq_one' [Group G] {n : ℤ} (hn : n ≠ 0) {x : G} (h : x ^ n = 1) :
    ∃ n : ℕ, 0 < n ∧ x ^ n = 1 := by
  cases n
  · simp only [Int.ofNat_eq_coe] at h
    rw [zpow_ofNat] at h
    refine ⟨_, Nat.pos_of_ne_zero fun n0 ↦ hn ?_, h⟩
    rw [n0]
    rfl
  · rw [zpow_negSucc, inv_eq_one] at h
    refine ⟨_ + 1, Nat.succ_pos _, h⟩
```

某些 tactic，如 `refine`，可以创建**命名的**子目标，这些子目标可以使用 `case` 按任意顺序证明。这个功能也有助于提高可读性。然而，并不要求用它来代替聚焦圆点（`·`）。

```lean
example {p q : Prop} (h₁ : p → q) (h₂ : q → p) : p ↔ q := by
  refine ⟨?imp, ?converse⟩
  case converse => exact h₂
  case imp => exact h₁
```

`t0 <;> t1` 用于执行 `t0`，然后对所有新目标执行 `t1`。可以将这些 tactic 写在一行，或者缩进后续的 tactic。

```lean
  cases x <;>
    simp [a, b, c, d]
```

对于单行 tactic 证明（或嵌入在项中的简短 tactic 证明），可以使用分号 `by tac1; tac2; tac3`，而不是换行加缩进。

通常，每行应该只有一个 tactic 调用，除非你用一个完全适合单行的证明来关闭目标。与单个数学思想对应的简短 tactic 序列也可以放在一行上，用分号分隔，例如 `cases bla; clear h` 或 `induction n; simp` 或 `rw [foo]; simp_rw [bar]`，但即使在这些情况下，也更推荐使用换行。

```lean
example : ... := by
  by_cases h : x = 0
  · rw [h]; exact hzero ha
  · rw [h]
    have h' : ... := H ha
    simp_rw [h', hb]
    ...
```

非常短的目标可以使用 `swap` 或 `pick_goal` 立即关闭，以避免证明其余部分的额外缩进。

```lean
example : ... := by
  rw [h]
  swap; exact h'
  ...
```

我们通常用一个空行来分隔定理和定义，但这可以省略，例如，为了将一些简短的定义组合在一起，或者将一个定义和其符号组合在一起。

### 精简 simp 调用

除非性能特别差或证明因此中断，否则**终端 `simp` 调用 (terminal `simp` calls)**（如果一个 `simp` 调用关闭了当前目标，或者其后只跟有 `ring`、`field_simp`、`aesop` 等灵活的 tactic，则该调用是终端的）不应该被**精简**（即被 `simp?` 的输出所替代）。

这主要有两个原因：
1. 一个精简后的 `simp` 调用可能比未精简的要长好几行，从而将为了关闭目标而添加到未精简 `simp` 调用中的关键引理等有用信息淹没在大量基本 simp 引理的海洋中。
2. 一个精简后的 `simp` 调用通过名称引用了许多引理，这意味着当其中任何一个引理被重命名时，它都会中断。引理重命名发生的频率足以让这一点在维护层面上成为问题。

### 空白与分隔符

Lean 是对空白 (whitespace) 敏感的，通常我们选择一种避免使用代码分隔符的风格。例如，在编写 tactic 时，可以写成 `tac1; tac2; tac3`，用 `;` 分隔，以覆盖默认的空白敏感性。然而，如上所述，除少数特殊情况外，我们通常尽量避免这样做。

类似地，有时可以通过巧妙使用 `<|` 运算符（或其同类 `|>`）来避免使用括号。注意：虽然 `$` 是 `<|` 的同义词，但在 mathlib 中，为了保持一致性以及与 `|>` 的对称性，我们不允许使用 `$`，而推荐使用 `<|`。这些运算符的效果是将 `<|` 右侧的所有内容括起来（注意 `(` 的弯曲方向与 `<` 相同），或将 `|>` 左侧的所有内容括起来（而 `)` 的弯曲方向与 `>` 相同）。

一个 `|>` 的常见用法是与点表示法一起使用，当 `.` 前面的项是一个应用于某些参数的函数时。例如，`((foo a).bar b).baz` 可以重写为 `foo a |>.bar b |>.baz`

一个 `<|` 的常见用法是当用户提供一个项，该项是一个应用于多个参数的函数，且其最后一个参数是策略模式下的证明，特别是当证明跨越多行时。在这种情况下，使用 `<| by ...` 而非 `(by ...)` 是很自然的，如下所示：

```lean
import Mathlib.Tactic

example {x y : ℝ} (hxy : x ≤ y) (h : ∀ ε > 0, y - ε ≤ x) : x = y :=
  le_antisymm hxy <| le_of_forall_pos_le_add <| by
    intro ε hε
    have := h ε hε
    linarith
```

当使用 `rw` 或 `simp` tactic 时，左箭头 `←` 之后应该有一个空格。例如 `rw [← add_comm a b]` 或 `simp [← and_or_left]`。
（tactic 名称和其参数之间也应该有一个空格，如 `rw [h]`。）
此规则同样适用于 `do` 符号：`do return (← f) + (← g)`

### 声明内部的空行

不鼓励在声明内部使用空行，并且有一个 linter 会强制确保它们不存在。这有助于在整个 mathlib 中保持统一的代码风格。

但是，我们鼓励您在代码中添加注释：即使是一个短句，所传达的信息也远比证明中间的一个空行要多得多！

### 范式

有些陈述是等价的。例如，有几种等价的方式来要求一个类型的子集 `s` 是非空的。再举一例，给定 `a : α`，`Option α` 中的对应元素可以等价地写成 `Some a` 或 `(a : Option α)`。通常，我们努力确定一种标准形式，称为范式 (normal form)，并在定理的陈述和结论中都使用它。在上述例子中，范式分别是 `s.Nonempty`（它允许使用点表示法）和 `(a : Option α)`。通常，我们会注册 simp 引理，将其他等价形式转换为范式。

这个规则有一个特例。在有底元素的类型中，要求 `hlt : ⊥ < x` 或 `hne : x ≠ ⊥` 是等价的，并且不清楚哪一个作为范式更好，因为两者各有优缺点。类似的情况也发生在有顶元素的类型中，即 `hlt : x < ⊤` 和 `hne : x ≠ ⊤`。由于从 `hlt` 转换为 `hne` 非常容易（根据我们想要的方向使用 `hlt.ne` 或 `hlt.ne'`），而反向转换则更为冗长，因此我们在定理的*假设*中使用 `hne`（因为这是更容易检查的假设），在定理的*结论*中使用 `hlt`（因为这是更强大的可用结果）。
这个规则的一个常见用法是处理自然数，其中 `⊥ = 0`。

### 注释

使用模块文档分隔符 `/-! -/` 来提供节标题和分隔符，因为这些会被整合到自动生成的文档中；使用 `/- -/` 来编写更技术性的注释（例如 TODO 和实现说明）或证明中的注释。
使用 `--` 来编写简短或行内注释。

声明的文档字符串用 `/-- -/` 分隔。
当声明的文档字符串跨越多行时，不要缩进后续行。

更多建议和示例，请参见我们的[文档要求](doc.html)。

### 弃用

删除、重命名或更改声明可能导致依赖这些定义的下游项目编译失败。
任何被移除的公开定理和定义都应通过保留带有 `@[deprecated]` 属性的旧声明来进行平稳过渡。
这会警告下游项目有关变更，并给它们在声明被删除前进行调整的机会。
重命名的定义应使用一个已弃用的 `alias` 指向新名称。
否则，当被弃用的定义没有直接替代品时，应使用一条消息来弃用该定义，如下所示：

```lean4
theorem new_name : ... := ...
@[deprecated (since := "YYYY-MM-DD")] alias old_name := new_name

@[deprecated "This theorem is deprecated in favor of using ... with ..." (since := "YYYY-MM-DD")]
theorem example_thm ...
```

`@[deprecated]` 属性需要弃用日期，以及一个指向新声明的别名或一个字符串，用于解释在不再提供新版本时如何从旧定义过渡。

[`deprecate to`](/mathlib4_docs/Mathlib/Tactic/DeprecateTo.html) 命令和 `scripts/add_deprecations.sh` 脚本可以帮助生成别名定义。

带有 `to_additive` 属性的声明的弃用应确保弃用本身也被正确地标记为 `to_additive`，如下所示：
```lean4
@[to_additive] theorem Group_bar {G} [Group G] {a : G} : a = a := rfl

-- Two deprecations required to include the `deprecated` tag on both the additive
-- and multiplicative versions
@[deprecated (since := "YYYY-MM-DD")] alias AddGroup_foo := AddGroup_bar
@[to_additive existing, deprecated (since := "YYYY-MM-DD")] alias Group_foo := Group_bar
```

我们允许但不鼓励贡献者同时将声明 X 重命名为 Y，并将 W 重命名为 X。在这种情况下，X 不需要弃用属性，但 W 需要。

命名的实例不需要弃用。被弃用的声明可以在 6 个月后删除。