## 存储引擎

```
show engines;
```

1. MyISAM InnoDB

对比项 | MyISAM                                                   | InnoDB
---    | ---                                                      | ---
主外键 | 不支持                                                   | 支持
事务   | 不支持                                                   | 支持
行表锁 | 表锁，即使操作一条记录也会锁着整个表，不适合高并发的操作 | 行锁，操作时只锁一行，适合高并发
表空间 | 小                                                       | 大
关注点 | 性能                                                     | 事务

Percona 公司提供 xtradb 引擎

alisql aliredis

## 索引

1. 性能下降SQL慢 执行时间长 等待时间长

    1. 查询语句写的烂
    2. 索引失效 （单值 复合）
    3. 关联查询太多join（设计缺陷或不得已的需求）
    4. 服务器调优及各个参数设置（缓冲、线程数等）

2. 索引是什么

帮助MySQL高效获取数据的数据结构。

3. 优缺点

    1. 优点 提高检索效率；降低数据排序成本
    2. 缺点 占空间；写操作需要更新索引；

4. Explain 能干什么

    1. 每张表有多少行被优化器查询
    2. 表之间的引用
    3. 哪些索引被实际使用
    4. 哪些索引可以使用
    5. 数据读取操作的操作类型
    6. 表的读取顺序

5. Explain 怎么用

    1. id
        * select查询的序列号，包含一组数字，表示查询中执行select子句或操作表的顺序
        * 三种情况
            1. id相同，执行顺序由上至下
            2. id不同，如果是子查询，id的序号会递增，id值越大优先级越高，越先被执行
            3. id相同不同，同时存在
    2. select_type
        查询的类型，主要用于区别 普通查询、联合查询、子查询等的复杂查询
        1. SIMPLE 简单的select查询，查询中不包含子查询或者UNION
        2. PRIMARY 查询中若包含任何复杂的子部分，最外层查询则被标记为
        3. SUBQUERY 在SELECT或者WHERE列表中包含了子查询
        4. DERIVED 在FROM列表中包含的子查询被标记为DERIVED（衍生） MySQL会递归执行这些子查询，把结果放在临时表里。
        5. UNION 若第二个SELECT出现在UNION之后，则被标记为UNION; 若UNION包含在FROM子句的子查询中，外层SELECT将被标记为：DERIVED
        6. UNION RESULT 从UNION表获取结果的SELECT
    3. table
        显示这一行的数据是关于哪张表的
    4. type
        显示查询使用了何种类型 从最好到最差依次是： `system>const>eq_ref>ref>range>index>ALL` 一般来说，得保证查询只是达到range级别，最好达到ref
        1. system 表只有一行记录（等于系统表），这是const类型的特例，平时不会出现，这个也可以忽略不计
        2. const 表示通过索引一次就找到了，const用于比较primary key或者unique索引。因为只匹配一行数据，所以很快。如将主键至于where列表中，MySQL就能将该查询转换为一个常量
        3. eq_ref 唯一性索引，对于每个索引键，表中只有一条记录与之匹配，常见于主键或唯一索引扫描
        4. ref 非唯一索引扫描，返回匹配某个单独值的所有行。本质上也是一种索引访问，它返回所有匹配某个单独值的行，然而，它可能会找到多个符合条件的行，所以他应该属于查找和扫描的混合体
        5. range 只检索给定范围的行，使用一个索引来选择行。key列显示使用了哪个索引
一般就是在你的where语句中出现了between、`<`、`>`、in等的查询 这种范围扫描索引扫描比全表扫描要好，因为他只需要开始索引的某一点，而结束语另一点，不用扫描全部索引
        6. index Full Index Scan,index与ALL区别为index类型只遍历索引树。这通常比ALL快，因为索引文件通常比数据文件小。（也就是说虽然all和index都是读全表，但index是从索引中读取的，而all是从硬盘中读的）
        7. all FullTable Scan,将遍历全表以找到匹配的行
    5. possible_keys
        显示可能应用在这张表中的索引,一个或多个。查询涉及的字段上若存在索引，则该索引将被列出，但不一定被查询实际使用
    6. key
        实际使用的索引。如果为null则没有使用索引 查询中若使用了覆盖索引，则索引和查询的select字段重叠
    7. key_len
        * 表示索引中使用的字节数，可通过该列计算查询中使用的索引的长度。在不损失精确性的情况下，长度越短越好
        * key_len显示的值为索引最大可能长度，并非实际使用长度，即key_len是根据表定义计算而得，不是通过表内检索出的
    8. ref
        显示索引那一列被使用了，如果可能的话，是一个常数。那些列或常量被用于查找索引列上的值
    9. rows
        根据表统计信息及索引选用情况，大致估算出找到所需的记录所需要读取的行数
    10. extra
        包含不适合在其他列中显示但十分重要的额外信息 Using filesort Using temporary  出现比较糟糕；using index 出现是比较好的说明覆盖索引
        1. Using filesort 说明mysql会对数据使用一个外部的索引排序，而不是按照表内的索引顺序进行读取。 MySQL中无法利用索引完成排序操作成为“文件排序”
        2. Using temporary 使用了临时表保存中间结果，MySQL在对查询结果排序时使用临时表。常见于排序order by 和分组查询 group by
        3. USING index
            * 表示相应的select操作中使用了覆盖索引（Coveing Index）,避免访问了表的数据行，效率不错！ 如果同时出现using where，表明索引被用来执行索引键值的查找； 如果没有同时出现using where，表明索引用来读取数据而非执行查找动作。
            * 覆盖索引（Covering Index）
        4. Using where 表面使用了where过滤
        5. using join buffer 使用了连接缓存
        6. impossible where where子句的值总是false，不能用来获取任何元组
        7. select tables optimized away 在没有GROUPBY子句的情况下，基于索引优化MIN/MAX操作或者 对于MyISAM存储引擎优化COUNT(*)操作，不必等到执行阶段再进行计算， 查询执行计划生成的阶段即完成优化。
        8. distinct 优化distinct，在找到第一匹配的元组后即停止找同样值的工作

6. 覆盖索引

理解方式一：就是select的数据列只用从索引中就能取到，不必读取数据行，MySQl可以利用索引返回select列表中的字段，而不必根据索引再次读取数据文件，换句话说查询列要被所见的索引覆盖

理解方式二：索引是高效找到行的一个方法，但是一般数据库也能使用索引找到一个列的数据，因此它不必读取整个行，毕竟索引叶子节点存储列它们索引的数据；当能通过读取索引就可以得到想要的数据，那就不需要读取行列。一个索引包含了（或覆盖了）满足查询结果的数据就是覆盖索引。

7. join 语句优化

    * 尽可能减少join语句中的NestedLoop的循环次数：“永远小结果集驱动大的结果集”
    * 优先优化Nestedloop的内层循环
    * 保证join语句中被驱动表上join条件字段已经被索引
    * 当无法保证被驱动表的join条件字段被索引且内存资源充足的前提下，不要太吝惜JoinBuffer的设置

8. 索引失效

    1. 全值匹配我最爱
    2. 最佳左前缀法则 如果索引了多例，要遵守最左前缀法则。指的是查询从索引的最左前列开始并且不跳过索引中的列。
    3. 不在索引列上做任何操作（计算、函数、（自动or手动）类型转换），会导致索引失效而转向全表扫描
    4. 存储引擎不能使用索引中范围条件右边的列
    5. 尽量使用覆盖索引（只访问索引的查询（索引列和查询列一致）），减少select*
    6. mysql在使用不等于（`!=`或者`<>`）的时候无法使用索引会导致全表扫描
    7. is null,is not null 也无法使用索引
    8. like以通配符开头（'$abc...'）mysql索引失效会变成全表扫描操作 问题：解决like'%字符串%'索引不被使用的方法？使用覆盖索引可以使all变成index类型查询
    9. 字符串不加单引号索引失效
    10. 少用or,用它连接时会索引失效

9. order by group by

    * 定值、范围还是排序，一般order by是给个范围
    * group by 基本上都需要进行排序，会有临时表产生

10. 一般建议

    1. 对于单键索引，尽量选择针对当前query过滤性更好的索引
    2. 在选择组合索引的时候，当前Query中过滤性最好的字段在索引字段顺序中，位置越靠前越好。
    3. 在选择组合索引的时候，尽量选择可以能包含当前query中的where子句中更多字段的索引
    4. 尽可能通过分析统计信息和调整query的写法来达到选择合适索引的目的

## 查询截取分析

1. 查询优化
    1. 慢查询的开启并捕获
    2. explain + 慢查询分析
    3. show profile 查询SQL在MySQL服务器里面的执行细节和生命周期情况
    4. SQL数据库服务器的参数调优

2. 永远小表驱动大表 类似嵌套循环Nested Loop

```
select * from A where id in (select id from B);
```

当B表的数据集小雨A表的数据集时，用in由于exists。

```
select * from A where exists (select 1 from B where B.id = A.id);
```

当A表的数据集小于B表的数据集时，用exists优于in。

3. ORDER BY 优化

    * ORDER BY子句，尽量使用Index方式排序，避免使用FileSort方式排序
        MySQL支持二种方式的排序，FileSort和Index,Index效率高。 它指MySQL扫描索引本身完成排序。FileSort方式效率较低。
        ORDER BY满足两情况，会使用Index方式排序
        1. ORDER BY语句使用索引最左前列
        2. 使用where子句与OrderBy子句条件列组合满足索引最左前列
    * 尽可能在索引列上完成排序操作，遵照索引建的最佳左前缀
    * order by 升序降序不一致 可能不能使用index
    * 如果不在索引列上，filesort有两种算法： mysql就要启动双路排序和单路排序
        1. 双路排序
            MySQL4.1之前是使用双路排序，字面意思是两次扫描磁盘，最终得到数据。
读取行指针和orderby列，对他们进行排序，然后扫描已经排序好的列表，按照列表中的值重新从列表中读取对应的数据传输
            从磁盘取排序字段，在buffer进行排序，再从磁盘取其他字段。
            取一批数据，要对磁盘进行两次扫描，众所周知，I\O是很耗时的，所以在mysql4.1之后，出现了第二张改进的算法，就是单路排序。
        2. 单路排序
            从磁盘读取查询需要的所有列，按照orderby列在buffer对它们进行排序，然后扫描排序后的列表进行输出， 它的效率更快一些，避免了第二次读取数据，并且把随机IO变成顺序IO，但是它会使用更多的空间， 因为它把每一行都保存在内存中了。
            由于单路是后出来的，总体而言好过双路
            但是用单路有问题，单路排序可能导致多次IO。 在sort_buffer中，方法B比方法A要占用很多空间，因为方法B是把所有字段都取出，所以有可能取出的数据总大小超出了sort_buffer的容量，导致每次只能取sort_buffer容量大小的数据，进行排序（创建tmp文件，多路合并），排完再取sort_buffer容量大小，再排。。。从而多次IO。
    * 优化策略
        1. 增大sort_buffer_size参数的设置
        2. 增大max_length_for_sort_data参数的设置

4. GROUP BY 优化

groupby实质是先排序后进行分组，遵照索引建的最佳左前缀

当无法使用索引列，增大max_length_for_sort_data参数的设置+增大sort_buffer_size参数的设置

where高于having,能写在where限定的条件就不要去having限定了。

5. 慢查询日志

    1. 开启慢查询日志
        ```
        SHOW VARIABLES LIKE '%slow_query_log%';
        ```
        slow_query_log 默认是关闭
        ```
        set global slow_query_log = 1
        ```
    2. 查看当前多少秒算慢
        ```
        SHOW VARIABLES LIKE 'long_query_time%';
        ```
        设置慢的阙值时间 `set global long_query_time=3;`
        需要重新连接或者新开一个回话才能看到修改值。`SHOW VARIABLES LIKE 'long_query_time%';`
    3. 慢查询日志路径 `SHOW VARIABLES LIKE '%slow_query_log_file%';`
    `show global status like '%Slow_queries';` 查询慢查询数。
    4. 日志分析工具mysqldumpshow
        查看mysqldumpshow的帮助信息
        1. s:是表示按何种方式排序
        2. c:访问次数
        3. l:锁定时间
        4. r:返回记录
        5. t:查询时间
        6. al:平均锁定时间
        7. ar:平均返回记录数
        8. at:平均查询时间
        9. t:即为返回前面多少条的数据
        10. g:后边搭配一个正则匹配模式，大小写不敏感的

6. show profiles

    * 是什么：是mysql提供可以用来分析当前会话中语句执行的资源消耗情况。可以用于SQL的调优测量
    * 官网：http://dev.mysql.com/doc/refman/5.5/en/show-profile.html
    * 默认情况下，参数处于关闭状态，并保存最近15次的运行结果 `show variables like 'profiling';` 查看；`set profiling = 1;` 开启
    * 怎么用
        1. 执行SQL
        2. 执行`show profiles;`查看结果
        3. 诊断SQL，show profile cpu,block io for query 上一步前面的问题SQL 数字号码；
        4. 日常开发需要注意的结论
            * converting HEAP to MyISAM 查询结果太大，内存都不够用了往磁盘上搬了。
            * Creating tmp table 创建临时表 （拷贝数据到临时表；用完再删除）
            * Copying to tmp table on disk 把内存中临时表复制到磁盘，危险！！！
            * locked

## 锁

1. 查看myisam 表上加过的锁

show open tables;

2. 表锁定

show status like 'table%'

3. 分析行锁定

show status like 'innodb_row_lock%';

4. 优化建议

    1. 尽可能让所有数据检索都通过索引来完成，避免无索引行锁升级为表锁
    2. 合理设计索引，尽量缩小锁的范围
    3. 尽可能较少检索条件，避免间隙锁
    4. 尽量控制事务大小，减少锁定资源量和时间长度
    5. 尽可能低级别事务隔离
