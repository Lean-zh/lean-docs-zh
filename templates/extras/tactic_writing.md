<div class="alert alert-info">
<p>
我们目前正在更新 Lean 社区网站以介绍 Lean 4 的使用，但您今天在这里找到的大部分信息仍然是关于 Lean 3 的。
</p>
<p>
<b><em>警告：Lean 3 和 Lean 4 不兼容。</em></b>本页中的所有示例都无法在 Lean 4 中运行。关于编写 Lean 4 策略的参考资料，请参见
  <a href="https://leanprover-community.github.io/lean4-metaprogramming-book/">《Metaprogramming in Lean 4》</a>
  和 <a href="https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Custom-Tactics/#custom-tactics">《The Lean Language Reference》</a>。
</p>
<p>
我们非常欢迎为本页面更新 Lean 4 内容的拉取请求 (pull requests)。本页底部有一个链接。
</p>
<p>
请访问 <a href="https://leanprover.zulipchat.com">leanprover zulip</a>，在这个过渡时期寻求任何你需要的帮助！
</p>
<p>
Lean 3 的网站已被<a href="https://leanprover-community.github.io/lean3/">存档</a>。
如果你需要链接到 Lean 3 的特定资源，请链接到那里。
</p>
</div>

# 教程：在 Lean 3 中编写策略

***本页内容关于 Lean 3：** 请在继续阅读前阅读上方的横幅。*

这是一篇在 Lean 中开始编写你自己的策略的入门教程。
它的目标读者是不一定有在函数式编程语言 (functional programming language) 中使用 monad 经验的人群（例如，大多数数学家）。

其他学习编写策略的有用资源包括：
* Rob Lewis 在 Lean for the Curious Mathematician 2020 上的 Lean 元编程[视频教程](https://www.youtube.com/playlist?list=PLlF-CfQhukNnq2kDCw2P_vI5AfXN7egP2)
* 《[Hitchhiker's Guide to Logical Verification](https://github.com/blanchette/logical_verification_2021/raw/main/hitchhikers_guide.pdf)》的第 7 章
* 关于 Lean 元编程的原始论文
  [《A Metaprogramming Framework for Formal Verification》](https://lean-lang.org/papers/tactic.pdf)

## Monad 论

策略 (Tactics) 是作用于证明状态 (proof state) 的程序。但 Lean 是一种函数式编程语言。这意味着你所能做的就是定义和求值函数。每个函数接受一个预定义类型的输入，并给出一个预定义类型的输出。这似乎阻止了拥有全局状态（如当前的假设和目标），以及让输出类型依赖于输入值（例如一个策略可以成功或失败），或者输出消息。这些问题通过三层技巧来解决（下面的简要描述希望稍后会变得更清晰）：
* 使用复杂的类型来传递证明状态和策略运行状态
* 使用巧妙的记法来隐藏大部分复杂的类型簿记和组合
* 使用交互式策略块 (interactive tactic blocks)，由 `by` 引入或由 `begin`/`end` 界定

前两点统称为 monadic 编程 (monadic programming)（当然有更精确的定义，但我们将尽量忽略它）。

一个可以检查证明状态、修改它，并可能返回类型为 `α` 的东西（或失败）的函数，其类型被称为 `tactic α`。特别是，`tactic unit` 只关心操纵证明状态，而不试图返回任何东西（技术上它会返回一个 `unit` 类型的东西，这个类型只有一个项，用 `()` 表示）。
这样的函数要么被其他策略调用——这些通常在 `tactic` 命名空间中——要么由用户在策略块内交互式地调用——这些必须在 `tactic.interactive` 命名空间中（对于非常简单的策略这不完全必要，但如果忽略此规则通常会发生奇怪的事情）。一个有时很方便的快捷方式是：可以使用 `` run_cmd add_interactive [`my_tac1,`my_tac2, `my_tac3] `` 将名为 `my_tac1`、`my_tac2`、`my_tac3` 的定义复制到 `tactic.interactive` 命名空间中。
这些函数将用于生成 Lean 证明，但我们不会证明关于这些函数本身的任何东西，常量 `my_tac1`、`my_tac2` 等也不会出现在它们生成的证明中。通过在它们前面加上关键字 `meta`，我们告诉 Lean 它们“仅用于求值”，这会禁用非 `meta` 声明必须通过的某些检查。
这些知识足以让我们编写第一个策略。

```lean
meta def my_first_tactic : tactic unit := tactic.trace "Hello, World."

example : true :=
begin
  my_first_tactic,
  trivial
end
```

在该示例中，`my_first_tactic` 在 VS Code 中呈绿色下划线，将光标移至该行将在 Lean 消息缓冲区中显示我们的消息。

接下来我们需要学习如何链接多个动作。从根本上说，这都是关于函数组合，但 monadic 记法隐藏了这一点，并模拟了命令式编程 (imperative programming)。我们需要使用 `and_then` 组合子 (combinator)。第一种方法是使用中缀表示法 `>>`，如：

```lean
meta def my_second_tactic : tactic unit :=
tactic.trace "Hello," >> tactic.trace "World."
```
这现在将我们的消息分两部分打印。或者，可以使用 `do` 语法，它还有其他好处。这引入了一个按顺序执行的、以逗号分隔的指令列表。
```lean
meta def my_second_tactic' : tactic unit :=
do
  tactic.trace "Hello,",
  tactic.trace "World."
```

除了显示消息，策略能做的下一件事是失败，并可能附带一些解释。
```lean
meta def my_failing_tactic  : tactic unit := tactic.failed

meta def my_failing_tactic' : tactic unit :=
tactic.fail "This tactic failed, we apologize for the inconvenience."
```

在链接指令时，第一个失败会中断整个过程。
然而，`orelse` 组合子 (combinator)，用中缀 `<|>` 表示，允许在其左侧失败时尝试其右侧。下面这个例子将成功地传递其消息。
```lean
meta def my_orelse_tactic : tactic unit :=
my_failing_tactic <|> my_first_tactic
```

下一个要做的复合事情是使用某个函数，它在读取或改变证明状态后，实际上尝试返回某些东西。例如，内置的 `tactic.target`（尝试）返回当前目标。这个目标有类型 `expr`（稍后会详细介绍这个类型）。因此，`tactic.target` 的类型是 `tactic expr`。假设我们想追踪当前目标。一个天真的尝试会是：
```lean
meta def broken_trace_goal : tactic unit :=
tactic.trace tactic.target    -- 错误！
```
这不可能是正确的，因为 `tactic.target` 可能会失败（可能没有目标了），而 `tactic.trace` 不能接受那个失败作为输入。我们需要 `bind` 组合子 (combinator)，其中缀表示法为 `>>=`，它在成功时将其左侧的输出发送到其右侧，否则失败。
```lean
meta def trace_goal : tactic unit :=
 tactic.target >>= tactic.trace
```
或者，特别是如果 `tactic.target` 的输出可能被多次使用，可以使用 `do` 块中的赋值，使用 `←`（与重写语法中的箭头相同）。这种模拟命令式变量赋值的方式，如果赋值的右侧失败，当然也会失败（就像上面的失败策略一样）。
```lean
meta def trace_goal' : tactic unit :=
do
 goal ← tactic.target,
 tactic.trace goal
```
注意，这种赋值只试图从 `tactic α` 类型的东西中提取 `α` 类型的数据。它不能用来存储常规的东西。下面这个就不行。
```lean
meta def broken_assignment : tactic unit :=
do
 message ← "Hello, World.",  -- 错误！
 tactic.trace message
```
但是，可以在 `do` 块中使用 `let`，如：
```lean
meta def let_example : tactic unit :=
do
 let message := "Hello, World.",
 tactic.trace message
```
接下来，我们想要编写返回某些东西的策略，就像 `tactic.target` 那样。唯一需要的额外成分是 `return` 函数。下面的函数在没有更多目标时尝试返回 `tt`，否则返回 `ff`。下一个可以交互式使用并追踪结果（注意，交互式使用第一个不会有任何可见效果，因为交互式使用会忽略返回值）。
```lean
meta def is_done : tactic bool :=
(tactic.target >> return ff) <|> return tt

meta def trace_is_done : tactic unit :=
is_done >>= tactic.trace
```
关于 monadic 赋值，我们最后需要了解的是模式匹配赋值。下面的策略尝试将表达式 `l` 和 `r` 定义为当前目标的左手边和右手边。它还使用了 `to_string` 函数，这个函数与 `trace` 结合使用以调试策略非常方便，并且适用于任何 `has_to_string` 的实例类型。
```lean
meta def trace_goal_is_eq : tactic unit :=
do t ← tactic.target,
   match t with
   | `(%%l = %%r) := tactic.trace $ "Goal is equality between " ++ (to_string l) ++ " and " ++ (to_string r)
   | _ := tactic.trace "Goal is not an equality"
   end
```
Lean 还为带有单个模式和通配符的模式匹配提供了专用语法，其中只有当模式匹配时，执行才会继续到 `do` 块的下一行，否则执行 `|` 之后的表达式：
```lean
meta def trace_goal_is_eq : tactic unit :=
do `(%%l = %%r) ← tactic.target | tactic.trace "Goal is not an equality",
   tactic.trace $ "Goal is equality between " ++ (to_string l) ++ " and " ++ (to_string r)
```

如果省略 `|`，那么当模式不匹配时策略会失败。
我们可以使用前面提到的 `orelse` 组合子来捕获这个失败，但请注意，这样做我们会捕获比上面更多的失败类型：
```lean
meta def trace_goal_is_eq : tactic unit :=
(do  `(%%l = %%r) ← tactic.target,
     tactic.trace $ "Goal is equality between " ++ (to_string l) ++ " and " ++ (to_string r),
     some_other_tactic)
   <|> tactic.trace "Goal is not an equality, or `some_other_tactic` failed"
```
上面代码中的括号看起来不太美观。可以使用花括号来界定一个 `do` 块，如：
```lean
meta def trace_goal_is_eq : tactic unit :=
do { `(%%l = %%r) ← tactic.target,
     tactic.trace $ "Goal is equality between " ++ (to_string l) ++ " and " ++ (to_string r) }
   <|> tactic.trace "Goal is not an equality"
```

## 第一个实用的策略

我们已经学习了足够的 monad 理论来理解我们的第一个有用策略：`assumption` 策略，它在局部上下文 (local context) 中搜索一个能够关闭当前目标的假设。它使用了一些更多的内置策略，这些策略都在核心库的 [init/meta/tactic.lean](https://github.com/leanprover-community/lean/blob/master/library/init/meta/tactic.lean) 中声明和简要记录，但实际上是在 C++ 中实现的。
首先 `infer_type : expr → tactic expr` 尝试确定一个表达式的类型（因为它返回一个 `tactic expr`，所以必须像上面解释的那样与 `>>=` 或 `←` 链接）。
接下来是 `tactic.unify`，它（除了一对可选参数外）接受两个表达式，并且当且仅当它们定义上相等 (definitionally equal) 时成功。
`assumption` 策略的第一部分是一个辅助函数，它在一个表达式列表中搜索与某个表达式 `e` 类型相同的表达式，返回第一个匹配项（如果找不到则失败）。
```lean
meta def find_matching_type (e : expr) : list expr → tactic expr
| []         := tactic.failed
| (H :: Hs)  := do t ← tactic.infer_type H,
                   (tactic.unify e t >> return H) <|> find_matching_type Hs
```
请确保你真正理解了上一节中上述代码的控制流。基本模式是在列表中进行经典的递归查找。注意表达式 `e` 在冒号左边，因此它将被原封不动地传递给递归调用 `find_matching_type Hs`。名称 `H` 代表 `hypothesis`（假设），而 `Hs` 遵循 Haskell 的命名习惯，代表多个假设。对于非空列表发生的事情，其命令式类比大致如下面的命令式伪代码所示
```text
if unify(e, infer_type(H)) then return H else find_matching_type(e, HS)
```
我们现在可以为我们的交互式策略使用这个函数。我们首先需要使用 `local_context` 获取局部上下文，它返回一个我们可以传递给 `find_matching_type` 的表达式列表。如果该函数成功，其输出将被传递给内置策略 `tactic.exact`。这里我们需要使用完全限定名，因为可能与 `exact` 的交互式版本（它接受不同的参数，所以它不是非交互式版本的精确副本）混淆。这是一个很好的机会指出，本教程的开头为了清晰起见，到处都使用完全限定名，但当然，现实世界的工作流程是打开 `tactic` 命名空间。
```lean
meta def my_assumption : tactic unit :=
do { ctx ← tactic.local_context,
     t   ← tactic.target,
     find_matching_type t ctx >>= tactic.exact }
<|> tactic.fail "my_assumption tactic failed"
```
附加题：如果我们去掉花括号会怎样？它还能通过类型检查吗？如果可以，得到的策略会和原来一样吗？

## Monadic 循环

命令式编程的一个关键工具是循环，所以 monad 必须模拟这一点。我们从通常的 Lean 中已经知道 `list.map` 和 `list.foldr`/`list.foldl` 允许在列表元素上循环。但我们需要能与 monad 世界良好交互的版本（消耗和返回 `tactic stuff` 类型的项）。这些版本以“m”为前缀，代表 monad，如 `list.mmap`、`list.mfoldr` 等。我们的策略是：
```lean
meta def list_types : tactic unit :=
do
  l ← tactic.local_context,
  l.mmap (λ h, tactic.infer_type h >>= tactic.trace),
  return ()
```
最后一行有点傻：它之所以存在，是因为我们从前一行得到的东西类型是 `list unit`，所以它不能是我们的 `do` 块的最后一部分。因此我们添加 `return ()`，其中 `()` 是 `unit` 类型的唯一项。也可以使用 `skip` 策略达到同样的目标。这种特殊情况非常常见，所以我们实际上有一个 `list.mmap` 的变体 `list.mmap'`，它会丢弃应用于列表元素的函数的结果，并在遍历完列表后返回 `()`。

## 操纵局部上下文

我们的下一个目标是能够在局部上下文中使用和创建假设。
我们将编写一个策略，通过将两个已知的等式相加来产生一个新的假设（如果这个操作没有意义，则会惨败）。起初，这两个等式的名称会愚蠢地硬编码在我们的策略中。所以我们想要一个策略来执行下面证明中的第一行。
```lean
example (a b j k : ℤ) (h₁ : a = b) (h₂ : j = k) :
  a + j = b + k :=
begin
  have := congr (congr_arg has_add.add h₁) h₂,
  exact this
end
```

我们需要的第一个新概念是名称 (name)。为了允许命名空间管理，Lean 中的名称实际上被定义为一个归纳类型 (inductive type)，在核心库 [meta/name.lean](https://github.com/leanprover-community/lean/blob/master/library/init/meta/name.lean) 中。操纵它的构造函数不方便，所以我们使用反引号记法 (backtick notation)（这是策略编写中许多反引号用法的第一个）。实际上，我们在最开始讨论 `add_interactive` 命令时已经这样做了。通过名称访问局部上下文中的项是使用 `tactic.get_local` 完成的。我们需要的下一个新部分是 `tactic.interactive.«have»`，它将创建我们的新上下文项。它奇怪的名称是为了绕过 `have` 是一个关键字，因此不是一个有效的名称。它接受两个我们暂时忽略的可选参数，以及一个我们新项的证明的预表达式 (pre-expression)。这样的预表达式是使用双反引号-括号表示法构建的：
``` ``(...) ```。在这样的构造中，先前赋值的表达式使用反引用 (anti-quotation) 前缀 `%%` 来访问。这个语法与我们上面看到的模式匹配语法非常接近（但不同）。

```lean
open tactic.interactive («have»)
open tactic (get_local infer_type)

meta def tactic.interactive.add_eq_h₁_h₂ : tactic unit :=
do e1 ← get_local `h₁,
   e2 ← get_local `h₂,
   «have» none none ``(_root_.congr (congr_arg has_add.add %%e1) %%e2)

example (a b j k : ℤ) (h₁ : a = b) (h₂ : j = k) :
  a + j = b + k :=
begin
  add_eq_h₁_h₂,
  exact this
end
```
关于上述策略的最后一点说明：名称 `` `h₁ `` 和 `` `h₂ `` 是在策略执行时解析的。为了在策略解析时触发名称解析 (name resolution)，应该使用双反引号，如 ``` ``h₁ ```。当然，在上述上下文中，这会触发一个错误，因为在策略解析时看不到任何名为 `h₁` 的东西。但在其他情况下它可能很有用。

## 策略参数解析

### 解析标识符

显然，如果假设名称是硬编码的，前面的策略是无用的。所以我们用以下代码替换它：
```lean
open interactive (parse)
open lean.parser (ident)

meta def tactic.interactive.add_eq (h1 : parse ident) (h2 : parse ident) : tactic unit :=
do e1 ← get_local h1,
   e2 ← get_local h2,
   «have» none none ``(_root_.congr (congr_arg has_add.add %%e1) %%e2)
```
参数 `h1` 和 `h2` 告诉 Lean 解析标识符。这里面有不少技巧。Lean 解析器看到冒号左边的 `parse`，所以它知道必须做一些参数解析，但结果类型只是一个名称，如下所示。
```lean
meta example : (parse ident) = name := rfl
```

### 解析可选参数和使用标记

这个策略的下一个改进是提供了为新的局部假设命名的机会（目前名为 `this`）。这样的名称传统上由标记 (token) `with` 引入，后跟所需的标识符。
“后跟”由 `seq_right` 组合子表达（这里又潜伏着一个 monad），其记法为 `*>`。解析一个标记由 `lean.parser.tk` 引入，后跟一个必须取自预定列表的字符串（这个列表的初始值可以在 Lean 源代码的 [frontends/lean/token_table.cpp](https://github.com/leanprover-community/lean/blob/master/src/frontends/lean/token_table.cpp) 中找到，当字面量在 `notation`、`infix` 或 `precedence` 中使用时，元素会被添加到这个列表中）。
然后将组合包装在 `optional` 中使其成为可选的。我们下面得到的项 `h` 的类型是 `option name`，可以作为 `«have»` 的第一个参数传递，如果提供了，它将使用它，否则使用名称 `this`。
```lean
open lean.parser (tk)
meta def tactic.interactive.add_eq' (h1 : parse ident) (h2 : parse ident)
  (h : parse (optional (tk "with" *> ident))) : tactic unit :=
do e1 ← get_local h1,
   e2 ← get_local h2,
   «have» h none ``(_root_.congr (congr_arg has_add.add %%e1) %%e2)

example (m a b c j k : ℤ) (Hj : a = b) (Hk : j = k) :
  a + j = b + k :=
begin
  add_eq' Hj Hk with new,
  exact new
end
```

### 解析位置和表达式

我们的下一个策略是将一个给定的表达式从左边乘到一个等式上（如果这个操作没有意义，则会失败）。我们想要机械化下面的证明。
```lean
example (a b c : ℤ) (hyp : a = b) : c*a = c*b :=
begin
  replace hyp := congr_arg (λ x, c*x) hyp,
  exact hyp
end
```

这里的主要新技能包括使用传统的标记 `at` 指示我们想要作用的位置 (location)，以及向策略传递一个表达式。位置在核心库 [meta/interactive_base.lean](https://github.com/leanprover-community/lean/blob/master/library/init/meta/interactive_base.lean) 中被定义为一个归纳类型，有两个构造函数：`wildcard` 表示所有位置，以及 `loc.ns` 它接受一个 `list (option name)`，其中 `option name` 中的 `none` 意味着当前目标，而 `some n` 意味着局部上下文中名为 `n` 的东西。在我们的例子中，我们将对解析出的位置进行模式匹配，并拒绝除了从局部上下文中指定单个名称之外的所有情况。第二个新部分是如何解析用户提供的表达式。相关的解析器是 `interactive.types.texpr`，其结果使用 `tactic.i_to_expr` 转换为实际的表达式。这也是我们第一次认真使用模式匹配赋值的机会，以及使用 `«have»` 的第二个可选参数，即期望的类型（否则我们会得到未应用的乘法，带有一个显式的 lambda，试试看！）。
```lean
open interactive (loc.ns)
open interactive.types (texpr location)
meta def tactic.interactive.mul_left (q : parse texpr) : parse location → tactic unit
| (loc.ns [some h]) := do
   e ← tactic.i_to_expr q,
   H ← get_local h,
   `(%%l = %%r) ← infer_type H,
   «have» h ``(%%e*%%l = %%e*%%r) ``(congr_arg (λ x, %%e*x) %%H),
   tactic.clear H
| _ := tactic.fail "mul_left takes exactly one location"

example (a b c : ℤ) (hyp : a = b) : c*a = c*b :=
begin
  mul_left c at hyp,
  exact hyp
end
```

作为最后的改进，让我们制作这个策略的一个版本，它通过附加 `.mul` 来命名相乘后的等式，并且如果策略名称后跟有 `!`，则可选择性地删除原始的等式。这是使用 `when` 的机会，它是 `ite` 的 monadic 版本（else 分支什么也不做）。
参见核心库中的 [control/combinators.lean](https://github.com/leanprover-community/lean/blob/master/library/init/control/combinators.lean) 以了解关于这个想法的其他变体。
```lean
meta def tactic.interactive.mul_left_bis (clear_hyp : parse (optional $ tk "!")) (q : parse texpr) :
parse location → tactic unit
| (loc.ns [some h]) := do
   e ← tactic.i_to_expr q,
   H ← get_local h,
   `(%%l = %%r) ← infer_type H,
   «have» (H.local_pp_name ++ "mul" : name) ``(%%e*%%l = %%e*%%r) ``(congr_arg (λ x, %%e*x) %%H),
   when clear_hyp.is_some (tactic.clear H)
| _ := tactic.fail "mul_left_bis takes exactly one location"
```

## 现在读什么？

本教程到此结束（尽管下面有两个备忘单）。
如果你想学习更多，可以阅读核心库或 mathlib 中策略的定义，看看你能理解多少，并在 Zulip 上提问具体问题。关于更多理论，特别是对 monad 的正确解释，你可以阅读
[《Programming in Lean》](https://lean-lang.org/programming_in_lean/)，但实际的策略编写部分已经过时。策略框架的官方文档是
论文 [《A Metaprogramming Framework for Formal Verification》](https://lean-lang.org/papers/tactic.pdf)。

## Mario 的反引号备忘单

本节是 Mario 在 Zulip 上消息的直接汇编。

* `` `my.name `` 是引用名称的方式。它本质上是一种字符串引用的形式；除了将点解析为命名空间名称外，不进行任何检查。

* ``` ``some ``` 在解析时 (parse time) 进行名称解析 (name resolution)，所以这个例子会扩展为 `` `option.some ``，如果给定的名称不存在，则会出错。
* `` `(my expr) `` 在解析时构造一个表达式，在当前的（策略的）命名空间中解析它能解析的内容。
* ``` ``(my pexpr) ``` 在解析时构造一个预表达式 (pre-expression)，在当前的（策略的）命名空间中解析。
* ```` ```(my pexpr) ```` 构造一个 `pexpr`，但将解析推迟到运行时 (run time)（策略的运行时），这意味着任何引用都将在用户的 `begin` `end` 块的命名空间中解析，而不是策略本身的命名空间。
* `%%`：这被称为反引用 (anti-quotation)，并且在所有表达式和预表达式的引用构造中都支持：`` `(expr) ``、``` ``(pexpr) ```、```` ```(pexpr) ````，以及 `` `[tacs] ``。
  在这些引用构造中任何期望表达式的地方，你都可以使用 `%%e`，其中 `e` 在策略的外部上下文中类型为 `expr`，它将被拼接到 (spliced into) 构造的 `expr`/`pexpr` 等中。例如，如果 `a b : expr`，那么 `` `(%%a + %%b) `` 的类型是 `expr`。
* `reflect` 函数将一个项 `t : T` 转换为一个反映 `t` 的 `expr`，如果 Lean 能够推断出一个 `reflected t` 实例。这可以用于，例如，在引用内部从策略定义中引用局部变量，使用 `%%(reflect n)`。举个例子，我们可以写成
    ```lean
    meta def assert_ge_zero (n : ℕ) : tactic unit :=
    do v ← to_expr ``(nat.zero_le %%(reflect n)),
       t ← infer_type v,
       assertv `h t v,
       skip
    ```
    如果你在这里直接写 `n`，你会得到一个“unexpected local in quotation expression”的错误。
* `` `[tac...] `` 与 `begin tac... end` 完全相同，因为它使用交互模式解析器解析 `tac...`，但它不是求值策略以产生一个项，而是将策略列表包装成一个类型为 `tactic unit` 的单个策略。这对于编写“宏”或轻量级策略编写很有用。


同样值得一提的是 `expr` 模式匹配，它具有与 `` `(%%a + %%b) `` 相同的语法。这些可以用在匹配的模式位置或 `do` 记法中 `←` 的左侧，它将解构一个表达式并绑定反引用的变量。
例如，如果 `e` 是一个表达式，那么 `` do `(%%a = %%b) ← return e, ... `` 将检查 `e` 是否是一个等式，并将左手边和右手边绑定到 `a` 和 `b`（类型为 `expr`），如果它不是等式，策略将失败。

（值得注意的是，这种模式匹配在语法层面 (syntactic level) 工作。有时使用合一 (unification) 会更灵活。）

## Mario 的 monadic 符号备忘单

下面列表中的所有函数和记法都适用于比 `tactic` 更通用的 monad，所以它们以通用形式列出，但为了本教程的目的，`m` 始终是 `tactic`（或 `lean.parser`）。尽管所有事情都可以用本教程中介绍的符号来完成，但更深奥的符号可以压缩代码，理解它们对于阅读现有的策略很有用。

* `return`：在 monad 中产生一个值（类型：`A → m A`）
* `ma >>= f`：从 `ma : m A` 中获取类型为 `A` 的值，并将其传递给 `f : A → m B`。替代语法：`do a ← ma, f a`
* `f <$> ma`：将函数 `f : A → B` 应用于 `ma : m A` 中的值，得到一个 `m B`。与 `do a ← ma, return (f a)` 相同
* `ma >> mb`：与 `do a ← ma, mb` 相同；这里 `ma` 的返回值被忽略，然后调用 `mb`。替代语法：`do ma, mb`
* `mf <*> ma`：与 `do f ← mf, f <$> ma` 或 `do f ← mf, a ← ma, return (f a)` 相同
* `ma <* mb`：与 `do a ← ma, mb, return a` 相同
* `ma *> mb`：与 `do ma, mb` 或 `ma >> mb` 相同。为什么同一个东西有两个记法？历史原因。
* `pure`：与 `return` 相同。同样，历史原因。
* `failure`：失败的值（特定的 monad 通常有更有用的形式，比如策略的 `fail` 和 `failed`）。
* `ma <|> ma'`：从失败中恢复：运行 `ma`，如果失败则运行 `ma'`。
* `a $> mb`：与 `do mb, return a` 相同
* `ma <$ b`：与 `do ma, return b` 相同