# 教学资源

我们收集了各种可能有助于开设 Lean 课程的资源。

## 笔记与教科书

本网站收集了各种[学习资源](../learn.html)。
这里我们列出了专为大学课程设计的教材。

* Heather Macbeth 的《[证明的机制 (The Mechanics of Proof)](https://hrmacbeth.github.io/math2001/index.html)》是一套关于如何编写审慎、严谨的数学证明的讲义，并配有 Lean 材料。
* Daniel Velleman 的《[如何用 Lean 证明 (How To Prove It With Lean)](https://djvelleman.github.io/HTPIwL/)》是《如何证明它 (*How To Prove It*)》一书的补充材料。
* Jasmin Blanchette 的《[逻辑验证搭车指南 (The Hitchhiker's Guide to Logical Verification)](https://lean-forward.github.io/hitchhikers-guide/2023/)》是一本教科书，它以 Lean 4 证明助手为载体，向读者介绍交互式定理证明。该教科书附有 Lean 演示和练习文件。

## 游戏

* 由 Kevin Buzzard、Jon Eugster 和 Mohammad Pedramfar 开发的《[自然数游戏 (The Natural Number Game)](https://adam.math.hhu.de/#/g/hhu-adam/NNG4)》是一个广受欢迎的 Lean 入门教程。
* [NNG 背后的引擎](https://github.com/leanprover-community/lean4game)可用于为课程设计自定义游戏。

## 自动评分器

* 适用于 Lean 4 的 [Gradescope 自动评分器](https://github.com/robertylewis/lean4-autograder-main)
* 适用于 Lean 4 的 [GitHub Classrooms 自动评分器](https://github.com/adamtopaz/hw_template)

## 云端 Lean 环境设置

* 将 [mathlib4 的 `.devcontainer` 目录](https://github.com/leanprover-community/mathlib4/tree/master/.devcontainer)插入到你的课程项目中，将为你的项目启用 GitHub Codespaces。鼓励学生通过 GitHub 的教育福利注册一个（免费的）专业账户，以获得更多的 Codespaces 使用时长。
* 同样，插入 mathlib4 的 [`.gitpod.yml`](https://github.com/leanprover-community/mathlib4/blob/master/.gitpod.yml) 和 [`.docker/gitpod/Dockerfile`](https://github.com/leanprover-community/mathlib4/blob/master/.docker/gitpod/Dockerfile) 将启用 Gitpod。