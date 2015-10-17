# 关于

在找工作时总结了一些笔记，整理了一下（目前仍在整理中），打算借助GitBook做成了电子书。电子书内容来源于本人的总结笔记以及一些网络文章，对于参考的文章，每个章节都说明了参考链接，如果有遗漏，还请告知，谢谢！

由于本人水平有限，书中不免有不足之处，还望见谅。如果您发现问题或者有什么好的建议，可以提交 [PR](https://github.com/howiefh/knowledge-summary/pulls) 或 [Issues](https://github.com/howiefh/knowledge-summary/issues)。

## GitBook

下面简要介绍下制作电子书。

GitBook 是一个基于 Node.js 的命令行工具，可使用 Github/Git 和 Markdown 来制作精美的电子书。

## Gitbook项目地址

* GitBook项目官网：http://www.gitbook.io
* GitBook Github地址：https://github.com/GitbookIO/gitbook

## 安装Gitbook

首先需要安装Node，Node版本迭代速度飞快，所以最好选择一个工具可以方便以后升级，[n](https://github.com/tj/n) （同样基于Node）和 [nvm](https://github.com/creationix/nvm)都是不错的选择。

通过
```
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.29.0/install.sh | bash
```
或
```
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.29.0/install.sh | bash
```
安装nvm

安装稳定版本的node
```
$ nvm install stable
```

安装gitbook
```
npm install -g gitbook-cli
```

## 使用Gitbook

新建一个书的目录book，目录可以创建README.md和SUMMARY.md分别作为书的描述和书目录。通过下面的命令初始化
```
gitbook init
```
如果没有README.md和SUMMARY.md，这个命令会创建这两个文件，如果有这两个文件，这个命令会根据SUMMARY.md中的目录结构创建相关的章节文件。

下面的命令可以创建一个本地服务器，然后通过浏览器就可以先浏览书了。
```
gitbook serve
```

可以通过下面的命令输出一个静态网站
```
gitbook build
```

## 版权

本书采用“[保持署名—非商用](http://creativecommons.org/licenses/by-nc/4.0/)”创意共享4.0许可证。

只要保持原作者署名和非商用，您可以自由地阅读、分享、修改本书。
