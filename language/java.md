# Java
## HashSet

HashSet确保元素唯一性的两个方法，hashCode()和equals()方法。HashSet其底层实现其实是HashMap，在Map中有Entry数组，Entry类中有 Entry<K,V> next成员，有冲突时是采用链地址法。

当调用add()方法其实是调用map的put方法，键是add传入的参数，值是一个固定的Object对象，所以说一下put方法。

调用put方法时，先判断是否是空的entry数组，如果是，找到一个数，这个数大于阀值（数组容量*装载因子）且是2的n次方，然后new一个数组。其次判断key是否为null，如果是会存入数组下标为0的位置，相当于hash值为0。之后就是hash算法了，通过hash值（对hashCode再hash一次，产生均匀的散列码，减少冲突）计算出在数组中的下标来，如果这个下标对应的Entry还是空的，那直接调用addEntry方法存入这个新的键值对就好了；否则就是hash产生冲突了，这里用的链地址法，循环遍历链表，如果有hash值相同且两个键值也相等的(e.key == key || key.equals(k))，那么更新value的值，否则调用addEntry方法加入到链表中。

addEntry方法，首先会判断存储的项数是否大于阀值了，如果是每次扩大两倍，初始值是16，所以总是2的n次方；然后将新值插入到链表中，在表头插入

参考编程思想，质数实际上并不是散列表的理想容量，经过广泛测试，java散列函数都使用2的n次方，当容量一定是2^n时，h & (length - 1) 和 h % length 是相等的，它俩是等价不等效的, 位操作是非常高效的。而get和put是最常用的操作，用位操作开销会小不少。

默认加载因子 (填入表中的元素个数 / 散列表的长度，HashMap默认是0.75) 在时间和空间成本上寻求一种折衷。加载因子过高虽然减少了空间开销，但同时也增加了查询成本(考虑get和put是最常用的操作，而其中都包含查询)

每次扩容都会重新hash一次，所以如果预先知道会存入很多键值对，最好一开始就在构造函数中指定初始容量和装载因子。以便最大限度地降低 rehash 操作次数。如果初始容量大于最大条目数除以加载因子(实际上就是最大条目数小于初始容量*加载因子)，则不会发生 rehash 操作。

## ArrayList，LinkedList，HashMap，Hashtable区别

1. HashMap和Hashtable区别：

    1. Hashtable的方法是同步的，HashMap未经同步，所以在多线程场合要手动同步HashMap这个区别就像Vector和ArrayList一样。
    2. Hashtable不允许null值(key和value都不可以),HashMap允许null值(key和value都可以)。
    3. Hashtable有一个contains(Object value)，功能和containsValue(Object value)功能一样。
    4. Hashtable使用Enumeration，HashMap使用Iterator。
    5. Hashtable中hash数组默认大小是11，增加的方式是 `old * 2 + 1`。HashMap中hash数组的默认大小是16，而且一定是2的指数。
    6. Hashtable继承自抽象类Dictionary，HashMap继承自AbstractMap抽象类，实现了Map接口

2. ArrayList和LinkedList区别：

    1. ArrayList是实现了基于动态数组的数据结构，LinkedList基于链表的数据结构。
    2. 对于随机访问get和set，ArrayList优于LinkedList，因为LinkedList要移动指针。
    3. 对于新增和删除操作add和remove，LinedList比较占优势，因为ArrayList要移动数据。

3. Iterator和Enumeration

    1. 函数接口不同
        Iterator接口中多了一个移除操作。
    2. Iterator支持fail-fast机制，而Enumeration不支持。
        Enumeration 是JDK 1.0添加的接口。使用到它的函数包括Vector、Hashtable等类，这些类都是JDK 1.0中加入的，Enumeration存在的目的就是为它们提供遍历接口。Enumeration本身并没有支持同步，而在Vector、Hashtable实现Enumeration时，添加了同步。

        而Iterator 是JDK 1.2才添加的接口，它也是为了HashMap、ArrayList等集合提供遍历接口。Iterator是支持fail-fast机制的：当多个线程对同一个集合的内容进行操作时，就可能会产生fail-fast事件。

## 不可变类

如何创建一个不可变类：
1. 将类声明为final，所以它不能被继承
2. 将所有的成员声明为私有的，这样就不允许直接访问这些成员
3. 对变量不要提供setter方法
4. 将所有可变的成员声明为final，这样只能对它们赋值一次
5. 通过构造器初始化所有成员，进行深拷贝(deep copy)
6. 在getter方法中，不要直接返回对象本身，而是克隆对象，并返回对象的拷贝

Java中String及基本类型的包装器类都是不可变的。为什么String是不可变的：

1. 只有当字符串是不可变的，字符串池才有可能实现。字符串池的实现可以在运行时节约很多heap空间，因为不同的字符串变量都指向池中的同一个字符串。但如果字符串是可变的，那么String interning将不能实现(译者注：String interning是指对不同的字符串仅仅只保存一个，即不会保存多个相同的字符串。)，因为这样的话，如果变量改变了它的值，那么其它指向这个值的变量的值也会一起改变。
2. 如果字符串是可变的，那么会引起很严重的安全问题。譬如，数据库的用户名、密码都是以字符串的形式传入来获得数据库的连接，或者在socket编程中，主机名和端口都是以字符串的形式传入。因为字符串是不可变的，所以它的值是不可改变的，否则黑客们可以钻到空子，改变字符串指向的对象的值，造成安全漏洞。
3. 因为字符串是不可变的，所以是多线程安全的，同一个字符串实例可以被多个线程共享。这样便不用因为线程安全问题而使用同步。字符串自己便是线程安全的。
4. 类加载器要用到字符串，不可变性提供了安全性，以便正确的类被加载。譬如你想加载java.sql.Connection类，而这个值被改成了myhacked.Connection，那么会对你的数据库造成不可知的破坏。
5. 因为字符串是不可变的，所以在它创建的时候hashcode就被缓存了，不需要重新计算。这就使得字符串很适合作为Map中的键，字符串的处理速度要快过其它的键对象。这就是HashMap中的键往往都使用字符串

## 字符串对象

1. `String str = new String("abc");`这条语句创建了几个对象？

    “创建了”还要分为是类加载阶段还是实际运行这段代码的时候。类加载阶段扫描class文件，找到字符串字面量"abc"，然后检查堆中是否已经存在"abc"字符串对象，如果没有，则在堆中创建一个，然后将其引用存入字符串池中（String也是对象，对象在堆中存储，String也不例外，但是引用存在字符串池），之后任何指向这个字符串的引用（如String a = "abc"）都将指向同一个对象。但是运行时遇到new关键字就会有所不同了，它会在堆上创建一个新的字符串对象。

    所以单说这一个语句的话，算上加载和运行时，会创建两个对象。如果这句之前还有String a = new String("abc")或String a = "abc"这样的语句，那么算上加载和运行时，String str = new String("abc")只在运行时会创建一个新的对象。如果只算运行时那么肯定是之创建一个对象。

2. intern()方法
    JDK 1.6和JDK 1.7的区别，对于字符串池中已经存在的字符串，会直接返回其引用，所以这时str.intern()==str是false。对于字符串池中不存在的字符串，JDK 1.6会新建一个对象，然后将其引用存于字符串池，所以str.intern()==str是false。而JDK 1.7会直接将str的引用存于字符串池，所以str.intern()==str是true。

## finally

finally并不总是会执行，在try块执行后才有可能执行，特例情况：System.exit(0)，在守护进程中，当一个线程在执行 try 语句块或者 catch 语句块时被打断（interrupted）或者被终止（killed），与其相对应的 finally 语句块可能不会执行。

```
public int name() {
      int x = 1;
      try {
             return x;
      } catch (Exception e) {
             // TODO: handle exception
             x = 2;
             return x;
      } finally {
             x = 3;
            System. out.println( x);
      }
}
```

如果调用name并输出返回结果，会输出3,1.说明finally总是会输出，但是之前返回值已经被压入栈中，返回的还是1。

## sleep、wait方法区别

1. sleep是Thread类的方法，wait是Object类的方法
2. sleep保持对象锁，wait释放对象锁
3. 调用wait后，需要别的线程执行notify/notifyAll才能够重新获得CPU执行时间。在sleep()休眠时间期满后，该线程不一定会立即执行，这是因为其它线程可能正在运行而且没有被调度为放弃执行，除非此线程具有更高的优先级。
4. wait()必须放在synchronized block中，否则会在program runtime时扔出"java.lang.IllegalMonitorStateException"异常。

## nio

* IO: 面向流 阻塞IO 无选择器
* NIO: 面向缓冲 非阻塞IO 选择器

原来的 I/O 库(在 `java.io.*`中) 与 NIO 最重要的区别是数据打包和传输的方式。正如前面提到的，原来的 I/O 以流的方式处理数据，而 NIO 以块的方式处理数据。nio快得多

`java.io.*` 已经以 NIO 为基础重新实现了，所以现在它可以利用 NIO 的一些特性。

通道 和 缓冲区 是 NIO 中的核心对象，几乎在每一个 I/O 操作中都要使用它们。

Java NIO的通道类似流，但又有些不同：

* 既可以从通道中读取数据，又可以写数据到通道。但流的读写通常是单向的。
* 通道可以异步地读写。
* 通道中的数据总是要先读到一个Buffer，或者总是要从一个Buffer中写入。

Buffer内部实现是一个数组，但是一个缓冲区不 仅仅 是一个数组。缓冲区提供了对数据的结构化访问，而且还可以跟踪系统的读/写进程。每个基本类型都有对应的Buffer类。

为了理解Buffer的工作原理，需要熟悉它的三个属性：

* capacity
* position
* limit

position和limit的含义取决于Buffer处在读模式还是写模式。不管Buffer处在什么模式，capacity的含义总是一样的。

* capacity

    作为一个内存块，Buffer有一个固定的大小值，也叫“capacity”.你只能往里写capacity个byte、long，char等类型。一旦Buffer满了，需要将其清空（通过读数据或者清除数据）才能继续写数据往里写数据。

* position

    当你写数据到Buffer中时，position表示当前的位置。初始的position值为0.当一个byte、long等数据写到Buffer后， position会向前移动到下一个可插入数据的Buffer单元。position最大可为capacity – 1.

    当读取数据时，也是从某个特定位置读。当将Buffer从写模式切换到读模式，position会被重置为0. 当从Buffer的position处读取数据时，position向前移动到下一个可读的位置。

* limit

    在写模式下，Buffer的limit表示你最多能往Buffer里写多少数据。 写模式下，limit等于Buffer的capacity。

    当切换Buffer到读模式时， limit表示你最多能读到多少数据。因此，当切换Buffer到读模式时，limit会被设置成写模式下的position值。换句话说，你能读到之前写入的所有数据（limit被设置成已写数据的数量，这个值在写模式下就是position）

向Buffer中写数据

写数据到Buffer有两种方式：

* 从Channel写到Buffer。int bytesRead = inChannel.read(buf); //read into buffer.
* 通过Buffer的put()方法写到Buffer里。buf.put(127);

从Buffer中读取数据

从Buffer中读取数据有两种方式：

* 从Buffer读取数据到Channel。int bytesWritten = inChannel.write(buf);
* 使用get()方法从Buffer中读取数据。byte aByte = buf.get();

Buffer 方法

* allocate方法

    每一个Buffer类都有一个allocate方法。下面是一个分配48字节capacity的ByteBuffer的例子。 `ByteBuffer buf = ByteBuffer.allocate(48);`

* flip()方法

    flip方法将Buffer从写模式切换到读模式。调用flip()方法会将position设回0，并将limit设置成之前position的值。

* rewind()方法

    Buffer.rewind()将position设回0，所以你可以重读Buffer中的所有数据。limit保持不变，仍然表示能从Buffer中读取多少个元素（byte、char等）。

* clear()与compact()方法

    一旦读完Buffer中的数据，需要让Buffer准备好再次被写入。可以通过clear()或compact()方法来完成。

    如果调用的是clear()方法，position将被设回0，limit被设置成 capacity的值。换句话说，Buffer 被清空了。Buffer中的数据并未清除，只是这些标记告诉我们可以从哪里开始往Buffer里写数据。

    如果Buffer中有一些未读的数据，调用clear()方法，数据将“被遗忘”，意味着不再有任何标记会告诉你哪些数据被读过，哪些还没有。

    如果Buffer中仍有未读的数据，且后续还需要这些数据，但是此时想要先先写些数据，那么使用compact()方法。

    compact()方法将所有未读的数据拷贝到Buffer起始处。然后将position设到最后一个未读元素正后面。limit属性依然像clear()方法一样，设置成capacity。现在Buffer准备好写数据了，但是不会覆盖未读的数据。

* mark()与reset()方法

    通过调用Buffer.mark()方法，可以标记Buffer中的一个特定position。之后可以通过调用Buffer.reset()方法恢复到这个position。

## 重载方法匹配

如果有多个重载方法，参数按如下顺序匹配

```
char->int->long->float->double->包装类型->包装类的接口->变长参数
```

目前的Java语言是一门静态多分派、动态单分派的语言。静态分派是由编译器确定的，编译器通过参数的静态类型来确定要调用哪个版本，动态分派是由虚拟机来确定的，由虚拟机根据调用者的实际类型来确定调用父类还是子类的方法。

区分当子类的对象，强制转换成父类的时候：重写（覆盖）与重载的区别。覆盖调用子类的方法，重载只调用父类的方法

```
class Parent {
    public void print(char c){
        System.out.println("p");
    }
}
class Sub extends Parent {
    public void print(double d){
        System.out.println("s");
    }
}
Sub sub = new Sub();
Parent p =(Parent) sub;
p.print(3.0);
```

若在父类中匹配到print则执行该方法，否则报错。这里显然父类中没有print(double d)方法，所以会报错。

调用哪个重载函数只和声明的类型相关，跟new出来的实例是哪个导出类无关。

## final

当final关键字用于修饰变量时表示该变量的值不可变；静态变量、实例成员变量、形式参数和局部变量都可以被final修饰。

1. final修饰的变量都是在方法区吗？

    * static在Java里是一种storage modifier（存储修饰符），它会影响变量的存储种类；
    * final在Java里则不是一种存储修饰符，不影响变量的存储种类。

    所以，被final修饰的变量，该存哪儿存哪儿，跟final与否根本没关系；被static修饰的变量是静态变量，从JVM规范层面看，它会存储在“方法区”（method area）这个运行时数据区里。

2. 局部内部类为什么能够访问局部final变量？

    局部内部类（方法中的内部类）能够访问局部final变量是因为，编译器在局部内部类中拷贝了一份副本（拷贝为内部类的一个字段）。之所以需要拷贝为一份副本是因为局部变量在方法执行完时，其生命周期就已经结束了，但是内部类的方法却需要访问这个局部变量，这就会有矛盾。内部类和普通类一样也会编译为class文件，可以通过 `javap -c Test$1Inner` 来查看反编译的内部类。内部类通过`Outer.this`可以访问外部类对象，也是在内部类有一个对外部类对象的副本。

## 内部类的作用

1. 完善多重继承

    C++作为比较早期的面向对象编程语言，摸着石头过河，不幸的当了炮灰。比如多重继承，Java是不太欢迎继承的。因为继承耦合度太高。比如你是一个人，你想会飞，于是就继承了鸟这个类，然后你顺便拥有了一对翅膀和厚厚的羽毛，可这些玩意你并不需要。所以Java发明了接口，以契约的方式向你提供功能。想想看，你的程序里成员变量会比函数多吗？况且多重继承会遇到死亡菱形问题，就是两个父类有同样名字的函数，你继承谁的呢？其实C++也可以做到这些，那就是定义没有成员变量的纯虚类，而且所有函数都是纯虚函数。可是这些都是要靠程序员自己把握，并没有把这些功能集成到类似Interface这样的语法里。

    所以Java只支持单重继承，想扩展功能，去实现接口吧。很快Java的设计者就发现了他们犯了矫枉过正的错误，多重继承还是有一定用处的。比如每一个人都是同时继承父亲和母亲两个类，要不然你的身体里怎么能留着父母的血呢？Java内部类应运而生。

2. 实现事件驱动系统返回

    用来开发GUI的Java Swing使用了大量内部类，主要用来响应各种事件。Swing的工作就是在事件就绪的时候执行事件，至于事件具体怎么做，这由事件决定。这里面有两个问题：1.事件必须要用到继承2.事件必须能访问到Swing。所以必须把事件写成内部类。

3. 闭包。

    内部类是面向对象的闭包，因为它不仅包含创建内部类的作用域的信息，还自动拥有一个指向此外围类对象的引用，在此作用域内，内部类有权操作所有的成员，包括private成员。一般使用一个库或类时，是你主动调用人家的API，这个叫Call，有的时候这样不能满足需要，需要你注册（注入）你自己的程序（比如一个对象)，然后让人家在合适的时候来调用你，这叫Callback。

    当父类和实现的接口出现同名函数时，你又不想父类的函数被覆盖，回调可以帮你解决这个问题。

## 程序的出错处理

当一个程序出现错误时，它可能的情况有3种：语法错误，运行时错误和逻辑错误。语法错误是指代码的格式错了，或者某个字母输错了;运行时错误是指在程序运行的时候出现的一些没有想到的错误，如：空指针异常，数组越界，除数为零等;逻辑错误是指运行结果与预想的结果不一样，这是一种很难调试的错误。而java中的异常处理机制主要是指处理运行时错误，即异常就是运行时错误。

产生异常的原因有3中：1.java内部发生错误，java虚拟机产生的异常。2.编写程序的时候由于错误引起的异常，如：空指针异常，数组越界等。3.通过throw语句生成的异常。这种异常通常称为“检查异常”，用来告知方法的调用着相关信息。

java通过面向对象的方法处理异常。在一个方法的运行过程中如果出现了异常，这个方法就会产生代表该异常的一个对象，把它交给运行时系统，运行时系统寻找相应的代码来处理这一异常。其中，生成异常对象，并把它交个运行时系统的过程称为抛出(throw)。运行时系统在方法的调用栈中查找，直到找到能处理该异常的对象的过程称为捕获(catch)。

## 面向对象设计的三个基本要素及五种主要设计原则

三个基本要素：封装、继承、多态

* 封装：也就是把客观事物封装成抽象的类，并且类可以把自己的数据和方法只让可信的类或者对象操作，对不可信的进行信息隐藏。
* 继承：它可以使用现有类的所有功能，并在无需重新编写原来的类的情况下对这些功能进行扩展。
* 多态：父类的引用指向了自己的子类对象 父类的引用也可以接受自己的子类对象

五种设计原则：单一职责原则、开放封闭原则、依赖倒置原则、接口隔离原则、Liskov替换原则。

## 依赖、关联、聚合和组合之间区别

依赖(Dependency)关系是类与类之间的联接。依赖关系表示一个类依赖于另一个类的定义。例如，一个人(Person)可以买车(car)和房子(House)，Person类依赖于Car类和House类的定义，因为Person类引用了Car和House。与关联不同的是，Person类里并没有Car和House类型的属性，Car和House的实例是以参量的方式传入到buy()方法中去的。一般而言，依赖关系在Java语言中体现为局域变量、方法的形参，或者对静态方法的调用。

关联(Association）关系是类与类之间的联接，它使一个类知道另一个类的属性和方法。关联可以是双向的，也可以是单向的。在Java语言中，关联关系一般使用成员变量来实现。

聚合(Aggregation) 关系是关联关系的一种，是强的关联关系。聚合是整体和个体之间的关系。例如，汽车类与引擎类、轮胎类，以及其它的零件类之间的关系便整体和个体的关系。与关联关系一样，聚合关系也是通过实例变量实现的。但是关联关系所涉及的两个类是处在同一层次上的，而在聚合关系中，两个类是处在不平等层次上的，一个代表整体，另一个代表部分。

组合(Composition) 关系是关联关系的一种，是比聚合关系强的关系。它要求普通的聚合关系中代表整体的对象负责代表部分对象的生命周期，组合关系是不能共享的。代表整体的对象需要负责保持部分对象和存活，在一些情况下将负责代表部分的对象湮灭掉。代表整体的对象可以将代表部分的对象传递给另一个对象，由后者负责此对象的生命周期。换言之，代表部分的对象在每一个时刻只能与一个对象发生组合关系，由后者排他地负责生命周期。部分和整体的生命周期一样。

人和手，脚是组合关系，因为当人死亡后人的手也就不复存在了。

## 参考链接

[如何写一个不可变类？](http://www.importnew.com/7535.html)
[为什么String类是不可变的？](http://www.importnew.com/7440.html)
[请别再拿“String s = new String("xyz");创建了多少个String实例”来面试了吧](http://rednaxelafx.iteye.com/blog/774673)
[The SCJP Tip Line Strings, Literally](http://www.javaranch.com/journal/200409/ScjpTipLine-StringsLiterally.html)
[关于 Java 中 finally 语句块的深度辨析](http://www.ibm.com/developerworks/cn/java/j-lo-finally/)
[Java NIO 系列教程](http://ifeve.com/java-nio-all/)
[关于Java重载方法匹配优先级](http://my.oschina.net/sel/blog/223229)
[【深入Java虚拟机】之五：多态性实现机制——静态分派与动态分派](http://blog.csdn.net/ns_code/article/details/17965867)
[Java编程思想笔记](http://howiefh.github.io/2014/08/27/thinking-in-java-note-1/#方法重载)
[一个关于final变量使用时JVM处理效率，以及GC效率的问题，其实它到底有没有提高效率？](http://www.zhihu.com/question/28730233#answer-12279432)
[关于编译时常量问题](http://hllvm.group.iteye.com/group/topic/34963#post-232761)
[JVM对于声明为final的局部变量（local var）做了哪些性能优化？](http://www.zhihu.com/question/21762917#answer-2874085) 及其评论<http://www.zhihu.com/question/21762917#comment-50153817>
[全局变量存放在哪里？](http://www.zhihu.com/question/30292319#answer-14401618)
[设计模式六大原则](http://segmentfault.com/blog/channe/1190000000691175)
