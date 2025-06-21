# Lean 中的数学：集合与类集对象

### 列表 (Lists)

#### `Mathlib.Data.List.Basic`

`List α` 是类型 `α` 的元素组成的列表类型。列表是有限且有序的，并且可以包含重复元素。列表只能包含相同类型的元素。列表是使用 cons 函数构造的，该函数将一个 `α` 类型的元素附加到列表的开头。列表在 TPIL 第 7.5 章中有更详细的讨论。

`[1, 1, 2, 4] ≠ [1, 2, 1, 4]`

`[1, 2, 1, 4] ≠ [1, 2, 4]`

### 多重集 (Multisets)

#### `Mathlib.Data.Multiset.Basic`

`Multiset α` 是类型为 `α` 的元素的多重集类型。多重集是有限的，可以包含重复元素，但是无序的。它们被定义为列表在 `Perm` 等价关系下的商。多重集只能包含相同类型的元素。

`{1, 1, 2, 4} = {1, 2, 1, 4}`

`{1, 1, 2, 4} ≠ {1, 2, 4}`

### 有限集 (Finsets)

#### `Mathlib.Data.Finset.Basic`

`Finset α` 是类型 `α` 的无序、不重复元素的列表类型。一个有限集是由一个多重集和一个该多重集不含重复元素的证明构造的。有限集是有限的。有限集只能包含相同类型的元素。

`{1, 1, 2, 4} = {1, 2, 1, 4}`

`{1, 1, 2, 4} = {1, 2, 4}`

### 集合与子类型 (Sets and subtypes)

#### `Mathlib.Data.Set.Basic`

`Set α`。一个集合被定义为一个谓词 (predicate)，即一个函数 `α → Prop`。使用的记法是 `{n : ℕ | 4 ≤ n}`，表示大于或等于 4 的自然数集合。集合可以是无限的，并且只能包含相同类型的元素。

子类型 (subtype) 与集合相似，因为它也是由一个谓词定义的。使用的记法是 `{n : ℕ // 4 ≤ n}`，表示大于或等于 4 的自然数类型。然而，子类型是一个类型而不是一个集合，前面提到的子类型的元素类型不是 `ℕ`，而是 `{n : ℕ // 4 ≤ n}`。这意味着在这个类型上没有定义加法，自然数和这个类型之间的相等性也未定义。但是，可以将这个子类型的元素强制转换 (coerce) 回自然数，就像自然数可以被强制转换为整数一样，然后加法和相等性的行为就和正常一样（关于强制转换的更多内容，请参见 TPIL 第 6.7 章）。要构造一个 `α` 的子类型的元素，你需要一个 `α` 的元素和一个它满足谓词的证明，在下面的例子中是 `4` 和 `le_refl 4`。

```lean
def x : {n : ℕ // 4 ≤ n} := ⟨4, le_refl 4⟩
example : (x : ℕ) + 6 = 10 := rfl
```

任何集合都可以在期望一个类型的地方使用，在这种情况下，该集合将被强制转换为相应的子类型。

```lean
def S : Set ℕ := {n : ℕ | 4 ≤ n}
example : ∀ n : S, 4 ≤ (n : ℕ) := fun ⟨n, hn⟩ ↦ hn
```

当需要在子类型上定义函数，或使用子类型的基数 (cardinal) 时，使用子类型比使用集合更有用。

### 有限类型 (Finite types)

#### `Mathlib.Data.Fintype.Basic`

`Fintype α` 意味着类型 `α` 是有限的。它是由一个包含该类型所有元素的有限集构造的。

```lean
class Fintype (α : Type*) where
  /-- The `Finset` containing all elements of a `Fintype` -/
  elems : Finset α
  /-- A proof that `elems` contains every element of the type -/
  complete : ∀ x : α, x ∈ elems
```

`Fintype α` 不是一个命题 (proposition)，因为它包含数据，但它是一个单例 (subsingleton)，意味着任何两个 `Fintype α` 类型的元素都是相等的。

`Finset.univ` 是包含一个类型所有元素的有限集，前提是有一个 `Fintype α` 实例。

### 有限集合 (Finite sets)

#### `Mathlib.Data.Set.Finite`

有限集合，与有限集不同，其定义是相应的类型与某个 `n : ℕ` 的 `Fin n` 存在双射 (bijection)。
这意味着当该集合被强制转换为子类型时，类型 `Fintype s` 是非空的。
使用 `Classical.choose`，你可以从 `Finite s` 的一个证明中产生一个 `Fintype s` 类型的对象。有一个函数 `Set.Finite.toFinset` 可以从一个有限集合中产生一个有限集。

### 基数 (Cardinals)

有三个函数 `Finset.card`、`Fintype.card` 和 `Multiset.card`，分别指有限集、有限类型和多重集的大小。对于集合的有限基数，可以使用 `Fintype.card`，前提是有一个证明该集合是有限的。

```lean
example : ∀ n : ℕ, Fintype.card (Fin n) = n := Fintype.card_fin
example : ∀ n : ℕ, Finset.card (Finset.range n) = n := Finset.card_range
```

这里，`Fin n` 是小于 `n` 的自然数的类型，`Finset.range n` 是小于 `n` 的自然数的有限集。

`Mathlib.SetTheory.Cardinal.Basic` 包含了关于无限基数 (infinite cardinals) 的理论。