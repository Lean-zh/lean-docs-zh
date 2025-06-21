# LaTeX 示例

本测试页面收集了 Markdown 中的几个 LaTeX 示例。这仅用于开发目的。

比较： <https://math.meta.stackexchange.com/revisions/9386/164>

## 来自 doc-gen issue 的示例

来自 [doc-gen#10](https://github.com/leanprover-community/doc-gen/issues/10)，如果我把 $f[*a,*b](cd)$ 放在 tex 里会怎么样？$g_{x_0}(y)$ ？

来自 [doc-gen#62](https://github.com/leanprover-community/doc-gen/issues/62)：

- 可能表示 $R[X_i : i \in \sigma]$。
- 示例：$x \in \sigma$ 以及单独的 `y`
- 示例：$x \in \sigma$ 以及单独的 `s`
- 示例：$x \in \sigma$ 以及单独的 `sigm`
- 示例：$x \in \sigma$ 以及单独的 `simg`
- 示例：单独的 `s` 和 $x \in \sigma$

示例来自 [dynamics.circle.rotation_number.translation_number](https://github.com/leanprover-community/mathlib/blob/c35672bbe581370c345d0862c078fbbbe1258fb3/src/dynamics/circle/rotation_number/translation_number.lean#L641)：

对于任何 `x : ℝ`，序列 $\frac{f^n(x)-x}{n}$ 会趋向于 `f` 的平移数 (translation number)。
特别地，这个极限不依赖于 `x`。

## [mathlib#3776](https://github.com/leanprover-community/mathlib/pull/3776)

[PR 之前](https://github.com/leanprover-community/mathlib/blob/d61bd4ae29222280e1b6dec421c840fb83c30438/src/algebra/classical_lie_algebras.lean#L45) (有一个多余的 `cc`)，行距过大：

$$
  J = \left[\begin{align}{cc}
              0_l & 1_l\\\\
              1_l & 0_l
            \end{align}\right]
$$

[PR 之后](https://github.com/leanprover-community/mathlib/blob/0166d0baa856ca4c3d516025105cfe8f912f48dc/src/algebra/classical_lie_algebras.lean#L46)，行距过大：

$$
  J = \left[\begin{array}{cc}
              0_l & 1_l\\\\
              1_l & 0_l
            \end{array}\right]
$$

实际修复后：

$$
  J = \left[\begin{array}{cc}
              0_l & 1_l\\
              1_l & 0_l
            \end{array}\right]
$$


## [mathlib#6175](https://github.com/leanprover-community/mathlib/pull/6175)

[PR 之前](https://github.com/leanprover-community/mathlib/blob/c70feebd43e143d81a695f7d7e5b21e5892286e8/src/analysis/analytic/basic.lean#L626) (渲染正确)：

如果一个函数在圆盘 `D(x, R)` 内是解析的，那么它在包含于该圆盘的任何圆盘内也是解析的。确实，可以写作
$$
f (x + y + z) = \sum_{n} p_n (y + z)^n = \sum_{n, k} \binom{n}{k} p_n y^{n-k} z^k
= \sum_{k} \Bigl(\sum_{n} \binom{n}{k} p_n y^{n-k}\Bigr) z^k.
$$
因此，对应的幂级数的第 `k` 个系数等于
$\sum_{n} \binom{n}{k} p_n y^{n-k}$。在 `pₙ` 是一个多重线性映射 (multilinear map) 的一般情况下，这必须被适当地解释：不使用二项式系数，而是应该对 `fin n` 中所有基数为 `k` 的可能子集 `s` 进行求和，并将 `z` 分配给 `s` 中的索引，将 `y` 分配给 `s` 之外的索引。
在这一段中，我们实现了这一点。新的幂级数被称为 `p.change_origin y`。然后，我们检查它的收敛性以及它的和与原始和一致的事实。这个讨论的结果是，一个函数是解析的点的集合是开集。


[PR 之后](https://github.com/leanprover-community/mathlib/blob/676836509e16e6b6d3baf1354594658257f687bd/src/analysis/analytic/basic.lean#L626) (在 `sum` 前使用两个反斜杠作为变通方法；应该会出错)：

如果一个函数在圆盘 `D(x, R)` 内是解析的，那么它在包含于该圆盘的任何圆盘内也是解析的。确实，可以写作
$$
f (x + y + z) = \\sum_{n} p_n (y + z)^n = \\sum_{n, k} \binom{n}{k} p_n y^{n-k} z^k
= \\sum_{k} \Bigl(\\sum_{n} \binom{n}{k} p_n y^{n-k}\Bigr) z^k.
$$
因此，对应的幂级数的第 `k` 个系数等于
$\\sum_{n} \binom{n}{k} p_n y^{n-k}$。在 `pₙ` 是一个多重线性映射的一般情况下，这必须被适当地解释：不使用二项式系数，而是应该对 `fin n` 中所有基数为 `k` 的可能子集 `s` 进行求和，并将 `z` 分配给 `s` 中的索引，将 `y` 分配给 `s` 之外的索引。

## 行距测试

(每个示例上方给出了 math.stackexchange.com 的结果)

---

渲染正常 ✅：
$\alpha
\alpha$

---

不应渲染 ❌：
$\alpha

\alpha$

---

不应渲染 ❌：
$$\alpha

\alpha$$

---

不应渲染 ❌：
$$

\alpha
\alpha

$$

---

渲染正常 ✅：
$$ \alpha\alpha
$$

---

渲染正常 ✅：
$$
\alpha\alpha
[hi](345)
b
$$

---

不应渲染 ❌：
$$ \alpha\alpha [hi](https://github.com) \beta

$$

---

渲染正常 ✅：
\begin{align}
\begin{matrix}
a & b & c
\end{matrix}
\end{align}

---

只有内部的 matrix 环境应该渲染：
\begin{align}

[hi](https://github.com)
\begin{matrix}
a & b & c
\end{matrix}
\end{align}

---

不应渲染 ❌：
\begin{align}

\begin{matrix}

a & b & c
\end{matrix}
\end{align}

---

渲染正常 ✅：

hi there \begin{align} 3 \\ 3 \end{align}

---

不应渲染 ❌：
\begin{align}
\end{blah}

---

不应渲染 ❌：
\begin{align}
[link](https://github.com) { {\alpha}
\end{align}

## 嵌套环境

来自 <http://web.archive.org/web/20120617014306/http://www.st.fmph.uniba.sk/~kiselak1/pdfka/tex/latexMath_align.pdf>

\begin{align}T(n) & \leq 2(c\lfloor n/2 \rfloor \lg( \lfloor n/2 \rfloor )) + n \\T(n) & \leq 2(cn/2) \lg(n/2) + n \\T(n) & = cn (\lg n - 1) + n \\T(n) & \leq cn \lg n\end{align}

\begin{align}
T(n) & \leq 2(c\lfloor n/2 \rfloor \lg( \lfloor n/2 \rfloor )) + n \\
T(n) & \leq 2(cn/2) \lg(n/2) + n \\
T(n) & = cn (\lg n - 1) + n \\
T(n) & \leq cn \lg n
\end{align}

\begin{gather}
\begin{aligned}T(n) & \leq 2(c\lfloor n/2 \rfloor \lg( \lfloor n/2 \rfloor )) + n \\T(n) & \leq 2(cn/2) \lg(n/2) + n \\T(n) & = cn (\lg n - 1) + n \\T(n) & \leq cn \lg n\end{aligned}\end{gather}

\begin{gather}
\begin{aligned}
T(n) & \leq 2(c\lfloor n/2 \rfloor \lg( \lfloor n/2 \rfloor )) + n \\
T(n) & \leq 2(cn/2) \lg(n/2) + n \\
T(n) & = cn (\lg n - 1) + n \\
T(n) & \leq cn \lg n
\end{aligned}
\end{gather}

\begin{align}\begin{aligned}T(n) & \leq 2(c\lfloor n/2 \rfloor \lg( \lfloor n/2 \rfloor )) + n \\T(n) & \leq 2(cn/2) \lg(n/2) + n \\T(n) & = cn (\lg n - 1) + n \\T(n) & \leq cn \lg n\end{aligned}\end{align}


## MathJax 基础教程和快速参考

来自 <https://math.meta.stackexchange.com/questions/5020/mathjax-basic-tutorial-and-quick-reference>

(德语: [MathJax: LaTeX Basic Tutorial und Referenz](https://www.mathelounge.de/509545/mathjax-latex-basic-tutorial-und-referenz-deutsch))

1. 要查看任何问题或答案中任何公式的写法，包括本篇中的，右键单击表达式并选择 "Show Math As > TeX Commands"。（当您这样做时，'$' 将不会显示。请确保您添加了这些符号。请参阅下一点。还有[其他可能性](https://math.meta.stackexchange.com/q/659)可以查看公式或整个帖子的代码。）

2. **对于行内公式，将公式包含在 `$...$` 中。对于陈列公式，请使用 `$$...$$`。**
它们的渲染方式不同。例如，输入
`$\sum_{i=0}^n i^2 = \frac{(n^2+n)(2n+1)}{6}$`
来显示 $\sum_{i=0}^n i^2 = \frac{(n^2+n)(2n+1)}{6}$ (这是行内模式) 或输入
`$$\sum_{i=0}^n i^2 = \frac{(n^2+n)(2n+1)}{6}$$`
来显示
$$\sum_{i=0}^n i^2 = \frac{(n^2+n)(2n+1)}{6}$$
(这是陈列模式)。

3. 对于**希腊字母**，使用 `\alpha`, `\beta`, …, `\omega`: $\alpha, \beta, … \omega$。对于大写字母，使用 `\Gamma`, `\Delta`, …, `\Omega`: $\Gamma, \Delta, …, \Omega$。一些希腊字母有变体形式：
`\epsilon \varepsilon` $\epsilon$, $\varepsilon$, `\phi \varphi` $\phi$, $\varphi$ 等。

4. 对于**上标和下标**，使用 `^` 和 `_`。例如，`x_i^2`: $x_i^2$，`\log_2 x`: $\log_2 x$。

5. **分组**。上标、下标和其他操作只应用于下一个“组”。一个“组”可以是一个单一的符号，或任何被花括号 `{`…`}` 包围的公式。如果你输入 `10^10`，你会得到一个意外：$10^10$。但 `10^{10}` 会得到你可能想要的结果：$10^{10}$。使用花括号来界定一个应用上标或下标的公式：`x^5^6` 是错误的；`{x^y}^z` 是 ${x^y}^z$，而 `x^{y^z}` 是 $x^{y^z}$。观察 `x_i^2` $x_i^2$ 和 `x_{i^2}` $x_{i^2}$ 之间的区别。

6. **括号** 普通符号 `()[]` 可以生成圆括号和方括号 $(2+3)[4+4]$。使用 `\{` 和 `\}` 来生成花括号 $\{\}$。

    这些括号的大小*不会*随它们之间的公式缩放，所以如果你写 `(\frac{\sqrt x}{y^3})`，括号会太小：$(\frac{\sqrt x}{y^3})$。使用 `\left(`…`\right)` 将使大小自动适应它们所包含的公式：`\left(\frac{\sqrt x}{y^3}\right)` 是 $\left(\frac{\sqrt x}{y^3}\right)$。

   `\left` 和 `\right` 适用于以下所有类型的括号：`(` 和 `)` $(x)$，`[` 和 `]` $[x]$，`\{` 和 `\}` $\{ x \}$，`|` $|x|$，`\vert` $\vert x \vert$，`\Vert` $\Vert x \Vert$，`\langle` 和 `\rangle` $\langle x \rangle$，`\lceil` 和 `\rceil` $\lceil x \rceil$，以及 `\lfloor` 和 `\rfloor` $\lfloor x \rfloor$。`\middle` 可用于添加额外的分隔符。还有不可见的括号，用 `.` 表示：`\left.\frac12\right\rbrace` 是 $\left.\frac12\right\rbrace$。

    如果需要手动调整大小：
`\Biggl(\biggl(\Bigl(\bigl((x)\bigr)\Bigr)\biggr)\Biggr)` 得到
$\Biggl(\biggl(\Bigl(\bigl((x)\bigr)\Bigr)\biggr)\Biggr)$。

7. **求和与积分** `\sum` 和 `\int`；下标是下限，上标是上限，例如 `\sum_1^n` $\sum_1^n$。如果上下限不止一个符号，别忘了使用 `{`…`}`。例如，`\sum_{i=0}^\infty i^2` 是 $\sum_{i=0}^\infty i^2$。类似地，`\prod` $\prod$，`\int` $\int$，`\bigcup` $\bigcup$，`\bigcap` $\bigcap$，`\iint` $\iint$，`\iiint` $\iiint$，`\idotsint` $\idotsint$。

8. **分数** 有[三种方法可以创建分数](https://math.meta.stackexchange.com/q/12978/3111)。`\frac ab` 应用于接下来的两个组，并产生 $\frac ab$；对于更复杂的分子和分母，请使用 `{`…`}`：`\frac{a+1}{b+1}` 是 $\frac{a+1}{b+1}$。如果分子和分母很复杂，你可能更喜欢使用 `\over`，它会分割它所在的组：`{a+1\over b+1}` 是 ${a+1\over b+1}$。
使用 `\cfrac{a}{b}` 命令对于连分式 $\cfrac{a}{b}$ 很有用，更多细节请参见[这篇子文章](https://math.meta.stackexchange.com/a/5058/3111)。

9. **字体**

  * 使用 `\mathbb` 或 `\Bbb` 来显示“黑板粗体”：$\mathbb{CHNQRZ}$。
  * 使用 `\mathbf` 来显示粗体：$\mathbf{ABCDEFGHIJKLMNOPQRSTUVWXYZ}$  $\mathbf{abcdefghijklmnopqrstuvwxyz}$。
    * 对于基于表达式的字符，请改用 `\boldsymbol`：$\boldsymbol{\alpha}$
  * 使用 `\mathit` 来显示斜体：$\mathit{ABCDEFGHIJKLMNOPQRSTUVWXYZ}$ $\mathit{abcdefghijklmnopqrstuvwxyz}$。
  * 使用 `\pmb` 来显示粗斜体：$\pmb{ABCDEFGHIJKLMNOPQRSTUVWXYZ}$ $\pmb{abcdefghijklmnopqrstuvwxyz}$。
  * 使用 `\mathtt` 来显示“打字机”字体：$\mathtt{ABCDEFGHIJKLMNOPQRSTUVWXYZ}$ $\mathtt{abcdefghijklmnopqrstuvwxyz}$。
  * 使用 `\mathrm` 来显示罗马字体：$\mathrm{ABCDEFGHIJKLMNOPQRSTUVWXYZ}$  $\mathrm{abcdefghijklmnopqrstuvwxyz}$。
  * 使用 `\mathsf` 来显示无衬线字体：$\mathsf{ABCDEFGHIJKLMNOPQRSTUVWXYZ}$  $\mathsf{abcdefghijklmnopqrstuvwxyz}$。
  * 使用 `\mathcal` 来显示“手写体”字母：$\mathcal{ ABCDEFGHIJKLMNOPQRSTUVWXYZ}$
  * 使用 `\mathscr` 来显示脚本字母：$\mathscr{ABCDEFGHIJKLMNOPQRSTUVWXYZ}$
  * 使用 `\mathfrak` 来显示“Fraktur”（旧德国风格）字母：$\mathfrak{ABCDEFGHIJKLMNOPQRSTUVWXYZ} \mathfrak{abcdefghijklmnopqrstuvwxyz}$。

10. **根号** 使用 `sqrt`，它会根据其参数的大小进行调整：`\sqrt{x^3}` $\sqrt{x^3}$；`\sqrt[3]{\frac xy}` $\sqrt[3]{\frac xy}$。对于复杂的表达式，可以考虑使用 `{...}^{1/2}` 代替。

11. 一些**特殊函数**，如 "lim"、"sin"、"max"、"ln" 等，通常使用罗马字体而不是斜体。使用 `\lim`、`\sin` 等来生成它们：`\sin x` $\sin x$，而不是 `sin x` $sin x$。使用下标将符号附加到 `\lim` 上：`\lim_{x\to 0}` $$\lim_{x\to 0}$$ 非标准函数名可以用 `\operatorname{foo}(x)` $\operatorname{foo}(x)$ 来设置。

12. 有非常多的**特殊符号和表示法**，这里无法一一列出；请参阅[这个更短的列表](http://pic.plover.com/MISC/symbols.pdf)，或[这个详尽的列表](https://www.ctan.org/tex-archive/info/symbols/comprehensive/symbols-a4.pdf)。一些最常见的包括：
  * `\lt \gt \le \leq \leqq \leqslant \ge \geq \geqq \geqslant \neq` $\lt$, $\gt$, $\le$, $\leq$, $\leqq$, $\leqslant$, $\ge$, $\geq$, $\geqq$, $\geqslant$, $\neq$。你可以用 `\not` 在几乎任何东西上画一条斜线：`\not\lt` $\not\lt$ 但通常看起来不好。
  * `\times \div \pm \mp` $\times$, $\div$, $\pm$, $\mp$。`\cdot` 是一个居中的点：$x\cdot y$
  * `\cup \cap \setminus \subset \subseteq \subsetneq \supset \in \notin \emptyset \varnothing` $\cup$, $\cap$, $\setminus$, $\subset$, $\subseteq$, $\subsetneq$, $\supset$, $\in$, $\notin$, $\emptyset$, $\varnothing$
  * `{n+1 \choose 2k}` 或 `\binom{n+1}{2k}` ${n+1 \choose 2k}$
  * `\to \rightarrow \leftarrow \Rightarrow \Leftarrow \mapsto` $\to$, $\rightarrow$, $\leftarrow$, $\Rightarrow$, $\Leftarrow$, $\mapsto$
  * `\land \lor \lnot \forall \exists \top \bot \vdash \vDash` $\land$, $\lor$, $\lnot$, $\forall$, $\exists$, $\top$, $\bot$, $\vdash$, $\vDash$
  * `\star \ast \oplus \circ \bullet` $\star$, $\ast$, $\oplus$, $\circ$, $\bullet$
  * `\approx \sim \simeq \cong \equiv \prec \lhd \therefore` $\approx$, $\sim $, $\simeq$, $\cong$, $\equiv$, $\prec$, $\lhd$, $\therefore$
  * `\infty \aleph_0` $\infty\, \aleph_0$ `\nabla \partial` $\nabla$, $\partial$ `\Im \Re` $\Im$, $\Re$
  * 对于模等价，像这样使用 `\pmod`：`a\equiv b\pmod n` $a\equiv b\pmod n$。
  * 对于二元模运算符，像这样使用 `\bmod`：`a\bmod 17` $a\bmod 17$。
  * 避免使用 `\mod`，因为它会产生额外的空格：比较上面与 `a\mod 17` $a\mod 17$。
  * `\ldots` 是 $a_1, a_2, \ldots ,a_n$ 中的点 `\cdots` 是 $a_1+a_2+\cdots+a_n$ 中的点
  * 脚本体小写 l 是 `\ell` $\ell$。

  [Detexify](http://detexify.kirelabs.org/classify.html) 允许您在网页上绘制一个符号，然后列出看起来相似的 $\TeX$ 符号。这些符号不保证能在 MathJax 中工作，但可以作为很好的起点。要检查一个命令是否受支持，请注意 MathJax.org 维护着一个[当前支持的 $\LaTeX$ 命令列表](http://docs.mathjax.org/en/latest/tex.html#supported-latex-commands)，也可以查看 Carol JVF Burns 博士的 [$\TeX$ Commands Available in MathJax](http://www.onemathematicalcat.org/MathJaxDocumentation/TeXSyntax.htm) 页面。

13. **空格** MathJax 通常会自己决定如何对公式进行间距排版，它使用一套复杂的规则。在公式中加入额外的字面空格不会改变 MathJax 放入的空格量：`a␣b` 和 `a␣␣␣␣b` 都是 $a    b$。要添加更多空格，使用 `\,` 表示一个窄空格 $a\,b$；`\;` 表示一个更宽的空格 $a\;b$。`\quad` 和 `\qquad` 是大空格：$a\quad b$, $a\qquad b$。

  要设置纯文本，请使用 `\text{…}`：$\{x\in s\mid x\text{ is extra large}\}$。你可以在 `\text{…}` 内部嵌套 `$…$`，例如为了使用空格。

14. **重音和变音符号** 对单个符号使用 `\hat` $\hat x$，对较长的公式使用 `\widehat` $\widehat{xy}$。如果弄得太宽，会看起来很傻。类似地，有 `\bar` $\bar x$ 和 `\overline` $\overline{xyz}$，以及 `\vec` $\vec x$ 和 `\overrightarrow` $\overrightarrow{xy}$ 和 `\overleftrightarrow` $\overleftrightarrow{xy}$。对于点，如 $\frac d{dx}x\dot x =  \dot x^2 +  x\ddot x$，使用 `\dot` 和 `\ddot`。

15. 用于 MathJax 解释的特殊字符可以使用 `\` 字符进行转义：`\$` $\$$, `\{` $\{$, `\_` $\_$, 等等。如果你想要 `\` 本身，你应该使用 `\backslash` (符号) 或 `\setminus` ([二元运算](https://tex.stackexchange.com/a/511332)) 来表示 $\backslash$，因为 `\\` 用于换行。

（教程到此结束。）

-------------

很重要的一点是，这份说明应该相当简短，不要过于臃肿。要包含更多主题，请创建简短的附录并以回答的形式发布，而不是插入到这篇文章中。

目录
---
按标题字母顺序排列的 MathJax 主题链接列表：

 - [绝对值和范数](https://math.meta.stackexchange.com/a/15078/161490) • [附加符号装饰](https://math.meta.stackexchange.com/a/13081/161490) • [对齐方程][3]
 - [LaTeX 的替代书写方式](https://math.meta.stackexchange.com/a/27910/161490) • [推理的注释](https://math.meta.stackexchange.com/a/21258/161490) • [任意运算符](https://math.meta.stackexchange.com/a/15077/161490)
 - [数组](https://math.meta.stackexchange.com/a/5044/161490) • [大括号](https://math.meta.stackexchange.com/a/11423/161490) • [颜色](https://math.meta.stackexchange.com/a/10116/161490)
 - [交换图](https://math.meta.stackexchange.com/a/16888/161490) • [连分式](https://math.meta.stackexchange.com/a/5058/161490) • [划掉内容](https://math.meta.stackexchange.com/a/13183/161490)
 - [分情况定义 (分段函数)](https://math.meta.stackexchange.com/a/5025/161490) • [度数符号](https://math.meta.stackexchange.com/a/19678/161490) • [陈列样式](https://math.meta.stackexchange.com/a/25054/161490)
 - [方程编号](https://math.meta.stackexchange.com/a/27793/161490) • [繁琐的间距问题](https://math.meta.stackexchange.com/a/5057/161490) • [高亮表达式](https://math.meta.stackexchange.com/a/22395/161490)
 - [左右箭头](https://math.meta.stackexchange.com/a/13310/161490) • [极限](https://math.meta.stackexchange.com/a/12850/161490) • [线性规划](https://math.meta.stackexchange.com/a/27756/161490)
 - [长除法](https://math.meta.stackexchange.com/a/21096/161490) • [数学规划][2] • [矩阵][1]
 - [马尔可夫链](https://math.meta.stackexchange.com/a/31141/161490) • [在行内混合代码和 MathJax 格式](https://math.meta.stackexchange.com/a/25251/161490) • [\newcommand 函数](https://math.meta.stackexchange.com/a/11638/161490)
 - [方程编号][4] • [叠加符号](https://math.meta.stackexchange.com/a/32210/736802) • [扑克牌](https://math.meta.stackexchange.com/a/22516/161490)
 - [符号](https://math.meta.stackexchange.com/a/11284/161490)
• [方程组](https://math.meta.stackexchange.com/a/6267/161490) • [表格](https://math.meta.stackexchange.com/a/29979/161490)
 - [标签和引用](https://math.meta.stackexchange.com/a/11491/161490) • [张量索引](https://math.meta.stackexchange.com/a/30661/161490) • [单位](https://math.meta.stackexchange.com/a/27212/161490)
 - [垂直间距](https://math.meta.stackexchange.com/a/25048/161490)

  [1]: https://math.meta.stackexchange.com/a/5023/676335
  [2]: https://math.meta.stackexchange.com/a/27756/676335
  [3]: https://math.meta.stackexchange.com/a/5024/676335
  [4]: https://math.meta.stackexchange.com/a/11491/676335
  [5]: https://math.meta.stackexchange.com/a/29979/676335

## 对齐的方程

<https://math.meta.stackexchange.com/questions/5020/mathjax-basic-tutorial-and-quick-reference/5024#5024>

人们通常想要一系列等号对齐的方程。要实现这一点，请使用 `\begin{align}…\end{align}`。每一行应以 `\\` 结尾，并应在要对齐的位置包含一个 & 符号，通常紧接在等号之前。

例如，

\begin{align}
\sqrt{37} & = \sqrt{\frac{73^2-1}{12^2}} \\
 & = \sqrt{\frac{73^2}{12^2}\cdot\frac{73^2-1}{73^2}} \\
 & = \sqrt{\frac{73^2}{12^2}}\sqrt{\frac{73^2-1}{73^2}} \\
 & = \frac{73}{12}\sqrt{1 - \frac{1}{73^2}} \\
 & \approx \frac{73}{12}\left(1 - \frac{1}{2\cdot73^2}\right)
\end{align}

是由以下代码生成的


    \begin{align}
\sqrt{37} & = \sqrt{\frac{73^2-1}{12^2}} \\
 & = \sqrt{\frac{73^2}{12^2}\cdot\frac{73^2-1}{73^2}} \\
 & = \sqrt{\frac{73^2}{12^2}}\sqrt{\frac{73^2-1}{73^2}} \\
 & = \frac{73}{12}\sqrt{1 - \frac{1}{73^2}} \\
 & \approx \frac{73}{12}\left(1 - \frac{1}{2\cdot73^2}\right)
\end{align}

此处可以省略用于界定陈列模式的常用 `$$` 标记。


## 分情况定义（分段函数）

<https://math.meta.stackexchange.com/a/5025>

使用 `\begin{cases}…\end{cases}`。每个情况以 `\\` 结尾，并在需要对齐的部分前使用 `&`。

例如，你可以得到这个：

$$f(n) =
\begin{cases}
n/2,  & \text{if $n$ is even} \\
3n+1, & \text{if $n$ is odd}
\end{cases}$$

通过编写以下代码：

      f(n) =
    \begin{cases}
n/2,  & \text{if $n$ is even} \\
3n+1, & \text{if $n$ is odd}
\end{cases}

大括号可以移到右边：
$$
\left.
\begin{array}{l}
\text{if $n$ is even:}&n/2\\
\text{if $n$ is odd:}&3n+1
\end{array}
\right\}
=f(n)
$$
通过编写以下代码：

    \left.
    \begin{array}{l}
\text{if $n$ is even:}&n/2\\
\text{if $n$ is odd:}&3n+1
\end{array}
    \right\}
    =f(n)

为了在情况之间获得更大的垂直空间，我们可以使用 `\\[2ex]` 而不是 `\\`。例如，你可以得到这个：

$$f(n) =
\begin{cases}
\frac{n}{2},  & \text{if $n$ is even} \\[2ex]
3n+1, & \text{if $n$ is odd}
\end{cases}$$

通过编写以下代码：

    f(n) =
    \begin{cases}
\frac{n}{2},  & \text{if $n$ is even} \\[2ex]
3n+1, & \text{if $n$ is odd}
\end{cases}

（一个 ‘ex’ 是等于字母 `x` 高度的长度单位；`2ex` 在这里意味着空间应该是两个 ex 高。）

## 矩阵

<https://math.meta.stackexchange.com/a/5023/>

1. 使用 `$$\begin{matrix}…\end{matrix}$$` 在 `\begin` 和 `\end` 之间，放入矩阵元素。每个矩阵行以 `\\` 结尾，矩阵元素之间用 `&` 分隔。例如，

        $$
        \begin{matrix}
        1 & x & x^2 \\
        1 & y & y^2 \\
        1 & z & z^2 \\
        \end{matrix}
$$

    产生：

$$
        \begin{matrix}
        1 & x & x^2 \\
        1 & y & y^2 \\
        1 & z & z^2 \\
        \end{matrix}
$$

  MathJax 将调整行和列的大小以使所有内容都适合。

2. 要添加括号，可以使用教程第6节中的 `\left…\right`，或者将 `matrix` 替换为 `pmatrix` $\begin{pmatrix}1&2\\3&4\\ \end{pmatrix}$、`bmatrix` $\begin{bmatrix}1&2\\3&4\\ \end{bmatrix}$、`Bmatrix` $\begin{Bmatrix}1&2\\3&4\\ \end{Bmatrix}$、`vmatrix` $\begin{vmatrix}1&2\\3&4\\ \end{vmatrix}$、`Vmatrix` $\begin{Vmatrix}1&2\\3&4\\ \end{Vmatrix}$。

3. 当您想省略某些条目时，请使用 `\cdots` $\cdots$ `\ddots` $\ddots$ `vdots` $\vdots$：

     $$\begin{pmatrix}
     1 & a_1 & a_1^2 & \cdots & a_1^n \\
     1 & a_2 & a_2^2 & \cdots & a_2^n \\
     \vdots  & \vdots& \vdots & \ddots & \vdots \\
     1 & a_m & a_m^2 & \cdots & a_m^n
     \end{pmatrix}$$


4. 对于水平“增广”矩阵，将括号或方括号放在格式合适的表格周围；详见下文的[数组](http://meta.math.stackexchange.com/a/5044/)。这是一个例子：

  $$ \left[\begin{array}{cc|c}
  1&2&3\\
  4&5&6
  \end{array}\right] $$

  是由以下代码生成的：

        $$ \left[
    \begin{array}{cc|c}
      1&2&3\\
      4&5&6
    \end{array}
\right] $$

  这里的 `cc|c` 是关键部分；它表示有三个居中对齐的列，第二列和第三列之间有一条竖线。

5. 对于垂直“增广”矩阵，使用 `\hline`。例如

$$
\begin{pmatrix}
a & b \\
c & d\\
\hline
1 & 0\\
0 & 1
\end{pmatrix}
$$
是由以下代码生成的

    $$
      \begin{pmatrix}
        a & b\\
        c & d\\
      \hline
        1 & 0\\
        0 & 1
      \end{pmatrix}
    $$


6. 对于小型行内矩阵，使用 `\bigl(\begin{smallmatrix} ... \end{smallmatrix}\bigr)`，例如 $\bigl( \begin{smallmatrix} a & b \\ c & d \end{smallmatrix} \bigr)$ 是由以下代码生成的：

         $\bigl( \begin{smallmatrix} a & b \\ c & d \end{smallmatrix} \bigr)$

## 来自 `tactic_writing.md`

* `return`: 在 monad 中产生一个值（类型：`A → m A`）
* `ma >>= f`: 从 `ma : m A` 中获取 `A` 类型的值，并将其传递给 `f : A → m B`。备用语法：`do a ← ma, f a`
* `f <$> ma`: 将函数 `f : A → B` 应用于 `ma : m A` 中的值以获得一个 `m B`。等同于 `do a ← ma, return (f a)`
* `ma >> mb`: 等同于 `do a ← ma, mb`；这里 `ma` 的返回值被忽略，然后调用 `mb`。备用语法：`do ma, mb`
* `mf <*> ma`: 等同于 `do f ← mf, f <$> ma`，或 `do f ← mf, a ← ma, return (f a)`
* `ma <* mb`: 等同于 `do a ← ma, mb, return a`
* `ma *> mb`: 等同于 `do ma, mb`，或 `ma >> mb`。为什么同一个东西有两种表示法？历史原因。
* `pure`: 等同于 `return`。同样是历史原因。
* `failure`: 失败的值（特定的 monad 通常有更有用的形式，例如 tactic 的 `fail` 和 `failed`）。
* `ma <|> ma'`: 从失败中恢复：运行 `ma`，如果失败则运行 `ma'`。
* `a $> mb`: 等同于 `do mb, return a`
* `ma <$ b`: 等同于 `do ma, return b`