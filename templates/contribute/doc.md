# 文档风格

所有的拉取请求 (pull request) 都必须符合以下文档标准。关于[自动生成的文档页面](https://leanprover-community.github.io/mathlib4_docs/)，请参阅 [the `doc-gen` repo](https://github.com/leanprover/doc-gen4)。

你可以使用 [Lean 文档预览页面](https://observablehq.com/@bryangingechen/github-lean-doc-preview) 来预览 GitHub 页面或拉取请求 (pull request) 的 Markdown 处理效果。

## 文件头注释

每个 mathlib 文件都应以以下内容开头：
* 一个包含版权信息的头部注释（请参阅我们[风格指南中的建议](style.html#header-and-imports)）；
* 导入列表（每行一个）；
* 一个包含通用文档的模块文档字符串，[使用 Markdown 和 LaTeX](#latex-and-markdown) 编写。

（请参见下面的示例。）

标题使用 atx 风格的标题（使用井号，下方无破折线）。
开始和结束的分隔符 `/-!` 和 `-/` 应各占一行。

文件的强制性标题是一个一级标题。其后是文件内容的摘要。

其他部分，使用二级标题，按此顺序排列：
* **主要定义** (可选，可包含在摘要中)
* **主要陈述** (可选，可包含在摘要中)
* **符号表示** (仅当此文件没有引入任何符号时省略)
* **实现说明** (对重要设计决策或接口功能的描述，包括类型类的使用以及新定义的 `simp` 规范形式)
* **参考文献** (对教科书、论文或维基百科页面的引用)
* **标签** (一个关键词列表，在 mathlib 中进行文本搜索以查找某项内容时可能会有用)

参考文献应引用 [the mathlib citations file](https://github.com/leanprover-community/mathlib4/blob/master/docs/references.bib) 中的 bibtex 条目。
请参阅下方的 [引用其他作品](#citing-other-works) 部分。

以下代码块是一个文件头示例。

```lean
/-
Copyright (c) 2018 Robert Y. Lewis. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Robert Y. Lewis

! This file was ported from Lean 3 source module number_theory.padics.padic_norm
! leanprover-community/mathlib commit 92ca63f0fb391a9ca5f22d2409a6080e786d99f7
! Please do not edit these lines, except to modify the commit id
! if you have ported upstream changes.
-/
import Mathlib.Algebra.Order.Field.Power
import Mathlib.NumberTheory.Padics.PadicVal

/-!
# p-adic norm

This file defines the `p`-adic norm on `ℚ`.

The `p`-adic valuation on `ℚ` is the difference of the multiplicities of `p` in the numerator and
denominator of `q`. This function obeys the standard properties of a valuation, with the appropriate
assumptions on `p`.

The valuation induces a norm on `ℚ`. This norm is a nonarchimedean absolute value.
It takes values in {0} ∪ {1/p^k | k ∈ ℤ}.

## Implementation notes

Much, but not all, of this file assumes that `p` is prime. This assumption is inferred automatically
by taking `[Fact p.Prime]` as a type class argument.

## References

* [F. Q. Gouvêa, *p-adic numbers*][gouvea1997]
* [R. Y. Lewis, *A formal proof of Hensel's lemma over the p-adic integers*][lewis2019]
* <https://en.wikipedia.org/wiki/P-adic_number>

## Tags

p-adic, p adic, padic, norm, valuation
-/
```

## 文档字符串

每个定义和主要定理都必须有文档字符串（doc string）。
（也鼓励在引理上使用文档字符串，特别是当引理具有任何数学内容或可能在其他文件中有用时。）
它们通过 `/--` 引入，并由上方的 `-/` 闭合，标记和文本之间使用换行符或单个空格。
文档字符串中的后续行不应缩进。
它们也可以包含 Markdown 和 LaTeX：请参阅下一节。如果一个文档字符串是一个完整的句子，那么它应该以句号结尾。命名的定理，例如 **平均值定理 (mean value theorem)**，应该加粗（即前后各有两个星号）。

文档字符串应传达定义的数学含义。它们允许在实际实现上存在轻微的出入。以下是一个文档字符串示例：

```lean
/-- If `q ≠ 0`, the `p`-adic norm of a rational `q` is `p ^ (-padicValRat p q)`.
If `q = 0`, the `p`-adic norm of `q` is `0`. -/
def padicNorm (p : ℕ) (q : ℚ) : ℚ :=
  if q = 0 then 0 else (p : ℚ) ^ (-padicValRat p q)
```

一个轻微不符但仍能描述数学内容的示例如下：

```lean
/-- `padicValRat` defines the valuation of a rational `q` to be the valuation of `q.num` minus the
valuation of `q.den`. If `q = 0` or `p = 1`, then `padicValRat p q` defaults to `0`. -/
def padicValRat (p : ℕ) (q : ℚ) : ℤ :=
  padicValInt p q.num - padicValNat p q.den
```

`docBlame` linter 会列出所有没有文档字符串的定义。`docBlameThm` linter 会列出没有文档字符串的定理和引理。

要仅运行 `docBlame` linter，请将以下内容添加到您的 lean 文件末尾：
```
#lint only docBlame
```
要仅运行 `docBlame` 和 `docBlameThm` linter，请将以下内容添加到您的 lean 文件末尾：
```
#lint only docBlame docBlameThm
```
要运行所有默认 linter（包括 `docBlame`），请将以下内容添加到您的 lean 文件末尾：
```
#lint
```
要运行所有默认 linter（包括 `docBlame`）并运行 `docBlameThm`，请将以下内容添加到您的 lean 文件末尾：
```
#lint docBlameThm
```

## LaTeX 和 Markdown

我们通常将对 Lean 声明或变量的引用放在反引号之间。编写完全限定名称（例如 `finset.card_pos` 而不是 `card_pos`）会在我们的[在线文档](https://leanprover-community.github.io/mathlib4_docs/)中将该名称转换为链接。

原始 URL 应包含在尖括号 `<...>` 中，以确保它们在网上是可点击的。（某些 URL，特别是那些带有括号或其他特殊符号的 URL，可能无法被 markdown 渲染器正确解析。）

当讨论的是数学符号时，使用 LaTeX 可能更可取。LaTeX 可以通过三种方式包含在文档字符串中：
- 使用单个美元符号 `$ ... $` 来内联渲染数学公式，
- 使用双美元符号 `$$ ... $$` 以“显示模式”渲染数学公式，或
- 使用环境 `\begin{*} ... \end{*}`（不带美元符号）。

这些对应于我们在线文档的 [MathJax](http://docs.mathjax.org/en/latest/basic/mathematics.html) 设置。那里的 Markdown 和 LaTeX 之间的交互类似于 <https://math.stackexchange.com> 和 <https://mathoverflow.net> 上的交互，所以你可以将文档字符串粘贴到[那里的编辑沙盒](https://math.meta.stackexchange.com/questions/4666/sandbox-for-drafts-of-long-complex-posts)中以预览最终结果。另请参阅 math.stackexchange 的 [MathJax 教程](https://math.meta.stackexchange.com/questions/5020/mathjax-basic-tutorial-and-quick-reference)。

## 分区注释

通常会将一个文件按节进行组织，每一节包含相关的声明。通过在开头使用模块文档 `/-! ... -/` 来描述这些节，可以在文档中看到它们。

虽然这些分区注释通常会对应于 `section` 或 `namespace` 命令，但这并非强制要求。你可以在一个 section 或 namespace 内部使用分区注释，也可以在一个分区注释后有多个 section 或 namespace。

分区注释仅用于显示和可读性。它们没有语义含义。

三级标题 `###` 应用于分区注释内部的标题。

如果注释超过一行，分隔符 `/-!` 和 `-/` 应各占一行。

实践中的示例请参见 [Lean/Expr/Basic.lean](https://github.com/leanprover-community/mathlib4/blob/master/Mathlib/Lean/Expr/Basic.lean)。

```lean
namespace BinderInfo

/-! ### Declarations about `BinderInfo` -/

/-- The brackets corresponding to a given `BinderInfo`. -/
def brackets : BinderInfo → String × String
  | BinderInfo.implicit => ("{", "}")
  | BinderInfo.strictImplicit => ("{{", "}}")
  | BinderInfo.instImplicit => ("[", "]")
  | _ => ("(", ")")

end BinderInfo

namespace Name

/-! ### Declarations about `name` -/

/-- Find the largest prefix `n` of a `Name` such that `f n != none`, then replace this prefix
with the value of `f n`. -/
def mapPrefix (f : Name → Option Name) (n : Name) : Name := Id.run do
  if let some n' := f n then return n'
  match n with
  | anonymous => anonymous
  | str n' s => mkStr (mapPrefix f n') s
  | num n' i => mkNum (mapPrefix f n') i
```

## 理论文档

除了 Lean 文件中的文档，我们还有[理论文档](../theories.html)，其中我们提供了跨越多个 Lean 文件的概述，以及在形式化需要稍微奇特的观点时提供更多的数学解释，例如参见[拓扑学文档](../theories/topology.html)。

## 引用其他作品

要在文档字符串中引用论文和书籍，应首先将参考文献添加到 BibTeX 文件中：`docs/references.bib`。要使用 `bibtool` 规范化该文件，你可以运行：

```text
bibtool --preserve.key.case=on --preserve.keys=on --print.use.tab=off --pass.comments=on -s -i docs/references.bib -o docs/references.bib
```

为确保您的引用在在线文档中成为链接，您可以使用以下两种样式中的任意一种：

首先，您可以将 `docs/references.bib` 中使用的引用键括在方括号中：

```markdown
The proof can be found in [Boole1854].
```

在在线文档中，这将变成类似：

> The proof can be found in [[Boo54]](https://leanprover-community.github.io/mathlib4_docs/references.html)

（引用键将变为 [`alpha` 样式标签](https://www.bibtex.com/s/bibliography-style-base-alpha/)，并成为指向文档[参考文献页面](https://leanprover-community.github.io/mathlib4_docs/references.html)的链接。）

或者，您可以通过在引用键前用方括号放置自定义文本来自定义引用：

```markdown
See [Grundlagen der Geometrie][hilbert1999] for an alternative axiomatization.
```

> See [Grundlagen der Geometrie](https://leanprover-community.github.io/mathlib4_docs/references.html) for an alternative axiomatization.

请注意，您当前不能在链接文本中使用右方括号 `]` 符号。因此，以下内容不会产生有效的链接：

```markdown
We follow [Euclid's *Elements* [Prop. 1]][heath1956a].
```

> We follow [Euclid's *Elements* [Prop. 1]][heath1956a].

## 示例

以下文件被维护为良好文档风格的示例：

* [Mathlib.NumberTheory.Padics.PadicNorm](https://github.com/leanprover-community/mathlib4/blob/master/Mathlib/NumberTheory/Padics/PadicNorm.lean)
* [Mathlib.Topology.Basic](https://github.com/leanprover-community/mathlib4/blob/master/Mathlib/Topology/Basic.lean)
* [Analysis.Calculus.ContDiff.Basic](https://github.com/leanprover-community/mathlib4/blob/master/Mathlib/Analysis/Calculus/ContDiff/Basic.lean)