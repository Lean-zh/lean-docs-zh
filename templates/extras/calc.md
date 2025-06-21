# 如何使用 calc

`calc` 是一个环境——也就是一种“模式”，类似于 `tactic mode`、`term mode` 和 [conv mode](conv.html)。关于如何使用它的文档和基本示例可以在《Theorem Proving In Lean》的[第 4 节](https://lean-lang.org/theorem_proving_in_lean4/quantifiers_and_equality.html#calculational-proofs)中找到。

基本用法示例：

```lean
example (a b c : ℕ) (H1 : a = b + 1) (H2 : b = c) : a = c + 1 :=
calc a = b + 1 := H1
     _ = c + 1 := by rw [H2]
```

`calc` 在 `tactic mode` 中也可用。你可以留下 `?_` 来创建一个新的目标：
```lean
example (a b c : ℕ) (H1 : a = b + 1) (H2 : b = c) : a = c + 1 := by
  calc
    a = b + 1 := ?_
    _ = c + 1 := ?_
  · exact H1
  · rw [H2]
```
事实上，在 `tactic mode` 中，`calc A = B := H ...` 的功能与调用 `refine (calc A = B := H ...)` 完全相同。

## 在使用 calc 时获得有效反馈

为了获得有用的错误信息，即使在证明完成之前，也要保持 `calc` 的结构。使用上面示例中的 `_` 或 `sorry` 来代表缺失的理由。`sorry` 会完全抑制错误信息，而 `_` 则会生成一条引导性的错误信息。

如果 `calc` 的结构不正确（例如，缺少 `:=` 或其后的理由），你可能会看到晦涩的错误信息和/或在某个随机的 `_` 下方出现的红色波浪线。为避免这些问题，你可以先填充一个骨架证明，例如：

```lean
example (A B C D : ℝ ) : A = D :=
calc A = B := sorry
     _ = C := _
     _ = D := sorry
```

然后再逐步填充 `sorry` 和 `_`。


```lean
example (A B C D : ℝ ) : A = D := by
     calc A = B := sorry
          _ = C := ?_
          _ = D := sorry
     sorry
```

还有一个 Calc 小部件可以使这个过程更简单，这里有一个[视频](https://youtu.be/8MFGhOWeCNE?t=1834)演示了它。

## 使用等号以外的运算符

《TPIL》中的许多基本示例都使用等号作为大部分或全部的运算符，但实际上 `calc` 可以用于任何我们为其创建了 `Trans` 实例的关系。

```lean
def r : ℕ → ℕ → Prop := sorry
variable (a b c: ℕ)
def r_trans {a b c} (h₁ : r a b) (h₂ : r b c) : r a c := sorry

instance : Trans r r r where
  trans := r_trans

infix:50 "***" => r

example (a b c : ℕ) (H1 : a *** b) (H2 : b *** c) : a *** c :=
calc a *** b := H1
     _ *** c := H2
```

## 使用多个运算符

这是可以的，例如：

```lean
theorem T2 (a b c d : ℕ)
  (h1 : a = b) (h2 : b ≤ c) (h3 : c + 1 < d) : a < d := 
  calc
    a = b     := h1
    _ < b + 1 := Nat.lt_succ_self b
    _ ≤ c + 1 := Nat.succ_le_succ h2
    _ < d     := h3

 ```

这里到底发生了什么？证明本身并不神秘，例如 `Nat.succ_le_succ h2` 是 `b + 1 ≤ c + 1` 的一个证明。巧妙之处在于，Lean 可以将所有这些部分组合在一起，正确地推断出如果 `U = V < W ≤ X < Y`，那么 `U < Y`。注意以下微妙之处：给定 `U op1 V` 和 `V op2 W`，Lean 必须为某个运算符 `op3` 得出 `U op3 W` 的结论，这个运算符可能是 `op1` 或 `op2`（甚至，正如我们将看到的，是一个新的运算符）。Lean 是如何做到这一点的？最简单的情况是当 `op1` 和 `op2` 中有一个是 `=` 时。Lean 知道

```lean
#check trans_rel_right -- {α : Sort u} {a b c : α} (r : α → α → Prop) (h₁ : a = b) (h₂ : r b c) : r a c
#check trans_rel_left -- {α : Sort u} {a b c : α} (r : α → α → Prop) (h₁ : r a b) (h₂ : b = c) : r a c
```

并且如果其中一个运算符是等号运算符，就会使用它们。然而，如果两个运算符都不是等号运算符，Lean 会查找 `Trans` 的实例并应用它们。

## 使用用户自定义的运算符

这就像创建相关的 `Trans` 实例一样简单。例如

```lean
def r : ℕ → ℕ → Prop := sorry
def s : ℕ → ℕ → Prop := sorry
def t : ℕ → ℕ → Prop := sorry

theorem rst_trans {a b c : ℕ} : r a b → s b c → t a c := sorry
infix:50 "****" => r
infix:50 "^^^^" => s
infix:50 "%%%%" => t

instance : Trans r s t  where
  trans := rst_trans

example (a b c : ℕ) (H1 : a **** b) (H2 : b ^^^^ c) : a %%%% c :=
calc a **** b := H1
     _ ^^^^ c := H2
```

这个例子向我们展示了第三个运算符 `op3` 可以与 `op1` 和 `op2` 都不同。