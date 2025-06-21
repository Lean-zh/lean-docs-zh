# Lean 中的数学：范畴论

`Category` 类型类 (typeclass) 定义在 [`Mathlib.CategoryTheory.Category.Basic`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/CategoryTheory/Category/Basic.html)。
它依赖于对象的类型，因此，例如，如果我们讨论的是一个其对象为类型（在 universe `u` 中）的范畴，我们可能会写成 `Category (Type u)`。

函子 (Functors)（它是一个结构体，而不是类型类）定义在 [`Mathlib.CategoryTheory.Functor.Basic`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/CategoryTheory/Functor/Basic.html) 中，
以及单位函子 (identity functors) 和函子复合 (functor composition)。

自然变换 (Natural transformations) 及其复合定义在 [`Mathlib.CategoryTheory.NatTrans`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/CategoryTheory/NatTrans.html) 中。

在固定的范畴 `C` 和 `D` 之间，由函子和自然变换构成的范畴定义在 [`Mathlib.CategoryTheory.Functor.Category`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/CategoryTheory/Functor/Category.html) 中。

范畴、函子和自然变换的笛卡尔积 (Cartesian products) 出现在 [`Mathlib.CategoryTheory.Products.Basic`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/CategoryTheory/Products/Basic.html) 中。

类型范畴 (category of types) 以及 hom 配对函子 (hom pairing functor) 定义在 [`Mathlib.CategoryTheory.Types`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/CategoryTheory/Types.html) 中。

## 记法

### 范畴

我们使用 `⟶` (`\hom`) 箭头来表示态射 (morphisms) 的集合，如 `X ⟶ Y`。
这使得实际的范畴是隐式的；它通过类型类推断 (typeclass inference) 从 `X` 和 `Y` 的类型中推断出来。

我们使用 `𝟙` (`\b1`) 来表示单位态射 (identity morphisms)，如 `𝟙 X`。

我们使用 `≫` (`\gg`) 来表示态射的复合，如 `f ≫ g`，表示“先 `f` 后 `g`”。
你可能更喜欢用常规的约定来写复合，使用 `⊚` (`\oo` 或 `\circledcirc`)，如 `f ⊚ g`，表示“先 `g` 后 `f`”。为此，你需要通过以下方式局部地添加此记法：

```lean
local notation f ` ⊚ `:80 g:80 := category.comp g f
```

### 同构

我们使用 `≅` 表示同构 (isomorphisms)。

### 函子

我们使用 `⥤` (`\func`) 来表示函子，如 `C ⥤ D` 表示从 `C` 到 `D` 的函子类型。

我们使用 `F.obj X` 表示函子在对象上的作用。
我们使用 `F.map f` 表示函子在态射上的作用。

函子复合可以写为 `F ⋙ G`。

### 自然变换

我们使用 `τ.app X` 表示自然变换的分量 (components)。

在其他方面，我们主要使用任何范畴中态射的记法：

我们使用 `F ⟶ G` (`\hom` 或 `-->`) 来表示函子 `F` 和 `G` 之间的自然变换类型。
我们使用 `F ≅ G` (`\iso`) 来表示自然同构 (natural isomorphisms) 的类型。

对于自然变换的垂直复合 (vertical composition)，我们只使用 `≫`。对于水平复合 (horizontal composition)，使用 `hcomp`。