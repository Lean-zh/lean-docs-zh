# Mathlib 命名约定

本指南是为 Lean 4 编写的。

## 文件名

mathlib 中的 `.lean` 文件通常应以 `UpperCamelCase` (大驼峰命名法) 命名。
一个（非常罕见的）例外是那些以特定小写对象命名的文件，例如 `lp.lean` 文件专门关于 $\ell_p$ 空间（而不是 $L^p$）。
此类例外应首先在 Zulip 上讨论。

##通用约定

与 Lean 3 中所有声明都使用 `snake_case` (蛇形命名法) 的约定不同，
在 Lean 4 下的 mathlib 中，我们根据以下命名方案结合使用 `snake_case`、`lowerCamelCase` (小驼峰命名法) 和 `UpperCamelCase`。

1.  `Prop` 的项（例如证明、定理名称）使用 `snake_case`。
2.  `Prop` 和 `Type` (或 `Sort`)（归纳类型、结构体、类）使用 `UpperCamelCase`。
    有一些罕见的例外：结构体的某些字段当前被错误地小写了（参见下面 `LT` 类的示例）。
3.  函数的命名方式与其返回值相同（例如，一个类型为 `A → B → C` 的函数，其命名方式就如同它是一个 `C` 类型的项）。
4.  所有其他 `Type` 的项（基本上是其他任何东西）都使用 `lowerCamelCase`。
5.  当一个以 `UpperCamelCase` 命名的东西是另一个以 `snake_case` 命名的东西的一部分时，它以 `lowerCamelCase` 的形式被引用。
6.  像 `LE` 这样的缩写词，根据首字母本应是大写还是小写，整体作为一组进行大写或小写。
7.  规则 1-6 同样适用于结构体的字段或归纳类型的构造函数。

为保持局部命名的对称性，存在一些罕见的例外：例如，我们使用 `Ne` 而不是 `NE` 以遵循 `Eq` 的示例；`outParam` 有一个 `Sort` 类型的输出，但没有使用 `UpperCamelCase`。其他一些例外包括区间（`Set.Icc`、`Set.Iic` 等），其中 `I` 尽管根据约定应为 `lowerCamelCase`，但却被大写了。任何此类例外都应在 Zulip 上讨论。

### 示例

```lean
-- 遵循规则 2
structure OneHom (M : Type _) (N : Type _) [One M] [One N] where
  toFun : M → N -- 通过规则 3 和规则 7，遵循规则 4
  map_one' : toFun 1 = 1 -- 通过规则 7，遵循规则 1

-- 通过规则 3，遵循规则 2
class CoeIsOneHom [One M] [One N] : Prop where
  coe_one : (↑(1 : M) : N) = 1 -- 通过规则 6，遵循规则 1

-- 通过规则 3，遵循规则 1
theorem map_one [OneHomClass F M N] (f : F) : f 1 = 1 := sorry

-- 遵循规则 1 和 5
theorem MonoidHom.toOneHom_injective [MulOneClass M] [MulOneClass N] :
  Function.Injective (MonoidHom.toOneHom : (M →* N) → OneHom M N) := sorry
-- 由于 `snake_case` 中包含多个单词的 `lowerCamelCase`，需要手动对齐
#align monoid_hom.to_one_hom_injective MonoidHom.toOneHom_injective

-- 遵循规则 2
class HPow (α : Type u) (β : Type v) (γ : Type w) where
  hPow : α → β → γ -- 通过规则 6，遵循规则 3；注意规则 5 不适用

-- 遵循规则 2 和 6
class LT (α : Type u) where
  lt : α → α → Prop -- 这是规则 2 的一个例外

-- 遵循规则 2 (对于 `Semifield`) 和规则 4 (对于 `toIsField`)
theorem Semifield.toIsField (R : Type u) [Semifield R] :
    IsField R -- 遵循规则 2

-- 遵循规则 1 和 6
theorem gt_iff_lt [LT α] {a b : α} : a > b ↔ b < a := sorry

-- 遵循规则 2; `Ne` 是规则 6 的一个例外
class NeZero : Prop := sorry

-- 遵循规则 1 和 5
theorem neZero_iff {R : Type _} [Zero R] {n : R} : NeZero n ↔ n ≠ 0 := sorry
-- 由于 `snake_case` 中包含多个单词的 `lowerCamelCase`，需要手动对齐
#align ne_zero_iff neZero_iff
```

### 符号名称

将定理的陈述翻译成文字时，通常使用以下词典。

#### 逻辑

| 符号 | 快捷键 | 名称 | 注释 |
|--------|----------|---------------------------|---------------------------------------------------------------------|
| `∨` | `\or` | `or` | |
| `∧` | `\and` | `and` | |
| `→` | `\r` | `of` / `imp` | 结论在前，假设常被省略 |
| `↔` | `\iff` | `iff` | 有时连同 `iff` 的右侧一起省略 |
| `¬` | `\n` | `not` | |
| `∃` | `\ex` | `exists` / `bex` | `bex` 代表 "bounded exists" (有界存在) |
| `∀` | `\fo` | `all` / `forall` / `ball` | `ball` 代表 "bounded forall" (有界全称) |
| `=` | | `eq` | 常被省略 |
| `≠` | `\ne` | `ne` | |
| `∘` | `\o` | `comp` | |

`ball` 和 `bex` 在 Lean core 中仍在使用，但在 mathlib 中不应使用。

#### 集合

| 符号 | 快捷键 | 名称 | 注释 |
|-----------------------------|-------------|----------------------|-----------------------------------------------|
| `∈` | `\in` | `mem` | |
| `∉` | `\notin` | `notMem` | |
| `∪` | `\cup` | `union` | |
| `∩` | `\cap` | `inter` | |
| `⋃` | `\bigcup` | `iUnion` / `biUnion` | `i` 代表 "indexed" (有索引的), `bi` 代表 "bounded indexed" (有界有索引的) |
| `⋂` | `\bigcap` | `iInter` / `biInter` | `i` 代表 "indexed" (有索引的), `bi` 代表 "bounded indexed" (有界有索引的) |
| `⋃₀` | `\bigcup\0` | `sUnion` | `s` 代表 "set" (集合) |
| `⋂₀` | `\bigcap\0` | `sInter` | `s` 代表 "set" (集合) |
| `\` | `\\` | `sdiff` | |
| `ᶜ` | `\^c` | `compl` | |
| <code>{x &#124; p x}</code> | | `setOf` | |
| `{x}` | | `singleton` | |
| `{x, y}` | | `pair` | |

#### 代数

| 符号 | 快捷键 | 名称 | 注释 |
| ------ | --------------------- | ------------- | ----------------------------------------------------------- |
| `0` | | `zero` | |
| `+` | | `add` | |
| `-` | | `neg` / `sub` | `neg` 用于一元函数，`sub` 用于二元函数 |
| `1` | | `one` | |
| `*` | | `mul` | |
| `^` | | `pow` | |
| `/` | | `div` | |
| `•` | `\bu` | `smul` | |
| `⁻¹` | `\-1` | `inv` | |
| `⅟` | `\frac1` | `invOf` | |
| `∣` | <code>\\&#124;</code> | `dvd` | |
| `∑` | `\sum` | `sum` | |
| `∏` | `\prod` | `prod` | |

#### 格 (Lattices)

| 符号 | 快捷键 | 名称 | 注释 |
|--------|----------|----------------------------|----------------------------------|
| `<` | | `lt` / `gt` | |
| `≤` | `\le` | `le` / `ge` | |
| `⊔` | `\sup` | `sup` | 二元运算符 |
| `⊓` | `\inf` | `inf` | 二元运算符 |
| `⨆` | `\supr` | `iSup` / `biSup` / `ciSup` | `c` 代表 "conditionally complete" (条件完备) |
| `⨅` | `\infi` | `iInf` / `biInf` / `ciInf` | `c` 代表 "conditionally complete" (条件完备) |
| `⊥` | `\bot` | `bot` | |
| `⊤` | `\top` | `top` | |

符号 `≤` 和 `<` 有特殊的命名约定。
在 mathlib 中，我们几乎总是使用 `≤` 和 `<` 而不是 `≥` 和 `>`，所以我们可以用 `le`/`lt` 和 `ge`/`gt` 来命名 `≤` 和 `<`。
有几个理由使用 `ge`/`gt`：

1.  如果 `≤` 或 `<` 的参数以不同的顺序出现，我们使用 `ge`/`gt`。我们对定理名称中第一次出现的 `≤`/`<` 使用 `le`/`lt`，然后 `ge`/`gt` 表示参数被交换了。
2.  我们使用 `ge`/`gt` 来匹配另一个关系（如 `=` 或 `≠`）的参数顺序。
3.  我们使用 `ge`/`gt` 来描述参数交换后的 `≤` 或 `<` 关系。
4.  如果 `≤` 或 `<` 的第二个参数“更易变”，我们使用 `ge`/`gt`。

```lean
-- 遵循规则 1
theorem lt_iff_le_not_ge [Preorder α] {a b : α} : a < b ↔ a ≤ b ∧ ¬b ≤ a := sorry
theorem not_le_of_gt [Preorder α] {a b : α} (h : a < b) : ¬b ≤ a := sorry
theorem LT.lt.not_ge [Preorder α] {a b : α} (h : a < b) : ¬b ≤ a := sorry

-- 遵循规则 2
theorem Eq.ge [Preorder α] {a b : α} (h : a = b) : b ≤ a := sorry
theorem ne_of_gt [Preorder α] {a b : α} (h : b < a) : a ≠ b := sorry

-- 遵循规则 3
theorem ge_trans [Preorder α] {a b : α} : b ≤ a → c ≤ b → c ≤ a := sorry

-- 遵循规则 4
theorem le_of_forall_gt [LinearOrder α] {a b : α} (H : ∀ (c : α), a < c → b < c) : b ≤ a := sorry
```

### 点号 (Dots)

点号用于命名空间，也用于自动生成的名称，如递归器、消去子和结构体投影。它们也可以手动引入，例如在投影表示法有用的地方。因此，它们被用于以下所有情况。

注意：由于 `And` 是一个（到 `Prop` 的二元函数），根据命名约定它是 `UpperCamelCased` 的，所以它的命名空间是 `And.*`。这可能看起来与 `∧` --> `and` 的词典不符，但因为大驼峰命名的类型在定理名称中出现时会变成小驼峰命名，所以这个词典通常仍然有效。这同样适用于 `Or`、`Iff`、`Not`、`Eq`、`HEq`、`Ne` 等。

逻辑连接词的引入、消去和析构规则，无论它们是自动生成的还是手动编写的：

-   `And.intro`
-   `And.elim`
-   `And.left`
-   `And.right`
-   `Or.inl`
-   `Or.inr`
-   `Or.intro_left`
-   `Or.intro_right`
-   `Iff.intro`
-   `Iff.elim`
-   `Iff.mp`
-   `Iff.mpr`
-   `Not.intro`
-   `Not.elim`
-   `Eq.refl`
-   `Eq.rec`
-   `Eq.subst`
-   `HEq.refl`
-   `HEq.rec`
-   `HEq.subst`
-   `Exists.intro`
-   `Exists.elim`
-   `True.intro`
-   `False.elim`

投影表示法有用的地方，例如：

-   `And.symm`
-   `Or.symm`
-   `Or.resolve_left`
-   `Or.resolve_right`
-   `Eq.symm`
-   `Eq.trans`
-   `HEq.symm`
-   `HEq.trans`
-   `Iff.symm`
-   `Iff.refl`

即使对于非归纳类型的类型，使用点号表示法也很有用。例如，我们使用：

-   `LE.trans`
-   `LT.trans_le`
-   `LE.trans_lt`

### 公理化描述

一些定理使用公理化的名称来描述，而不是描述它们的结论。

-   `def` (用于展开定义)
-   `refl`
-   `irrefl`
-   `symm`
-   `trans`
-   `antisymm`
-   `asymm`
-   `congr`
-   `comm`
-   `assoc`
-   `left_comm`
-   `right_comm`
-   `mul_left_cancel`
-   `mul_right_cancel`
-   `inj` (injective, 单射)

### 变量约定

-   `u`, `v`, `w`, ... 用于 universe
-   `α`, `β`, `γ`, ... 用于泛型类型
-   `a`, `b`, `c`, ... 用于命题
-   `x`, `y`, `z`, ... 用于泛型类型的元素
-   `h`, `h₁`, ... 用于假设
-   `p`, `q`, `r`, ... 用于谓词和关系
-   `s`, `t`, ... 用于列表
-   `s`, `t`, ... 用于集合
-   `m`, `n`, `k`, ... 用于自然数
-   `i`, `j`, `k`, ... 用于整数

具有数学内容的类型使用通常的数学符号表示，通常用大写字母（`G` 表示群，`R` 表示环，`K` 或 `𝕜` 表示域，`E` 表示向量空间，...）。在较旧的文件中，这个约定没有被遵守，那里的所有类型都使用希腊字母。欢迎提交重命名这些文件中类型变量的拉取请求 (pull request)。

## 标识符和定理名称

我们采用以下命名准则，以便用户更容易猜到定理的名称或使用 Tab 补全找到它。一个运算（如合取或析取）的常见“公理化”属性被放在以该运算名称开头的命名空间中：

```lean
import Mathlib.Logic.Basic

#check And.comm
#check Or.comm
```

特别地，这包括逻辑连接词的 `intro` 和 `elim` 操作，以及关系的属性：

```lean
import Mathlib.Logic.Basic

#check And.intro
#check And.elim
#check Or.intro_left
#check Or.intro_right
#check Or.elim

#check Eq.refl
#check Eq.symm
#check Eq.trans
```

但请注意，我们不对公理化的逻辑和算术运算这样做。

```lean
import Mathlib.Algebra.Group.Basic

#check and_assoc
#check mul_comm
#check mul_assoc
#check @mul_left_cancel  -- 乘法是左可消的
```

然而，在大多数情况下，我们依赖于描述性的名称。通常，定理的名称只是描述了结论：

```lean
import Mathlib.Algebra.Ring.Basic
open Nat
#check succ_ne_zero
#check mul_zero
#check mul_one
#check @sub_add_eq_add_sub
#check @le_iff_lt_or_eq
```

如果描述的前缀足以传达意思，名称可能会更短：

```lean
import Mathlib.Algebra.Ring.Basic

#check @neg_neg
#check Nat.pred_succ
```

当一个运算写成中缀形式时，定理名称也随之调整。例如，我们写 `neg_mul_neg` 而不是 `mul_neg_neg` 来描述模式 `-a * -b`。

有时，为了消除定理名称的歧义或更好地传达预期的参考，有必要描述一些假设。单词 "of" 用于分隔这些假设：

```lean
import Mathlib.Algebra.Order.Monoid.Lemmas

open Nat

#check lt_of_succ_le
#check lt_of_not_ge
#check lt_of_le_of_ne
#check add_lt_add_of_lt_of_le
```

假设是按它们出现的顺序列出的，而**不是**逆序。例如，定理 `A → B → C` 会被命名为 `C_of_A_of_B`。

有时缩写或替代描述更容易使用。例如，我们使用 `pos`、`neg`、`nonpos`、`nonneg` 而不是 `zero_lt`、`lt_zero`、`le_zero` 和 `zero_le`。

```lean
import Mathlib.Algebra.Order.Monoid.Lemmas
import Mathlib.Algebra.Order.Ring.Lemmas

open Nat

#check mul_pos
#check mul_nonpos_of_nonneg_of_nonpos
#check add_lt_of_lt_of_nonpos
#check add_lt_of_nonpos_of_lt
```

这些约定并不完美。它们无法区分直到结合律的复合表达式，或模式中的重复出现。对此，我们尽力而为。例如，`a + b - b = a` 可以被命名为 `add_sub_self` 或 `add_sub_cancel`。

有时单词 "left" 或 "right" 有助于描述定理的变体。

```lean
import Mathlib.Algebra.Order.Monoid.Lemmas
import Mathlib.Algebra.Order.Ring.Lemmas

open Nat

#check add_le_add_left
#check add_le_add_right
#check le_of_mul_le_mul_left
#check le_of_mul_le_mul_right
```

在不在同个命名空间中的引理名称中引用一个有命名空间的定义时，该定义应该移除其命名空间。如果该定义名在没有其命名空间的情况下是明确的，可以直接使用。否则，命名空间以 `lowerCamelCase` 的形式重新加到其前面。这是为了确保引理名称中由 `_` 分隔的字符串对应于一个定义名或连接词。
```lean
import Mathlib.Data.Int.Cast.Basic
import Mathlib.Data.Nat.Cast.Basic
import Mathlib.Topology.Constructions

#check Prod.fst
#check continuous_fst

#check Nat.cast
#check map_natCast
#check Int.cast_natCast
```

## 结构性引理的命名

我们正在努力标准化结构性引理的某些命名模式。

### 外延性 (Extensionality)

一个形如 `(∀ x, f x = g x) → f = g` 的引理应命名为 `.ext`，并用 `@[ext]` 属性标记。
通常这类引理可以通过将 `@[ext]` 属性放在结构体上来自动生成。
（然而，自动生成的引理总是用结构体投影来表示，而通常有更好的陈述，例如使用强制类型转换，应该手动编写然后用 `@[ext]` 标记。）

一个形如 `f = g ↔ ∀ x, f x = g x` 的引理应命名为 `.ext_iff`。

### 单射性 (Injectivity)

在可能的情况下，单射性引理应以 `Function.Injective f` 的结论形式编写，使用完整的单词 `injective`，通常命名为 `f_injective`。
形式 `injective_f` 在 mathlib 中仍然经常出现。

除此之外，通常还应提供一个双向蕴含的变体，例如 `f x = f y ↔ x = y`，这可以从 `Function.Injective.eq_iff` 得到。
此类引理应命名为 `f_inj`（但如果它们在适当的命名空间中，`.inj` 也是可以的）。
双向单射性引理通常是 `@[simp]` 的好候选。
mathlib 中仍有许多名为 `inj` 的单向蕴含，当您遇到它们时，更新和替换它们是合理的。

然而请注意，归纳类型的构造函数有自动生成的名为 `.inj` 的单向蕴含，没有计划改变这一点。
当这样一个自动生成的引理已经存在，并且需要一个双向引理时，可以将其命名为 `.inj_iff`。

一个使用 "left" 或 "right" 的单射性引理应该指的是“变化”的那个参数。例如，一个陈述为 `a - b = a - c ↔ b = c` 的引理可以称为 `sub_right_inj`。

### 归纳和递归原则

归纳/递归原则是为某个类型 `T` 的所有元素构造数据或证明的方法，通过提供在更受限的特定上下文中构造这些数据或证明的方法。
这些原则的表述应接受一个 `motive` 参数，它声明了我们正在为所有 `T` 证明的属性或构造的数据。
当 motive 消去到 `Prop` 时，它是一个归纳原则，名称应包含 `induction`。另一方面，当 motive 消去到 `Sort u` 或 `Type u` 时，它是一个递归原则，名称应包含 `rec`。

此外，当参数顺序中，值在构造之前时，名称应包含 `on`。

下表总结了这些命名约定：

| motive 消去到: | `Prop` | `Sort u` 或 `Type u` |
|-------------------------|------------------|----------------------|
| 值在前 | `T.induction_on` | `T.recOn` |
| 构造在前 | `T.induction` | `T.rec` |

当必要时（例如为了消除歧义），对这些名称的变体是可以接受的。

### 作为后缀的谓词

大多数谓词应作为前缀添加。例如 `IsClosed (Icc a b)` 应称为 `isClosed_Icc`，而不是 `Icc_isClosed`。

一些广泛使用的谓词不遵循此规则。这些是那些与命名约定中已经作为后缀的原语类似的谓词。以下是一个不完全的列表：
* 我们对 `f a = f b ↔ a = b` 使用 `_inj`，所以我们也对 `Injective f` 使用 `_injective`，对 `Surjective f` 使用 `_surjective`，对 `Bijective f` 使用 `_bijective`…
* 我们对 `a ≤ b → f a ≤ f b` 使用 `_mono`，对 `a ≤ b → f b ≤ f a` 使用 `_anti`，所以我们也对 `Monotone f` 使用 `_monotone`，对 `Antitone f` 使用 `_antitone`，对 `StrictMono f` 使用 `_strictMono`，对 `StrictAnti f` 使用 `_strictAnti` 等…

### Prop 值的类

Mathlib 有许多 `Prop` 值的类和其他定义。例如，“令 $R$ 是一个拓扑环”写成 `variable (R : Type*) [Ring R] [TopologicalSpace R] [IsTopologicalRing R]`，以及“令 $G$ 是一个群，令 $H$ 是一个正规子群”写成 `variable (G : Type*) [Group G] (H : Subgroup G) [Normal H]`。这里 `IsTopologicalRing R` 和 `Normal H` 不是额外的数据，而是我们已有数据上的额外假设。

Mathlib 目前正朝着以下针对这些 `Prop` 值的类的命名约定努力。如果这个类是一个名词，那么它的名字应该以 `Is` 开头。然而，如果它是一个形容词，那么它的名字就不需要以 `Is` 开头。因此，例如 `IsNormal` 对于“正规子群”类型类是可接受的，但 `Normal` 也可以；我们在非正式语言中可能会说“假设子群 `H` 是正规的”。然而，对于“拓扑环”类型类，`IsTopologicalRing` 更受青睐，因为我们非正式地不会说“假设环 `R` 是拓扑的”。

### 函数的未展开和展开形式

两个函数 `f` 和 `g` 的乘积可以等价地表示为 `f * g` 或 `fun x ↦ f x * g x`。这些表达式在定义上是相等的，但在句法上不是（并且它们在索引树中没有相同的键），这意味着像 `rw`、`fun_prop` 或 `apply?` 这样的工具不会在一个形式的表达式上使用另一个形式的定理。因此，有时拥有使用这两种形式的陈述变体是很方便的。如果需要区分它们，涉及第一种未展开形式的陈述仅使用 `mul`，而使用第二种展开形式的陈述则应使用 `fun_mul`。如果因为一个引理只使用展开形式而无需区分，则不需要前缀 `fun_`。

例如，两个连续函数的乘积是连续的这一事实是
```lean
theorem Continuous.fun_mul (hf : Continuous f) (hg : Continuous g) : Continuous fun x ↦ f x * g x
```
和
```lean
theorem Continuous.mul (hf : Continuous f) (hg : Continuous g) : Continuous (f * g)
```
两个定理都应该用 `fun_prop` 属性标记。

对于函数的加法、减法、取反、幂和复合也是如此。