# Lean 中的数学：线性代数

### 半模、模与向量空间

#### [`Mathlib.Algebra.Module.Defs`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/Algebra/Module/Defs.html)

该文件定义了类型类 (typeclass) `Module R M`，它在类型 `M` 上赋予了一个 `R`-模结构。
一个加性交换幺半群 (additive commutative monoid) `M` 是一个在（半）环 `R` 上的模 (module)，如果存在一个标量乘法 (scalar multiplication) `•` (`SMul`)，它满足关于 `+`（在 `M` 和 `R` 中）和 `*`（在 `R` 中）的预期分配律公理 (distributivity axioms)。
要定义一个 `Module R M` 实例，你首先需要 `Semiring R` 和 `AddCommMonoid M` 的实例。
通过分离这些依赖，我们避免了实例循环和菱形问题。

在一般数学用法中，半环 (semiring) 上的模也称为半模 (semimodule)，域 (field) 上的模也称为向量空间 (vector space)。
我们没有单独的 `Semimodule` 或 `VectorSpace` 类型类，因为这些要求通过更改 `R`（和 `M`）上的类型类实例更容易表达。
在本文档中，我们将使用“模”作为“半模、模或向量空间”的通用术语，使用“环”作为“（交换）半环、环或域”的通用术语。

设 `m` 是一个任意类型，例如 `Fin n`，那么典型的例子是：
`m → ℕ` 是一个 `ℕ`-半模，`m → ℤ` 是一个 `ℤ`-模，而 `m → ℚ` 是一个 `ℚ`-向量空间
（在类型论之外，它们分别被称为 `ℕ^m`、`ℤ^m` 和 `ℚ^m`）。
一个环是其自身的模，其中 `•` 定义为 `*`（这个等式由 `simp` 引理 [`smul_eq_mul`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/Algebra/Group/Action/Defs.html#smul_eq_mul) 阐明）。
每个加性幺半群都有一个由 `n • x = x + x + ... + x`（`n` 次）给出的典范 `ℕ`-模结构，每个加性群也类似地定义了一个典范 `ℤ`-模结构；这些也适用于（半）环。

文件 [`Mathlib.LinearAlgebra.LinearIndependent`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/LinearAlgebra/LinearIndependent.html) 定义了模中索引族 (indexed family) 的线性无关性。
为了表示集合 `s : Set M` 是线性无关的，我们将其视为一个以自身为索引的族，写作 `LinearIndependent R ((↑) : s → M)`。

文件 [`Mathlib.LinearAlgebra.Basis`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/LinearAlgebra/Basis.html) 定义了模的基 (bases)。

文件 [`Mathlib.LinearAlgebra.Dimension.Basic`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/LinearAlgebra/Dimension/Basic.html) 将模的 `rank` 定义为一个基数 (cardinal)。
我们也用 `rank` 表示向量空间的维数 (dimension)，因为维数总是等于秩 (rank)。
线性映射 (linear map) 的 `rank` 被定义为其像 (image) 的维数。
该文件中的大多数定义都是非计算的 (non-computable)。

文件 [`Mathlib.LinearAlgebra.Dimension.Finrank`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/LinearAlgebra/Dimension/Finrank.html) 将模的 `finrank` 定义为一个自然数。
按照惯例，如果秩是无限的，则 `finrank` 等于 0。

### 矩阵

#### [`Mathlib.Data.Matrix.Basic`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/Data/Matrix/Basic.html)

类型 `Matrix m n α` 包含 `m` 行 `n` 列的矩形数组，其元素类型为 `α`。
它是类型 `m → n → α` 的别名。一个矩阵类型可以由任意类型索引。
例如，一个图的邻接矩阵 (adjacency matrix) 可以由该图的节点索引。
如果你想用自然数 `m n : ℕ` 指定矩阵的维度，你可以使用 `Fin m` 和 `Fin n` 作为索引类型。

一个矩阵是通过给出从索引到元素的映射来构造的：`(fun (i : m) (j : n) ↦ (_ : α)) : Matrix m n α`。
然而，不建议使用形如 `fun i j ↦ _` 甚至 `(fun i j ↦ _ : Matrix m n α)` 的项来构造矩阵，
因为 Lean 无法识别它们具有正确的类型。相反，应该使用 `Matrix.of`。
对于由自然数索引的矩阵，你也可以使用在 [`Mathlib.Data.Matrix.Notation`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/Data/Matrix/Notation.html) 中定义的记法：`![![a, b, c], ![b, c, d]] : Matrix (Fin 2) (Fin 3) α`。
要获取矩阵 `M : Matrix m n α` 在第 `i` 行（`i : m`）和第 `j` 列（`j : n`）的元素，
你可以将 `M` 应用于索引：`M i j : α`。
关于矩阵元素的引理通常以 `_apply` 结尾：`Matrix.add_apply M N i j : (M + N) i j = M i j + N i j`。

矩阵乘法和转置的记法通过命令 `open scoped Matrix` 可用。
矩阵乘法像往常一样用 `*` 表示。中缀运算符 (infix operator) `⬝ᵥ` 代表 `Matrix.dotProduct`，
后缀运算符 (postfix operator) `ᵀ` 代表 `Matrix.transpose`。

在使用矩阵时，*向量* 指的是对于任意 `Fintype` `m` 的函数 `m → α`。
它们在 [`algebra.module.pi`](https://leanprover-community.github.io/mathlib_docs/algebra/module/pi.html) 中定义了由逐点加法和乘法组成的模（或向量空间）结构。
行向量和列向量的区别仅通过函数的选择来体现。
例如，`Matrix.mulVec M v`（表示为 `M *ᵥ v`）将一个矩阵与一个列向量 `v : m → α` 相乘，而 `Matrix.Vecmul v M`
（表示为 `v ᵥ* M`）将一个行向量 `v : m → α` 与一个矩阵相乘。
如果你大量使用 `mulVec` 和 `Vecmul`，你可能需要考虑使用线性映射（见下文）。

置换矩阵 (Permutation matrices) 定义在 [`Mathlib.LinearAlgebra.Matrix.Permutation`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/LinearAlgebra/Matrix/Permutation.html)。

矩阵的行列式 (determinant) 定义在 [`Mathlib.LinearAlgebra.Matrix.Determinant.Basic`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/LinearAlgebra/Matrix/Determinant/Basic.html)。

伴随矩阵 (adjugate) 以及非奇异矩阵 (nonsingular matrices) 的逆 (inverse) 定义在 [`Mathlib.LinearAlgebra.Matrix.Adjugate`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/LinearAlgebra/Matrix/Adjugate.html) 和 [`Mathlib.LinearAlgebra.Matrix.NonsingularInverse`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/LinearAlgebra/Matrix/NonsingularInverse.html)。

类型 `Matrix.SpecialLinearGroup m R` 是行列式为 `1` 的 `m` 行 `m` 列矩阵构成的群，
定义在 [`Mathlib.LinearAlgebra.Matrix.SpecialLinearGroup`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/LinearAlgebra/Matrix/SpecialLinearGroup.html)。

### 线性映射与线性等价

#### [`Mathlib.Algebra.Module.LinearMap.Defs`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/Algebra/Module/LinearMap/Defs.html)

类型 `M →[R]ₗ M₂`，或 `LinearMap R M M₂`，表示从 `R`-模 `M` 到 `R`-模 `M₂` 的 `R`-线性映射。
它们由它们在 `M` 元素上的作用来定义。
类型 `M ≃[R]ₗ M₂`，或 `LinearEquiv R M M₂`，是 `M` 到 `M₂` 的可逆 `R`-线性映射的类型。

矩阵和线性映射之间的等价在 [`Matrix.toLin`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/LinearAlgebra/Matrix/ToLin.html#Matrix.toLin) 中被形式化。
[`Matrix.toLin'`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/LinearAlgebra/Matrix/ToLin.html#Matrix.toLin') 表明 `Matrix.mulVec` 是 `Matrix m n R` 和 `(n → R) →[R]ₗ (m → R)` 之间的一个线性等价。
此外，[`LinearMap.toMatrix`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/LinearAlgebra/Matrix/ToLin.html#LinearMap.toMatrix) 接受 `M₁` 的一个基 `ι` 和 `M₂` 的一个基 `κ`，
并给出 `M₁` 和 `M₂` 之间的 `R`-线性映射与 `Matrix ι κ R` 之间的等价。
如果你有映射的显式基，这个等价允许你进行诸如求行列式之类的计算。

矩阵和线性映射的区别在于，矩阵本质上是元素的数组
（这恰好允许像 `Matrix.mulVec` 这样的操作），
而线性映射本质上是对向量的作用
（如果有一个有限基，这恰好可以由一个矩阵表示）。
如果你想进行计算，矩阵是更好的选择。
如果你想进行无计算的证明，线性映射是更好的选择。

类型 [`Matrix.GeneralLinearGroup R M`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/LinearAlgebra/Matrix/GeneralLinearGroup/Defs.html#Matrix.GeneralLinearGroup) 是从 `M` 到自身的可逆 `R`-线性映射构成的群。
`LinearMap.GeneralLinearGroup.generalLinearEquiv R M` 是 `GeneralLinearGroup` 和 `M ≃[R]ₗ M` 之间的等价。
`Matrix.SpecialLinearGroup.toGL` 是从特殊线性群（矩阵的）到一般线性群（线性映射的）的嵌入 (embedding)。

对偶空间 (dual space)，由线性映射 `M →[R]ₗ R` 构成，定义在 [`Mathlib.LinearAlgebra.Dual`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/LinearAlgebra/Dual.html)。

### 双线性、半双线性与二次型

#### [`Mathlib.LinearAlgebra.BilinearMap`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/LinearAlgebra/BilinearMap.html)

对于一个 `R`-模 `M`，类型 `LinearMap.BilinForm R M` 是在两个参数上都是线性的映射 `M → M → R` 的类型。
`LinearMap.BilinForm R M` 和在两个参数上都是线性的映射 `M →ₗ[R] M →ₗ[R] R` 之间的等价被称为 `bilin_linear_map_equiv`。
一个矩阵 `M` 对应一个将向量 `v` 和 `w` 映射到 `row v ⬝ M ⬝ col w` 的双线性型。
`BilinForm R (n → R)` 和 `Matrix n n R` 之间的等价被称为 [`BilinForm.toMatrix`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/LinearAlgebra/Matrix/BilinearForm.html#BilinForm.toMatrix)。

#### [`Mathlib.LinearAlgebra.SesquilinearForm`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/LinearAlgebra/SesquilinearForm.html)

对于一个 `R`-模 `M` 和 `I : R →+* R`，类型 `M →ₗ M →ₛₗ[I] R` 是在第一个参数上线性，
并且在第二个参数上是 `I`-[半线性 (semilinear)](https://leanprover-community.github.io/mathlib4_docs/Mathlib/Algebra/Module/LinearMap/Defs.html#LinearMap) 的映射 `M → M → R` 的类型。
`f` 关于环同态 (ring homomorphism) `I` 的半线性意味着以下等式成立：`f x (a • y) = I a * f x y`。

#### [`Mathlib.LinearAlgebra.QuadraticForm.Basic`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/LinearAlgebra/QuadraticForm/Basic.html)

对于一个 `R`-模 `M`，类型 `QuadraticForm R M` 是满足 `f (a • x) = a * a * f x` 且 `fun x y ↦ f (x + y) - f x - f y` 是一个双线性映射 (bilinear map) 的映射 `f : M → R` 的类型。

在差一个因子 `2` 的情况下，二次型和双线性型的理论是等价的。
[`LinearMap.BilinMap.toQuadraticMap f`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/LinearAlgebra/QuadraticForm/Basic.html#LinearMap.BilinMap.toQuadraticMap) 是由 `fun x ↦ f x x` 给出的二次型。
[`QuadraticMap.associatedHom f`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/LinearAlgebra/QuadraticForm/Basic.html#QuadraticMap.associatedHom) 是由 `fun x y ↦ ⅟2 * (f (x + y) - f x - f y)` 给出的双线性型（如果存在 `2` 的乘法逆元 (multiplicative inverse)）。
[`QuadraticMap.toMatrix'`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/LinearAlgebra/QuadraticForm/Basic.html#QuadraticMap.toMatrix') 和 [`Matrix.toQuadraticMap'`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/LinearAlgebra/QuadraticForm/Basic.html#Matrix.toQuadraticMap') 是二次型和矩阵之间的映射。