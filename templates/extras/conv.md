# `conv` 策略模式

在策略块 (tactic block) 内部，可以使用关键字 `conv` 进入转换模式 (conversion mode)。此模式允许在假设 (assumptions) 和目标 (goals) 内部进行导航，甚至可以进入其中的 `fun` 绑定符 (binders)，以应用重写 (rewriting) 或简化步骤 (simplifying steps)。

这类似于在其他定理证明器如 HOL4、HOL Light 或 Isabelle 中找到的转换策略组合子 (conversion tacticals/tactic combinators)。

## 基本导航与重写

作为第一个例子，让我们证明 `example (a b c : ℕ) : a * (b * c) = a * (c * b)`（本文件中的例子有些刻意，因为 `Tactic.Ring` 中的 `ring` 策略可以立即完成它们）。最直接的初次尝试是进入策略模式并尝试 `rw [mul_comm]`。但这会将目标转换为 `b * c * a = a * (c * b)`，因为它交换了项中出现的第一个乘法。有几种方法可以解决这个问题，其中一种是使用更精确的工具：转换模式。下面的代码块显示了每行代码之后当前的目标。请注意，目标以 `|` 为前缀，而在普通模式下目标以 `⊢` 为前缀（尽管这些目标仍被称为“goals”）。

```lean
example (a b c : ℕ) : a * (b * c) = a * (c * b) := by
  conv =>           -- | a * (b * c) = a * (c * b)
    lhs             -- | a * (b * c)
    congr           -- | a and | b * c
    · skip          -- | a
    · rw [mul_comm] -- | c * b
```

上面的代码片段展示了三个导航命令：
* `lhs` 导航到关系（此处为等式）的左侧，还有一个 `rhs` 导航到右侧。
* `congr` 会为当前头部函数 (head function) 的每个参数创建一个目标（这里的头部函数是乘法）。
* `skip` 跳转到下一个目标。

一旦到达相关目标，我们就可以像在普通模式下一样使用 `rw`。请注意，如果当前目标变为 `x = x`（在严格的语法意义上，定义性相等 (definitional equality) 是不够的：在这种情况下需要用 `rfl` 或 `trivial` 来结束），Lean 会尝试解决它。

供您参考，我们可以将 `conv => lhs ..` 写成 `conv_lhs => ..`：

```lean
example (a b c : ℕ) : a * (b * c) = a * (c * b) := by
  conv_lhs =>
    congr
    · skip
    · rw [mul_comm]
```

使用转换模式的第二个主要原因是在绑定符下进行重写。假设我们想证明 `example (fun x : ℕ ↦ 0 + x) = (fun x ↦ x)`。最直接的初次尝试是进入策略模式并尝试 `rw [zero_add]`。但这会失败，并显示令人沮丧的：
```text
tactic 'rewrite' failed, did not find instance of the pattern in the target expression
  0 + ?a
⊢ (fun x ↦ 0 + x) = fun x ↦ x
```

解决方案是：
```lean
example : (fun x : ℕ ↦ 0 + x) = (fun x ↦ x) := by
  conv_lhs =>     -- | fun x ↦ 0 + x
    ext x         -- | 0 + x
    rw [zero_add] -- | x
```
其中 `ext` 是进入 `fun` 绑定符内部的导航命令。请注意，这个例子有些刻意，也可以这样做：
```lean
example : (fun x : ℕ ↦ 0 + x) = (fun x ↦ x) := by
  funext x; rw [zero_add]
```

所有这些功能也可用于使用 `conv at H` 重写局部上下文中的假设 `H`。

## 模式匹配

使用上述命令进行导航可能很繁琐。可以使用模式匹配 (pattern matching) 来简化它，如下所示：

```lean
example (a b c : ℕ) : a * (b * c) = a * (c * b) := by
  conv in (b * c) => -- | b * c
    rw [mul_comm]    -- | c * b
```

我们可以将这个证明写在一行中：

```lean
example (a b c : ℕ) : a * (b * c) = a * (c * b) := by
  conv in (b * c) => rw [mul_comm]
```

当然，也允许使用通配符 (wild-cards)：

```lean
example (a b c : ℕ) : a * (b * c) = a * (c * b) := by
  conv in (_ * c) => rw [mul_comm]
```

在所有这些情况下，只有第一个匹配项会受到影响。
在转换模式内部，可以使用 `for` 命令进行更复杂的模式匹配。下面仅对 `b * c` 的第二次和第三次出现进行重写：

```lean
example (a b c : ℕ) : (b * c) * (b * c) * (b * c) = (b * c) * (c * b) * (c * b) := by
  conv in (occs := 2 3) (b * c) =>
    · rw [mul_comm]
    · rw [mul_comm]
```

我们可以使用 "all_goals" 将这个证明写在一行中：

```lean
example (a b c : ℕ) : (b * c) * (b * c) * (b * c) = (b * c) * (c * b) * (c * b) := by
  conv in (occs := 2 3) (b * c) => all_goals rw [mul_comm]
```

## 在转换模式中使用其他策略

除了使用 `rw` 进行重写，还可以使用 `simp`、`dsimp`、`change` 和 `whnf`。
`change` 是一个有用的工具——它允许将一个项更改为定义上相等的另一个项，有点像策略模式中的 `show` 命令。
`whnf` 命令意为“归约至弱头范式 (reduces to weak head normal form)”，这将在《Metaprogramming in Lean 4》第 4 节 [Metaprogramming in Lean 4](https://leanprover-community.github.io/lean4-metaprogramming-book/main/04_metam.html#weak-head-normalisation) 中得到解释。

由 mathlib 提供的对 `conv` 的扩展，例如 `ring` 和 `norm_num`，可以在 [`Mathlib.Tactic.HelpCmd`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/Tactic/HelpCmd.html) 中使用 `#help conv` 命令找到。