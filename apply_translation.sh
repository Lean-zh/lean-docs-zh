#!/bin/sh
# 这是一个标准的 Bash 脚本

echo "Starting translation application script..."

# 查找备份分支中所有以 ' copy.md' 结尾的文件
git ls-tree -r --name-only backup-translation | grep " copy.md$" | while read file; do
    # 计算出目标文件名，例如把 '... copy.md' 变成 '... .md'
    target_file=$(echo "$file" | sed 's/ copy.md$/.md/')
    
    # 打印日志，让我们知道它在干什么
    echo "  -> Applying '$target_file'"
    
    # 从备份分支获取文件内容，并强制覆盖到当前目录下的目标文件
    git show "backup-translation:$file" > "$target_file"
done

echo "Script finished successfully!"
