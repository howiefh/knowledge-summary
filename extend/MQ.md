## 为什么用消息队列

**存在问题**

1. 系统直接接口耦合比较严重。 订单不应该因为积分、返利、营销等业务需求频繁更改代码、报文
2. 面对大流量并发时，容易被拖垮。
3. 等待同步存在性能问题。

**MQ作用**

1. 解耦。要做到系统解耦，当新的模块接进来时，可以做到代码改动最小；
2. 消峰。设置流量缓冲池，可以让后端系统按照自身吞吐能力进行消费；
3. 异步。强弱依赖梳理能将非关键调用链路的操作异步化并提升整体系统的吞吐能力；

## 通信

ActiveMQ的有两种消息模型：一是点对点，二是发布/订阅模式。点对点在ActiveMQ中的具体实现就是Queue，发布/订阅则是Topic。

在点对点的消息传递域中，目的地被称为队列（queue）
在发布订阅消息传递域中，目的地被称为主题（topic）

 比较项目   | Topic模式队列                                                                                                          | Queue模式队列
---         | ---                                                                                                                    | ---
 工作模式   | 订阅\-发布模式； 如果当前没有订阅者，消息将会别丢弃； 如果有多个订阅者，那么所有订阅者都会受到消息。                   | 负载均衡模式。如果当前没有消费者，消息也不会丢弃。如果有多个消费者，那么一条消息也只会发送给一个消费者，并且要求消费者ack信息。
 有无状态   | 无状态                                                                                                                 | Queue数据默认会在MQ服务器上以文件的形式保存，ActiveMQ一般会保存在$AMQ\_HOME/data/kr\-store/data下面，也可以配置成DB存储。
 传递完整性 | 如果没有订阅者，消息会被丢弃。                                                                                         | 消息不会被丢弃。
 处理效率   | 由于消息要按照订阅者的数量进行复制，所有处理性能会随着订阅者的增加而明显降低，并且还要结合不同消息协议自身的性能差异。 | 由于一条消息只发送给一个消费者，所以就算消费者再多，性能也不会有明显降低，当然不同消息协议的具体性能也是有差异的。

## JMS

1. Java EE 是一套使用Java进行企业级应用开发的大家一致遵循的13个核心规范工业标准。

    1. JDBC
    2. JNDI
    3. EJB
    4. RMI
    5. Java IDL
    6. JSP
    7. Servlet
    8. XML
    9. JMS 两个应用程序之间进行异步通信的API。
    10. JTA
    11. JTS
    12. JavaMail
    13. JAF

2. 落地消息中间件对比

特性              | ActiveMQ                       | RabbitMQ                           | RocketMQ                                                               | Kafka
---               | ---                            | ---                                | ---                                                                    | ---
PRODUCER-COMSUMER | 支持                           | 支持                               | 支持                                                                   | 支持
PUBLISH-SUBSCRIBE | 支持                           | 支持                               | 支持                                                                   | 支持
REQUEST-REPLY     | 支持                           | 支持                               | 支持                                                                   | -
API完备性         | 高                             | 高                                 | 高                                                                     | 高
开发语言          | Java                           | Erlang                             | Java                                                                   | Scala & Java
多语言支持        | 支持，JAVA优先                 | 语言无关                           | 只支持JAVA                                                             | 支持，JAVA优先
单机呑吐里        | 万级                           | 万级                               | 十万级                                                                 | 十万级
消息延迟          | -                              | 微秒级                             | 毫秒级                                                                 | 毫秒级
可用性            | 高（主从）                     | 高（主从）                         | 非常高（分布式）                                                       | 非常高（分布式）
消息丢尖          | 低                             | 低                                 | 理论上不会丢失                                                         | 理论上不会丢失
消息重复          | -                              | 可控制                             | -                                                                      | 理论上会有重夏
文挡的完备性      | 高                             | 高                                 | 高                                                                     | 高
提供快速入门      | 有                             | 有                                 | 有                                                                     | 有
首次部署难度      | -                              | 低                                 | -                                                                      | 中
社区活跃度        | 高                             | 高                                 | 中                                                                     | 高
商业支持          | 无                             | 无                                 | 阿里云                                                                 | 无
成熟度            | 成熟                           | 成熟                               | 比较成熟                                                               | 成熟曰志领域
特点              | 功能齐全，被大量开源项目使用   | 由于Erlang语言的并发能力，性能很好 | 各个环节分布式扩展设计，主从HA；支持上万个队列；多种消费模式；性能很好 |
支持协议          | OpenWires,STOMP,REST.XMPP.AMQP | AMQP                               | 自己定义的一套(社区提供JMS不成熟）                                     | 自有协议，社区封装了HTTP协议支持
持久化            | 内存、文件、数据库             | 内存、文件                         | 磁盘文件                                                               | 磁盘文件
事务              | 支持                           | 不支持                             | 支持                                                                   | 不支持，但可以通过low level api保证只消费一次
负栽均籥          | 支持                           | 支持                               | 支持                                                                   | 支持
管理羿面          | 一般                           | 好                                 | 有web console实现                                                      | 官方只提供了命令行，Yahoo有开源管理端
部署方式          | 抽立, 嵌入                     | 抽立                               | 抽立                                                                   | 独立
评价 | 优点：成熟的产品，已经在很多公司得到应用（非大规棋场杲〉。有较多的文档。各种协议支持较好，有多重语言的成熟的客户端； 缺点：根提其他用户反读，会出莫名其妙的问题，会丢消息。其重心放到activemq6产 品一apollo上去了，目前社区不活妖，且对5.x 维护较少；Activemq不适含用于上千个队列的应用场杲。| 优点：由于erlang语言的特性，mq性能较好；管埋界面较丰富，在互联网公司也有较大规模的应用；支持amqp 协议，有多中语言且支持 amqp的客户端可用；缺点：erlang语言难度较大。集群不支持动态扩展。| 优点：横型简单，接口易用（JMS接口很多场合并不太实用〉。在阿里大规棋应用。目前支付宝中的余额宝等新兴产品均使用rocketmq 。集群规模大槪在50台左右，单曰处理消息上百亿；性能非常好，可以大量堆积消息在 broker中；支持多种消费，包括集群消赛、广播消费等。开发度较活妖，版本更新很快。缺点：产品较新文档比较缺乏。没有在mq核心中去实现JMS接口，对已有系统而言不能兼容。阿里内部还有一套未开源的MQAPI，这一层API可以将上层应用和下层MQ实现解耦 (阿里内部有多个实现，如 notify、 metaq1.c，metaq2.x，rocketmq等），使得下面mq可以很方便的进行切換和升级而对应用无任何影响，自前这—套东西未开源


3. JMS的组成和特点

    1. JMS privider 实现JMS接口与规范的消息中间件，也就是我们的MQ服务器
    2. JMS producer 消息生产者，创建与发送JMS消息的客户端应用
    3. JMS consumer 消息的消费者，接受与处理JMS消息的客户端应用
        消费方式
        1. 同步消费：通过调用消费者的receive方法从目的地中显示提取消息，receive方法可以一直阻塞到消息到达
        2. 异步消费：客户可以为消费者注册一个消息监听器，以定义在消息到达时所采取的动作

    4. JMS message
        * 消息头
            * JMSDesination 消息发送的目的地，主要是指Queue与Topic
            * JMSDeliveryMode 持久、非持久模式。非持久模式机器故障消息丢失
            * JMSExpiration 消息过期时间，为0 永不过期。
            * JMSPriority 优先级，0～9十个级别，0～4是普通消息，5～9是加急消息。默认4
            * JMSMessageID 唯一识别每个消息的表示，由MQ产生
        * 消息体
            1. StreamMessage java原始值的数据流
            2. MapMessage 一套名称-值对
            3. TextMessage 一个字符串对象
            4. ObjectMessage 一个序列化的java对象
            5. ByteMessage 一个未解释字节的数据流
        * 消息属性
            如果需要使用消息头以外的值，那么可以使用消息属性///一种加强型的api
            识别/去重/重点标注等操作非常有用的方法

4. 可靠性
    1. 持久化
        1. 持久化消息，即将消息存储在文件系统或数据库，MQ服务宕机后重启，消息不会丢失。`producer.setDeliveryMode(DeliveryMode.PERSISTENT);`可以设置持久化消息，默认就是持久化的。
        2. 消息订阅者为持久订阅时，客户端向activemq broker注册一个自己身份的ID，当这个客户端处于离线时，broker会为这个ID 保存所有发送到主题的消息，当客户再次连接到broker时，会根据自己的ID得到所有当自己处于离线时发送到主题的消息。
            1. 为连接connection设置一个客户 ID，如果ID以前已经被占用了，将会抛出异常。
            `connection.setClientID(CLIENT_ID); //持久化订阅要设置`
            2. 为订阅的主题指定一个订阅名称，连接ID和订阅名两者组合必须唯一，否则按两个订阅者算.`MessageConsumer consumer = session.createDurableSubscriber(topic, SUBSCRIBER_NAME); //持久订阅需要以这种方式创建订阅者`
            必须先在MQ服务注册，否则注册前发送的消息无法被消费。

    2. 事务
        `Session session = connection.createSession(true, Session.AUTO_ACKNOWLEDGE);`创建session时通过第一个参数开启事务，开启事务一定要通过`session.commit()`提交事务。否则生产者不提交，消息不会入队，消费者也不会收到；消费者不提交，MQ服务会认为还没有被消费，消费端会收到重复消息。
    3. 签收
        `Session session = connection.createSession(true, Session.AUTO_ACKNOWLEDGE);`第二个参数即签收方式。
        1. 自动签收（默认）：Session.AUTO_ACKNOWLEDGE
        2. 手动签收：Session.CLIENT_ACKNOWLEDGE。客户端调用message 的 acknowledge方法手动签收。
        3. 允许重复消息：Session.DUPS_OK_ACKNOWLEDGE

        在事务性会话中，当一个事务被成功提交则消息被自动签收。如果事务回滚，则消息会被再次传送
        非事务会话中，消息何时被确认取决于创建会话时的应答模式（acknowledgement）
    4. 集群

5. 传输协议
    1. Transmission Control Protocol (TCP)
        1. 这是默认的Broker配置，TCP的Client监听端口是61616。
        2. 在网络传输数据前，必须要序列化数据，消息是通过一个叫wire protocol的来序列化成字节流。默认情况下，ActiveMQ把wire protocol叫做OpenWire，它的目的是促使网络上的效率和数据快速交互。
        3. TCP连接的URI形式：tcp://hostname:port?key=value&key=value，加粗部分是必须的
        4. TCP传输的优点：
            * TCP协议传输可靠性高，稳定性强
            * 高效性：字节流方式传递，效率很高
            * 有效性、可用性：应用广泛，支持任何平台
        5. 所有关于Transport协议的可配置参数，可以参见： http://activemq.apache.org/configuring-version-5-transports.html
    2. New I/O API Protocol（NIO）
        1. NIO协议和TCP协议类似，但NIO更侧重于底层的访问操作。它允许开发人员对同一资源可有更多的client调用和服务端有更多的负载。
        2. 适合使用NIO协议的场景：
            * 可能有大量的Client去链接到Broker上一般情况下，大量的Client去链接Broker是被操作系统的线程数所限制的。因此，NIO的实现比TCP需要更少的线程去运行，所以建议使用NIO协议
            * 可能对于Broker有一个很迟钝的网络传输NIO比TCP提供更好的性能
        3. NIO连接的URI形式：nio://hostname:port?key=value
        4. Transport Connector配置示例：http://activemq.apache.org/configuring-version-5-transports.html
    3. User Datagram Protocol（UDP)
        1. UDP和TCP的区别
            * TCP是一个原始流的传递协议，意味着数据包是有保证的，换句话说，数据包是不会被复制和丢失的。UDP，另一方面，它是不会保证数据包的传递的
            * TCP也是一个稳定可靠的数据包传递协议，意味着数据在传递的过程中不会被丢失。这样确保了在发送和接收之间能够可靠的传递。相反，UDP仅仅是一个链接协议，所以它没有可靠性之说
        2. 从上面可以得出：TCP是被用在稳定可靠的场景中使用的；UDP通常用在快速数据传递和不怕数据丢失的场景中，还有ActiveMQ通过防火墙时，只能用UDP
        3. UDP连接的URI形式：udp://hostname:port?key=value
    4. Secure Sockets Layer Protocol (SSL)
        1. 连接的URI形式：ssl://hostname:port?key=value
    5. Hypertext Transfer Protocol (HTTP/HTTPS)
        1. 像web和email等服务需要通过防火墙来访问的，Http可以使用这种场合
        2. 连接的URI形式：http://hostname:port?key=value或者https://hostname:port?key=value
    6. VM Protocol（VM）
        1. VM transport允许在VM内部通信，从而避免了网络传输的开销。这时候采用的连 接不是socket连接，而是直接的方法调用。
        2. 第一个创建VM连接的客户会启动一个embed VM broker，接下来所有使用相同的 broker name的VM连接都会使用这个broker。当这个broker上所有的连接都关闭 的时候，这个broker也会自动关闭。
        3. 连接的URI形式：vm://brokerName?key=value
        4. Java中嵌入的方式： vm:broker:(tcp://localhost:6000)?brokerName=embeddedbroker&persistent=fal se ， 定义了一个嵌入的broker名称为embededbroker以及配置了一个 tcptransprotconnector在监听端口6000上
        5. 使用一个加载一个配置文件来启动broker vm://localhost?brokerConfig=xbean:activemq.xml
    7. Advanced Message Queuing Protocol（AMQP） 一个提供统一消息服务的应用层高级消息队列协议，是应用层协议的一个开放标准，为面向消息的中间件设计。可以不受语言限制。
    8. Streaming Text Orientated Message Protocol（STOPMP） 是流文本定向消息协议。一种为面向消息的中间件设计的简单文本协议。
    9. Message Queuing Telemetry Transport （MQTT） IBM开发的一个即使通讯协议。有可能成为物联网的重要组成部分。支持所有平台。

    那么我们怎么即让这个端口支持NIO网络io模型，又让它支持多个协议呢？
    使用auto关键字 使用“+”符号来为端口设置多种特性。如果我们即需要某一个端口支持NIO网络io模型，又需要它支持多种协议
    ```
    <transportConnectors>
      <!-- DOS protection, limit concurrent connections to 1000 and frame size to 100MB -->
      <transportConnector name="auto+nio" uri="auto+nio://0.0.0.0:61618?maximumConnections=1000&amp;wireFormat.maxFrameSize=104857600"/>
    </transportConnectors>
    ```

6. 消息存储和持久化

    ActiveMQ 支持的持久化机制有JDBC、KahaDB、LevelDB、AMQ。发送者将消息发送后，消息中心先将消息存储在本地数据文件、本地数据库或者远程数据库再试图将消息发送给接受者。成功则将消息删除，失败则尝试重新发送。消息中心启动后首先要检查指定的存储位置，如果有未发送成功的消息，则需要把消息发送出去。

    mq服务和存储一般不应该在同一个机器。

    1. AMQ（不推荐）
        一种文件存储形式。写入快、已恢复。文件默认大小32M。当一个文件中当消息已经全部被消费，那么这个文件标记为可删除，在下一个清除阶段，这个文件被删除。ActiveMQ 5.3前使用AMQ。
    2. KahaDB（默认）
        从ActiveMQ 5.4 开始默认的持久化插件。提供了性能和恢复能力。消息存储使用一个事务文件和仅仅用一个索引文件来存储它所有的地址。
        db-[number].log 存储消息到预定义大小的数据记录文件中，当数据文件已满时，一个新的文件会随之创建，number数值也会随之递增，它随着消息数量增多。当不再引用到文件中的任何消息时，文件被删除或归档。
        db.data BTree索引。
        db.free 标记db.data文件里那个页面是空闲的。存储所有空闲页的id。
        db.redo 用来进行消息恢复。强制退出后启动，用于恢复BTree索引。
        lock 文件锁，表示当前获得读写权限的broker
    3. LevelDB（不推荐）
        ActiveMQ 5.8 后引入，和KahaDB相似，也是基于文件的本地数据库存储形式，但是它提供更快的持久性。不实用BTree实现索引预写日志，而是使用基于LevelDB的索引。
    4. JDBC
      `<persistenceAdapter> <jdbcPersistenceAdapter dataSource="#mysql-ds"/> </persistenceAdapter>`
      mysql-ds 是mysql 数据源的 spring bean id。
      有三张表 `ACTIVEMQ_MSGS`（queue topic消息），`ACTIVEMQ_ACKS`（topic订阅端），`ACTIVEMQ_LOCK`
    5. JDBC Message store with ActiveMQ Journal 使用高速缓存写入技术，大大提高了性能，克服了 JDBC Store 的不足，JDBC每次消息过来，都需要去写库和读库。

7. 高级特性
    1. 保证高可用性
        ZooKeeper + Replicated LevelDB Store
        这种主备方式是ActiveMQ5.9以后才新增的特性，使用ZooKeeper协调选择一个node作为master。被选择的master broker node开启并接受客户端连接。
        其他node转入slave模式，连接master并同步他们的存储状态。slave不接受客户端连接。所有的存储操作都将被复制到连接至Master的slaves。
        如果master死了，得到了最新更新的slave被允许成为master。fialed node能够重新加入到网络中并连接master进入slave mode。所有需要同步的disk的消息操作都将等待存储状态被复制到其他法定节点的操作完成才能完成。所以，如果你配置了replicas=3，那么法定大小是(3/2)+1=2. Master将会存储并更新然后等待 (2-1)=1个slave存储和更新完成，才汇报success。至于为什么是2-1，熟悉Zookeeper的应该知道，有一个node要作为观擦者存在。
        单一个新的master被选中，你需要至少保障一个法定node在线以能够找到拥有最新状态的node。这个node将会成为新的master。因此，推荐运行至少3个replica nodes，以防止一个node失败了，服务中断。
        配置也简单，首先选择3台服务器，修改配置文件activemq.xml（位于/usr/local/apache-activemq-5.13.4/conf），将每个配置文件的brokerName设置成相同的名称，接着配置replicatedLevelDB的zkAddress和hostname即可
    2. 异步投递
        同步发送时，Producer.send() 方法会被阻塞，直到 broker 发送一个确认消息给生产者，这个确认消息暗示生产者 broker 已经成功地将它发送的消息路由到目标目的并把消息保存到二级存储中。
        在默认大多数情况下，AcitveMQ 是以异步模式发送消息。例外的情况：在没有使用事务的情况下，生产者以PERSISTENT 传送模式发送消息。在这种情况下，send 方法都是同步的，并且一直阻塞直到ActiveMQ 发回确认消息：消息已经存储在持久性数据存储中。这种确认机制保证消息不会丢失，但会造成生产者阻塞从而影响反应时间。高性能的程序一般都能容忍在故障情况下丢失少量数据。如果编写这样的程序，可以通过使用异步发送来提高吞吐量
        对于一个slow consumer ，使用同步发送消息可能出现producer堵塞等情况，慢消费者适合使用异步发送
        三种方式开启异步投递 `tcp://localshot:61616?jms.useAsyncSend=true`，`connectionFactory.setUseAsyncSend(true)`，`connection.setUseAsyncSend(true)`
        异步发送丢失消息的场景，需要回调确认发送成功。producer.send有带上AsyncCallback的方法。该方法中需要重写onSuccess方法和onException方法。onSuccess方法就是表示这条消息成功发送到MQ上，并接收到了MQ持久化后的回调。onException表示MQ返回一个入队异常的回执。
    3. 延时投递和定时投递
        xml 配置中开启 broker 的 schedulerSupport 属性为 true
        ```
        message.setLongProperty(ScheduledMessage.AMQ_SCHEDULED_DELAY, time);
	    message.setLongProperty(ScheduledMessage.AMQ_SCHEDULED_PERIOD, period);
	    message.setIntProperty(ScheduledMessage.AMQ_SCHEDULED_REPEAT, repeat);
        ```
        Property name          | type   | description
        ------------------------|--------|-------------
        `AMQ_SCHEDULED_DELAY`  | long   | 延迟投递的时间
        `AMQ_SCHEDULED_PERIOD` | long   | 重复投递的时间间隔
        `AMQ_SCHEDULED_REPEAT` | int    | 重复投递次数
        `AMQ_SCHEDULED_CRON`   | String | Cron表达式
    4. 重试机制
        activeMQ会在什么情况下重新发送消息？
        1. 在使用事务的Session中，调用rollback()方法；
        2. 在使用事务的Session中，调用commit()方法之前就关闭了Session;
        3. 在Session中使用CLIENT_ACKNOWLEDGE签收模式，并且调用了recover()方法。
        配置项 通过RedeliveryPolicy可以配置，也可以通过链接url
        collisionAvoidanceFactor 默认值 0.15 设置防止冲突范围的正负百分比，只有启用useCollisionAvoidance参数时才生效。
        maximumRedeliveries 默认值：6 最大重传次数。 达到最大重连次数后抛出异常。为-1时不限制次数，为0时表示不进行重传。
        maximumRedeliveryDelay 默认值 -1 最大传送延迟，只在useExponentialBackOff为true时有效（V5.5），假设首次重连间隔为10ms，倍数为2，那么第二次重连时间间隔为 20ms，第三次重连时间间隔为40ms，当重连时间间隔大的最大重连时间间隔时，以后每次重连时间间隔都为最大重连时间间隔。
        initialRedeliveryDelay 默认值 1000L 初始重发延迟时间
        redeliveryDelay 默认值：1000L 重发延迟时间，当initialRedeliveryDelay=0时生效（v5.4）
        useCollisionAvoidance 默认值 false 启用防止冲突功能，因为消息接收时是可以使用多线程并发处理的，应该是为了重发的安全性，避开所有并发线程都在同一个时间点进行消息接收处理。所有线程在同一个时间点处理时会发生什么问题呢？应该没有问题，只是为了平衡broker处理性能，不会有时很忙，有时很空闲。
        useExponentialBackOff 默认值 false 启用指数倍数递增的方式增加延迟时间。
        backOffMultiplier 默认值 5 重连时间间隔递增倍数，只有值大于1和启用useExponentialBackOff参数时才生效。
        有毒消息
        当一个消息被接收的次数超过maximumRedeliveries(默认为6次)次数时，会给broker发送一个`poison_ack`，这种ack类型告诉broker这个消息“有毒”，尝试多次依然失败，这时broker会将这个消息发送到DLQ，以便后续处理。activeMQ默认的死信队列是ActiveMQ.DLQ，如果没有特别指定，死信消息都会被发送到这个队列。
        默认情况下持久消息过期都会被送到DLQ，非持久消息过期默认不会送到DLQ。
        可以通过配置文件为指定队列创建死信队列。
    5. 死信队列
        将所有的DeadLetter保存在一个共享的队列中，这是activemq broker默认策略。可以通过 `deadLetterQueue` 属性设定
        通过 processExpired 属性可以指定是否将过期消息放入死信队列，默认true。
        通过 processNonPersistent 可以指定是否将非持久化的消息放入死信队列，默认false
    6. 防止重复调用
        网络延迟传输中，会造成消息重复消费。

        1. 数据库唯一主键
        2. 将消费过的消息id存入redis

