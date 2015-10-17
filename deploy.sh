#!/bin/bash
deployDir=".deploy"
ignoreDeleteFiles=".git\|.gitignore"
repoUrl="https://github.com/howiefh/knowledge-summary.git"
repoBranch="gh-pages"

# 初始化发布书籍的目录
if [ ! -d $deployDir ]; then
    mkdir $deployDir
    cd $deployDir
    git init
    git checkout -b $repoBranch
    git add -A
    git commit -m "First commit"
    cd ..
fi

cd $deployDir
# 删除除隐藏文件(.git和.gitignore)之外的其它文件
ls | grep -v $ignoreDeleteFiles | xargs rm -rf
cd ..

gitbook build
cp -r _book/* $deployDir
cd $deployDir
git add -A
git commit -m "Book updated $(date "+%Y-%m-%d %H:%M:%S")"
git push -u $repoUrl "HEAD:"${repoBranch} --force
