# Lean 官方文档中文翻译 (Lean Documentation in Chinese)

[![QQ Group](https://img.shields.io/badge/QQ%E7%BE%A4-897971266-blue)](链接到QQ加群)
[![Telegram](https://img.shields.io/badge/Telegram-Lean%E4%B8%AD%E6%96%87%E7%A4%BE%E5%8C%BA-blue)](Telegram链接)
[![GitHub](https://img.shields.io/github/stars/lean-zh/lean-docs-zh?style=social)](https://github.com/lean-zh/lean-docs-zh)

欢迎来到 Lean 官方文档中文翻译项目！

本项目由 [Lean-zh 社区](https://github.com/lean-zh) 维护，致力于将 Lean 官方文档和社区资料翻译成中文，帮助更多中文使用者学习和使用 Lean 这一强大的交互式定理证明器。

*   **原文仓库**: [leanprover-community.github.io](https://github.com/leanprover-community/leanprover-community.github.io)
*   **在线阅读 (英文原版)**: [https://leanprover-community.github.io/](https://leanprover-community.github.io/)

---

## 贡献指南 (Contribution Guide)

我们非常欢迎任何形式的贡献，无论是翻译新页面、校对现有翻译，还是改进本文档。每一份努力都会让 Lean 社区变得更好！

### 沟通与协调

在开始翻译之前，请务必：
1.  **查看下方的 [翻译进度表](#翻译进度)，避免重复劳动。**
2.  加入我们的 [QQ 群](链接到QQ加群) 或 [Telegram 频道](Telegram链接) 进行讨论，认领你感兴趣的翻译任务。

### 翻译流程 (简单三步)

我们采用标准的 GitHub Fork & Pull Request 流程，即使是新手也能轻松上手：

1.  **Fork 本仓库**: 点击右上角的 "Fork" 按钮，将此仓库复制到你的个人 GitHub 账号下。
2.  **修改与翻译**: 在你 Fork 后的仓库中，可以直接通过 GitHub 网页界面找到想要翻译的文件并进行编辑。
    *   **目录结构**: 请确保你的翻译文件与[原仓库 `lean4` 分支](https://github.com/leanprover-community/leanprover-community.github.io/tree/lean4)中的目录结构保持一致。
    *   **翻译规范**: 请参考下方的翻译规范，以保证译文质量和风格统一。
3.  **创建 Pull Request (PR)**: 完成翻译后，在你的仓库页面会自动出现一个 "Contribute" 按钮，点击 "Open pull request"，按照提示将你的修改提交给我们审核。

对于更熟悉 Git 的用户，我们推荐使用[命令行流程](https://docs.github.com/zh/get-started/quickstart/contributing-to-projects)。

### 翻译规范

1.  **术语表**: 对于专有名词，请参考我们的 **[术语表 (GLOSSARY.md)]()** (待创建)。
    *   **原则**: 保留常见的英文术语，如 `Lean`, `VS Code`, `lake`, `mathlib`, `git`, `Infoview` 等，不在正文中做强制翻译。
    *   对于不常见的术语，可在首次出现时以括号形式标注原文，例如：“工具链 (toolchain)”。
2.  **格式**: 请完整保留原文的 Markdown 格式，包括标题、代码块、列表、链接等。
3.  **代码块**: 代码块（` ``` `）中的内容**不要翻译**，但代码注释可以翻译。
4.  **语气**: 请尽量保持客观、准确、专业的风格，与原文档保持一致。

---

## 翻译进度

在这里，你可以看到所有文档的翻译状态。欢迎在社区群中认领 "待翻译" 的任务！

（未启用）

| 原始文件路径 | 状态 | 负责人 | PR 链接 |
|:---|:---:|:---:|:---:|
| **Installation** | | | |
| `templates/install/project.md` | ✅ 已完成 | @你的GitHub用户名 | [#1](链接到你的PR) |
| `templates/install/windows.md` | 📝 待翻译 | | |
| `templates/install/macos.md` | 📝 待翻译 | | |
| `templates/install/linux.md` | 📝 待翻译 | | |
| **Contributing** | | | |
| `templates/contribute/index.md` | 📝 待翻译 | | |
| `templates/contribute/githowto.md` | 📝 待翻译 | | |
| ... (更多文件待添加) | | | |

**图例**: `📝 待翻译` | `正在翻译` | `🔍 待校对` | `✅ 已完成`

---

## 本地预览与构建 (开发者指南)

如果你希望在提交前于本地预览网站效果，或参与网站功能的开发，可以参考以下指南。

### 环境依赖

*   首先，安装 Python 依赖：
    ```bash
    pip install -r requirements.txt
    ```
*   构建参考文献需要安装 [`bibtool`](https://github.com/ge-ne/bibtool)。
*   如需从 SCSS 文件重建 CSS 样式，你还需要：
    *   [sass](https://sass-lang.com/)
    *   [bootstrap v4.4.1](https://github.com/twbs/bootstrap/archive/v4.4.1.zip) (应解压到项目根目录)

### 构建网站

*   如果需要，先构建 CSS 文件：
    ```bash
    sass scss/lean.scss > css/lean.css
    ```
*   使用 `make_site.py` 脚本来构建网站。
    *   用于**本地预览** (内部链接将使用本地文件路径)：
        ```bash
        ./make_site.py --local
        ```
    *   用于在模板更改时**持续构建** (此功能对 `data/` 目录的更改无效)：
        ```bash
        ./make_site.py --reload
        ```

### 开发者提示

*   **GitHub API 速率限制**: 在本地构建时，你可能会很快达到 GitHub API 的速率限制。你可以[创建一个个人访问令牌](https://docs.github.com/zh/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-personal-access-token-classic)并在运行时提供它：
    ```bash
    GITHUB_TOKEN=你的令牌 ./make_site.py --local
    ```
*   **使用缓存**: 你可以正常运行一次脚本，之后使用 `NODOWNLOAD=1` 标志来利用已下载的缓存数据进行构建，以加快速度。缓存信息存储在 `data_cache` 文件夹中。
    ```bash
    NODOWNLOAD=1 ./make_site.py --local
    ```
*   **只渲染特定模板**: 你可以使用 `--only` 参数来只渲染特定的模板文件，这在调试单个页面时非常有用。
    ```bash
    ./make_site.py --local --only my_template.html
    ```

---

## 关于其他分支

*   **`lean3` 分支**: 包含 Lean 3 社区网站的文件和历史。
*   **`oldsite` 分支**: 包含更早版本的社区网站文件和历史。

感谢你的贡献！
