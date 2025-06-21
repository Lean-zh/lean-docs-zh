# Lean 中的数学：自然数

自然数从零开始，这在计算机科学中是标准做法。你可以称它们为 `Nat` 或 `ℕ`（后者通过在 VS Code 中输入 `\N` 得到）。

自然数是一种所谓的归纳类型 (inductive type)，有两个构造子 (constructors)。第一个是 `Nat.zero`，在实践中通常写作 `0` 或 `(0 : ℕ)`，表示零。另一个构造子是 `Nat.succ`，它接受一个自然数作为输入，并输出下一个自然数。

加法和乘法是通过对第二个变量进行递归来定义的，核心库中许多基本内容的证明都是通过对第二个变量进行归纳来完成的。记号 `+`、`-`、`*` 是函数 `Nat.add`、`Nat.sub` 和 `Nat.mul` 的简写，其他记号（`≤`、`<`、`|`）也表示通常的含义（通过 `\|` 得到“整除”符号）。`%` 符号表示模（除法后的余数）。

以下是核心 Lean 中一些用于处理 `Nat` 的函数。

```lean
open nat

example : Nat.succ (Nat.succ 4) = 6 := rfl

example : 4 - 3 = 1 := rfl

example : 5 - 6 = 0 := rfl -- 这些是自然数

example : 1 ≠ 0 := one_ne_zero

example : 7 * 4 = 28 := rfl

example (m n p : ℕ) : m + p = n + p → m = n := add_right_cancel

example (a b c : ℕ) : a * (b + c) = a * b + a * c := left_distrib a b c

example (m n : ℕ) : succ m ≤ succ n → m ≤ n := Nat.le_of_succ_le_succ

example (a b: ℕ) : a < b → ∀ n, 0 < n → a ^ n < b ^ n := pow_lt_pow_of_lt_left
```

在 mathlib 中，有更多关于自然数的基本函数，例如阶乘 (factorials)、最小公倍数 (lowest common multiples)、素数 (primes)、平方根 (square roots) 和一些模运算 (modular arithmetic)。

```lean
import Mathlib.Data.Nat.Dist -- 距离函数
import Mathlib.Data.Nat.GCD.Basic -- 最大公约数
import Mathlib.Data.Nat.ModEq -- 模运算
import Mathlib.Data.Nat.Prime.Basic -- 素数相关
import Mathlib.Data.Nat.Factors -- 因子
import Mathlib.Tactic.NormNum.Prime -- 用于快速计算的策略

open Nat

example : factorial 4 = 24 := rfl -- 阶乘

example (a : ℕ) : factorial a > 0 := factorial_pos a

example : dist 6 4 = 2 := rfl -- 距离函数

example (a b : ℕ) : a ≠ b → dist a b > 0 := dist_pos_of_ne

example (a b : ℕ) : gcd a b ∣ a ∧ gcd a b ∣ b := gcd_dvd a b

example : lcm 6 4 = 12 := rfl

example (a b : ℕ) : lcm a b = lcm b a := lcm_comm a b
example (a b : ℕ) : gcd a b * lcm a b = a * b := gcd_mul_lcm a b

-- 使用 \== 输入同余符号

example : 5 ≡ 8 [MOD 3] := rfl

-- nat.sqrt 是整数平方根（向下取整）。

#eval sqrt 1000047
-- 返回 1000

example (a : ℕ) : sqrt (a * a) = a := sqrt_eq a

example (a b : ℕ) : sqrt a < b ↔ a < b * b := sqrt_lt

example : Nat.Prime 59 := by decide

-- (默认实例是 `nat.decidable_prime`，它不能被
-- `dec_trivial` 使用，因为内核需要展开
-- 由良基递归生成的不可约证明。)

-- `norm_num` 策略，除其他功能外，提供了更快的素性测试。

example : Nat.Prime 104729 := by
  norm_num

example (p : ℕ) : Nat.Prime p → p ≥ 2 := Prime.two_le

example (p : ℕ) : Nat.Prime p ↔ p ≥ 2 ∧ ∀ m, 2 ≤ m → m ≤ sqrt p → ¬ (m ∣ p) := prime_def_le_sqrt

example (p : ℕ) : Nat.Prime p → (∀ m, Coprime p m ∨ p ∣ m) := coprime_or_dvd_of_prime

example : ∀ n, ∃ p, p ≥ n ∧ Nat.Prime p := exists_infinite_primes

-- minFac 返回 n 的最小素因子（如果没有则返回垃圾值）

example : minFac 12 = 2 := rfl

-- `Nat.primeFactorsList n` 是 `n` 的素因子分解，按升序列出。
-- 这似乎不会归约，而且显然还没有人尝试
-- 让内核合理地求值它。
-- 但我们可以使用 #eval 在虚拟机中对它求值。

#eval primeFactorsList (2^32+1)
-- [641, 6700417]
```