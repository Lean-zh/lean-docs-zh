# Lean 中的数学：拓扑空间、一致空间与度量空间

`TopologicalSpace` 类型类 (typeclass) 定义在 mathlib 的 `Mathlib.Topology.Defs.Basic` 中。`topology` 中有大量的代码，涵盖了拓扑空间、连续函数、拓扑群与拓扑环，以及无穷和的基础知识。本文档仅关注 `Mathlib.Topology` 文件夹的内容。

### 基本类型类

`TopologicalSpace` 类型类是一个归纳类型 (inductive type)，它以一种显而易见的方式被定义为一个类型 `α` 上的结构：有一个 `IsOpen` 谓词 (predicate)，告诉我们一个 `U : Set α` 何时是开集，然后是拓扑的公理（一个严谨的注记：空集是开集的公理被省略了，因为它由“开集的并集是开集”这一事实应用于空并集而得到！）。

请注意，形式化“任意开集的并集是开集”这一公理有两种方式：一种是要求给定一个开集构成的集合，它们的并集是开集；另一种是要求给定一个从某个索引集 `I` 到开集集合的函数，该函数值的并集是开集。Mathlib 采用了第一种方式，所以其公理是

```lean
isOpen_sUnion : ∀ (s : Set (set α)), (∀ t ∈ s, IsOpen t) → IsOpen (⋃₀ s)
```

然后，索引集版本是一个引理：

```lean
lemma isOpen_biUnion {f : ι → Set α} {s : Set ι} (h : ∀ i ∈ s, IsOpen (f i)) : IsOpen (⋃ i ∈ s, f i)
```

注意命名约定，这在 mathlib 中是标准的：`sUnion` 是对集合的并集，而 `biUnion` 是对一个函数在索引集上像的并集。大写的 U 是为了表示任意大小的并集，与 `union` 相对，后者表示两个集合的并集：

```lean
lemma IsOpen.union (h₁ : is_open s₁) (h₂ : is_open s₂) : is_open (s₁ ∪ s₂)
```

谓词 `IsClosed`，以及函数 `interior`（内部）、`closure`（闭包）和 `frontier`（闭包减去内部，在数学中有时称为边界 (boundary)）都被定义了，并且它们的基本性质也得到了证明。例如

```lean
import Mathlib.Topology.Basic


open TopologicalSpace
variable {X : Type} [TopologicalSpace X] {U V C D Y Z : Set X}

example : IsClosed C → IsClosed D → IsClosed (C ∪ D) := IsClosed.union

example : IsOpen Cᶜ ↔ IsClosed C := isOpen_compl_iff

example : IsOpen U → IsClosed C → IsOpen (U \ C) := IsOpen.sdiff

example : interior Y = Y ↔ IsOpen Y := interior_eq_iff_isOpen

example : Y ⊆ Z → interior Y ⊆ interior Z := interior_mono

example : IsOpen Y ↔ ∀ x ∈ Y, ∃ U ⊆ Y, IsOpen U ∧ x ∈ U := isOpen_iff_forall_mem_open

example : closure Y = Y ↔ IsClosed Y := closure_eq_iff_isClosed

example : closure Y = (interior Yᶜ)ᶜ := closure_eq_compl_interior_compl
```

### 滤子 (Filters)

在 mathlib 中，与典型的数学教科书方法不同，滤子 (filters) 被广泛用作拓扑空间理论中的一个工具。让我们简要回顾一下数学中滤子的概念。一个集合 `X` 上的滤子是一个非空的 `X` 的子集集合 `F`，它满足以下两个公理：

1) 如果 `U ∈ F` 且 `U ⊆ V`，那么 `V ∈ F`；以及
2) 如果 `U, V ∈ F` 那么存在 `W ∈ F` 使得 `W ⊆ U ∩ V`。

通俗地讲，可以把 `F` 看作是 `X` 的“大”子集的集合。例如，如果 `X` 是一个集合，`F` 是 `X` 的子集 `Y` 的集合，使得 `X \ Y` 是有限的，那么 `F` 就是一个滤子。这被称为 `X` 上的**余有限滤子 (cofinite filter)**。

注意，如果一个滤子 `F` 包含空集，那么根据第一条公理，它就包含 `X` 的所有子集。这个滤子有时被称为“底 (bottom)”（我们稍后会看到原因）。有些文献要求滤子中不允许包含空集——Lean 没有这个限制。不包含空集的滤子有时被称为“真滤子 (proper filter)”。

如果 `X` 是一个拓扑空间，`x ∈ X`，那么 `x` 的**邻域滤子 (neighborhood filter)** `𝓝 x` 是 `X` 的子集 `Y` 的集合，使得 `x` 在 `Y` 的内部。可以轻松地检验这是一个滤子（技术要点：要看出这实际上是 mathlib 中 `𝓝 x` 的定义，了解一个类型上所有滤子的集合是一个全格 (complete lattice)，其偏序关系为 `F ≤ G` 当且仅当 `G ⊆ F` 会有所帮助，所以这个定义，它涉及到一个下确界 (inf)，实际上是一个并集；另外，我给出的定义并非字面上 mathlib 中的定义，但 `lemma mem_nhds_iff` 表明它们的定义与此相同。还要注意，这就是为什么拥有最多集合的滤子被称为底！）。

我们为什么对这些滤子感兴趣？嗯，给定一个从 `ℕ` 到拓扑空间 `X` 的映射 `f`，可以检验得到的序列 `f 0`、`f 1`、`f 2`... 趋向于 `x ∈ X` 当且仅当滤子 `𝓝 x` 中任意元素的原像在 `ℕ` 上的余有限滤子中——这只是说，给定任意包含 `x` 的开集 `U`，存在 `N` 使得对于所有 `n ≥ N`，`f n ∈ U` 的另一种方式。所以滤子提供了一种思考极限的方式。

例如，下面是在 Lean 中表述的三个极限。
这个例子使用了滤子 `atTop` 和 `atBot`，它们在配备了序的类型中分别代表“趋向于 `∞`”和“趋向于 `-∞`”。

```lean
open Filter Topology

-- The limit of `2 * x` as `x` tends to `3` is `6`
example : Tendsto (fun x : ℝ ↦ 2 * x) (𝓝 3) (𝓝 6) := sorry
-- The limit of `1 / x` as `x` tends to `∞` is `0`
example : Tendsto (fun x : ℝ ↦ 1 / x) atTop (𝓝 0) := sorry
-- The limit of `x ^ 2` as `x` tends to `-∞` is `∞`
example : Tendsto (fun x : ℝ ↦ x ^ 2) atBot atTop := sorry
```

附着于集合 `X` 的子集 `Y` 的**主滤子 (principal filter)** `Filter.principal Y` 是 `X` 中所有包含 `Y` 的子集的集合。所以不难说服自己，以下结果应该是正确的：

```lean
variable (X : Type) [TopologicalSpace X] (Y : Set X)

example : interior Y = {x | 𝓝 x ≤ Filter.principal Y} := interior_eq_nhds

example : IsOpen Y ↔ ∀ y ∈ Y, Y ∈ (𝓝 y).sets := isOpen_iff_eventually
```

### 使用滤子定义紧致性

由于采用了以滤子为中心的方法，mathlib 中的一些定义对于不习惯这种方法的数学家来说可能看起来相当奇怪。
我们已经看到了一个使用滤子来定义序列趋向于极限的定义。
紧致性 (compactness) 的定义也是用滤子理论的术语来写的：

```lean
/-- A set `s` is compact if for every nontrivial filter `f` that contains `s`,
    there exists `a ∈ s` such that every set of `f` meets every neighborhood of `a`. -/
/-- 一个集合 `s` 是紧致的，如果对于每个包含 `s` 的非平凡滤子 `f`，
    存在一个 `a ∈ s`，使得 `f` 中的每个集合都与 `a` 的每个邻域相交。 -/
def IsCompact (s : Set X) :=
  ∀ ⦃f⦄ [NeBot f], f ≤ 𝓟 s → ∃ x ∈ s, ClusterPt x f
```

翻译过来，这表示拓扑空间 `X` 的一个子集 `Y` 是紧致的，如果对于 `X` 上的每一个真滤子 `F`，如果 `Y` 是 `F` 的一个元素，那么存在一个 `Y` 的元素 `y`，使得包含 `F` 和 `y` 的邻域滤子的最小滤子也不是 `X` 的所有子集的滤子。这应该被看作是 Bolzano-Weierstrass 定理的正确推广，即在 `ℝ^n` 的紧致子空间中，任何序列都有一个收敛子序列。

人们可能会问为什么选择了这个紧致性的定义，而不是标准的关于开覆盖有有限子覆盖的定义。其原因在某种意义上是计算机科学的而非数学的——问题不应该是最终选择了哪个定义（实际上，开发者应该可以自由选择任何他们喜欢的定义，只要它在逻辑上等同于通常的定义，他们可能有与非数学点（如运行时间）相关的理由），问题应该是如何证明内置的定义与你实践中想要使用的定义是等价的。幸运的是，我们有

```lean
example : IsCompact Y ↔ ∀ {ι : Type} (U : ι → Set X),
      (∀ i, IsOpen (U i)) → (Y ⊆ ⋃ i, U i) → ∃ t : Finset ι, Y ⊆ ⋃ i ∈ t, U i :=
    isCompact_iff_finite_subcover
```

所以 Lean 的定义与标准的定义是等价的。

### 豪斯多夫空间 (Hausdorff spaces)

在 Lean 中，他们选择了术语 `T2Space` 来表示豪斯多夫（也许因为它更短！）。

```lean
class T2Space (X : Type u) [TopologicalSpace X] : Prop where
  /-- Every two points in a Hausdorff space admit disjoint open neighbourhoods. -/
  /-- 在豪斯多夫空间中，任意两点都存在不相交的开邻域。-/
  t2 : Pairwise fun x y => ∃ u v : Set X, IsOpen u ∧ IsOpen v ∧ x ∈ u ∧ y ∈ v ∧ Disjoint u v
```

当然，豪斯多夫性是确保极限唯一性所必需的，但因为极限是使用滤子定义的，所以这个陈述最终读起来如下：

```lean
lemma tendsto_nhds_unique [T2Space X] {f : β → X} {l : Filter β} {x y : X}
  [l.NeBot] (hx : Tendsto f l (𝓝 x)) (hb : Tendsto f l (𝓝 y)) : x = y
```

注意，实际上这个陈述比经典的“如果一个序列在豪斯多夫空间中趋向于两个极限，那么这两个极限相同”的陈述更具一般性，因为它适用于任何集合上的任何非平凡滤子，而不仅仅是自然数上的余有限滤子。

### 拓扑的基 (Bases for topologies)

如果 `X` 是一个**集合**，`S` 是 `X` 的子集的一个集合，那么可以考虑由 `S`“生成”的拓扑，这（在这些情况下很典型）可以用两种方式定义：首先是 `X` 上所有包含 `S` 的拓扑的交集（这里我们将拓扑等同于其底层的开集集合），或者更构造性地，作为使用拓扑空间公理由 `S`“生成”的集合。
不出所料，Lean 中使用的是后一种定义，因为开集自然地是一个归纳类型；开集被称为 `generate_open S`，拓扑是 `generate_from S`。

mathlib 中拓扑基的定义包含一个公理，即拓扑是由上述意义上的基生成的，这可能使终端用户难以直接证明一个给定的集合满足该定义。然而，我们又有一个定理，它将我们简化为检查基的两个通常的公理：

```lean
example (B : Set (Set X)) (h_open : ∀ V ∈ B, IsOpen V)
  (h_nhds : ∀ (x : X) (U : Set X), x ∈ U → IsOpen U → ∃ V ∈ B, x ∈ V ∧ V ⊆ U) :
IsTopologicalBasis B :=
isTopologicalBasis_of_isOpen_of_nhds h_open h_nhds
```

### 其他内容

还有其他涉及滤子的内容，有可分空间 (separable)、第一可数空间 (first-countable) 和第二可数空间 (second-countable spaces)、乘积空间 (product spaces)、子空间 (subspace) 和商拓扑 (quotient topologies)（以及更一般的拓扑的拉回 (pull-back) 和前推 (push-forward)），以及像 T1 和 T3 空间这样的东西。

## 文件组织

以下“核心”模块形成了一个线性的导入链。一个涉及在这些文件中定义的多个概念的定理应该在该排序中最后一个这样的文件中找到。

* `Mathlib.Topology.Basic`
  拓扑空间。开集与闭子集、内部、闭包与边界。邻域滤子。滤子的极限。局部有限族。连续性与点连续性。
* `Mathlib.Topology.Order.Basic`
  固定集合上拓扑的全格结构。诱导拓扑与余诱导拓扑。
* `maps`
  开映射与闭映射。“诱导”映射。嵌入、开嵌入与闭嵌入。商映射。
* `Mathlib.Topology.Constructions`
  从旧的拓扑空间构建新的拓扑空间：乘积、和、子空间与商。
* `Mathlib.Topology.Separation`
  分离公理 T₀ 到 T₄，也分别称为 Kolmogorov、Tychonoff 或 Fréchet、Hausdorff、正则和正规空间。

其余一些目录和文件，无特定顺序：

* `Mathlib.Topology.Algebra`
  具有相容代数或有序结构的拓扑空间。
* `Mathlib.Topology.Category`
  拓扑空间、一致空间等的范畴。
* `Mathlib.Topology.Instances`
  特定的拓扑空间，如实数和复数。
* `Mathlib.Topology.MetricSpace`
  度量空间的理论；但一些人们可能期望在这里找到的概念被推广到了一致空间。
* `Mathlib.Topology.Sheaves`
  拓扑空间上的预层 (Presheaves)。
* `Mathlib.Topology.UniformSpace`
  一致空间的理论，包括完备性、一致连续性和全有界集等概念。
* `Mathlib.Topology.Bases`
  滤子和拓扑空间的基。可分、第一可数和第二可数空间。
* `Mathlib.Topology.CompactOpen`
  两个拓扑空间之间连续映射空间上的紧开拓扑。
* `Mathlib.Topology.ContinuousOn`
  子集内的邻域。子集上的连续性，以及子集内一点的连续性。
* `Mathlib.Topology.DenseEmbedding`
  嵌入和其他像稠密的函数。
* `Mathlib.Topology.Homeomorph`
  拓扑空间之间的同胚 (Homeomorphisms)。
* `Mathlib.Topology.List`
  列表和向量上的拓扑。
* `Mathlib.Topology.Sequences`
  序列闭包和序列空间。序列连续函数。
* `Mathlib.Topology.StoneCech`
  拓扑空间的 Stone-Čech 紧化。