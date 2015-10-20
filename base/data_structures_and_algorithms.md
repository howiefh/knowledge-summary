# 数据结构和算法

## Java中的栈、队列、双端队列

LinkedList实现了栈、队列、双端队列。

Queue

操作    | 抛出异常  | 返回特殊值
    --- | ---       | ---
插入    | add(e)    | offer(e)
移除    | remove()  | poll()
检查    | element() | peek()

Stack

方法           | 说明
---            | ---
E peek()       | 查看堆栈顶部的对象，但不从堆栈中移除它。
E pop()        | 移除堆栈顶部的对象，并作为此函数的值返回该对象。
E push(E item) | 把项压入堆栈顶部。

Deque

操作         | 抛出异常      | 特殊值
 ---         | ---           | ---
插入（头部） | addFirst(e)   | offerFirst(e)
插入（尾部） | addLast(e)    | offerLast(e)
移除（头部） | removeFirst() | pollFirst()
移除（尾部） | removeLast()  | pollLast()
检查（头部） | getFirst()    | peekFirst()
检查（尾部） | getLast()     | peekLast()

## KMP

思想是记录字符串“ABCDABD”各个前缀后缀的最大公共元素长度。如果不匹配可以直接跳到下个匹配的前缀处。

```
void createNext(char* p,int next[])
{
    int pLen = strlen(p);
    next[0] = -1;
    int k = -1;
    int j = 0;
    while (j < pLen - 1)
    {
        //p[k]表示前缀，p[j]表示后缀
        if (k == -1 || p[j] == p[k])
        {
            ++k;
            ++j;
            next[j] = k;
        }
        else
        {
            k = next[k];
        }
    }
}
int kmpIndex(char* s, char * p, int next[]){
    int i = 0, j = 0;
    int lenS = strlen(s);
    int lenP = strlen(p);
    while (i<lenS&&j<lenP) {
        if (j == -1 || s[i] == p[j]) {
            i++;
            j++;
        } else {
            j = next[j];
        }
    }
    if (j == lenP) {
        return i - j;
    }
    return -1;
}
```

## 树

结点拥有的子树数称为结点的度。

带权路径长度：WPL = ∑ Wk * Lk （其中Wk 为第k 个叶结点的权值，Lk 为第k 个叶结点的路径长度）

### 二叉树的性质

1. 性质1：一棵非空二叉树的第i层上最多有2^(i-1)个结点（i≥1）。
2. 性质2：一棵深度为k的二叉树中，最多具有2^k－1个结点。
3. 性质3：对于一棵非空的二叉树，如果叶子结点数为n0，度数为2的结点数为n2，则有：n0＝n2＋1
4. 性质4：具有n个结点的完全二叉树的深度k为|log2(n)|+1。
5. 性质5：对于具有n个结点的完全二叉树，如果按照从上至下和从左到右的顺序对二叉树中的所有结点从1开始顺序编号，则对于任意的序号为i的结点，有：

    1. 如果i＞1，则序号i的结点的双亲结点的序号为|i/2|；如果i＝1，则序号为i的结点是根结点，无双亲结点。
    2. 如果2i≤n，则序号为i的结点的左孩子结点的序号为2i；如果2i＞n，则序号为i的结点无左孩子。
    3. 如果2i＋1≤n，则序号为i的结点的右孩子结点的序号为2i＋1；如果2i＋1＞n，则序号为i的结点无右孩子。
    此外，若对二叉树的根结点从0开始编号，则相应的i号结点的双亲结点的编号为|(i-1)/2|，左孩子的编号为2i＋1，右孩子的编号为2i＋2。

### 遍历二叉树

```
typedef struct treeNode{
    int data;
    struct treeNode * lChild;
    struct treeNode * rChild;
} Node,*BiTree;

void visit(int data){
    printf("%d\n", data);
}
```

遍历二叉树是以一定规则将二叉树中结点排列成一个线性序列，实质是对一个非线性结构进行线性化操作。

（1）前序遍历的递归实现

```
void preOrder(BiTree bt){ /*前序遍历二叉树bt*/
    if (bt==NULL) return;   /*递归调用的结束条件*/
    visit(bt->data);      /*访问结点的数据域*/
    preOrder(bt->lChild); /*前序递归遍历bt的左子树*/
    preOrder(bt->rChild); /*前序递归遍历bt的右子树*/
}
```

（2）中序遍历的递归实现

```
void inOrder(BiTree bt){  /*中序遍历二叉树bt*/
    if (bt==NULL) return;   /*递归调用的结束条件*/
    inOrder(bt->lChild);  /*中序递归遍历bt的左子树*/
    visit(bt->data);      /*访问结点的数据域*/
    inOrder(bt->rChild);  /*中序递归遍历bt的右子树*/
}
```
（3）后序遍历的递归实现

```
void postOrder(BiTree bt){/*后序遍历二叉树bt*/
    if (bt==NULL) return;    /*递归调用的结束条件*/
    postOrder(bt->lChild); /*后序递归遍历bt的左子树*/
    postOrder(bt->rChild); /*后序递归遍历bt的右子树*/
    visit(bt->data);       /*访问结点的数据域*/
}
```

（4）层序遍历的实现

一维数组queue[MAX_TREE_SIZE]用以实现队列，变量front和rear分别表示当前对队首元素和队尾元素在数组中的位置。

```
void levelOrder(BiTree root){ /*层序遍历二叉树bt*/
    if (root==NULL)
        return;
    BiTree queue[MAX_QUEUE_SIZE];
    int front = -1, tail = 0;
    queue[tail] = root;
    while(front!=tail) {
        visit(queue[++front]->data); /*访问队首结点数据域*/
        if (queue[front]->lChild!=NULL) /*将队首结点的左孩子结点入队列*/
        {
            queue[++tail]=queue[front]->lChild;
        }
        if (queue[front]->rChild!=NULL) /*将队首结点的右孩子结点入队列*/
        {
            queue[++tail]=queue[front]->rChild;
        }
    }
}
```

（5）前序遍历的非递归实现

二叉树以二叉链表存放，一维数组stack[MAX_TREE_SIZE]用以实现栈，变量top用来表示当前栈顶的位置。

```
void NRPreOrder(BiTree root){/*非递归先序遍历二叉树*/
    if (root==NULL)
        return;
    BiTree stack[MAX_STACK_SIZE];
    BiTree p = root;
    int top = -1;
    while(top != -1 || p != NULL) {
        while(p != NULL){
            if (top < MAX_STACK_SIZE - 1) {
                visit(p->data); /*访问结点的数据域*/
                stack[++top] = p;/*将当前指针p压栈*/
                p = p->lChild; /*指针指向p的左孩子结点*/
            } else {
                printf("栈溢出\n");
                return;
            }
        }
        p = stack[top--]->rChild;/*从栈中弹出栈顶元素*/
    }
}
```

（6）中序遍历的非递归实现

只需将先序遍历的非递归算法中的Visit(p->data)移到p=stack[- -top]和p=p->rchild之间即可。

```
void NRInOrder(BiTree root){/*非递归中序遍历二叉树*/
    if (root==NULL)
        return;
    BiTree stack[MAX_STACK_SIZE];
    BiTree p = root;
    int top = -1;
    while(top != -1 || p != NULL) {
        while(p != NULL){
            if (top < MAX_STACK_SIZE - 1) {
                stack[++top] = p;/*将当前指针p压栈*/
                p = p->lChild;/*指针指向p的左孩子结点*/
            } else {
                printf("栈溢出\n");
                return;
            }
        }
        p = stack[top--];
        visit(p->data); /*访问结点的数据域*/
        p = p->rChild;
    }
}
```

（7）后序遍历的非递归实现

后序遍历与先序遍历和中序遍历不同，在后序遍历过程中，结点在第一次出栈后，还需再次入栈，也就是说，结点要入两次栈，出两次栈，而访问结点是在第二次出栈时访问。因此，为了区别同一个结点指针的两次出栈，设置一标志flag，令：

1. flag = 1  第一次出栈，结点不能访问
2. flag = 2  第二次出栈，结点可以访问

当结点指针进、出栈时，其标志flag也同时进、出栈。因此，可将栈中元素的数据类型定义为指针和标志flag合并的结构体类型。定义如下：

```
struct StackEle{
    BiTree node;
    int flag;//进栈次数
};
```
后序遍历二叉树的非递归算法如下。在算法中，一维数组stack[MAX_TREE_SIZE]用于实现栈的结构，指针变量p指向当前要处理的结点，整型变量top用来表示当前栈顶的位置，整型变量sign为结点p的标志量。

```
void NRPostOrder(BiTree root){
    if (root==NULL)
        return;

    struct StackEle stack[MAX_STACK_SIZE];
    BiTree p;
    int top,sign;
    top=-1;                         /*栈顶位置初始化*/
    p=root;

    while (!(p==NULL && top==-1)) {
        if (p!=NULL) {                  /*结点第一次进栈*/
            stack[++top].node=p;
            stack[top].flag=1;
            p=p->lChild;              /*找该结点的左孩子*/
        } else {
            p=stack[top].node;
            sign=stack[top--].flag;
            if (sign==1) {           /*结点第二次进栈*/
                stack[++top].node=p;
                stack[top].flag=2;  /*标记第二次出栈*/
                p=p->rChild;
            } else {
                printf("%d\n", p->data); /*访问该结点数据域值*/
                p=NULL;
            }
        }
    }
}
```

## BFS & DFS

广度优先搜索算法可以利用递归或者栈实现，类似于树的先序遍历。

深度优先搜索算法可以利用队列实现，类似于树的层序遍历

## 查找

### 静态查找

1. 顺序查找：顺序或者链式存储结构都可以，不要求是有序的。O(n)
2. 折半查找：顺序存储结构，要求是有序的。O(logn)

### 动态查找

1. 二叉排序树：或者是一棵空树；或者是具有下列性质的二叉树
    * 若左子树不空，则左子树上所有节点的值均小于根节点的值；若右子树不为空，则右子树上的所有节点的值均大于根节点的值。
    * 左右子树也都是二叉排序树
2. 平衡二叉树：或是一棵空树；或是具有一下性质的二叉排序树：它的左子树和右子树都是平衡二叉树，且左子树和右子树高度之差的绝对值不超过１．
    * 单向右旋：ａ的左子树根节点的左子树插入节点导致ａ失去平衡
    * 单向左旋：ａ的右子树根节点的右子树插入节点导致ａ失去平衡
    * 先左旋后右旋：ａ的左子树根节点的右子树插入节点导致ａ失去平衡
    * 先右旋后左旋：ａ的右子树根节点的左子树插入节点导致ａ失去平衡
3. B树
    一棵m阶的B-树，或者为空树，或为满足下列特性的m叉树：

    * 树中每个结点至多有m棵子树；
    * 若根结点不是叶子结点，则至少有两棵子树；
    * 除根结点之外的所有非终端结点至少有m/2 棵子树；
    * 所有的非终端结点中包含以下信息数据：（n，A0，K1，A1，K2，…，Kn，An）
        其中：Ki（i=1,2,…,n）为关键码，且Ki<Ki+1，Ai为指向子树根结点的指针(i=0,1,…,n)，且指针Ai-1所指子树中所有结点的关键码均小于Ki (i=1,2,…,n)，An所指子树中所有结点的关键码均大于Kn，m/2 1≤n≤m 1 ，n为关键码的个数。
    * 所有的叶子结点都出现在同一层次上，并且不带信息（可以看作是外部结点或查找失败的结点，实际上这些结点不存在，指向这些结点的指针为空）。

    B+树，节点如果有n个子树就含有n个关键字。叶子节点包含了所有关键字信息。节点中只含其子树的最大（或最小）关键字

### 散列表

散列函数
1. 直接定址法：H(key) = a * key + b
    适合于：地址集合的大小 = = 关键字集合的大小
2. 数字分析法：分析关键字集中的全体，并从中提取分布均匀的若干位或它们的组合作为地址。
    适合于：能预先估计出全体关键字的每一位上各种数字出现的频度。
3. 平方取中法：以关键字的平方值的中间几位作为存储地址。
    适合于：关键字中的每一位都有某些数字重复出现频度很高的现象。
4. 折叠法：将关键字分割成若干部分，然后取它们的叠加和为散列地址。
    适合于：关键字的数字位数特别多。
5. 除留余数法：H(key) = key MOD p ，其中p≤m (表长)并且p 应为不大于 m 的素数
6. 随机数法：H(key) = Random(key)
    适合于：对长度不等的关键字构造散列函数。

解决冲突的方法
1. 开放定址法：当关键字key的散列地址p= H（key）出现冲突时，以p为基础，产生另一个散列地址p1，如果p1仍然冲突，再以p为基础，产生另一个散列地址p2，……，直到找出一个不冲突的散列地址pi，将相应元素存入其中。

    主要有以下三种：
    * 线性探测再散列di=1，2，3，…:， m-1
        特点：冲突发生时，顺序查看表中下一单元，直到找出一个空单元或查遍全表。
    * 二次探测再散列di=±12，±22，…，±k2 (k≤m/2)
        特点：冲突发生时，在表的左右进行跳跃式探测，比较灵活。
    * 伪随机探测再散列di=伪随机数序列。
2. 再哈希法：用一组散列函数对key求值，直到没有冲突。
3. 链地址法：将所有散列地址为i的元素构成一个称为同义词链的单链表，并将单链表的头指针存在散列表的第i个单元中，因而查找、插入和删除主要在同义词链中进行。 链地址法适用于经常进行插入和删除的情况。
4. 建立一个公共溢出区：将散列表分为基本表和溢出表两部分，凡是与基本表发生冲突的元素一律填入溢出表。

## 折半查找

首先要把握下面几个要点：
1. 边界
    `right=n-1 => while(left <= right) => right=middle-1;`或`right=n   => while(left <  right) => right=middle;`
2. middle的计算不能写在while循环外，否则无法得到更新。
3. middle= (left+right)>>1; 这样的话left与right的值比较大的时候，其和可能溢出。

```
int binarySearch(int array[], int value, int n){
    int left=0;
    int right=n-1;
    //如果这里是int right = n 的话，那么下面有两处地方需要修改，以保证一一对应：
    //1、下面循环的条件则是while(left < right)
    //2、循环内当array[middle]>value 的时候，right = mid

    while (left<=right) {           //循环条件，适时而变
        int middle=left + ((right-left)>>1);  //防止溢出，移位也更高效。同时，每次循环都需要更新。
        if (array[middle]>value) {          //数组中不相等的情况更多 ，如果每次循环都判断一下是否相等，将耗费时间
            right =middle-1;   //right赋值，适时而变
        } else if(array[middle]<value)  {
            left=middle+1;
        }  else
            return middle;
    }
    return -1;
}
int main(int argc, char const* argv[])
{
    int array[7] = {1,2,4,7,14,17,31};
    int index = binarySearch(array,31, 7);
    printf("%d\n", index);
    return 0;
}
```

## 排序算法以及每个算法的优缺点

排序方法     | 平均情况       | 最好情况 | 最坏情况 | 辅助空间      | 稳定性
---          | ---            | ---      | ---      | ---           | ---
冒泡排序     | O(n2)          | O(n)     | O(n2)    | O(1)          | 稳定
直接插入排序 | O(n2)          | O(n)     | O(n2)    | O(1)          | 稳定
简单选择排序 | O(n2)          | O(n2)    | O(n2)    | O(1)          | 不稳定
希尔排序     | O(nlogn)-O(n2) | O(n1.3)  | O(n2)    | O(1)          | 不稳定
堆排序       | O(nlogn)       | O(nlogn) | O(nlogn) | O(1)          | 不稳定
归并排序     | O(nlogn)       | O(nlogn) | O(nlogn) | O(n)          | 稳定
快速排序     | O(nlogn)       | O(nlogn) | O(n2)    | O(logn)～O(n) | 不稳定

* 简单算法：冒泡、简单选择、直接插入。
* 改进算法：希尔、堆、并、快速。
* 稳定的排序算法：冒泡排序、插入排序、归并排序
* 不是稳定的排序算法：选择排序、快速排序、希尔排序、堆排序

1. 插入排序
    1. 直接插入排序
        特点：稳定排序，原地排序，时间复杂度`O(N * N)`，最好的情况就是已经有序，最坏是逆序
        思想：1.将第一待排序序列第一个元素看做一个有序序列，把第二个元素到最后一个元素当成是未排序序列。2.从头到尾依次扫描未排序序列，将扫描到的每个元素插入有序序列的适当位置。（如果待插入的元素与有序序列中的某个元素相等，则将待插入元素插入到相等元素的后面。）
        适用场景：当数据已经基本有序时，采用插入排序可以明显减少数据交换和数据移动次数，进而提升排序效率。
    2. 希尔排序
        特点：非稳定排序，原地排序，时间复杂度O(n^lamda)(1 < lamda < 2), lamda和每次步长选择有关。
        思想：增量缩小排序。1.选择一个增量序列t1，t2，…ti,tj…，tk，其中ti>tj，tk=1； 2.按增量序列个数k，对序列进行k 趟排序； 3.每趟排序，根据对应的增量ti，将待排序列分割成若干长度为m 的子序列，分别对各子表进行直接插入排序。仅增量因子为1 时，整个序列作为一个表来处理，表长度即为整个序列的长度。
        适用场景：因为增量初始值不容易选择，所以该算法不常用。
2. 交换排序
    1. 冒泡排序
        特点：稳定排序，原地排序，时间复杂度O(N*N)，最好的情况就是已经有序，最坏是逆序
        思想：1.比较相邻的元素。如果第一个比第二个大，就交换他们两个。 2.对每一对相邻元素作同样的工作，从开始第一对到结尾的最后一对。这步做完后，最后的元素会是最大的数。 3.针对所有的元素重复以上的步骤，除了最后一个。 4.持续每次对越来越少的元素重复上面的步骤，直到没有任何一对数字需要比较。
        适用场景：同直接插入排序类似
    2. 快速排序
        特点：不稳定排序，原地排序，时间复杂度O(N*lg N)，最坏是已经有序，最好是每次划分的中值左右序列长度相同。最好情况下用于递归的栈的辅助空间O(logN)，最坏O(N)
        思想：1.从数列中挑出一个元素，称为 “基准”（pivot）， 2.重新排序数列，所有元素比基准值小的摆放在基准前面，所有元素比基准值大的摆在基准的后面（相同的数可以到任一边）。在这个分区退出之后，该基准就处于数列的中间位置。这个称为分区（partition）操作。 3.递归地（recursive）把小于基准值元素的子数列和大于基准值元素的子数列排序。
        适用场景：应用很广泛，差不多各种语言均提供了快排API
3. 选择排序
    1. 简单选择排序
        特点：不稳定排序（比如对3 3 2三个数进行排序，第一个3会与2交换），原地排序，时间复杂度O(N*N)
        思想：1.首先在未排序序列中找到最小（大）元素，存放到排序序列的起始位置 2.再从剩余未排序元素中继续寻找最小（大）元素，然后放到已排序序列的末尾。 3.重复第二步，直到所有元素均排序完毕。
        适用场景：交换少
    2. 堆排序
        特点：非稳定排序，原地排序，时间复杂度O(N*lg N)
        思想：1.创建一个堆H[0..n-1] 2.把堆首（最大值）和堆尾互换 3.把堆的尺寸缩小1，并调用shift_down(0),目的是把新的数组顶端数据调整到相应位置 4. 重复步骤2，直到堆的尺寸为1
        适用场景：不如快排广泛
4. 其它排序
    1. 归并排序
        特点：稳定排序，非原地排序，时间复杂度O(N*N)
        思想：首先，将整个序列（共N个元素）看成N个有序子序列，然后依次合并相邻的两个子序列，这样一直下去，直至变成一个整体有序的序列。
        适用场景：外部排序

```
#include<stdio.h>
void printArray(int array[], int length){
  int i;
  for (i = 0; i < length; i++) {
    printf("%d\n", array[i]);
  }
}

void swap(int * a, int * b){
  *a = (*a)^(*b);
  *b = (*a)^(*b);
  *a = (*a)^(*b);
}

// 冒泡排序
void bubbleSort(int array[], int length){
  if(array == NULL || length <=0){
    return;
  }

  int i,j;
  for (i = 0; i < length; i++) {
    for (j = length - 1; j > i; j--) {
      if (array[j] < array[j-1]) {
        swap(&array[j],&array[j-1]);
      }
    }
  }
}

//选择排序
void selectSort(int array[], int length){
  if(array == NULL || length <=0){
    return;
  }

  int i,j,min;
  for (i = 0; i < length; i++) {
    min = i;
    for (j = length - 1; j > i; j--) {
      if (array[j] < array[min]) {
        min = j;
      }
    }
    if (min!=i) {
      swap(&array[i],&array[min]);
    }
  }
}

//插入排序
void insertSort(int array[], int length){
  if(array == NULL || length <=0){
    return;
  }

  int i,j;
  for (i = 1; i < length; i++) {
    int temp = array[i];
    for (j = i; j >= 1 && array[j - 1] > temp; j--) {
      array[j] = array[j - 1];
    }
    array[j] = temp;
  }
}

//快速排序
int partition(int array[], int low, int high){
  while (low<high) {
    while (low<high&&array[low]<array[high]) {
      high--;
    }
    if (low<high) {
      swap(&array[low],&array[high]);
    }
    while (low<high&&array[low]<array[high]) {
      low++;
    }
    if (low<high) {
      swap(&array[low],&array[high]);
    }
  }
  return low;
}

void quickSort(int array[], int low, int high){
  if(array == NULL || low<0||high<0||low>=high){
    return;
  }
  int index = partition(array,low,high);
  quickSort(array,low,index-1);
  quickSort(array,index+1,high);
}

//希尔排序
void shell(int array[], int length, int d){
  int i, j;
  for (i = d; i < length; i++) {
    int tmp = array[i];
    for (j = i; j >= d && array[j-d] > tmp; j-=d) {
      array[j] = array[j-d];
    }
    array[j]=tmp;
  }
}

void shellSort(int array[], int length){
  if(array == NULL || length <=0){
    return;
  }
  int i , d = 5;
  for (i = 5; i >= 1; i/=2) {
    shell(array,length,i);
  }
}

//归并排序
void merge(int array[], int low, int high){
  int mid = (low+high)/2;
  int k = low, lLen = mid - low + 1, rLen = high - mid;
  int i = 0, j = 0;
  int * lNew = (int*)malloc(sizeof(int)*lLen);
  int * rNew = (int*)malloc(sizeof(int)*rLen);
  memcpy(lNew, array+low, lLen*sizeof(int));
  memcpy(rNew, array+low+lLen, rLen*sizeof(int));

  while (i<lLen && j<rLen) {
    if (lNew[i]<=rNew[j]) {
      array[k++]=lNew[i++];
    } else {
      array[k++]=rNew[j++];
    }
  }
  while (i<lLen) {
    array[k++]=lNew[i++];
  }
  while (j<rLen) {
    array[k++]=rNew[j++];
  }
  free(lNew);
  free(rNew);
}

void mergeSort(int array[], int low, int high){
  if(array == NULL || low<0||high<0||low>=high){
    return;
  }

  int mid = (low+high)/2;
  mergeSort(array, low, mid);
  mergeSort(array, mid+1,high);
  merge(array,low,high);
}

//堆排序
void ajustHeap(int array[], int nodeIndex, int length){
  int lChild = nodeIndex * 2 + 1;
  int maxIndex;
  while (lChild < length) {
    if (lChild + 1 < length && array[lChild] < array[lChild+1]) {
      maxIndex = lChild + 1;
    } else {
      maxIndex = lChild;
    }
    if (array[maxIndex] > array[nodeIndex]) {
      swap(&array[maxIndex], &array[nodeIndex]);
    }
    lChild = maxIndex * 2 + 1;
    nodeIndex = maxIndex;
  }
}

void heapSort(int array[], int length){
  if(array == NULL || length <=0){
    return;
  }
  int i = length - 1;
  for (i = (i-1)/2; i >= 0; i--) {
    ajustHeap(array,i,length);
  }
  for (i = length - 1; i > 0; i--) {
    swap(&array[0],&array[i]);
    ajustHeap(array, 0, i);
  }
}

int main(){
  int array[] = {1,27,8,3,2,4,30};
  // bubbleSort(array,7);
  // selectSort(array,7);
  // insertSort(array,7);
  // quickSort(array,0,6);
  // shellSort(array,7);
  // mergeSort(array,0,6);
  heapSort(array, 7);
  printArray(array,7);
  system("pause");
  return 0;
}
```

## 海量数据查找

1. 分而治之/Hash映射 + Hash_map统计 + 堆/快速/归并排序

    海量日志数据，提取出某日访问百度次数最多的那个IP。

    1. 分而治之/hash映射：针对数据太大，内存受限，只能是：把大文件化成(取模映射)小文件，即16字方针：大而化小，各个击破，缩小规模，逐个解决
    2. hash_map统计：当大文件转化了小文件，那么我们便可以采用常规的hash_map(ip，value)来进行频率统计。
    3. 堆/快速排序：统计完了之后，便进行排序(可采取堆排序)，得到次数最多的IP。TOP10小，用最大堆，TOP10大，用最小堆

2. 多层划分(双层桶)  适用范围：第k大，中位数，不重复或重复的数字
3. Bloom filter/Bitmap
    适用范围：可以用来实现数据字典，进行数据的判重，或者集合求交集

    Bitmap 可进行数据的快速查找，判重，删除，一般来说数据范围是int的10倍以下

    所谓的Bit-map就是用一个bit位来标记某个元素对应的Value， 而Key即是该元素。由于采用了Bit为单位来存储数据，因此在存储空间方面，可以大大节省。

    如果说了这么多还没明白什么是Bit-map，那么我们来看一个具体的例子，假设我们要对0-7内的5个元素(4,7,2,5,3)排序（这里假设这些元素没有重复）。那么我们就可以采用Bit-map的方法来达到排序的目的。要表示8个数，我们就只需要8个Bit（1Bytes），首先我们开辟1Byte的空间，将这些空间的所有Bit位都置为0 `0 | 0 | 0 | 0 | 0 | 0 | 0 | 0`

    然后遍历这5个元素，首先第一个元素是4，那么就把4对应的位置为1（可以这样操作 p+(i/8)|(0×01<<(i%8)) 当然了这里的操作涉及到Big-ending和Little-ending的情况，这里默认为Big-ending）,因为是从零开始的，所以要把第五位置为一`0 | 0 | 0 | 0 | 1 | 0 | 0 | 0`

    然后再处理第二个元素7，将第八位置为1，接着再处理第三个元素，一直到最后处理完所有的元素，将相应的位置为1，这时候的内存的Bit位的状态如下：`0 | 0 | 1 | 1 | 1 | 1 | 0 | 1`

    然后我们现在遍历一遍Bit区域，将该位是一的位的编号输出（2，3，4，5，7），这样就达到了排序的目的。

    eg:2.5亿个整数中找出不重复的整数的个数，内存空间不足以容纳这2.5亿个整数。

    将bit-map扩展一下，用2bit表示一个数即可，0表示未出现，1表示出现一次，2表示出现2次及以上，在遍历这些数的时候，如果对应位置的值是0，则将其置为1；如果是1，将其置为2；如果是2，则保持不变。或者我们不用2bit来进行表示，我们用两个bit-map即可模拟实现这个2bit-map，都是一样的道理。

    Bloom Filter 可以用来实现数据字典，进行数据的判重，或者集合求交集

    Bloom Filter是一种空间效率很高的随机数据结构，它的原理是，当一个元素被加入集合时，通过K个Hash函数将这个元素映射成一个位阵列（Bit array）中的K个点，把它们置为1。检索时，我们只要看看这些点是不是都是1就（大约）知道集合中有没有它了：如果这些点有任何一个0，则被检索元素一定不在；如果都是1，则被检索元素很可能在。这就是布隆过滤器的基本思想。

    但Bloom Filter的这种高效是有一定代价的：在判断一个元素是否属于某个集合时，有可能会把不属于这个集合的元素误认为属于这个集合（false positive）。因此，Bloom Filter不适合那些“零错误”的应用场合。而在能容忍低错误率的应用场合下，Bloom Filter通过极少的错误换取了存储空间的极大节省。


4. Trie树/数据库/倒排索引
5. 外排序
6. 分布式处理之Mapreduce

## 倒排索引

根据单词来查找文档，而不是由文档来定位单词。保存倒排索引的文件称为倒排文件。单词词典是由所有单词构成的字符串集合。倒排列表每个单词对应一个记录列表，每条记录为一个倒排项，记录包含文档编号，单词词频、位置等信息。

## 不用算术运算符，如何判定一个数是否是二的幂？

```
public static boolean powerOfTwo(int x) {
    return (x & (x - 1)) == 0;
}
```

x & (x - 1)可以清除最低位的1，在判断一个数二进制有多少个1时除了移位也可以使用这个技巧。

```
public int count(int x){
     int count = 0;
     while (x != 0) {
          x = x & (x -1);
          count++;
     }
     return count;
}
```

## 三门问题

三个门中其中有一个有奖，选一个的概率是多少（1/3），如果这时主持人打开了为选中的两个门中没有奖的那个，你还有一次机会选择，那么中奖概率是多少(2/3)。

## 给定一个函数rand5()用其生成等概率的rand7()

题目：给定一个函数rand5()，该函数可以随机生成1-5的整数，且生成概率一样。现要求使用该函数构造函数rand7()，使函数rand7()可以随机等概率的生成1-7的整数。

解题：这种思想是基于，rand()产生[0,N-1]，把rand()视为N进制的一位数产生器，那么可以使用`rand()*N+rand()`来产生2位的N进制数，以此类推，可以产生3位，4位，5位...的N进制数。这种按构造N进制数的方式生成的随机数，必定能保证随机，而相反，借助其他方式来使用rand()产生随机数(如 `rand5() + rand()%3` )都是不能保证概率平均的。 此题中N为5，因此可以使用`rand5()*5+rand5()`来产生2位的5进制数，范围就是1到25。再去掉22-25，剩余的除3，以此作为rand7()的产生器。

```
/*
*   0 5  10 15 20   //5 * (rand5() - 1)
*   -------------
*   1 6  11 16 21
*   2 7  12 17
*   3 8  13 18
*   4 9  14 19
*   5 10 15 20
*/
int rand7()
{
    int x = 0;
    do{
        x = 5 * (rand5() - 1) + rand5();
    }while(x > 21);
    return 1 + x%7;
}
```

## LCS 最长公共子序列

注意子串和子序列的不同，子串是连续的。

如果用 L[i][j] 记录最长公共子序列长度，用 i 和 j 分别表示序列 X 的长度和序列 Y 的长度，状态转移方程为

1. L[i][j] = 0  如果i=0或j=0
2. L[i][j] = L[i-1][j-1] + 1  如果X[i-1] = Y[i-1]
3. L[i][j] = max{ L[i-1][j], L[i][j-1] }  如果X[i-1] != Y[i-1]

在序列X={A，B，C，B，D，A，B}和 Y={B，D，C，A，B，A}上，由LCS_LENGTH计算出的表c和b。第i行和第j列中的方块包含了c[i，j]的值以及指向b[i，j]的箭头。在c[7,6]的项4，表的右下角为X和Y的一个LCS<B，C，B，A>的长度。对于i，j>0，项c[i，j]仅依赖于是否有xi=yi，及项c[i-1，j]和c[i，j-1]的值，这几个项都在c[i，j]之前计算。为了重构一个LCS的元素，从右下角开始跟踪b[i，j]的箭头即可，这条路径标示为阴影，这条路径上的每一个“↖”对应于一个使xi=yi为一个LCS的成员的项（高亮标示）。

所以根据上述图所示的结果，程序将最终输出：“B C B A”，或“B D A B”。

```
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

/* Utility function to get max of 2 integers */
int max(int a, int b) {
  return (a > b)? a : b;
}

/* Returns length of LCS for X[0..m-1], Y[0..n-1] */
int lcs( char *X, char *Y, int m, int n ) {
  int L[m+1][n+1];
  int i, j;

  /* Following steps build L[m+1][n+1] in bottom up fashion. Note
     that L[i][j] contains length of LCS of X[0..i-1] and Y[0..j-1] */
  for (i=0; i<=m; i++) {
    for (j=0; j<=n; j++) {
      if (i == 0 || j == 0)
        L[i][j] = 0;
      else if (X[i-1] == Y[j-1])
        L[i][j] = L[i-1][j-1] + 1;
      else
        L[i][j] = max(L[i-1][j], L[i][j-1]);
    }
  }
  /* L[m][n] contains length of LCS for X[0..n-1] and Y[0..m-1] */
  return L[m][n];
}

int main() {
  char X[] = "AGGTAB";
  char Y[] = "GXTXAYB";

  int m = strlen(X);
  int n = strlen(Y);

  printf("Length of LCS is %d\n", lcs( X, Y, m, n ) );

  getchar();
  return 0;
}
```

如果需要输出子序列可以参考下面代码
```
i = m;
j = n;
int k = L[i][j];
char lcs[21] = {'\0'};
while(i && j)
{
if(X[i-1] == Y[j-1] && L[i][j] == L[i-1][j-1] + 1)
{
    lcs[--k] = X[i-1];
    --i; --j;
}else if(X[i-1] != Y[j-1] && L[i-1][j] > L[i][j-1])
{
    --i;
}else
{
    --j;
}
}
printf("%s\n",lcs);
```

## LIS 最长递增子序列

对于长度为N的数组A[N] = {a0, a1, a2, ..., an-1}，假设假设我们想求以aj结尾的最大递增子序列长度，设为L[j]，那么L[j] = max(L[i]) + 1, where i < j && a[i] < a[j], 也就是i的范围是0到j - 1。这样，想求aj结尾的最大递增子序列的长度，我们就需要遍历j之前的所有位置i（0到j-1），找出a[i] < a[j]，计算这些i中，能产生最大L[i]的i，之后就可以求出L[j]。之后我对每一个A[N]中的元素都计算以他们各自结尾的最大递增子序列的长度，这些长度的最大值，就是我们要求的问题——数组A的最大递增子序列。

```
int LIS_DP_N2(int *array, int nLength)
{
  int LIS[nLength];
  for(int i = 0; i < nLength; i++)
  {
    LIS[i] = 1;
  }

  for(int i = 1; i < nLength; i++)
  {
    int maxLen = 0;
    for(int j = 0; j < i; j++)
    {
      if(array[i] > array[j])
      {
        if(maxLen < LIS[j])
          maxLen = LIS[j];
      }
    }
    LIS[i] = maxLen + 1;
  }
  int maxLIS = 0;
  for(int i = 0; i < nLength; i++)
  {
    if(maxLIS < LIS[i])
      maxLIS = LIS[i];
  }

  return maxLIS;
}

int main()
{
  int data[6] = {5, 6, 7, 1, 2, 8};
  cout<<LIS_DP_N2(data, 6)<<endl;
  cout<<LIS_DP_NlogN(data, 6)<<endl;
  return 0;
}
```

## 参考链接

* [从头到尾彻底理解KMP](http://blog.csdn.net/v_july_v/article/details/7041827)
* [8大排序算法图文讲解](http://www.cricode.com/3212.html)
* [十道海量数据处理面试题与十个方法大总结](http://blog.csdn.net/v_JULY_v/article/details/6279498)
* [教你如何迅速秒杀掉：99%的海量数据处理面试题](http://blog.csdn.net/v_july_v/article/details/7382693)
* [常见的动态规划问题分析与求解](http://www.cnblogs.com/wuyuegb2312/p/3281264.html)
