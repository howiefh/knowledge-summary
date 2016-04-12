# 数据库

## 数据库事务

1. 事务（Transaction）是并发控制的单位，是用户定义的一个操作序列。这些操作要么都做，要么都不做，是一个不可分割的工作单位。通过事务，SQL Server能将逻辑相关的一组操作绑定在一起，以便服务器保持数据的完整性。
2. 事务MySQL中以START TRANSACTION或BEGIN开始，以COMMIT或ROLLBACK结束。
3. jdbc中使用事务。Jdbc程序向数据库获得一个Connection对象时，默认情况下这个Connection对象会自动向数据库提交在它上面发送的SQL语句。若想关闭这种默认提交方式，让多条SQL在一个事务中执行，可使用下列的JDBC控制事务语句

    * connection.setAutoCommit(false);//开启事务(start transaction)
    * SavePoint point =  connection.setSavepoint("s1");//设置回滚点
    * connection.rollback();//回滚事务(rollback)
    * connection.commit();//提交事务(commit)

4. 事务的特性(ACID特性)

    * 原子性(Atomicity)
        事务是数据库的逻辑工作单位，事务中包括的诸操作要么全做，要么全不做。
    * 一致性(Consistency)
        事务执行的结果必须是使数据库从一个一致性状态变到另一个一致性状态。一致性与原子性是密切相关的。
    * 隔离性(Isolation)
        一个事务的执行不能被其他事务干扰。
    * 持续性/永久性(Durability)
        一个事务一旦提交，它对数据库中数据的改变就应该是永久性的。

问题：

1. 第一类更新丢失
   这是事物隔离级别最低时出现的问题，既不发出共享锁，也不接受排它锁。两个事务更新相同的数据资源时，如果一个事务被提交，一个事务被撤销，则提交的事务所做的修改也将被撤销。
2. 脏读
   第二个事务查询到了第一个事务未提交的更新数据，第二个事务在查询结果上继续操作，但是第一个事务撤销所作的更新，这会导致第二个事务操作脏数据。
3. 虚读
   虚读是一个事务查询到另一个事务已提交（insert）的新插入的数据引起的。比如这样同一事务两次读取同一表的行数就会发现不一致。
4. 不可重复读
   同虚读类似，不可重复读是由一个事务查询到另一个事务已提交的对数据的更新（update、delete）引起的。


隔离级别                     | 脏读（Dirty Read） | 不可重复读（NonRepeatable Read） | 幻读（Phantom Read）
---                          | ---                | ---                              | ---
未提交读（Read uncommitted） | 可能               | 可能                             | 可能
已提交读（Read committed）   | 不可能             | 可能                             | 可能
可重复读（Repeatable read）  | 不可能             | 不可能                           | 可能
可串行化（Serializable ）    | 不可能             | 不可能                           | 不可能

mysql InnoDB数据库查询当前事务隔离级别：select @@tx_isolation。默认隔离级别是Repeatable read

MySQL中RR级别的事务不会出现幻读，使用Gap锁避免了幻读。行锁防止别的事务修改或删除，GAP锁防止别的事务新增

[Innodb中的事务隔离级别和锁的关系](http://tech.meituan.com/innodb-lock.html)

* 未提交读： 未提交读(READ UNCOMMITTED)是最低的隔离级别。允许脏读(dirty reads)，事务可以看到其他事务“尚未提交”的修改。
* 已提交读：在提交读(READ COMMITTED)级别中，基于锁机制并发控制的DBMS需要对选定对象的写锁(write locks)一直保持到事务结束，但是读锁(read locks)在SELECT操作完成后马上释放（因此“不可重复读”现象可能会发生，见下面描述）。和前一种隔离级别一样，也不要求“范围锁(range-locks)”。简而言之，提交读这种隔离级别保证了读到的任何数据都是提交的数据，避免读到中间的未提交的数据，脏读(dirty reads)。但是不保证事务重新读的时候能读到相同的数据，因为在每次数据读完之后其他事务可以修改刚才读到的数据。
* 可重复读：在可重复读(REPEATABLE READS)隔离级别中，基于锁机制并发控制的DBMS需要对选定对象的读锁(read locks)和写锁(write locks)一直保持到事务结束，但不要求“范围锁(range-locks)”，因此可能会发生“幻影读(phantom reads)”
* 可串行化：在基于锁机制并发控制的DBMS实现可序列化要求在选定对象上的读锁和写锁保持直到事务结束后才能释放。在SELECT 的查询中使用一个“WHERE”子句来描述一个范围时应该获得一个“范围锁(range-locks)”。这种机制可以避免“幻影读(phantom reads)”现象。当采用不基于锁的并发控制时不用获取锁。但当系统探测到几个并发事务有“写冲突”的时候，只有其中一个是允许提交的。这种机制的详细描述见“快照隔离”

## 锁
### 共享锁、共享锁
1. 共享锁
    共享锁用于读数据操作，它是非独占的，允许其他事务同时读取锁定的资源，但不允许其他事务更新它。

    加锁条件：当一个事务执行select语句时，数据库系统会为这个事务分配一把共享锁，来锁定被查询的数据。

    解锁条件：默认情况下，数据被读取后，数据库系统立即解除共享锁。

    兼容性：如果数据资源上放置了共享锁，还能再放置共享锁和更新锁。

2. 独占锁
    独占锁也叫排他锁，使用与修改数据的场合。它锁定的资源，其他事务不能读取也不能修改。

    加锁条件：当一个事务执行insert、update或delete语句时，数据库会放置一把排他锁。

    解锁条件：独占锁一直到事务结束才能被解除。‘

    兼容性：不能与其他锁兼容。

http://mdba.cn/?p=202
实例：http://www.cnblogs.com/xdp-gacl/p/3984001.html

### 一次封锁or两段锁？

因为有大量的并发访问，为了预防死锁，一般应用中推荐使用一次封锁法，就是在方法的开始阶段，已经预先知道会用到哪些数据，然后全部锁住，在方法运行之后，再全部解锁。这种方式可以有效的避免循环死锁，但在数据库中却不适用，因为在事务开始阶段，数据库并不知道会用到哪些数据。
数据库遵循的是两段锁协议，将事务分成两个阶段，加锁阶段和解锁阶段（所以叫两段锁）

* 加锁阶段：在该阶段可以进行加锁操作。在对任何数据进行读操作之前要申请并获得S锁（共享锁，其它事务可以继续加共享锁，但不能加排它锁），在进行写操作之前要申请并获得X锁（排它锁，其它事务不能再获得任何锁）。加锁不成功，则事务进入等待状态，直到加锁成功才继续执行。
* 解锁阶段：当事务释放了一个封锁以后，事务进入解锁阶段，在该阶段只能进行解锁操作不能再进行加锁操作。

### 悲观锁和乐观锁
* 悲观锁
     正如其名，它指的是对数据被外界（包括本系统当前的其他事务，以及来自外部系统的事务处理）修改持保守态度，因此，在整个数据处理过程中，将数据处于锁定状态。悲观锁的实现，往往依靠数据库提供的锁机制（也只有数据库层提供的锁机制才能真正保证数据访问的排他性，否则，即使在本系统中实现了加锁机制，也无法保证外部系统不会修改数据）。
     在悲观锁的情况下，为了保证事务的隔离性，就需要一致性锁定读。读取数据时给加锁，其它事务无法修改这些数据。修改删除数据时也要加锁，其它事务无法读取这些数据。

* 乐观锁
     相对悲观锁而言，乐观锁机制采取了更加宽松的加锁机制。悲观锁依靠锁机制，保证了独占性，但是性能开销大。
     而乐观锁机制在一定程度上解决了这个问题。乐观锁，大多是基于数据版本（ Version ）记录机制实现。何谓数据版本？即为数据增加一个版本标识，在基于数据库表的版本解决方案中，一般是通过为数据库表增加一个 “version” 字段来实现。读取出数据时，将此版本号一同读出，之后更新时，对此版本号加一。此时，将提交数据的版本数据与数据库表对应记录的当前版本信息进行比对，如果提交的数据版本号大于数据库表当前版本号，则予以更新，否则认为是过期数据。

## 索引
### 索引的类型
> Most MySQL indexes (PRIMARY KEY, UNIQUE, INDEX, and FULLTEXT) are stored in B-trees. Exceptions: Indexes on spatial data types use R-trees; MEMORY tables also support hash indexes; InnoDB uses inverted lists forFULLTEXT indexes.

* 普通索引。这是最基本的索引，它没有任何限制。
* 唯一索引。它与前面的普通索引类似，不同的就是：索引列的值必须唯一，但允许有空值。如果是组合索引，则列值的组合必须唯一。
* 主键索引。它是一种特殊的唯一索引，不允许有空值。
     在MyISAM中，primary key和其它索引没有什么区别。Primary key仅仅只是一个叫做PRIMARY的唯一，非空的索引而已。
     在InnoDB中，主键索引是聚集索引，聚集（聚簇）索引保证关键字的值相近的元组存储的物理位置也相同（所以字符串类型不宜建立聚集索引，特别是随机字符串，会使得系统进行大量的移动操作，通常使用int类型会比较好，而且是AUTO_INCREMENT的），且一个表只能有一个聚集索引。因为由存储引擎实现索引，所以，并不是所有的引擎都支持聚集索引。目前，只有InnoDB和solidDB支持。
     MySQL中对InnoDB来说每个表都有一个聚集索引（clustered index ），除此之外的表上的每个非聚集索引都是二级索引，又叫辅助索引（secondary indexes）。每个InnoDB表具有一个特殊的索引称为聚集索引，它支持聚集索引，但是不允许你自己显示创建。如果你的表上定义有主键，该主键索引是聚集索引。如果没有主键，MySQL取第一个唯一索引（unique）而且只含非空列（NOT NULL）作为主键，InnoDB使用它作为聚集索引。如果没有这样的列，InnoDB就自己产生一个这样的ID值，它有六个字节，而且是隐藏的，使其作为聚集索引。
     InnoDB主索引的叶子节点存储了key和整行的数据，而二级索引存储了key和主键

* 组合索引。多列上建索引

参考：

* [理解MySQL——索引与优化](http://www.cnblogs.com/hustcat/archive/2009/10/28/1591648.html)
* [聚簇索引和非聚簇索引以及二级索引](http://www.cnblogs.com/arlen/articles/1605626.html)

### 索引由 B/B+树实现的原因

B-\B+树查询包含两种基本操作：1. 在B-树中找节点；2. 在节点中找关键字。由于B-树通常存储在磁盘上，则前一查找操作是在磁盘上进行的，而后一操作是在内存中进行的，即在磁盘上找到指针p所指节点后，先将节点中的信息读入内存，然后再利用顺序查找或折半查找查询等于K的关键字。显然，在磁盘上进行一次查找比在内存中进行一次查找耗时多很多，因此，在磁盘上进行查找的次数，即待查关键字所在节点在B-树上的层次数，是决定B-树查找效率的首要原因。

先从B-Tree分析，根据B-Tree的定义，可知检索一次最多需要访问h个节点。数据库系统的设计者巧妙利用了磁盘预读原理，将一个节点的大小设为等于一个页，这样每个节点只需要一次I/O就可以完全载入。为了达到这个目的，在实际实现B-Tree还需要使用如下技巧：

1. 每次新建节点时，直接申请一个页的空间，这样就保证一个节点物理上也存储在一个页里，加之计算机存储分配都是按页对齐的，就实现了一个node只需一次I/O。
2. IO次数取决于b+树的高度h，假设当前数据表的数据为N，每个磁盘块的数据项的数量是m，则有h=㏒(m+1)N，当数据量N一定的情况下，m越大，h越小；而m = 磁盘块的大小 / 数据项的大小，磁盘块的大小也就是一个数据页的大小，是固定的，如果数据项占的空间越小，数据项的数量越多，树的高度越低。这就是为什么每个数据项，即索引字段要尽量的小，比如int占4字节，要比bigint8字节少一半。这也是为什么b+树要求把真实的数据放到叶子节点而不是内层节点，一旦放到内层节点，磁盘块的数据项会大幅度下降，导致树增高。当数据项等于1时将会退化成线性表。
3. 当b+树的数据项是复合的数据结构，比如(name,age,sex)的时候，b+树是按照从左到右的顺序来建立搜索树的，比如当(张三,20,F)这样的数据来检索的时候，b+树会优先比较name来确定下一步的所搜方向，如果name相同再依次比较age和sex，最后得到检索的数据；但当(20,F)这样的没有name的数据来的时候，b+树就不知道下一步该查哪个节点，因为建立搜索树的时候name就是第一个比较因子，必须要先根据name来搜索才能知道下一步去哪里查询。比如当(张三,F)这样的数据来检索时，b+树可以用name来指定搜索方向，但下一个字段age的缺失，所以只能把名字等于张三的数据都找到，然后再匹配性别是F的数据了， 这个是非常重要的性质，即索引的最左匹配特性。
而红黑树这种结构，h明显要深的多。由于逻辑上很近的节点（父子）物理上可能很远，无法利用局部性，所以红黑树的I/O渐进复杂度也为O(h)，效率明显比B-Tree差很多。
综上所述，用B-Tree作为索引结构效率是非常高的。

B-tree索引有以下一些限制：
1. 查询必须从索引的最左边的列开始。如`a = 1 and b = 2` 如果建立(a,b,c,d)顺序的索引，是从a开始的然后是b
2. 不能跳过某一索引列。比如`b = 2 and c > 3 and d = 4` 如果建立(a,b,c,d)顺序的索引，b是用不到索引的
3. 存储引擎不能使用索引中范围条件右边的列。比如`a = 1 and b = 2 and c > 3 and d = 4` 如果建立(a,b,c,d)顺序的索引，d是用不到索引的

Hash索引有以下一些限制：
1. 由于索引仅包含hash code和记录指针，所以，MySQL不能通过使用索引避免读取记录。但是访问内存中的记录是非常迅速的，不会对性能造成太大的影响。
2. 不能使用hash索引排序。
3. Hash索引不支持键的部分匹配，因为是通过整个索引值来计算hash值的。
4. Hash索引只支持等值比较，例如使用=，IN( . 和<=>。对于WHERE price>100并不能加速查询。

hash和btree索引的区别：
1. hash索引查找数据基本上能一次定位数据，当然有大量碰撞的话性能也会下降。而btree索引就得在节点上挨着查找了，很明显在数据精确查找方面hash索引的效率是要高于btree的；
2. 那么不精确查找呢，也很明显，因为hash算法是基于等值计算的，所以对于“like”等范围查找hash索引无效，不支持；
3. 对于btree支持的联合索引的最优前缀，hash也是无法支持的，联合索引中的字段要么全用要么全不用。
4. hash不支持索引排序，索引值和计算出来的hash值大小并不一定一致。

### 建索引的几大原则

1. 最左前缀匹配原则，非常重要的原则，mysql会一直向右匹配直到遇到范围查询(`>、<、between、like`)就停止匹配，比如`a = 1 and b = 2 and c > 3 and d = 4` 如果建立(a,b,c,d)顺序的索引，d是用不到索引的，如果建立(a,b,d,c)的索引则都可以用到，a,b,d的顺序可以任意调整。
2. =和in可以乱序，比如a = 1 and b = 2 and c = 3 建立(a,b,c)索引可以任意顺序，mysql的查询优化器会帮你优化成索引可以识别的形式
3. 尽量选择区分度高的列作为索引,区分度的公式是count(distinct col)/count(*)，表示字段不重复的比例，比例越大我们扫描的记录数越少，唯一键的区分度是1，而一些状态、性别字段可能在大数据面前区分度就是0，那可能有人会问，这个比例有什么经验值吗？使用场景不同，这个值也很难确定，一般需要join的字段我们都要求是0.1以上，即平均1条扫描10条记录
4. 索引列不能参与计算，保持列“干净”，比如from_unixtime(create_time) = ’2014-05-29’就不能使用到索引，原因很简单，b+树中存的都是数据表中的字段值，但进行检索时，需要把所有元素都应用函数才能比较，显然成本太大。所以语句应该写成create_time = unix_timestamp('2014-05-29');
5. 尽量的扩展索引，不要新建索引。比如表中已经有a的索引，现在要加(a,b)的索引，那么只需要修改原来的索引即可。一次查询只能用到一个索引
6. like "%ww",not in,!=,对列用到函数时数据库不会使用索引。like "ww%"会用索引
7. 索引列排序.MySQL查询只使用一个索引，因此如果where子句中已经使用了索引的话，那么order by中的列是不会使用索引的。因此数据库默认排序可以符合要求的情况下不要使用排序操作；尽量不要包含多个列的排序，如果需要最好给这些列创建复合索引。
8. 越小的、越简单的数据类型通常更好，尽量避免NULL。使用短索引。对串列进行索引，如果可能应该指定一个前缀长度。例如，如果有一个CHAR(255)的列，如果在前10个或20个字符内，多数值是惟一的，那么就不要对整个列进行索引。短索引不仅可以提高查询速度而且可以节省磁盘空间和I/O操作。
9. 更新非常频繁的数据不适宜建索引

[MySQL索引原理及慢查询优化](http://tech.meituan.com/mysql-index.html)

## 数据库优化

为什么要创建索引呢？这是因为，创建索引可以大大提高系统的性能。
1. 通过创建唯一性索引，可以保证数据库表中每一行数据的唯一性。
2. 可以大大加快 数据的检索速度，这也是创建索引的最主要的原因。
3. 可以加速表和表之间的连接，特别是在实现数据的参考完整性方面特别有意义。
4. 在使用分组和排序 子句进行数据检索时，同样可以显著减少查询中分组和排序的时间。
5. 通过使用索引，可以在查询的过程中，使用优化隐藏器，提高系统的性能。

MySQL数据库优化的几个方面。

首先，在数据库设计的时候，要能够充分的利用索引带来的性能提升，至于如何建立索引，建立什么样的索引，在哪些字段上建立索引，上面已经讲的很清楚了，这里不再赘述。另外就是设计数据库的原则就是尽可能少的进行数据库写操作（插入，更新，删除等），查询越简单越好。

其次，配置缓存是必不可少的，配置缓存可以有效的降低数据库查询读取次数，从而缓解数据库服务器压力，达到优化的目的，一定程度上来讲，这算是一个“围魏救赵”的办法。可配置的缓存包括索引缓存(key_buffer)，排序缓存(sort_buffer)，查询缓存(query_buffer)，表描述符缓存(table_cache)

第三，切表，切表也是一种比较流行的数据库优化法。分表包括两种方式：横向分表和纵向分表，其中，横向分表比较有使用意义，故名思议，横向切表就是指把记录分到不同的表中，而每条记录仍旧是完整的（纵向切表后每条记录是不完整的），例如原始表中有100条记录，我要切成2个表，那么最简单也是最常用的方法就是ID取摸切表法，本例中，就把ID为1,3,5,7。。。的记录存在一个表中，ID为2,4,6,8,。。。的记录存在另一张表中。虽然横向切表可以减少查询强度，但是它也破坏了原始表的完整性，如果该表的统计操作比较多，那么就不适合横向切表。横向切表有个非常典型的用法，就是用户数据：每个用户的用户数据一般都比较庞大，但是每个用户数据之间的关系不大，因此这里很适合横向切表。最后，要记住一句话就是：分表会造成查询的负担，因此在数据库设计之初，要想好是否真的适合切表的优化：

第四，日志分析，在数据库运行了较长一段时间以后，会积累大量的LOG日志，其实这里面的蕴涵的有用的信息量还是很大的。通过分析日志，可以找到系统性能的瓶颈，从而进一步寻找优化方案。

## 什么是SQL注入？

SQL注入是一种安全漏洞，它使得入侵者可以从系统中窃取数据。任何从用户那里得到输入并不加验证地创建SQL查询的系统都可能被SQL注入攻击。在这样的系统中，入侵者可以输入SQL代码，而不是数据，来获取额外的数据。有很多用敏感信息（如用户id、密码和个人信息）被人利用这种漏洞获取的实例。 在Java中，你可以用Prepared语句来避免SQL注入。

## 在SQL中，内连接(inner join)和左连接(left join)有什么区别？

在SQL中，主要有两种连接类型，内连接和外连接。外连接包括右外连接和左外连接。内连接和左连接的主要区别是，内连接中两个表都匹配的记录才被选中，左连接中两个表都匹配的记录被选中，外加左表的所有记录都被选中。要留意包含“所有”的查询，它们往往要求左连接，例如写一个SQL查询来找所有的部门和它们的雇员人数。如果你用内连接处理这个查询，你会漏掉没有人工作的空部门。

内连接结果加上student的所有元组
```
select student.sno, sname, cno,grade from student left join sc on student.sno = sc.sno;
```
内连接结果加上sc的所有元组
```
select student.sno, sname, cno,grade from student right join sc on student.sno = sc.sno;
```

## 各种范式有什么区别

按照“数据库规范化"对表进行设计, 其目的就是减少数据库中的数据冗余, 以增加数据的一致性。

1. 1NF (第一范式)。第一范式是指数据库表的每一列都是不可分割的基本数据项, 同一列中不能有多个值, 即实体中的某个属性不能有多个值或者不能有重复的属性。如果出现重复的属性, 就可能需要定义一个新的实体, 新的实体由重复的属性构成, 新实体与原实体之间为一对多关系。第一范式的模式要求属性值不可再分裂成更小部分, 即属性项不能是属性组合或由组属性组成。简而言之, 第一范式就是无重复的列, 例如, 由“职工号"“姓名"“电话号码"组成的表(一个人可能有一部办公电话和一部移动电话), 这时将其规范化化为1NF 可以将电话号码分为办公电话和移动电话两个属性, 即职工(职工号, 姓名, 办公电话, 移动电话)。

2. 2NF (第二范式)。第二范式(2NF) 是在第一范式(1NF) 的基础上建立起来的, 即满足第二范式(2NF) 必须先满足第一范式(1NF)。第二范式(2NF) 要求数据库表中的每个实例或行必须可以被唯一地区分。为实现区分通常需要为表加上一个列, 以存储各个实例的唯一标识。如果关系模式R 为第一范式, 并且R 中的每一个非主属性完全函数依赖于R 的某个候选键, 则称R 为第二范式模式(如 果A 是关系模式R 的候选键的一个属性, 则称A 是R的主属性, 否则称A 是R 的非主属性), 例如, 在选课关系表(学号, 课程号, 成绩, 学分), 关键字为组合关键字(学号, 课程号), 但由于非主属性学分仅依赖于课程号, 对关键字(学号, 课程号) 只是部分依赖, 而不是完全依赖, 因此此种方式会导致数据冗余以及更新异常等问题, 解决办法是将其分为两个关系模式: 学生表(学号, 课程号, 分数) 和课程表(课程号, 学分), 新关系通过学生表中的外关键字课程号联系, 在需要时进行连接。

3. 3NF (第三范式)。如果关系模式R 是第二范式, 且每个非主属性都不传递依赖于R 的候选键, 则称R 是第三范式的模式, 以学生表(学号, 姓名, 课程号, 成绩) 为例, 其中学生姓名无重名, 所以该表有两个候选码(学号, 课程号) 和(姓名, 课程号), 故存在函数依赖: 学号->姓名, (学号, 课程号)->成绩, (姓名, 课程号)->成绩, 唯一的非主属性成绩对码不存在部分依赖, 也不存在传递依赖, 所以属于第三范式。

4. BCNF。它构建在第三范式的基础上, 如果关系模式R 是第一范式, 且每个属性都不传递依赖于R 的候选键, 那么称R 为BCNF 的模式。假设仓库管理关系表(仓库号, 存储物品号, 管理员号, 数量), 满足一个管理员只在一个仓库工作; 一个仓库可以存储多种物品, 则存在如下关系:

    `(仓库号, 存储物品号)->(管理员号, 数量)`

    `(管理员号, 存储物品号)->(仓库号, 数量)`

    所以, (仓库号, 存储物品号) 和(管理员号, 存储物品号) 都是仓库管理关系表的候选码, 表中的唯一非关键字段为数量, 它是符合第三范式的。但是, 由于存在如下决定关系:

    `(仓库号)->(管理员号)`

    `(管理员号)->(仓库号)`

    即存在关键字段决定关键字段的情况, 因此其不符合BCNF。把仓库管理关系表分解为两个关系表: 仓库管理表(仓库号, 管理员号) 和仓库表(仓库号, 存储物品号, 数量), 这样的数据库表是符合BCNF 的, 并消除了删除异常、插入异常和更新异常。

5. 4NF (第四范式)。设R 是一个关系模式, D 是R 上的多值依赖集合。如果D 中存在凡多值依赖X->Y 时, X 必是R 的超键, 那么称R 是第四范式的模式, 例如, 职工表(职工编号, 职工孩子姓名,职工选修课程), 在这个表中同一个职工可能会有多个职工孩子姓名, 同样, 同一个职工也可能会有多个职工选修课程, 即这里存在着多值事实, 不符合第四范式。如果要符合第四范式, 只需要将上表分为两个表, 使它们只有一个多值事实, 例如职工表一(职工编号, 职工孩子姓名), 职工表二(职工编号, 职工选修课程), 两个表都只有一个多值事实, 所以符合第四范式。

## 视图的作用

1. 视图能够简化用户的操作
    当视图中数据不是直接来自基本表时，定义视图能够简化用户的操作。如基于多张表连接形成的视图，基于复杂嵌套查询的视图和含导出属性的视图。

2. 视图使用户能以多种角度看待同一数据
    不同的用户和应用程序会以不同的角度看待同一数据。如学生信息中的生源所在地，在招生管理中表达该学生是从哪个地方录取的，而在户籍管理中则表达该学生的户口是从哪个地方迁入的。这两种应用所使用的是数据库中存储的同一数据。

    因此，视图可以避免数据存储的冗余性，适应数据库共享的需要。

3. 视图对重构数据库提供了一定程度的逻辑独立性
    例：运行中的学籍管理数据库，其学生关系： `Student ( Sno, Sname, Ssex, Sage, Sdept )` 因性能需要重构： `SX ( Sno, Sname, Sage ); SY( Sno, Ssex, Sdept )`

    这时原关系Student已经不存在，应用程序也就无法使用。
    解决方法：可以通过建立以下视图实现 `CREATE VIEW Student ( Sno, Sname, Ssex, Sage, Sdept ) AS SELECT SX.Sno, SX.Sname, SY.Ssex, SX.Sage, SY.Sdept FROM SX, SY WHERE SX.Sno = SY.Sno;` 即修改外模式／模式映象!

4. 视图能够对机密数据提供安全保护
    建立面向不同用户的视图，并将对该视图的操作权限赋予不同的用户，则这些用户只能对视图所见的数据进行权限内的操作，而视图之外的数据对这些用户是不可见的，从而也就对视图之外的数据进行了保护。

    同样，针对不同的应用程序建立视图，使用该应用程序也只能操作视图内的数据，对视图外的数据也进行了保护。

    例如Student表涉及三个系的学生数据，可以在其上定义三个视图，每个视图只包含一个系的学生数据，并只允许每个系的系主任查询自己系的学生视图。

## 数据库缓存

1 mysql的cache功能的key的生成原理是：把select语句按照一定的hash规则生成唯一的key，select的结果生成value，即 key=>value。所以对于cache而言，select语句是区分大小写的，也区分空格的。两个select语句必须完完全 全一致，才能够获取到同一个cache。

2 生成cache之后，只要该select中涉及到的table有任何的数据变动(insert，update，delete操作等),相 关的所有cache都会被删除。因此只有数据很少变动的table，引入mysql 的cache才较有意义。

## 导出数据库

1. 导出整个数据库`mysqldump -u 用户名 -p 数据库名 > 导出的文件名`
    例：`mysqldump -h192.168.0.3 -unikey -p123456 --default-character-set=utf8 neem_jabil commerr > d:/jabil1.sql`
2. 导出一个表`mysqldump -u 用户名 -p 数据库名 表名> 导出的文件名`。导出一个数据库结构`mysqldump -u wcnc -p -d smgp_apps_wcnc >d:wcnc_db.sql`
3. 导入数据库
    方法一：source 命令
    进入mysql数据库控制台，如`mysql -u root -p`，选择数据库`mysql>use 数据库`，然后使用source命令，后面参数为脚本文件(如这里用到的.sql)`mysql>source back.sql`
    方法二：`mysql -u root -p 数据库名<导出的文件`

## MyISAM 和 InnoDB
MyISAM 是MySQL中默认的存储引擎，一般来说不是有太多人关心这个东西。决定使用什么样的存储引擎是一个很tricky的事情，但是还是值我们去研究一下，这里的文章只考虑 MyISAM 和InnoDB这两个，因为这两个是最常见的。

下面先让我们回答一些问题：

1. 你的数据库有外键吗？
2. 你需要事务支持吗？
3. 你需要全文索引吗？
4. 你经常使用什么样的查询模式？
5. 你的数据有多大？


思考上面这些问题可以让你找到合适的方向，但那并不是绝对的。如果你需要事务处理或是外键，那么InnoDB 可能是比较好的方式。如果你需要全文索引，那么通常来说 MyISAM是好的选择，因为这是系统内建的，然而，我们其实并不会经常地去测试两百万行记录。所以，就算是慢一点，我们可以通过使用Sphinx从InnoDB中获得全文索引。

数据的大小，是一个影响你选择什么样存储引擎的重要因素，大尺寸的数据集趋向于选择InnoDB方式，因为其支持事务处理和故障恢复。数据库的在小决定了故障恢复的时间长短，InnoDB可以利用事务日志进行数据恢复，这会比较快。而MyISAM可能会需要几个小时甚至几天来干这些事，InnoDB只需要几分钟。

您操作数据库表的习惯可能也会是一个对性能影响很大的因素。比如： COUNT() 在 MyISAM 表中会非常快，而在InnoDB 表下可能会很痛苦。而主键查询则在InnoDB下会相当相当的快，但需要小心的是如果我们的主键太长了也会导致性能问题。大批的inserts 语句在MyISAM下会快一些，但是updates 在InnoDB 下会更快一些——尤其在并发量大的时候。

所以，到底你检使用哪一个呢？根据经验来看，如果是一些小型的应用或项目，那么MyISAM 也许会更适合。当然，在大型的环境下使用MyISAM 也会有很大成功的时候，但却不总是这样的。如果你正在计划使用一个超大数据量的项目，而且需要事务处理或外键支持，那么你真的应该直接使用InnoDB方式。但需要记住InnoDB 的表需要更多的内存和存储，转换100GB 的MyISAM 表到InnoDB 表可能会让你有非常坏的体验。

[MySQL: InnoDB 还是 MyISAM?](http://coolshell.cn/articles/652.html)

## SQL语句

集DDL（数据定义语言）、DML（数据管理语言）、DCL（数据控制语言）于一体

SQL数据类型 http://www.w3school.com.cn/sql/sql_datatypes.asp

* SMALLINT -32768 到 32767 常规。0 到 65535 无符号（unsigned）。在括号中规定最大位数。
* INTEGER或INT -2147483648 到 2147483647 常规。0 到 4294967295 无符号（unsigned）。在括号中规定最大位数。
* DECIMAL (p[,q]) 作为字符串存储的 DOUBLE 类型，允许固定的小数点。
* FLOAT 带有浮动小数点的小数字。在括号中规定最大位数。在 d 参数中规定小数点右侧的最大位数。
* CHARACTER(n)或CHAR(n) 保存固定长度的字符串（可包含字母、数字以及特殊字符）。在括号中指定字符串的长度。最多 255 个字符。
* VARCHAR(n)     保存可变长度的字符串（可包含字母、数字以及特殊字符）。在括号中指定字符串的最大长度。最多 255 个字符。
* DATE 日期型，格式为yyyy-mm-dd
* TIME 时间型，格式为hh:mm:ss
* TIMESTAMP 日期加时间 范围是从 '1970-01-01 00:00:01' UTC 到 '2038-01-09 03:14:07' UTC
* DATETIME 范围是从 '1000-01-01 00:00:00' 到 '9999-12-31 23:59:59'

数据类型始终选择可以支持最大可能值的最小数值类型。如果没有负值用unsigned，如果字段长度确定或很少变化最好用char利于索引。如对于电话号码用char(13)
```
create table meal(
id int not null primary key,
fruit emun('apple' ,'banana')
);
```
枚举类型会被抽象为底层的数值类型

常用完整性约束
1. 主码约束： PRIMARY KEY
2. 唯一性约束：UNIQUE(不能取相同值但允许多个空值)
3. 非空值约束：NOT NULL
4. 参照完整性约束：FOREIGN KEY<列名> REFERENCES <表名>(<列名>)
5. CHECK约束：CHECK (<谓词>)
6. 断言(Assertion)约束

```
CREATE  TABLE  <表名>
  ( <列名> <数据类型>[ <列级完整性约束条件> ]
    [，<列名> <数据类型>[ <列级完整性约束条件>] ] …
    [，<表级完整性约束条件> ]  )；
```
1. 列级完整性约束条件：not null、 unique、 auto_increment、unsigned、check()、 default、primary key
2. 表级完整性约束条件：FOREIGN KEY(index_col_name, ...) REFERENCES tbl_name(index_col_name, ...) [ON DELETE|UPDATE {CASCADE | SET NULL | NO ACTION | RESTRICT}]
    1. CASCADE: 从父表中删除或更新对应的行，同时自动的删除或更新自表中匹配的行。ON DELETE CANSCADE和ON UPDATE CANSCADE都被InnoDB所支持。
    2. SET NULL: 从父表中删除或更新对应的行，同时将子表中的外键列设为空。注意，这些在外键列没有被设为NOT NULL时才有效。ON DELETE SET NULL和ON UPDATE SET SET NULL都被InnoDB所支持。
    3. NO ACTION: InnoDB拒绝删除或者更新父表。
    4. RESTRICT: 拒绝删除或者更新父表。指定RESTRICT（或者NO ACTION）和忽略ON DELETE或者ON UPDATE选项的效果是一样的。

```
-- 学生表
CREATE TABLE Student (
     Sno VARCHAR(9) PRIMARY KEY,
     Sname VARCHAR(20),
     Sage SMALLINT CHECK (VALUE>=0 AND VALUE<=100) ,
     Ssex VARCHAR(2),
     Sdept VARCHAR(20)
);

-- 课程表
CREATE TABLE Course (
     Cno VARCHAR(9) PRIMARY KEY,
     Cname VARCHAR(20),
     Cpno VARCHAR(4),
     Ccredit SMALLINT,
     FOREIGN KEY(Cpno) REFERENCES Course(Cno)
);

-- 学生选课表
CREATE TABLE SC (
     Sno VARCHAR(9),
     Cno VARCHAR(9),
     Grade SMALLINT,
     PRIMARY KEY(Sno,Cno),
     FOREIGN KEY(Cno) REFERENCES Course(Cno),
     FOREIGN KEY(Sno) REFERENCES Student(Sno)
);
```

删除：DROP TABLE 表名;

```
ALTER TABLE <表名>
[ ADD <新列名> <数据类型> [ 完整性约束 ] ]
[ DROP <完整性约束名> <列名>]
[ MODIFY <列名> <数据类型> ]；
[例4] 向Student表增加“入学时间”列，其数据类型为日期型。
  ALTER TABLE Student ADD Senroll DATE ;
```
注：不论基本表中原来是否已有数据，新增加的列一律为空值。

[例] 将年龄的数据类型改为半字长整数。
```
ALTER TABLE Student MODIFY Sage SMALLINT ;
```
注：修改原有的列定义有可能会破坏已有数据

[例] 删除学生姓名必须取唯一值的约束。
```
ALTER TABLE Student DROP UNIQUE(Sname) ;
```
删除外键
```
alter table course drop foreign key `course_ibfk_1`;
```

索引

* 单一索引(Unique Index)：每一个索引值只对应唯一的数据记录。相当于增加了一个UNIQUE约束，如果待索引项存在相同值则不能建立。
* 聚集索引(Cluster Index)：索引项顺序与表中数据记录的物理顺序一致。InnoDB引擎有聚集索引，如果声明了主键(primary key)，则这个列会被做为聚集索引，如果没有声明主键，则会用一个唯一且不为空的索引列做为主键，成为此表的聚集索引。前两个条件都不满足，InnoDB会自己产生一个虚拟的聚集索引。一个表只能有一个聚集索引

```
CREATE [UNIQUE] INDEX <索引名> ON   <表名>(<列名>[<次序>][,<列名>[<次序>] ]…) ;
```
索引可以建立在该表的一列或多列上，各列名之间用逗号分隔

1. <次序>：指定索引值的排列次序。升序：ASC，降序：DESC，缺省值：ASC
2. UNIQUE：表明此索引的每一个索引值只对应唯一的数据记录

删除：DROP INDEX 索引名 on 表名;

插入单个元组 —— 新元组插入指定表中。
```
INSERT
INTO <表名> [(<属性列1>[, <属性列2 >…)]
VALUES (<常量1> [, <常量2>] … ) ;
```
插入子查询结果
```
INSERT
INTO <表名> [(<属性列1> [, <属性列2>… )]
子查询 ;
```
1. 实体完整性：对于插入的记录，主码不为空且不可以与表中已有记录主码相同。
2. 参照完整性：外码必须取空值或被参照关系中对应属性的值。
3. 用户定义的完整性
    * 对于有NOT NULL约束的属性列是否提供了非空值
    * 对于有UNIQUE约束的属性列是否提供了非重复值
    * 对于有值域约束的属性列所提供的属性值是否在值域范围内

修改数据
```
UPDATE <表名>
SET <列名>=<表达式>[, <列名>=<表达式>]…
[WHERE <条件>] ;
```

删除数据
```
DELETE
FROM <表名>
[WHERE <条件>] ;
```

DBMS在执行插入、删除、修改语句时必须保证数据库的完整性和一致性。必须以事务处理的方式进行数据更新

完整性检查和保证例子：从帐户A向帐户B转帐100元，其处理方式分为两步：
1. 从帐户A减去100元；
2. 给帐户B加上100元。
要求这两步要么不作，要么全部执行。否则会引起数据库的不一致性。需要用事务处理程序实现这一转帐操作。

例：删除某一学生记录，必须删除该学生的选课记录。
    使用两条显式的删除语句，通过一种特殊的事务处理机制——触发器——来实现，当删除学生记录时由触发器程序先删除该学生的选课记录(参照关系)，再删除学生记录(被参照关系)。

查询：
```
SELECT [ ALL | DISTINCT ] <目标列表达式1>
[, <目标列表达式2>] …
FROM <表名或视图名1>[, <表名或视图名2> ] …
[ WHERE <条件表达式> ]
[ GROUP BY <列名1> [ HAVING <条件表达式> ] ]
[ ORDER BY <列名2> [ ASC | DESC ] ] ;
```
查询全体学生的姓名、出生年份和所在系，在“出生年份”前加入常数列“Year of Birth:”，用小写字母表示所有系名，并将输出字段依次更名为：NAME、BIRTH、BIRTHYEAR、DEPARTMENT。
```
SELECT Sname NAME, 'Year of Birth:' BIRTH,1996 - Sage BIRTHYEAR, lcase ( Sdept ) DEPARTMENT
FROM Student ;
```
查询选修了课程的学生学号。
```
SELECT DISTINCT Sno FROM SC ;
```
DISTINCT 短语的作用范围是所有目标列！
```
SELECT DISTINCT Cno, Grade FROM SC ;
```

where 子句常用查询条件

查询条件 | 谓  词
---      | ---
比    较 | `= , < , > , <= , >= , <> , != , !> , !<`; NOT + 上述比较符
确定范围 | BETWEEN … AND … ,包含边界 NOT BETWEEN … AND …
确定集合 | IN , NOT IN
字符匹配 | LIKE , NOT LIKE
空    值 | IS NULL , IS NOT NULL
多重条件 | AND , OR

注意
* between and 和 in不会提高查询效率，应该改用等价的多重条件查询
* between and包含边界

order by子句
* 升序：ASC；
* 降序：DESC；
缺省值为升序，空值当做最小值

* 通配符：% (百分号)：代表任意长度(可以为0)的字符串。
* _ (下横线)：代表任意单个字符。一个中文两个下划线

当要查询的字符串本身就含有 % 或 _ 时，要使用ESCAPE '<换码字符>' 短语对通配符进行转义。
```
SELECT Cno , Ccredit FROM Course WHERE Cname LIKE 'DB\_Design' ESCAPE '\' ;
```
转义符‘\’表示模板中出现在其后的第一个字符不再是通配符，而是字符本身。默认转义字符'\'

连接查询：

等值连接
```
SELECT Student.*, SC.*
FROM Student, SC
WHERE
Student.Sno = SC.Sno ;
```
去掉相等的一列student.sno或sc.sno就是自然连接

一个表与其自己进行连接，称为表的自身连接。需要给表起别名以示区别。由于所有属性名都是同名属性，因此必须使用别名前缀
内连接
```
select student.sno, sname, cno,grade from student [inner] join sc on student.sno = sc.sno;
```
左连接   内连接结果加上student的所有元组
```
select student.sno, sname, cno,grade from student left join sc on student.sno = sc.sno;
```
右连接   内连接结果加上sc的所有元组
```
select student.sno, sname, cno,grade from student right join sc on student.sno = sc.sno;
```
全连接   内连接结果加上student、sc的所有元组
```
select student.sno, sname, cno,grade from student full join sc on student.sno = sc.sno;
```

使用集函数(Aggregate Functions，聚集函数)

集函数只能用于 SELECT子句和 HAVING短语之中，而绝对不能出现在 WHERE子句中(WHERE子句执行过程是对记录逐一检验，并没有结果集，故无法施加集函数)。

(1) 计数
```
COUNT（[DISTINCT | ALL] *）
COUNT（[DISTINCT | ALL] <列名>）列如果为null不计入
```
(2) 计算总和
```
SUM（[DISTINCT | ALL] <列名>）
```
(3) 计算平均值
```
AVG（[DISTINCT | ALL] <列名>）
```
(4) 求最大值
```
MAX（[DISTINCT | ALL] <列名>）
```
(5) 求最小值
```
MIN（[DISTINCT | ALL] <列名>）
```

count函数对于列为空则不计入

客服表(id, name),客服-用户表(kefu_id, yonghu_id)，查每个客服对应用户数
```
select kefu.id, count(kf_yh.yonghu_id) cnt from kefu left join yonghu on kefu.id = kf_yh.kefu_id group by kefu.id order by cnt;
```

查询选修了课程的学生人数。
```
SELECT COUNT (DISTINCT Sno) FROM SC ;
```
注：用DISTINCT以避免重复计算学生人数

分组

分组方法：按指定的一列或多列分组，值相等为一组
* HAVING子句作用于且只能作用于各组之上
* GROUP BY子句的作用对象是查询的中间结果表
* 未对查询结果分组，集函数将作用于整个查询结果
* 对查询结果分组后，集函数将分别作用于每个组
* 使用GROUP BY子句后，SELECT子句的列名表中只能出现分组属性和集函数

嵌套查询
查询与“刘晨”在同一个系学习的学生。
```
SELECT  Sno, Sname, Sdept FROM  Student WHERE  Sdept  = ( SELECT  Sdept FROM  Student WHERE  Sname= '刘晨');
```
1. 先执行子查询，得到结果集{IS}
2. 再执行父查询WHERE Sdept IN {IS}

这种查询称为不相关子查询，即子查询的执行不依赖于父查询的条件。有的嵌套查询可以用连接查询替换，采用不相关子查询的效率要优于连接查询。

特别注意：子查询一定要跟在比较符之后！

谓词语义： (1) ANY ( SOME )：某些值；  (2) ALL：所有值

查询其他系中比信息系某些学生年龄小的学生姓名和年龄。
```
SELECT Sname, Sage FROM Student WHERE Sage < ANY (
SELECT Sage FROM Student WHERE Sdept = 'IS' ) AND Sdept <> 'IS' ; //这是父查询块中的条件
```
执行过程
1. 带有EXISTS谓词的子查询不返回任何数据，只产生逻辑真值“True”或逻辑假值“False” ；
2. 若内层查询结果非空，则返回真值
3. 若内层查询结果为空，则返回假值
4. 由EXISTS引出的子查询，其目标列表达式通常都用 * 。
5. 因为带EXISTS的子查询只返回真值或假值，给出列名无实际意义。

查询所有选修了c1号课程的学生姓名。
```
SELECT Sname FROM Student WHERE EXISTS
( SELECT * FROM SC  WHERE Sno = Student.Sno AND Cno = 'c1' ) ;
```
1. 首先取外层查询中表的第一个元组，根据它与内层查询相关的属性值处理内层查询，若WHERE子句返回值为真，则取此元组放入结果表；
2. 然后再取外层表的下一个元组，重复这一过程，直至外层表全部检查完为止。

此类查询称为相关子查询，即子查询的条件与父查询当前值相关。

查询选修了全部课程的学生姓名。
```
SELECT Sname FROM Student WHERE NOT EXISTS
( SELECT * FROM Course WHERE NOT EXISTS
( SELECT * FROM SC WHERE Sno = Student.Sno AND Cno = Course.Cno )) ;
```
查询至少选修学生95002所选全部课程的学生学号。
```
SELECT Sno FROM SC SCX WHERE NOT EXISTS
( SELECT * FROM SC SCY WHERE SCY.Sno = '95002' AND NOT EXISTS
( SELECT * FROM SC SCZ WHERE SCZ.Sno = SCX.Sno AND SCZ.Cno = SCY.Cno )) ;
```

集合查询

集合操作命令：
1. 并操作(UNION)
2. 交操作(INTERSECT)
3. 差操作(MINUS)

查询计算机科学系的学生及年龄不大于19岁的学生。
方法一：
```
SELECT *
FROM Student
WHERE Sdept = 'CS'
UNION
SELECT *
FROM Student
WHERE Sage <= 19 ;
```
方法二：
```
SELECT DISTINCT *
FROM Student
WHERE Sdept = 'CS' OR Sage <= 19 ;
```

查询选修了课程c1和c2的学生学号。
方法一：
```
SELECT Sno
FROM SC
WHERE Cno = 'c1'
INTERSECT
SELECT Sno
FROM SC
WHERE Cno = 'c2' ;
```
方法二：
```
SELECT DISTINCT SCX.Sno
FROM SC SCX, SC SCY
WHERE SCX.Sno = SCY.Sno AND
SCX.Cno = 'c1' AND SCY.Cno = 'c2' ;
```

查询计算机系年龄不大于19岁的学生学号。
方法一：
```
SELECT Sno
FROM Student
WHERE Sdept = 'CS' AND Sage <= 19 ;
```
方法二：
```
SELECT Sno
FROM Student
WHERE Stept = 'CS'
MINUS
SELECT Sno
FROM Student
WHERE Sage > '19' ;
```
查询效率：使用集合操作能更好地利用索引，效率高。

SQL性能优化

第一个原则：在WHERE子句中应把最具限制性的条件放在最前面

例：
(1)
```
SELECT *
FROM table1
WHERE  field1 <= 10000 AND field1 >= 0 ;
```
(2)
```
SELECT *
FROM table1
WHERE field1 >= 0 AND field1 <= 10000 ;
```
如果数据表中数据的 field1 值大部分都>=0，则语句(1) 要比语句(2) 效率高得多，因为语句(2)的第一个条件耗费了大量的系统资源。

第二个原则： WHERE子句中字段的顺序应和索引中字段顺序一致

例：
```
SELECT *
FROM tab
WHERE  a =… AND b =… AND c =… ;
```
若有索引INDEX(a,b,c)，则WHERE子句中字段的顺序应和索引中字段顺序一致。

什么是视图(View)？
* 视图是从一个或几个基本表（或视图）导出的表，它与基本表不同，是一个虚表。
* 在数据字典中只存放视图的定义，不会出现数据冗余。
* 基表中的数据发生变化，从视图中查询出的数据也随之改变。
* 视图一经定义，就可以和基本表一样被查询和删除，并且可以在视图之上再定义新的视图。
* 视图的更新(增加、删除、修改)操作会受到一定的限制。
* 视图对应三级模式体系结构中的外模式。

(1) 建立视图
```
CREATE VIEW <视图名> [(<列名> [，<列名>]…)]
AS <子查询>
[WITH CHECK OPTION] ;
```
注： CREATE VIEW 子句中的列名可以省略，但在下列情况下明确指定视图的所有列名：
1. 某个目标列是集函数或列表达式
2. 多表连接时选出了几个同名列作为视图的字段
3. 需要在视图中为某个列启用新的更合适的名字

* 子查询中的属性列不允许定义别名，不允许含有ORDER BY子句和DISTINCT短语。
* WITH CHECK OPTION表示对视图进行更新操作的数据必须满足视图定义的谓词条件(子查询的条件表达式)。
* DBMS执行CREATE VIEW语句时只是把视图的定义存入数据字典，并不执行其中的SELECT语句。在对视图查询时，按视图的定义从基本表中将数据查出。

[例] 建立信息系学生的视图，并要求透过该视图进行的更新操作只涉及信息系学生。
```
CREATE VIEW IS_Student AS
SELECT Sno, Sname, Sage FROM Student WHERE Sdept = 'IS'
WITH CHECK OPTION ;
```
针对此视图，当进行以下更新操作时，
* 修改操作：DBMS自动加上 Sdept=' IS' 的条件；
* 删除操作：DBMS自动加上 Sdept='IS' 的条件；
* 插入操作：DBMS自动检查Sdept属性值是否为'IS'，1) 如果不是，则拒绝该插入操作 2) 如果没有提供Sdept属性值，则自动定义Sdept为'IS'
[例] 将Student表中所有女生记录定义为一个视图。
```
CREATE VIEW F_Student1 (stdnum, name, sex, age, dept)
AS SELECT *
FROM Student
WHERE Ssex = '女' ;
```
存在问题：修改基表Student的结构后(在非末尾增加一列)，Student表与F_Student1视图的映象关系会被破坏，导致该视图不能正确工作。

处理方法：在子查询的SELECT子句中明确指出各属性列的名称，可以避免对基本表的属性列增加而破坏与视图间的映象关系，但不能解决修改列名的问题，因此上对基本表修改后采用重建视图的方法。

删除视图
```
DROP VIEW <视图名> ;
```
注：
* 该语句从数据字典中删除指定的视图定义
* 由该视图导出的其他视图定义仍在数据字典中，但已不能使用，必须显式删除
* 删除基表时，由该基表导出的所有视图定义都必须显式删除

* 视图实体化法：通过视图定义建立视图结构下的临时表并对临时表进行查询，在查询结束后删除临时表。
* 视图消解法：根据视图定义将对视图的查询转换为对基本表的查询

一些视图是不可更新的，因为对这些视图的更新不能唯一地有意义地转换成对相应基本表的更新(对两类方法均如此)。

学号及平均成绩的视图定义：
```
CREATE VIEW S_G (Sno, Gavg) AS
SELECT Sno, AVG (Grade)
FROM SC
GROUP BY Sno ;
```
对于如下更新语句：
```
UPDATE S_G
SET Gavg = 90
WHERE Sno = '95001' ;
```
注：无论实体化法还是消解法都无法将其转换成对基本表SC的更新。

可更新视图：从理论上讲，对其更新能够唯一转换为对应基本表更新的视图是可更新的。

允许更新的视图
* 实际使用的RDBMS系统对允许更新的视图有不同的规定，使用中以参考手册为依据；
* 对于行列子集视图，各RDBMS都允许更新。

授权 —— 将数据库中的某些对象的某些操作权限赋予某些用户
```
GRANT <权限>[,<权限>]...
[ON <对象类型> <对象名>]
TO <用户>[,<用户>]...
[WITH GRANT OPTION] ;
```
* DBA拥有数据库操作所有权限，他可以将权限赋予其他用户。
* 建立数据库对象的用户称为该对象的属主(OWNER)，他拥有该对象的所有操作权限。
* 接受权限的用户可以是一个或多个具体用户，也可以是全体用户(PUBLIC)。
* 指定了WITH GRANT OPTION子句,获得某种权限的用户还可以把这种权限再授予别的用户；没有指定WITH GRANT OPTION子句，获得某种权限的用户只能使用该权限，不能传播该权限。

对象   | 对象类型 | 操作权限
---    | ---      | ---
属性列 | TABLE    | SELECT, INSERT, UPDATE, DELETE, ALL PRIVILEGES
视  图 | TABLE    | SELECT, INSERT, UPDATE, DELETE, ALL PRIVILEGES
基本表 | TABLE    | SELECT, UPDATE, DELETE, ALTER, INDEX, ALL PRIVILEGES
数据库 | DATABASE | CREATETAB

[例] 把对Student表和Course表的全部权限授予用户U2和U3。
```
GRANT ALL PRIVILIGES
ON TABLE Student, Course
TO U2, U3 ;
```
[例] 把对表SC的查询权限授予所有用户。
```
GRANT SELECT
ON TABLE SC
TO PUBLIC ;
```
[例] 把查询Student表和修改学生学号的权限授给用户U4。
```
GRANT UPDATE ( Sno ), SELECT
ON TABLE Student
TO U4 ;
```

收回权限 —— 从指定用户那里收回对指定对象的指定权限。
```
REVOKE <权限>[,<权限>]...
[ON <对象类型> <对象名>]
FROM <用户>[,<用户>]... ;
```
[例] 把用户U5对SC表的INSERT权限收回。
```
REVOKE INSERT
ON TABLE SC
FROM U5 ;
```
系统将收回直接或间接从U5处获得的对SC表的INSERT权限:
→ U5 → U6 → U7

什么是游标(Cursor)?
* 游标是嵌入式SQL引入的机制
* 游标是SQL查询语句向宿主语言提供查询结果集的一段公共缓冲区
* 嵌入式SQL提供了逐条处理游标记录的功能，将当前记录各字段值推入主变量，并移动游标指针
* 游标解决了SQL语言只有记录处理能力的问题，将记录的各字段赋给主变量，交由宿主语言进行单值处理

使用游标的步骤：
1. 说明游标
2. 打开游标，把所有满足查询条件的记录从指定表取至缓冲区
3. 推进游标指针，并把当前记录从缓冲区中取出来送至主变量
4. 检查该记录是否需要处理（修改或删除），是则处理之
5. 重复第(3)和(4)步，用逐条取出结果集中的行进行判断和处理
6. 关闭游标，释放结果集占用的缓冲区和其他资源

使用游标(cursor)

1.声明游标
```
DECLARE cursor_name CURSOR FOR select_statement
```
这个语句声明一个游标。也可以在子程序中定义多个游标，但是一个块中的每一个游标必须有唯一的名字。声明游标后也是单条操作的，但是不能用SELECT语句不能有INTO子句。

2.游标OPEN语句
```
OPEN cursor_name
```
这个语句打开先前声明的游标。

3. 游标FETCH语句
```
FETCH cursor_name INTO var_name [, var_name] ...
```
这个语句用指定的打开游标读取下一行（如果有下一行的话），并且前进游标指针。

4. 游标CLOSE语句
```
CLOSE cursor_name
```
这个语句关闭先前打开的游标。

什么是存储过程？
* 存储过程(Stored Procedure) 是一组为了完成特定功能的SQL 语句集，经编译后存储在服务器端数据库中，用户通过指定存储过程的名字并给定参数(如果该存储过程带有参数)来执行它。

存储过程的优点
* 存储过程可以实现组件化管理
* 存储过程是实现特定功能的程序体，不同的应用程序都可以通过名称和参数调用存储过程，对存储过程的修改完善不会影响应用程序，提高系统的可移植性。
* 存储过程能够实现较快的执行速度
    因为存储过程是经过预编译和优化过的程序代码。
* 存储过程能够减少网络流量
    客户端程序通过名称和参数调用存储过程，而非传递整个SQL代码来执行操作。
* 存储过程可以实现数据的安全性
    存储过程的调用需要权限，且对数据的操作是被封装的，只提供调用接口。


创建和使用带In参数的MySQL存储过程

下面是一个命令行方式创建MySQL存过的例子，我们根据 department从employee表中获取一个总数，dept_id是department表的 外键。
```
mysql> DELIMITER //
mysql> CREATE PROCEDURE scount(in sex varchar(2))
> begin
> select count(*) as total from student where ssex = sex;
> end//
mysql> DELIMITER ;
```
首先我们改变默认的分隔符为“//”来作为存储过程结束的标识，随后再恢复默认值。使用“usp”前缀是区分系统存过过程和用户自定义存储过程的最佳实践。现在你可以在MySQL命令行像这样来调用存过：

```
mysql> call scount("f");
```

存储过程的参数有三种类型:

* IN: 输入参数. 在调用存储过程时指定, 默认未指定类型时则是此类型.
* OUT: 输出参数. 在存储过程里可以被改变, 并且可返回.
* INOUT: 输入输出参数. IN 和 OUT 结合

然后定义存储过程, 参数可有可无, 就和编码写函数一样, 定义几个参数, 调用时就写几个参数.然后以BEGIN开始, 以END结束. 里面是一系列的SQL语句, 并且还提供了结构控制语句, 比如 IF, WHILE, CASE等等, 可以完成复杂的操作.

1. 用户变量：以"@"开始，形式为"@变量名" set @a=1;
    用户变量跟mysql客户端是绑定的，设置的变量，只对当前用户使用的客户端生效
2. 全局变量：定义时，以如下两种形式出现，set GLOBAL 变量名  或者  set @@global.变量名
    对所有客户端生效。只有具有super权限才可以设置全局变量
3. 会话变量：只对连接的客户端有效。
4. 局部变量：作用范围在begin到end语句块之间。在该语句块里设置的变量。得放在begin之后。


declare与set

declare语句专门用于定义局部变量。set语句是设置不同类型的变量，包括会话变量和全局变量

DECLARE 声明局部变量:
```
DECLARE var_name,[var_name...] data_type DEFAULT default_value
```
如:
```
DECLARE a, b, c INT DEFAULT 5;
```
SET 对已声明的变量赋值或重新赋值. SELECT 显示变量; SELECT var into out_var 将变量值写入OUT参数

其它命令:

```
SHOW PROCEDURE STATUS 列出所有存储过程
SHOW CREATE PROCEDURE <sp_name> 查看一个已存在的存储过程的信息
```

什么是触发器?
* 触发器是一种特殊类型的存储过程。它与存储过程的区别：触发器主要是通过事件进行触发而被执行的，而存储过程可以通过存储过程名字被直接调用执行。
* 当对某一表进行诸如UPDATE、 INSERT、DELETE 这些操作时，SQL Server 就会自动执行触发器所定义的SQL 语句。
* 触发器的主要作用就是其能够实现由主键和外键所不能保证的复杂的参照完整性和数据的一致性。

触发器的功能
* 强化约束(Enforce restriction)
* 能够实现比CHECK 语句更为复杂的约束。
* 跟踪变化(Auditing changes)
    同时保留更新前后的数据。
* 级联运行(Cascaded operation)
    表Ａ的触发器程序更新表Ｂ数据，会引起表Ｂ触发器的执行。
* 存储过程的调用(Stored procedure invocation)
    通过调用存储过程实现其他操作，甚至可以调用扩展存储过程实现DBMS以外的功能。

触发器的种类
* 后触发器(AFTER TRIGGER)：在执行某一更新操作之后触发执行。后触发器只能定义在基本表上，可以对同一操作定义多个后触发器并设定触发次序。
* 前触发器(INSTEAD OF  TRIGGER)：在执行某一更新操作前触发执行，而不再执行该更新操作，即替代了指定的更新操作。前触发器可以定义在视图和表上，同一操作只能定义一个前触发器。使用前触发器可以实现分割视图(partitioned view)的更新。

触发器原理

在触发器的执行过程中，系统会自动建立和管理两个逻辑表：插入表(inserted)和删除表(deleted)。这两个表与触发器所对应的基本表有着完全相同的结构，但为只读表，驻留于内存之中，直到触发器执行完毕，系统会自动删除。这两个表是事务回滚的重要依据。
* 使用INSERT命令时，新插入到表中的记录同时也会由系统自动存储在inserted表中。
* 使用DELETE命令时，被删除的记录存放于deleted表中。
* UPDATE命令可以解释为先DELETE掉原来的记录，再INSERT新的记录，即把修改前的记录存入deleted表中，修改后的记录存入inserted表中。

```
CREATE TRIGGER <触发器名称>
{ BEFORE | AFTER }
{ INSERT | UPDATE | DELETE }
ON <表名称>
FOR EACH ROW
BEGIN
<触发器SQL语句>
END
```

其中，触发器名参数指要创建的触发器的名字。BEFORE和AFTER参数指定了触发执行的时间，在事件之前或是之后。FOR EACH ROW表示任何一条记录上的操作满足触发事件都会触发该触发器。触发器包含所要触发的SQL语句：这里的语句可以是任何合法的语句， 包括复合语句，但是这里的语句受的限制和函数的一样。

```
mysql> DELIMITER //
mysql> CREATE TRIGGER trig BEFORE DELETE
    -> ON student FOR EACH ROW
    -> BEGIN
    -> DELETE FROM sc WHERE old.sno = sc.sno;
    -> END
    -> //
mysql> DELIMITER ;
```

MySQL 输出时的\G

有时使用SHOW输出一些信息表格时, 限制于屏幕的宽度, 表格会比较混乱. 加上\G后显示效果如:
```
show triggers\G;
```

什么是事务?
事务(Transaction)是用户定义的一个数据库操作序列，这些操作要么全做，要么全不做，是一个不可分割的工作单位

事务和程序是两个概念
* 在关系数据库中，一个事务可以是一条SQL语句，一组SQL语句或整个程序
* 一个应用程序通常包含多个事务
* 事务是恢复和并发控制的基本单位

myisam不支持事务，innodb支持事务

mysql使用事务的关键字

* begin 或 start transaction //打开一个事务。
* commit //提交到数据库。
* rollback 或 rollback to [savepoint] //取消操作。
* savepoint //保存，部分取消，部分提交。
* alter table person type=INNODB //修改数据引擎。

例子，修改成绩
```
begin;
update sc set grade=94 where sno="1235";
savepoint s1;
update sc set grade=90 where sno="1224";
select * from sc;
rollback to savepoint s1;
select * from sc;
commit;
```

事务的特性
* 原子性（Atomicity）
    事务中包括的诸操作要么都做，要么都不做。
* 一致性（Consistency）
    事务执行的结果必须是使数据库从一个一致性状态变到另一个一致性状态。
* 隔离性（Isolation）
    一个事务的执行不能被其他事务干扰，而影响它对数据的正确使用和修改。
* 持久性 (Durability)
    一个事务一旦提交，它对数据库中数据的改变就应该是永久性的，接下来的其他操作或故障不应该对其执行结果有任何影响。

* 第一类更新丢失
    丢失修改是指事务1与事务2从数据库中读入同一数据并修改，事务2的提交结果破坏了事务1提交的结果，导致事务1的修改被丢失。
* 读脏数据
    事务1修改某一数据，并将其写回磁盘，事务2读取同一数据后，事务1由于某种原因被撤消。这时事务1已修改过的数据恢复原值，事务2读到的数据就与数据库中的数据不一致，是不正确的数据，又称为“脏”数据。
* 不可重复读
    事务1读取某一数据后：
    * 事务2对其做了修改，当事务1再次读该数据时，得到与前一次不同的值。
    * 事务2删除了其中部分记录，当事务1再次读取数据时，发现某些记录神密地消失了。
* 幻读
    事务1读取某一数据后，事务2插入了一些记录，当事务1再次按相同条件读取数据时，发现多了一些记录。

一般应用中推荐使用一次封锁法，就是在方法的开始阶段，已经预先知道会用到哪些数据，然后全部锁住，在方法运行之后，再全部解锁。这种方式可以有效的避免循环死锁，但在数据库中却不适用，因为在事务开始阶段，数据库并不知道会用到哪些数据。

数据库遵循的是两段锁协议，将事务分成两个阶段，加锁阶段和解锁阶段（所以叫两段锁）

1. 加锁阶段：在该阶段可以进行加锁操作。在对任何数据进行读操作之前要申请并获得S锁（共享锁，其它事务可以继续加共享锁，但不能加排它锁），在进行写操作之前要申请并获得X锁（排它锁，其它事务不能再获得任何锁）。加锁不成功，则事务进入等待状态，直到加锁成功才继续执行。
2. 解锁阶段：当事务释放了一个封锁以后，事务进入解锁阶段，在该阶段只能进行解锁操作不能再进行加锁操作。

两段锁保证可串行化，可能会死锁，可以通过判断超时来检测

1. 排它锁（eXclusive lock，简记为X锁，又称为写锁）
      若事务T对数据对象A加上X锁，则只允许T读取和修改A，其它任何事务都不能再对A加任何类型的锁，直到T释放A上的锁。
2. 共享锁（Share lock，简记为S锁，又称为读锁）
      若事务T对数据对象A加上S锁，则其它事务只能再对A加S锁，而不能加X锁，直到T释放A上的S锁

隔离级别

1. Read Uncommitted
    - 一个事务读的时候允许其他事务操作，写的时候其他事物只能读不能写
    - 允许一个事务读取到未提交的数据，即 Read Uncommitted
    - 解决了丢失修改问题，但不能解决读脏数据和不可重复读问题
2. Read Committed
    - 一个事务读的时候允许其他事务操作，修改的时候不允许任何其它事务读写
    - 事务只能读取到提交了的数据，即Read Committed
    - 解决了丢失修改、读脏数据问题，但不能解决不可重复读问题
3. Repeatable Read
    - 一个事务读取的时候其他事务不可修改（允许读），写事务的时候禁止其他任何事务
    - 解决了丢失修改、读脏数据、不可重复读问题，但可能出现读幻影现象
4. Serializable
    - 事务可串行化执行
    - 使用表级锁，解决读幻影现象

隔离级别 \ 不一致性          | 丢失修改 | 脏读数据 | 不可重复读 | 幻读
---                          | ---      | ---      | ---        | ---
读未提交（Read uncommitted） | 不可能   | 可能     | 可能       | 可能
读已提交（Read committed）   | 不可能   | 不可能   | 可能       | 可能
可重复读（Repeatable read）  | 不可能   | 不可能   | 不可能     | 可能
可串行化（Serializable ）    | 不可能   | 不可能   | 不可能     | 不可能

事件(Event), 可以定义一些任务调度.

首先需要开启事件调度的支持:
```
SET GLOBAL event_scheduler = 1;
```
创建语法:
```
CREATE EVENT [IF NOT EXISTS] <event_name>
ON SCHEDULE <schedule>
DO
<event_body>;
```

其它命令:
```
SHOW EVENTS 列出所有事件
SHOW CREATE EVENT <event_name> 查看一个已存在的事件的信息
```

例子  使用事件, 每半小时调用存储过程, 存储过程是一个WHILE循环, 一直删除2个小时之前的数据, 每次删除1000条.
```
-- 定义存储过程
DELIMITER //
DROP PROCEDURE IF EXISTS usp_del_user;
CREATE PROCEDURE usp_del_user(IN expire_interval INT, IN delete_per_count INT)
-- expire_interval: the unit is hour
-- delete_per_count: specify the count do every delete operation
BEGIN
    WHILE EXISTS (select 1 from users where ts < DATE_SUB(NOW(), INTERVAL expire_interval HOUR)) DO
        delete from users order by ts limit delete_per_count;
    END WHILE;
END //
DELIMITER ;

-- 定义事件, 调用存储过程
DROP EVENT IF EXISTS del_user;
CREATE EVENT del_user
ON SCHEDULE EVERY 30 MINUTE
DO
CALL usp_del_user(2, 1000)
```
