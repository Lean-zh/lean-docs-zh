# 方程编译器与良基关系

要递归地定义函数和证明，如果你在该类型上有一个良基关系 (well founded relation)，你就可以使用方程编译器 (equation compiler)。

例如，自然数上 `gcd` 的定义就使用了良基递归 (well founded recursion)。

```lean
def gcd (m n : Nat) : Nat :=
  if m = 0 then
    n
  else
    gcd (n % m) m
  termination_by m
  decreasing_by simp_wf; apply mod_lt _ (zero_lt_of_ne_zero _); assumption
```

因为 `<` 是自然数上的一个良基关系，并且因为 `¬m = 0 → n % m < m`，所以这个递归函数是良基的。

每当你使用方程编译器时，被递归的类型上都会有一个默认的良基关系（由 `WellFoundedRelation` 实例给出），方程编译器会自动尝试证明该函数在该关系下是良基的。

当方程编译器失败时，主要有两个原因。

1. 它找不到一个递减度量 (decreasing measure)。
2. 它未能证明所需的不等式。

## 证明所需的不等式

如果我们修改上面的 gcd 例子，移除 `termination_by` 和 `decreasing_by`，我们会得到一个错误。

```lean
def gcd (m n : Nat) : Nat :=
  if m = 0 then
    n
  else
    gcd (n % m) m
```

```text
fail to show termination for
  Nat.gcd
with errors
argument #1 was not used for structural recursion
  failed to eliminate recursive application
    (n % m).gcd m

argument #2 was not used for structural recursion
  failed to eliminate recursive application
    (n % m).gcd m

structural recursion cannot be used

Could not find a decreasing measure.
The arguments relate at each recursive call as follows:
(<, ≤, =: relation proved, ? all proofs failed, _: no proof attempted)
           m n
1) 93:4-18 ? ?
Please use `termination_by` to specify a decreasing measure.
```

错误信息告诉我们使用 `termination_by` 来指定递减度量，所以我们用 `m` 作为递减度量，但我们得到了另一个错误。

```lean
def gcd (m n : Nat) : Nat :=
  if m = 0 then
    n
  else
    gcd (n % m) m
  termination_by m
```

```text
failed to prove termination, possible solutions:
  - Use `have`-expressions to prove the remaining goals
  - Use `termination_by` to specify a different well-founded relation
  - Use `decreasing_by` to specify your own tactic for discharging this kind of goal
m n : ℕ
h✝ : ¬m = 0
⊢ n % m < m
```

我们指定了正确的递减度量，所以我们的选择是使用 `have` 表达式或使用 `decreasing_by`。
在这里，我们使用 `decreasing_by tactics` 来证明这个函数的终止性。
首先，我们用 `sorry` 占位以显示目标。

```lean
def gcd (m n : Nat) : Nat :=
  if m = 0 then
    n
  else
    gcd (n % m) m
  termination_by m
  decreasing_by sorry
```

```text
m n : ℕ
h✝ : ¬m = 0
⊢ (invImage (fun x ↦ PSigma.casesOn x fun m n ↦ m) instWellFoundedRelationOfSizeOf).1 ⟨n % m, m⟩ ⟨m, n⟩
```

这个目标是编译器生成的，所以很难读懂，我们用 `simp_wf` 来简化它。

```lean
def gcd (m n : Nat) : Nat :=
  if m = 0 then
    n
  else
    gcd (n % m) m
  termination_by m
  decreasing_by simp_wf; sorry
```

```text
m n : ℕ
h✝ : ¬m = 0
⊢ n % m < m
```

顺便问一下，假设 `h✝ : ¬m = 0` 是从哪里来的？实际上，在终止性证明期间，`if p then t else f` 会被重写为 `if h : p then t else f`，因此假设 `p` 就变得可用了。

剩下的任务就只是证明这个目标了：

```lean
def gcd (m n : Nat) : Nat :=
  if m = 0 then
    n
  else
    gcd (n % m) m
  termination_by m
  decreasing_by simp_wf; apply mod_lt _ (zero_lt_of_ne_zero _); assumption
```

供您参考，如果我们使用 `have` 表达式的选项，函数的形式如下：

```lean
def gcd (m n : Nat) : Nat :=
  if h : m = 0 then
    n
  else
    have := mod_lt n (zero_lt_of_ne_zero h)
    gcd (n % m) m
```

但是，当我们使用方程引理 (equation lemma) 时，`have` 表达式可能会成为一个障碍。

另一个例子是 `Data.Multiset.Basic` 中的以下函数。

```lean
def strongInductionOn {p : Multiset α → Sort*} (s : Multiset α) (ih : ∀ s, (∀ t < s, p t) → p s) :
    p s :=
    (ih s) fun t _h =>
      strongInductionOn t ih
termination_by card s
decreasing_by exact card_lt_card _h
```

这个例子使用 `card s` 作为递减度量，而不是参数本身。

## 良基关系实例

我们不仅可以指定一个 `Nat` 值，还可以指定任何带有 `WellFoundedRelation` 的类型作为递减度量，正如你在 `Data.List.Defs` 中所看到的：

```lean
def permutationsAux.rec {C : List α → List α → Sort v} (H0 : ∀ is, C [] is)
    (H1 : ∀ t ts is, C ts (t :: is) → C is [] → C (t :: ts) is) : ∀ l₁ l₂, C l₁ l₂
  | [], is => H0 is
  | t :: ts, is =>
      H1 t ts is (permutationsAux.rec H0 H1 ts (t :: is)) (permutationsAux.rec H0 H1 is [])
  termination_by ts is => (length ts + length is, length ts)
  decreasing_by all_goals (simp_wf; omega)
```

这个例子使用一个 `Nat × Nat` 值作为递减度量。该类型上的 `WellFoundedRelation` 是自然数上的字典序 (lexicographical order)，
由 `Init.WF` 中的以下实例定义：

```lean
instance [ha : WellFoundedRelation α] [hb : WellFoundedRelation β] : WellFoundedRelation (α × β) :=
  lex ha hb
```