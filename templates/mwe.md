# 最小工作示例

## 长话短说

在 Zulip 上发布代码时，请包含所有的 `import`、`open`、`universe` 和 `variable`，以便其他人可以直接复制粘贴您发布的内容，并看到您遇到的同样问题。

确保您已做到这一点的最佳方法是，将您打算发布的代​​码片段复制粘贴到一个空的 Lean 文件中，或粘贴到 [lean 网页编辑器](https://live.lean-lang.org/)中，并检查它是否能编译通过。

## 示例

### 错误示例：

```lean
#check (univ : Set X)
```

### 正确示例：

```lean
import Mathlib

universe u

variable (X : Type u)

open Set

#check (univ : Set X)
```

### 错误示例：

```text
目标状态:
/-
a b : blah,
h : a.fst < b.fst,
h2 : a.snd < b.snd
⊢ false
-/
```

### 正确示例：

```lean
def blah : Type := Nat × Nat

example (a b : blah) (h : a.fst < b.fst) (h2 : a.snd < b.snd) : False := by
  /-
  a b : blah,
  h : a.fst < b.fst,
  h2 : a.snd < b.snd
  ⊢ False
  -/
  done
```

提示：如果您正在使用 [mathlib](https://github.com/leanprover-community/mathlib4)（例如，使用了 `import Mathlib`），有一个名为 [`extract_goal`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/Tactic/ExtractGoal.html) 的 tactic 可以帮助您将当前目标格式化为一个独立示例。您可以从 `extract_goal` 的输出中删除无关的变量和假设，以进一步精简您的示例。

请注意，您仍然需要像上面提到的那样，包含相应的 `import`、`open`、`universe` 和 `variable`。

## 形式化定义

一个**最小工作示例 (minimal working example)** 是一个可以被复制粘贴到空的 Lean 文件中，并且仍然具有相同特性（能工作），且不包含不必要细节（最小）的代码片段。

[这里](https://stackoverflow.com/help/minimal-reproducible-example) 是 StackOverflow 关于制作 MWE 的指南。

请确保您的代码片段包含：

- 正确的导入；以及
- 所有相关的定义 / 定理。

您的示例抛出编译器错误或警告是完全可以的。特别是，您的代码可以包含关键字 `sorry`（实际上，用 `sorry` 替换不相关的证明是精简示例的好方法）。MWE 的重点在于，您的代码应该**在一个空白文件中抛出与您遇到时相同的错误**，这样人们才能针对您困惑的确切错误提供帮助。

## 我如何知道我的代码是否是 MWE？

您应该通过将您的代码片段复制粘贴到一个新的 Lean 文件或 [lean 网页编辑器](https://live.lean-lang.org/) 中来**测试**这一点，看看是否能得到预期的行为。这正是那些试图帮助您的人会做的事情！

## 如果我问的是像 [自然数游戏](https://adam.math.hhu.de/#/g/hhu-adam/NNG4) 这样的游戏怎么办？

如果您的示例来自自然数游戏或任何类似的基于浏览器的 Lean 演示，那么您可以添加一个指向该网页的链接，而不是去寻找正确的导入。例如，说“我正在自然数游戏的[这个关卡](https://adam.math.hhu.de/#/g/hhu-adam/NNG4/world/Addition/level/2)上，我的证明脚本是_blah_”会比说“我正在自然数游戏的加法世界第 2 关，我的证明脚本是_blah_”有用得多。

如果您在 Zulip 上发布代码片段，请确保它被三个反引号包围。

````text
```
def myNat : Nat := 5
```
````

## 精简代码的技巧
- 在 MWE 中，一个简单的 `import Mathlib` 是完全可以接受的导入。
- 为了制作 MWE，您可以将所有（您正在处理的那个之外的）`theorem` 和 `lemma` 的证明替换为 `sorry`。Lean 会给出额外的警告，但这些是无害的。

- 移除所有与您遇到的问题无关的声明（`def`、`theorem`、`lemma`、`example` 等）。通常，如果您可以注释掉某些代码而不会引发错误，那么它就可以被移除。

- 删除一些代码后，您可以接着删除所有仅在那里被引用的声明。通过重复这个过程几次，您可能能将一个长文件缩短到只有几行。
- 最后，您可以在代码中添加像 `-- 这里`、`-- 待办`、`-- 错误：等等等等` 或类似的注释，以将注意力引导到您 MWE 中的特定部分。