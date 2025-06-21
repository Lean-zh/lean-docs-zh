# 如何加速 Mathlib 文件

我们解释如何让一个缓慢的 Mathlib 文件变得更快。这些说明基于在 Mathlib 拉取请求 (PR) [#12412](https://github.com/leanprover-community/mathlib4/pull/12412) 中进行的实验。

1. 第一步是找出代码的哪些部分是缓慢的。为此，请在 `import` 语句后添加一行 `set_option profiler true`。这将在信息视图 (infoview) 中产生形如 `<blah> took <number>ms`（甚至 `<number>s`）的行，记录耗时至少 `100ms` 的步骤（毫秒单位的下限可以通过 `set_option profiler.threshold <num>` 进行调整）。
2. 对于每一行这样的信息，请按照下面的说明尝试让相应的步骤变得更快。
3. 上一步可以潜在地通过降低 `profiler.threshold` 的设置来重复，以找出并加速那些不是非常慢，但也不是很快的部分。然而，这最终会带来递减的回报。
4. 再次移除分析器 (profiler) 选项，然后提交 PR！

## 处理特定的缓慢步骤

在这里，我们解释如何尝试加速代码中导致分析器 (profiler) 在信息视图 (infoview) 中产生消息的各个部分。

### `类型类推断 (typeclass inference) of <name> 耗时过长`

1. 在引起该消息的声明 (declaration) 之前，立即添加 `set_option trace.Meta.synthInstance true in`。
2. 查看信息视图 (infoview) 中生成的实例合成跟踪 (instance synthesis trace)，并找到 `<name>` 中缓慢的实例。
3. 在声明之前使用 `#synth <name> <args>`（如果需要，可以临时向上下文中添加 `variable`）以获得提供该实例的合适项 (term)。
4. 在声明之前（或在当前 section/namespace 的开头附近）添加一行
   `@[local instance] lemma/def <some name> <possibly some args> : <name> <args> := <term>`。
   如果实例需要证明内部的某些局部上下文，则应在证明的适当位置添加
   `have/let <some name> <possibly some args> : <name> <args> := <term>`。
5. 移除声明前的 `set_option` 行。

`<term>` 可能会再次触发缓慢的实例搜索，因此这个过程可能需要重复。

**权衡：** 在文件中散布局部实例并不美观，并且在某种程度上违背了类型类 (type class) 系统的初衷。

当然，一个更好的解决方案是找出在发现的情况下，**什么**导致了类型类搜索缓慢，然后找到修复方法。这很可能会使 Mathlib 中的许多其他文件受益。

### `simp 耗时过长`

将相关的 `simp/simpa` 调用替换为 `simp?/simpa?`，并点击 `Try this:` 建议，将其替换为 `simp/simpa only` 调用。在某些情况下，也可以在一定程度上精简引理列表。

**权衡：** 证明可能会增加好几行密集的代码，并且现在会按名称提及许多引理，其中任何一个将来都可能被重命名，从而破坏你的证明。

### `精化 (elaboration) 耗时过长`

在触发该消息的声明中查找 `_`，找出它们被填充的内容，并用相应的显式参数替换它们。

**权衡：** 如果显式参数很长，这会使语句更长，并可能更难阅读。

### `编译 (compilation) of <name> 耗时过长`

尝试在定义前添加 `noncomputable`。

**权衡：** 定义不再是内核可归约的 (kernel-reducible)，但这在大多数情况下应该不是问题。

### `<tactic> 的策略执行 (tactic execution) 耗时过长`

尝试用对更简单策略的调用来替换慢的 tactic。

* 例如，一个缓慢的 `nontriviality ... using ...` 可以被替换为
  ```lean
  rcases subsingleton_or_nontrivial ... with H | H
  · -- 处理 `Subsingleton` 的情况
    ...
  -- 现在我们有了 `Nontrivial ...`
  ```

* 可以通过先执行其后的重写，然后使用 `refine` 或 `exact` 来避免缓慢的 `convert`。

**权衡：** 证明可能会变得稍长一些，也更按部就班。