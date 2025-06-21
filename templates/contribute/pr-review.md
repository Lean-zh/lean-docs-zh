# 拉取请求 (Pull Request) 审查指南

本指南详细介绍了如何为 mathlib 进行 PR 审查。您可能会想，这份指南是否适用于我，答案是“是的！”

虽然 mathlib 维护者是唯一有权**合并**拉取请求的用户，但我们欢迎，甚至鼓励每个人来**审查**拉取请求。（注意：实际上还有另一类人，即 mathlib **审查者**，他们已经证明了自己能提供有价值的 PR 审查；来自这些用户的带有 `maintainer merge` 的批准审查会被维护者更快地合并）。

拥有提供有益审查的历史是成为 mathlib 审查者或 mathlib 维护者团队成员的关键标准。

本指南首先是一般的[审查指南](#guidelines-for-review)，然后是对审查者应考虑事项的高层次[概述](#what-to-consider-when-reviewing)，最后聚焦于一些实践性的[示例](#examples)。

虽然本指南相当长，但在开始审查之前并不需要完全理解所有内容。部分审查本身也是有帮助的，随着您对 Lean 和 mathlib 理解的加深，您可以逐步学习各种考量因素。

## 审查指南

### 尊重与鼓励

与 mathlib 社区中的所有互动一样，请务必遵守[行为准则](https://www.contributor-covenant.org/version/2/0/code_of_conduct/)。
简而言之，要互相尊重。然而，在审查时，请务必同时也要**鼓励**他人。大多数贡献者只提交过少数几个拉取请求，这甚至可能是他们的第一个！因此，避免像“这个结果没用，我们已经有它的一个版本了”这样的评论非常重要。相反，您可以更温和地说，例如：“感谢您证明了这一点，但我想我们已经有一个具有此效果的引理了。它是 `my_generic_lemma`。请尝试使用那个。” 即使在指出改进空间的同时，也要努力发现他们所做工作中的优点。

### 谦逊

我们中没有人是完美的，包括 mathlib 维护者，也没有人对最佳实践有垄断权。因此，审查者应始终为他人提出更好的方法留有余地。此外，认识到**您可能是错的**并允许这种可能性很重要。当然，完美是优秀的敌人，所以没有必要无限期地等待更好的方法或新想法。

## 审查时应考虑的事项

审查本质上是审视代码并向自己提问。
基础性问题，大致按从易到难的顺序排列是：风格、文档、位置、改进和库集成。

请注意，新的审查者当然有能力对前两三个问题发表评论，而回答关于库集成的问题通常需要几个月的时间来熟悉 mathlib 并参与审查过程。

以下是您作为审查者可以问自己的一些明确问题。
这只是一个大纲；在后面的部分中，我们将通过示例更详细地探讨每个问题。

- [是否遵循风格？](#style)
    + [代码格式化](style.html)
    + [命名约定](naming.html)
    + [PR 标题和描述](commit.html)是否提供了足够的信息？
- [是否有有用的文档？](#documentation)
    + 定义是否有足够信息量的文档字符串 (docstring)？
    + 是否有对相关声明的交叉引用？
    + 复杂的证明中是否穿插了注释形式的草图？
    + 重要的定理是否有文档字符串？
    + 当代码只能以特定方式使用时，是否对用户有警告？
    + 它是否正在形式化文献中的某些内容？
- [位置，位置，位置](#location)
    + 声明是否位于合适的文件中？
      [`#find_home`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/Util/Imports.html#«command#find_home_») 在这里可能很有用。
    + 结果是否已经存在？可能以更通用的形式用不同的名称存在？
      `apply?` 或 `exact?` 策略有时可以帮助回答这个问题。
    + 是否引入了新的 `import`？如果是，它们是否为此文件导入了过多的材料？
    + 是否应将某些结果放入新文件中以最小化导入需求？
    + 文件是否因为过长（例如，> 1000行）或涉及太多不同主题而应被拆分成多个部分？
- [是否有明显的改进可以做？](#improvements)
    + 是否可以将某些部分拆分为辅助引理或定义（特别是对于长证明）？
    + 是否可以使用不同/更好的策略来提高可读性（例如，使用 `gcongr`
      而不是 `mul_le_mul_of_nonneg_left`）？
      注意：代码精简 (code golfing) 是可以的，只要它**不牺牲可读性**，尽管精简琐碎的结果通常是可以的。
    + 不同的证明结构是否能极大地简化论证？
    + 引入的定义是否是形式化该概念的最佳方式（非常困难！）？
- [它是否推进或改进了库？](#library-integration)
    + 它是否提供了一个合理的 API？
    + 它是否足够通用以支持已知的未来需求？
    + 它是否符合 mathlib 的设计和集体愿景？
- 更具体的考虑
    + 声明是否使用 `α β : Type*` 而不是 `α β : Type _` 来指代任意的 universe level？
      （注意：这是一个性能问题，因为使用 `Type _` 会引入需要解决的类型合一问题。）
    + 引理是否在应该的地方被标记了 `@[simp]`、`@[ext]` 等等？或者不应该被标记？
    + 新定义是否附带了关于它们的引理（也许只是那些由 `@[simps]` 生成的）？
    + 新声明的实例是否会产生菱形问题 (diamond)？非定义性相等或非命题性相等？

## 示例

本指南的其余部分致力于思考审查过程中的虚构和真实世界的示例。我们尝试为上述每个问题提供示例。真实世界示例中涉及的各方已被征求同意将其包含在本风格指南中。

并非每个问题都有对应的示例，但我们尝试至少为每种情况提供关于应考虑事项的讨论。

### 风格

#### 代码格式化

```lean
-- 不要用这种风格写代码！
theorem mul_assoc_assoc {α : Type*} [Semigroup α] (a b c d : α)
: a*b*c*d=a*(b*(c*d)) :=
by
rw [mul_assoc,
    mul_assoc]
```

上面的代码违反了几个格式化准则：二元运算符周围没有空格，行以 `:` 开头而不是在前一行的末尾结束，`by` 应该移到前一行而不是单独一行（一个风格 linter 无论如何都应该在 CI 中捕捉到这一点），并且 `rw` 策略被不必要地分成了多行。

在这种情况下，PR 的作者由于违反了如此多的风格准则，可能是一个新的贡献者，不熟悉或不记得风格指南。一个合适的审查评论应该是这样的：

````markdown
如果您还不了解，请熟悉一下 mathlib 的
[风格指南](https://leanprover-community.github.io/contribute/style.html)。
您需要在 `*` 周围添加空格，将 `:` 放在行尾，并且将 `rw` 放在同一行。
```suggestion
theorem mul_assoc_assoc {α : Type*} [Semigroup α] (a b c d : α) :
    a * b * c * d = a * (b * (c * d)) := by
  rw [mul_assoc, mul_assoc]
```
````

#### 命名约定

```lean
theorem inv_is_unit_times_self_eq_1 {M : Type*} [Monoid M] {a : M} (h : IsUnit a) :
    ↑(IsUnit.unit h)⁻¹ * a = 1 := sorry
```

上面的引理直接取自库，您能猜出它的实际名称吗？
它是 `IsUnit.inv_val_mul`。一个建议新名称的合适审查可能会是这样：

````markdown
为了符合 mathlib 的
[命名约定](https://leanprover-community.github.io/contribute/naming.html)，
我建议将其重命名为：`IsUnit.inv_val_mul`。请注意：

- 我们使用 `mul` 而不是 `times`，以及 `one` 而不是 `1`
- 没有对 `1` 的引用，引理也足够清晰
- 如果我们引用一个 `IsUnit` 假设，我们会用 `isUnit`，而不是 `is_unit`
- 然而，由于我们有一个 `IsUnit` 假设，将其放在 `IsUnit.`
  命名空间中允许使用点表示法。
- 我们应该引用这里出现的强制类型转换，即 `Subtype.val`，因此
  建议的名称中有 `val`。
````

这为 PR 作者提供了一个命名约定的链接，以防他们还没有看过，但同时也指出了具体问题，这样他们就不必再通读整个指南。如果他们在命名约定中只犯了一个错误，这可能也很有帮助。

注意：并非所有声明都有一个完全合适的名称，可能会有几个，每个都有其优缺点。

#### PR 标题和描述是否提供了足够的信息？

考虑以下 PR 标题和描述：

```markdown
Title: feat(Analysis/SpecificLimits)
Description: Where should we put these lemmas?
```

这有两个问题：标题没有提供任何关于更改的信息，而描述包含了一个讨论性问题，而不是关于更改的信息。一个合理的审查评论可能是：

```markdown
请更新 PR 标题和描述，使其更能说明您添加或更改了什么，因为当这个 PR 被合并时，这些信息将被永久包含在 git 历史中。问题或讨论主题是允许出现在 PR 描述中的，但应该放在 `---` 之后，这样它们将被视为评论而不会被包含在 git 历史中。
```

当然，您可以提供建议，甚至自己更新 PR 标题和描述，但您可能希望指出这一点，特别是如果 PR 作者是相对较新的贡献者。

### 文档

#### 定义是否有足够信息量的文档字符串？

`docBlame` linter 应该能确保用户为他们所有的定义添加文档字符串。然而，仅仅因为一个文档字符串**存在**并不一定意味着它**有用**和**准确**。审查者应尽力确保所提供的文档字符串以易于理解的方式准确描述了该 `def`。

#### 重要的定理是否有文档字符串？

以下示例引用了 [#5580](https://github.com/leanprover-community/mathlib4/pull/5580/files) 中的审查。
在该 PR 中，添加了以下定理：

```lean
protected theorem _root_.WithSeminorms.equicontinuous_TFAE {κ : Type*}
    {q : SeminormFamily 𝕜₂ F ι'} [UniformSpace E] [UniformAddGroup E] [u : UniformSpace F]
    [hu : UniformAddGroup F] (hq : WithSeminorms q) [ContinuousSMul 𝕜 E]
    (f : κ → E →ₛₗ[σ₁₂] F) : TFAE
    [ EquicontinuousAt ((↑) ∘ f) 0,
      Equicontinuous ((↑) ∘ f),
      UniformEquicontinuous ((↑) ∘ f),
      ∀ i, ∃ p : Seminorm 𝕜 E, Continuous p ∧ ∀ k, (q i).comp (f k) ≤ p,
      ∀ i, BddAbove (range fun k ↦ (q i).comp (f k)) ∧ Continuous (⨆ k, (q i).comp (f k)) ] :=
  sorry
```

这个定理很有用，但也有点长，需要时间来（对人类）解析。因此，它可能应该有一个文档字符串，这导致了[以下评论](https://github.com/leanprover-community/mathlib4/pull/5580/files#r1286511394)

```markdown
请您添加一个文档字符串来解释这个定理的陈述，并添加一个到 `NormedSpace.equicontinuous_TFAE` 的交叉引用好吗？
```

然后，PR 作者用以下信息丰富的文档字符串更新了该定理，我们可以看到这里增加了巨大的价值：

```lean
/-- Let `E` and `F` be two topological vector spaces over a `NontriviallyNormedField`, and assume
that the topology of `F` is generated by some family of seminorms `q`. For a family `f` of linear
maps from `E` to `F`, the following are equivalent:
* `f` is equicontinuous at `0`.
* `f` is equicontinuous.
* `f` is uniformly equicontinuous.
* For each `q i`, the family of seminorms `k ↦ (q i) ∘ (f k)` is bounded by some continuous
  seminorm `p` on `E`.
* For each `q i`, the seminorm `⊔ k, (q i) ∘ (f k)` is well-defined and continuous.
In particular, if you can determine all continuous seminorms on `E`, that gives you a complete
characterization of equicontinuity for linear maps from `E` to `F`. For example `E` and `F` are
both normed spaces, you get `NormedSpace.equicontinuous_TFAE`. -/
/-- 设 `E` 和 `F` 是 `NontriviallyNormedField` 上的两个拓扑向量空间，并假设 `F` 的拓扑是由某个半范数族 `q` 生成的。对于一个从 `E` 到 `F` 的线性映射族 `f`，以下各项是等价的：
* `f` 在 `0` 点是等度连续的。
* `f` 是等度连续的。
* `f` 是一致等度连续的。
* 对于每个 `q i`，半范数族 `k ↦ (q i) ∘ (f k)` 被某个 `E` 上的连续半范数 `p` 所界定。
* 对于每个 `q i`，半范数 `⊔ k, (q i) ∘ (f k)` 是良定义且连续的。
特别地，如果您能确定 `E` 上的所有连续半范数，那就为您提供了从 `E` 到 `F` 的线性映射的等度连续性的完整刻画。例如，如果 `E` 和 `F` 都是赋范空间，您就得到了 `NormedSpace.equicontinuous_TFAE`。 -/
```

#### 是否有对相关声明的交叉引用？

请参见前一个示例，其中请求了对一个相关声明的交叉引用。

#### 复杂的证明中是否穿插了注释形式的草图？

在这个例子中，我们只展示一个现有示例，说明穿插的注释如何能显著增加 Lean 中证明的价值。这直接从 [Gromov_Hausdorff.GH_space.topological_space.second_countable_topology](https://leanprover-community.github.io/mathlib_docs/topology/metric_space/gromov_hausdorff.html#Gromov_Hausdorff.GH_space.topological_space.second_countable_topology) 的源代码复制而来。

每当一个复杂的证明没有像这样被文档化时，请鼓励 PR 作者这样做。您可以向他们指出这段代码。另一个合适的、不那么复杂的例子可以在 [banach_steinhaus](https://leanprover-community.github.io/mathlib_docs/analysis/normed_space/banach_steinhaus.html#banach_steinhaus) 的源代码中找到。

```
/-- The Gromov-Hausdorff space is second countable. -/
/-- Gromov-Hausdorff 空间是第二可数的。 -/
instance : second_countable_topology GH_space :=
begin
  refine second_countable_of_countable_discretization (λ δ δpos, _),
  let ε := (2/5) * δ,
  have εpos : 0 < ε := mul_pos (by norm_num) δpos,
  have : ∀ p:GH_space, ∃ s : set p.rep, s.finite ∧ (univ ⊆ (⋃x∈s, ball x ε)) :=
    λ p, by simpa only [subset_univ, exists_true_left]
      using finite_cover_balls_of_compact is_compact_univ εpos,
  -- for each `p`, `s p` is a finite `ε`-dense subset of `p` (or rather the metric space
  -- `p.rep` representing `p`)
  -- 对于每个 `p`，`s p` 是 `p` (或代表 `p` 的度量空间 `p.rep`) 的一个有限 `ε`-稠密子集
  choose s hs using this,
  have : ∀ p:GH_space, ∀ t:set p.rep, t.finite → ∃ n:ℕ, ∃ e:equiv t (fin n), true,
  { assume p t ht,
    letI : fintype t := finite.fintype ht,
    exact ⟨fintype.card t, fintype.equiv_fin t, trivial⟩ },
  choose N e hne using this,
  -- cardinality of the nice finite subset `s p` of `p.rep`, called `N p`
  -- `p.rep` 的好的有限子集 `s p` 的基数，称为 `N p`
  let N := λ p:GH_space, N p (s p) (hs p).1,
  -- equiv from `s p`, a nice finite subset of `p.rep`, to `fin (N p)`, called `E p`
  -- 从 `p.rep` 的好的有限子集 `s p` 到 `fin (N p)` 的等价，称为 `E p`
  let E := λ p:GH_space, e p (s p) (hs p).1,
  -- A function `F` associating to `p : GH_space` the data of all distances between points
  -- in the `ε`-dense set `s p`.
  -- 一个函数 `F`，它将 `p : GH_space` 与 `ε`-稠密集 `s p` 中点之间所有距离的数据关联起来。
  let F : GH_space → Σn:ℕ, (fin n → fin n → ℤ) :=
    λp, ⟨N p, λa b, ⌊ε⁻¹ * dist ((E p).symm a) ((E p).symm b)⌋⟩,
  refine ⟨Σ n, fin n → fin n → ℤ, by apply_instance, F, λp q hpq, _⟩,
  /- As the target space of F is countable, it suffices to show that two points
  `p` and `q` with `F p = F q` are at distance `≤ δ`.
  For this, we construct a map `Φ` from `s p ⊆ p.rep` (representing `p`)
  to `q.rep` (representing `q`) which is almost an isometry on `s p`, and
  with image `s q`. For this, we compose the identification of `s p` with `fin (N p)`
  and the inverse of the identification of `s q` with `fin (N q)`. Together with
  the fact that `N p = N q`, this constructs `Ψ` between `s p` and `s q`, and then
  composing with the canonical inclusion we get `Φ`. -/
  /- 由于 F 的目标空间是可数的，只需证明具有 `F p = F q` 的两点 `p` 和 `q` 的距离 `≤ δ`。
  为此，我们构造一个从 `s p ⊆ p.rep` (代表 `p`) 到 `q.rep` (代表 `q`) 的映射 `Φ`，它在 `s p` 上几乎是一个等距映射，且其像为 `s q`。
  为此，我们复合 `s p` 与 `fin (N p)` 的等价，以及 `s q` 与 `fin (N q)` 的等价的逆。
  结合 `N p = N q` 的事实，这构造了 `s p` 和 `s q` 之间的 `Ψ`，然后与典范包含复合得到 `Φ`。-/
  have Npq : N p = N q := (sigma.mk.inj_iff.1 hpq).1,
  let Ψ : s p → s q := λ x, (E q).symm (fin.cast Npq ((E p) x)),
  let Φ : s p → q.rep := λ x, Ψ x,
  -- Use the almost isometry `Φ` to show that `p.rep` and `q.rep`
  -- are within controlled Gromov-Hausdorff distance.
  -- 使用几乎等距的 `Φ` 来证明 `p.rep` 和 `q.rep` 在受控的 Gromov-Hausdorff 距离内。
  have main : GH_dist p.rep q.rep ≤ ε + ε/2 + ε,
  { refine GH_dist_le_of_approx_subsets Φ  _ _ _,
    show ∀ x : p.rep, ∃ (y : p.rep) (H : y ∈ s p), dist x y ≤ ε,
    { -- by construction, `s p` is `ε`-dense
      -- 根据构造，`s p` 是 `ε`-稠密的
      assume x,
      have : x ∈ ⋃y∈(s p), ball y ε := (hs p).2 (mem_univ _),
      rcases mem_Union₂.1 this with ⟨y, ys, hy⟩,
      exact ⟨y, ys, le_of_lt hy⟩ },
    show ∀ x : q.rep, ∃ (z : s p), dist x (Φ z) ≤ ε,
    { -- by construction, `s q` is `ε`-dense, and it is the range of `Φ`
      -- 根据构造，`s q` 是 `ε`-稠密的，并且它是 `Φ` 的值域
      assume x,
      have : x ∈ ⋃y∈(s q), ball y ε := (hs q).2 (mem_univ _),
      rcases mem_Union₂.1 this with ⟨y, ys, hy⟩,
      let i : ℕ := E q ⟨y, ys⟩,
      let hi := ((E q) ⟨y, ys⟩).is_lt,
      have ihi_eq : (⟨i, hi⟩ : fin (N q)) = (E q) ⟨y, ys⟩, by rw [fin.ext_iff, fin.coe_mk],
      have hiq : i < N q := hi,
      have hip : i < N p, { rwa Npq.symm at hiq },
      let z := (E p).symm ⟨i, hip⟩,
      use z,
      have C1 : (E p) z = ⟨i, hip⟩ := (E p).apply_symm_apply ⟨i, hip⟩,
      have C2 : fin.cast Npq ⟨i, hip⟩ = ⟨i, hi⟩ := rfl,
      have C3 : (E q).symm ⟨i, hi⟩ = ⟨y, ys⟩,
      { rw ihi_eq, exact (E q).symm_apply_apply ⟨y, ys⟩ },
      have : Φ z = y,
      { simp only [Φ, Ψ], rw [C1, C2, C3], refl },
      rw this,
      exact le_of_lt hy },
    show ∀ x y : s p, |dist x y - dist (Φ x) (Φ y)| ≤ ε,
    { /- the distance between `x` and `y` is encoded in `F p`, and the distance between
      `Φ x` and `Φ y` (two points of `s q`) is encoded in `F q`, all this up to `ε`.
      As `F p = F q`, the distances are almost equal. -/
      /- `x` 和 `y` 之间的距离被编码在 `F p` 中，而 `Φ x` 和 `Φ y`（`s q` 的两点）之间的距离被编码在 `F q` 中，这一切都精确到 `ε`。
      由于 `F p = F q`，这些距离几乎相等。 -/
      assume x y,
      have : dist (Φ x) (Φ y) = dist (Ψ x) (Ψ y) := rfl,
      rw this,
      -- introduce `i`, that codes both `x` and `Φ x` in `fin (N p) = fin (N q)`
      -- 引入 `i`，它在 `fin (N p) = fin (N q)` 中编码了 `x` 和 `Φ x`
      let i : ℕ := E p x,
      have hip : i < N p := ((E p) x).2,
      have hiq : i < N q, by rwa Npq at hip,
      have i' : i = ((E q) (Ψ x)), by { simp only [equiv.apply_symm_apply, fin.coe_cast] },
      -- introduce `j`, that codes both `y` and `Φ y` in `fin (N p) = fin (N q)`
      -- 引入 `j`，它在 `fin (N p) = fin (N q)` 中编码了 `y` 和 `Φ y`
      let j : ℕ := E p y,
      have hjp : j < N p := ((E p) y).2,
      have hjq : j < N q, by rwa Npq at hjp,
      have j' : j = ((E q) (Ψ y)).1,
      { simp only [equiv.apply_symm_apply, fin.val_eq_coe, fin.coe_cast] },
      -- Express `dist x y` in terms of `F p`
      -- 用 `F p` 表示 `dist x y`
      have : (F p).2 ((E p) x) ((E p) y) = floor (ε⁻¹ * dist x y),
        by simp only [F, (E p).symm_apply_apply],
      have Ap : (F p).2 ⟨i, hip⟩ ⟨j, hjp⟩ = floor (ε⁻¹ * dist x y),
        by { rw ← this, congr; apply fin.ext_iff.2; refl },
      -- Express `dist (Φ x) (Φ y)` in terms of `F q`
      -- 用 `F q` 表示 `dist (Φ x) (Φ y)`
      have : (F q).2 ((E q) (Ψ x)) ((E q) (Ψ y)) = floor (ε⁻¹ * dist (Ψ x) (Ψ y)),
        by simp only [F, (E q).symm_apply_apply],
      have Aq : (F q).2 ⟨i, hiq⟩ ⟨j, hjq⟩ = floor (ε⁻¹ * dist (Ψ x) (Ψ y)),
        by { rw ← this, congr; apply fin.ext_iff.2; [exact i', exact j'] },
      -- use the equality between `F p` and `F q` to deduce that the distances have equal
      -- integer parts
      -- 使用 `F p` 和 `F q` 之间的相等性来推断距离具有相等的整数部分
      have : (F p).2 ⟨i, hip⟩ ⟨j, hjp⟩ = (F q).2 ⟨i, hiq⟩ ⟨j, hjq⟩,
      { -- we want to `subst hpq` where `hpq : F p = F q`, except that `subst` only works
        -- with a constant, so replace `F q` (and everything that depends on it) by a constant `f`
        -- then `subst`
        -- 我们想在 `hpq : F p = F q` 的地方使用 `subst hpq`，但 `subst` 只对常量有效，所以用一个常量 `f` 替换 `F q`（以及所有依赖它的东西），然后再 `subst`
        revert hiq hjq,
        change N q with (F q).1,
        generalize_hyp : F q = f at hpq ⊢,
        subst hpq,
        intros,
        refl },
      rw [Ap, Aq] at this,
      -- deduce that the distances coincide up to `ε`, by a straightforward computation
      -- that should be automated
      -- 通过一个应该被自动化的直接计算，推断出距离在 `ε` 精度内是一致的
      have I := calc
        |ε⁻¹| * |dist x y - dist (Ψ x) (Ψ y)| =
          |ε⁻¹ * (dist x y - dist (Ψ x) (Ψ y))| : (abs_mul _ _).symm
        ... = |(ε⁻¹ * dist x y) - (ε⁻¹ * dist (Ψ x) (Ψ y))| : by { congr, ring }
        ... ≤ 1 : le_of_lt (abs_sub_lt_one_of_floor_eq_floor this),
      calc
        |dist x y - dist (Ψ x) (Ψ y)| = (ε * ε⁻¹) * |dist x y - dist (Ψ x) (Ψ y)| :
          by rw [mul_inv_cancel (ne_of_gt εpos), one_mul]
        ... = ε * (|ε⁻¹| * |dist x y - dist (Ψ x) (Ψ y)|) :
          by rw [abs_of_nonneg (le_of_lt (inv_pos.2 εpos)), mul_assoc]
        ... ≤ ε * 1 : mul_le_mul_of_nonneg_left I (le_of_lt εpos)
        ... = ε : mul_one _ } },
  calc dist p q = GH_dist p.rep (q.rep) : dist_GH_dist p q
    ... ≤ ε + ε/2 + ε : main
    ... = δ : by { simp only [ε], ring }
end
```

#### 当代码只能以特定方式使用时，是否对用户有警告？

有些声明仅打算在特定文件内使用，也许因为它们是辅助性的。
其他声明可以在任何地方使用，但应谨慎使用，并且仅在首选方法不可用或使用它的缺点无关紧要时使用。

##### 在特定文件内使用

前者的一个例子是：
[PiLp.iSup_edist_ne_top_aux](https://leanprover-community.github.io/mathlib4_docs/Mathlib/Analysis/NormedSpace/PiLp.html#PiLp.iSup_edist_ne_top_aux)
它包含以下文档字符串。

```lean
/-- An auxiliary lemma used twice in the proof of `PiLp.pseudoMetricAux` below. Not intended for use outside this file. -/
/-- 一个在下面的 `PiLp.pseudoMetricAux` 证明中使用了两次的辅助引理。不打算在本文件之外使用。 -/
```

这个引理通过其名称（包含 `aux`）和其文档字符串向读者表明，它不打算用于通用目的。原因在于它紧邻的前一个声明，
[PiLp.pseudoEmetricAux](https://leanprover-community.github.io/mathlib4_docs/Mathlib/Analysis/NormedSpace/PiLp.html#PiLp.pseudoEmetricAux)，
是一个仅为构建恰当的伪扩展度量结构而临时激活的实例。
它的文档字符串也清楚地说明了这一点：

```lean
/-- Endowing the space `PiLp p β` with the `L^p` pseudoemetric structure. This definition is not
satisfactory, as it does not register the fact that the topology and the uniform structure coincide
with the product one. Therefore, we do not register it as an instance. Using this as a temporary
pseudoemetric space instance, we will show that the uniform structure is equal (but not defeq) to
the product one, and then register an instance in which we replace the uniform structure by the
product one using this pseudoemetric space and `PseudoEMetricSpace.replaceUniformity`. -/
/-- 为空间 `PiLp p β` 赋予 `L^p` 伪扩展度量结构。这个定义并不令人满意，因为它没有注册拓扑和一致结构与乘积结构一致的事实。因此，我们不将其注册为实例。我们将使用这个作为临时的伪扩展度量空间实例，来证明一致结构等于（但不是定义性相等）乘积结构，然后使用这个伪扩展度量空间和 `PseudoEMetricSpace.replaceUniformity` 注册一个实例，在其中我们将一致结构替换为乘积结构。 -/
```

##### 使用条件

后者的一个例子是：
[completeLatticeOfSup](https://leanprover-community.github.io/mathlib4_docs/Mathlib/Order/CompleteLattice.html#completeLatticeOfSup)，
它包含以下文档字符串。

````lean
/-- Create a `CompleteLattice` from a `PartialOrder` and `SupSet`
that returns the least upper bound of a set. Usually this constructor provides
poor definitional equalities.  If other fields are known explicitly, they should be
provided; for example, if `inf` is known explicitly, construct the `CompleteLattice`
instance as
```
instance : CompleteLattice my_T :=
  { inf := better_inf,
    le_inf := ...,
    inf_le_right := ...,
    inf_le_left := ...
    -- don't care to fix sup, sInf, bot, top
    ..completeLatticeOfSup my_T _ }
```-/
/-- 从一个返回集合最小上界的 `PartialOrder` 和 `SupSet` 创建一个 `CompleteLattice`。
通常这个构造函数提供的定义性等式很差。如果其他字段是明确已知的，它们应该被提供；
例如，如果 `inf` 是明确已知的，应像这样构造 `CompleteLattice` 实例
```
instance : CompleteLattice my_T :=
  { inf := better_inf,
    le_inf := ...,
    inf_le_right := ...,
    inf_le_left := ...
    -- 不关心修正 sup, sInf, bot, top
    ..completeLatticeOfSup my_T _ }
```
-/
````

在这种情况下，一个 `CompleteLattice` 被构造出来，但携带数据的 `sup`、`sInf`、`bot` 和 `top` 字段是根据 `sSup` 定义的，因此当需要访问定义时，证明关于它们的事情会很不方便。因此，这个文档字符串对用户来说是一个重要的警告，即这个构造函数应谨慎使用，并且如果这些携带数据的字段是明确已知的，就应该提供它们。

#### 它是否正在形式化文献中的某些内容？

mathlib 中的一些对象仅仅是为了形式化而存在的（例如，`AddMonoidWithOne`），但大多数形式化的思想直接来自数学文献。在这种情况下，特别是当贡献者模仿现有的已发表的纸上证明时，应该鼓励他们向 `references.bib` 文件添加一个条目，并在模块文档和/或相关定理的文档字符串中引用它。

此外，将与文献相关的数学纳入 mathlib 是一个额外的健全性检查，以确保所添加的内容是相关的，并希望以后有人会关心并使用它。将数学纳入 mathlib 会带来维护所添加内容的负担，如果它永远不会被使用，就没有理由承担这个负担。

### 位置

#### 声明是否位于合适的文件中？

考虑 [#5742](github.com/leanprover-community/mathlib4/pull/5742) 中的以下示例，其中 PR 作者正在为 `Unitization` 设置范数结构。作者正在创建一个新文件 `Analysis.NormedSpace.Unitization`，并在某个时刻声明了该实例：

```lean
instance Unitization.instNontrivial {𝕜 A} [Nontrivial 𝕜] [Nonempty A] :
    Nontrivial (Unitization 𝕜 A) :=
  nontrivial_prod_left
```

请注意，这个实例与范数无关，因此它很可能属于一个更早的文件。审查者可以使用 `#find_home Unitization.instNontrivial` 来确定放置此声明的自然位置是 `Algebra.Algebra.Unitization`。一个有帮助的审查者可以评论：

```markdown
这个实例似乎与 `Unitization` 上的范数结构无关。也许您可以将此实例放在 `Algebra.Algebra.Unitization` 中。
```

#### 结果是否已经存在？可能以更通用的形式用不同的名称存在？

Mathlib 现在是一个相当大的库，对任何人，特别是新用户来说，熟悉所有不同的角落和确切有哪些结果是困难的。我们追求通用性并避免代码重复，这加剧了这个问题；这导致了新用户的典型问题：“mathlib 真的缺少向量空间和群同态吗？”，其答案是：“不，这些分别是 `Module` 和 `MonoidHom`。”

因此，新贡献者（甚至是有经验的贡献者！）为一个已经存在的结果创建一个 PR，有时是逐字相同的，有时是在更广的通用性下，这并不少见。

`apply?` 和 `exact?` 策略有时可以帮助回答这个问题。如果您怀疑一个结果已经存在，只需将其复制到一个带有 `import Mathlib` 的新文件中，然后尝试 `exact?`。

#### 是否引入了新的 `import`？它们是否导入了过多？

维护 mathlib 导入层级的组织是一项重要任务，但如果没有仔细的审查，它很容易失控。通常，问题以下列方式发生。

一个贡献者想：“我想添加 `my_theorem`，它完全是关于 `Z` 的，所以我会把它加到 `X.Y.Z`。”在尝试在那里添加定理时，贡献者意识到：“哦，我无法访问 `helper_lemma`，我需要 `import A.B.C`。”在审查期间，审查者专注于其他事情，PR 就带着这个导入更改被合并了。这就是 `Analysis.NormedSpace.Star.Basic` 曾一度导入 `Analysis.NormedSpace.OperatorNorm` 的故事！这发生在 [#16964](https://github.com/leanprover-community/mathlib/pull/16964) 中，然后不得不在 [#18194](https://github.com/leanprover-community/mathlib/pull/18194) 中修复。

作为另一个例子，在 [#6239](https://github.com/leanprover-community/mathlib4/pull/6239) 中，贡献者将 `Data.IsROrC.Basic` 的导入添加到了 `LinearAlgebra.Matrix.DotProduct`。对于新贡献者来说，这可能是一个很难识别的事情，因为它有时需要对库的组织方式有相当的熟悉度。

当然，审查者应该尽力捕捉最过分的例子（例如，将 `Analysis` 文件导入到 `Algebra` 文件中通常是相当可疑的），但提出这个问题总是合理的。这通常意味着结果属于其他地方，文件应该沿着一个自然的边界被拆分，或者新的结果应该放在一个新文件中。

#### 文件是否应被拆分成多个部分？

拆分文件基本上有三个原因：

1.  它太长了，不好用。
    一个好的经验法则是它超过 1000 行。
2.  文件被分成了多个仅松散相关的部分。
3.  为了避免因引入与现有结果密切相关的新结果而导致的导入蔓延。

假设一些结果，大约 500 行，被添加到一个已经包含 700 行的现有文件中，并进一步假设新材料与文件中的一些现有材料密切相关。审查者应该留意一个自然的边界，可以将文件拆分成连贯的部分。

### 改进

#### 是否应将（尤其是长证明）拆分为辅助引理或定义？

长的独立证明常常表明附近潜藏着一个值得进行的重构。通常新贡献者不了解库中现有的引理，或者可能不知道如何将他们的定理拆分成更易于管理的小块。在这些情况下，审查者有几个选择，包括：亲自上阵，将结果重构为多个引理，以 GitHub 上的 `suggestion` 形式提供；寻找潜在的重构并提及它，如“您可能会考虑将 xx 行的论证拆分成自己的引理，这将简化证明”；或者只是问，“这个证明似乎相当长且笨重，您有没有考虑过如何将其拆分成更易于管理的部分？”；甚至，“这个证明如果利用定理 X 可能会更容易。”

#### 不同的策略以提高可读性

一个很好的例子，说明使用更好的策略或代码精简可以**提高**可读性，可以在 [#6140](https://github.com/leanprover-community/mathlib4/pull/6140/files/d2506ba26543b630722124dbf030339f43f6590a#r1287284988) 的这个建议中找到。
在这种情况下，证明中最初的策略序列是：

```lean
  have h₀ : log b = log (- -b) := by simp
  rw [h₀, log_neg_eq_log]
  have hb' : 0 < -b := by linarith
  have h₁ : log (-b) < 0 := by rw [log_neg_iff hb']; linarith
  refine tendsto_exp_atBot.comp ?_
  rw [tendsto_const_mul_atBot_of_neg h₁]
  show atTop ≤ atTop
  rfl
```

而建议是将其精简为：

```lean
  refine tendsto_exp_atBot.comp <| (tendsto_const_mul_atBot_of_neg ?_).mpr tendsto_id
  rw [←log_neg_eq_log, log_neg_iff (by linarith)]
  linarith
```

从精简后的版本中，我们可以很容易地看出，这本质上只是复合了一些关于 `Filter.Tendsto` 的库引理，以及其中一个定理的一个假设，这个假设是通过一些基本的重写和调用 `linarith` 来证明的。

一个使用更好策略可以提高可读性的例子可以在 [#4702](https://github.com/leanprover-community/mathlib4/pull/4702/files) 的整个 diff 中找到，它使用新的 `gcongr` 策略精简了整个库的引理。我们将重点介绍一个特别好的例子以供参考。原始代码是：

```lean
  _ ≤ ε / 2 * ‖∑ i in range n, g i‖ + ε / 2 * ∑ i in range n, g i := by
    rw [← mul_sum]
    exact add_le_add hn (mul_le_mul_of_nonneg_left le_rfl (half_pos εpos).le)
```

使用 `gcongr` 改进为：

```lean
  _ ≤ ε / 2 * ‖∑ i in range n, g i‖ + ε / 2 * ∑ i in range n, g i := by rw [← mul_sum]; gcongr
```

或者，来自同一个 PR，这个例子使用 `positivity` 从：

```lean
  · have ha' := mul_le_mul_of_nonneg_left ha (inv_pos.2 hab).le
    rwa [MulZeroClass.mul_zero, ← div_eq_inv_mul] at ha'
  · have hb' := mul_le_mul_of_nonneg_left hb (inv_pos.2 hab).le
    rwa [MulZeroClass.mul_zero, ← div_eq_inv_mul] at hb'
```

改进为：

```lean
  · positivity
  · positivity
```

#### 不同的证明结构是否能极大地简化论证？

一个很好的例子发生在 [#5602](https://github.com/leanprover-community/mathlib4/pull/5602/files/ea99653c047046bae3a109ee980314eec0bb9e81#r1282044795) 的审查中。
在这种情况下，PR 作者证明了：

```lean
variable {R S A : Type*} [CommSemiring R] [Semiring A] [Algebra R A] [SetLike S A]
  [hSA : NonUnitalSubsemiringClass S A] [hSRA : SMulMemClass S R A] (s : S)

-- `NonUnitalSubalgebra.unitization s : Unitization R s →ₐ[R] Algebra.adjoin R (s : Set A)`
theorem NonUnitalSubalgebra.unitization_surjective :
    Function.Surjective (NonUnitalSubalgebra.unitization s) := by
  apply Algebra.adjoin_induction'
  · refine' fun x hx => ⟨(0, ⟨x, hx⟩), Subtype.ext _⟩
    simp only [NonUnitalSubalgebra.unitization_apply_coe, Subtype.coe_mk]
    change (algebraMap R { x // x ∈ Algebra.adjoin R (s : Set A) } 0 : A) + x = x
    rw [map_zero, Subsemiring.coe_zero, zero_add]
  · exact fun r => ⟨algebraMap R (Unitization R s) r, AlgHom.commutes _ r⟩
  · rintro _ _ ⟨x, rfl⟩ ⟨y, rfl⟩
    exact ⟨x + y, map_add _ _ _⟩
  · rintro _ _ ⟨x, rfl⟩ ⟨y, rfl⟩
    exact ⟨x * y, map_mul _ _ _⟩
```

审查者评论道：

```markdown
我明白为什么这不直接（你得回到完整的余定义域），但真的没有好方法在这里使用 `Algebra.adjoin_le` 吗？
```

这导致了极大改进的三行证明：

```lean
theorem NonUnitalSubalgebra.unitization_surjective :
    Function.Surjective (NonUnitalSubalgebra.unitization s) := by
  have : Algebra.adjoin R s ≤ ((Algebra.adjoin R (s : Set A)).val.comp (unitization s)).range :=
    Algebra.adjoin_le fun a ha ↦ ⟨(⟨a, ha⟩ : s), by simp⟩
  fun x ↦ match this x.property with | ⟨y, hy⟩ => ⟨y, Subtype.ext hy⟩
```

在这种情况下，诉诸引理 `Algebra.adjoin_le` 比使用 `Algebra.adjoin_induction'` 是一个巨大的简化。

#### 引入的定义是否是形式化该概念的最佳方式（非常困难！）？

这在一般情况下非常难以描述，但也许可以给出的最简单的经验法则是：定义越能避免依赖类型，就越好。

例如，考虑 [Vector](https://leanprover-community.github.io/mathlib4_docs/Mathlib/Data/Vector.html#Vector) 的定义。
许多关于依赖类型理论的入门性阐述将 `Vector` 定义为一个归纳类型，并将其作为依赖类型的典型例子。虽然依赖类型是不可避免的，但 mathlib 的定义转而选择了 `List` 的一个简单子类型，对 `ℕ` 的依赖只出现在 `List.length` 的相等性命题中。这样做的好处是，我们可以通过强制转换为 `List` 轻松地脱离依赖类型世界，然后生活就容易多了。实际上，`Vector` 上的大多数操作正是 `List` 上的相应操作加上一个关于长度的相等性证明。

### 库集成

这里的许多问题有点模糊，通常需要对 mathlib 的结构有大量的熟悉度，或者至少在形式化方面有重要的先前专业知识。如果您在审查时发现难以解决这些问题，请不要灰心。

#### 它是否提供了一个合理的 API？

- 属性是否被适当地添加（例如，`@[simp]`、`@[ext]`、`@[gcongr]`、`@[aesop]` 等）？
- 是否提供了重写引理以避免一直需要通过定义性等式来传递？
- 新类型是否为常见用例提供了方便的构造函数？

#### 它是否足够通用以支持已知的未来需求？

这需要知道未来的一些需求可能是什么！在 Zulip 上保持活跃可以帮助审查者了解这些需求。然而，人们可以用一个代理问题来代替这个问题，即：“文献中是否存在一个更通用的版本，它调用了 mathlib 中已有的概念？”如果有，也许现有的 PR 应该被泛化。

#### 它是否符合 mathlib 的设计和集体愿景？

同样，这是一个模糊的问题，需要知道设计和集体愿景是什么！
然而，作为一些实际的例子：

- 如果一个用户正在添加一种新的态射（不在范畴论库中），他们很可能应该定义一个绑定的态射类型，并且可能使用 `FunLike` API 定义一个相关的态射类。
- 类似地，如果一个贡献者正在添加一个新的子对象，他们可能应该使用绑定的子对象并利用 `SetLike` API。作为参考，请参见 [Mathematics in Lean 中相关章节](https://leanprover-community.github.io/mathematics_in_lean/C07_Hierarchies.html#sub-objects)。
- 遵循任何现有库注释的建议。