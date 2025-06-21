# 拉取请求标题和描述约定

我们使用以下约定来编写拉取请求的标题和描述。

## 格式

注意：“Title:”和“Description:”实际上不会出现。

```markdown
  Title:
  <type>(<optional-scope>): <subject>

  Description:
  <body>
  <NEWLINE>
  <footer>
  <NEWLINE>
  <dependencies>
```

`<type>` 是：

- feat (功能)
- fix (漏洞修复)
- doc (文档)
- style (格式化，例如缺少分号等)
- refactor (代码重构)
- test (测试，当添加缺失的测试时)
- chore (日常维护)
- perf (性能优化，例如性能改进、优化等)

`<optional-scope>` 是一个模块或包含已更改模块的目录的名称。
这不是必须包含的，但如果 `<subject>` 不足以说明问题，它可能会很有用。
`Mathlib` 目录前缀总是被省略。
例如，它可以是

- Data/Nat/Basic
- Algebra/Group/Defs
- Topology/Constructions

`<subject>` 有以下约束：

- 使用祈使句和现在时态：“change”而不是“changed”或“changes”
- 不要大写首字母
- 末尾不加句号(.)

`<body>` 有以下约束：

- 与 `<subject>` 一样，使用祈使句和现在时态
- 包括变更的动机以及与之前行为的对比

`<footer>` 是可选的，可以包含两项内容：

- 破坏性变更 (Breaking changes): 所有的破坏性变更都必须在页脚（footer）中提及，并附上变更的描述、理由和迁移说明
- 引用议题 (Referencing issues): 已关闭的漏洞应在页脚中单独一行列出，并以“Closes”关键字为前缀，例如：`Closes #123, #456`

`<dependencies>` 如果此 PR 依赖于其他 PR，则应以复选框格式列出它们，即 `- [ ] depends on: #XXXX`

## 示例

一个不需要 `<scope>` 的示例如下：

```markdown
feat: have library search use the whole range for replacement

previously `apply? using h` would replace to `refine blah using h` rather than `refine blah`.

This also changes the diagnostic message to be on the whole syntax `apply? using h` rather than just the `apply?` bit, which seems fine to me.
```

一个包含 `<scope>` 能增加价值的示例如下：

```markdown
docs(CategoryTheory/EssentialImage): typo and punctuation

Fix a typo, add two periods.
```

一个带有依赖 PR 的示例如下：

```markdown
feat: The norm on `Unitization` is a C⋆-norm

This shows that C⋆-algebras are always `RegularNormedAlgebra`s, so that their `Unitization` is equipped with a norm. Moreover, we show this norm is a C⋆-norm.

---

- [ ] depends on: #5330
- [ ] depends on: #5741
- [ ] depends on: #5742
- [ ] depends on: #5743
```