# 设计模式

## 设计模式简介

<style>
td {
  background-color: #ffffff;
}
</style>

<TABLE cellspacing=1 cellpadding=3 WIDTH=94% BGCOLOR=GRAY ALIGN=CENTER>
  <TR>
    <TD>
    </TD>
    <TD>
      创建型
    </TD>
    <TD>
      结构型
    </TD>
    <TD>
      行为型
    </TD>
  </TR>
  <TR>
    <TD>
      类
    </TD>
    <TD VBGCOLOR=GRAY ALIGN=TOP>
      <A HREF=#FactoryMethod>
        Factory Method
      </A>
    </TD>
    <TD VBGCOLOR=GRAY ALIGN=TOP>
      <A HREF=#Adapter_Class>
        Adapter_Class
      </A>
    </TD>
    <TD VBGCOLOR=GRAY ALIGN=TOP>
      <A HREF=#Interpreter>
        Interpreter
      </A>
      <BR/>
      <A HREF=#TemplateMethod>
        Template Method
      </A>
    </TD>
  </TR>
  <TR>
    <TD>
      对象
    </TD>
    <TD VBGCOLOR=GRAY ALIGN=TOP>
      <A HREF=#AbstractFactory>
        Abstract Factory
      </A>
      <BR/>
      <A HREF=#Builder>
        Builder
      </A>
      <BR/>
      <A HREF=#Prototype>
        Prototype
      </A>
      <BR/>
      <A HREF=#Singleton>
        Singleton
      </A>
    </TD>
    <TD VBGCOLOR=GRAY ALIGN=TOP>
      <A HREF=#Adapter_Object>
        Adapter_Object
      </A>
      <BR/>
      <A HREF=#Bridge>
        Bridge
      </A>
      <BR/>
      <A HREF=#Composite>
        Composite
      </A>
      <BR/>
      <A HREF=#Decorator>
        Decorator
      </A>
      <BR/>
      <A HREF=#Facade>
        Facade
      </A>
      <BR/>
      <A HREF=#Flyweight>
        Flyweight
      </A>
      <BR/>
      <A HREF=#Proxy>
        Proxy
      </A>
    </TD>
    <TD VBGCOLOR=GRAY ALIGN=TOP>
      <A HREF=#ChainofResponsibility>
        Chain of Responsibility
      </A>
      <BR/>
      <A HREF=#Command>
        Command
      </A>
      <BR/>
      <A HREF=#Iterator>
        Iterator
      </A>
      <BR/>
      <A HREF=#Mediator>
        Mediator
      </A>
      <BR/>
      <A HREF=#Memento>
        Memento
      </A>
      <BR/>
      <A HREF=#Observer>
        Observer
      </A>
      <BR/>
      <A HREF=#State>
        State
      </A>
      <BR/>
      <A HREF=#Strategy>
        Strategy
      </A>
      <BR/>
      <A HREF=#Visitor>
        Visitor
      </A>
    </TD>
  </TR>
  <TR>
    <TD>
      概览
    </TD>
    <TD COLSPAN=3>
      <A NAME=OverView>
        <IMG SRC=../images/design_patterns/OverView.gif TITLE="OverView" USEMAP="#OverView" BORDER=0 />
      </A>
      <MAP NAME=OverView>
        <AREA SHAPE="RECT" COORDS="399,495,512,524" HREF=#FactoryMethod>
          <AREA SHAPE="RECT" COORDS="398,25,461,54" HREF=#Adapter_Class>
            <AREA SHAPE="RECT" COORDS="194,303,267,328" HREF=#Interpreter>
              <AREA SHAPE="RECT" COORDS="206,448,316,475" HREF=#TemplateMethod>
                <AREA SHAPE="RECT" COORDS="134,544,243,570" HREF=#AbstractFactory>
                  <AREA SHAPE="RECT" COORDS="38,39,100,65" HREF=#Builder>
                    <AREA SHAPE="RECT" COORDS="50,485,125,511" HREF=#Prototype>
                      <AREA SHAPE="RECT" COORDS="25,616,99,641" HREF=#Singleton>
                        <AREA SHAPE="RECT" COORDS="398,25,461,54" HREF=#Adapter_Object>
                          <AREA SHAPE="RECT" COORDS="496,75,543,100" HREF=#Bridge>
                            <AREA SHAPE="RECT" COORDS="182,170,254,197" HREF=#Composite>
                              <AREA SHAPE="RECT" COORDS="2,197,74,222" HREF=#Decorator>
                                <AREA SHAPE="RECT" COORDS="291,580,353,607" HREF=#Facade>
                                  <AREA SHAPE="RECT" COORDS="110,243,183,270" HREF=#Flyweight>
                                    <AREA SHAPE="RECT" COORDS="483,4,532,28" HREF=#Proxy>
                                      <AREA SHAPE="RECT" COORDS="411,305,544,330" HREF=#ChainofResponsibility>
                                        <AREA SHAPE="RECT" COORDS="469,147,545,173" HREF=#Command>
                                          <AREA SHAPE="RECT" COORDS="205,75,267,100" HREF=#Iterator>
                                            <AREA SHAPE="RECT" COORDS="254,363,327,388" HREF=#Mediator>
                                              <AREA SHAPE="RECT" COORDS="254,2,329,27" HREF=#Memento>
                                                <AREA SHAPE="RECT" COORDS="471,388,544,414" HREF=#Observer>
                                                  <AREA SHAPE="RECT" COORDS="134,411,182,436" HREF=#State>
                                                    <AREA SHAPE="RECT" COORDS="15,352,86,377" HREF=#Strategy>
                                                      <AREA SHAPE="RECT" COORDS="326,244,388,268" HREF=#Visitor>
      </MAP>
    </TD>
  </TR>
</TABLE>
<A NAME=FactoryMethod>
</A>
<BR/>
<BR/>
<TABLE cellspacing=1 cellpadding=10 WIDTH=94% BGCOLOR=GRAY ALIGN=CENTER>
  <TR>
    <TD>
      名称
    </TD>
    <TD>
      <B>
        Factory Method
      </B>
    </TD>
  </TR>
  <TR>
    <TD>
      结构
    </TD>
    <TD>
      <IMG SRC=../images/design_patterns/FactoryMethod.gif Title="Factory Method" />
    </TD>
  </TR>
  <TR>
    <TD>
      意图
    </TD>
    <TD>
      定义一个用于创建对象的接口，让子类决定实例化哪一个类。Factory Method 使一个类的实例化延迟到其子类。
    </TD>
  </TR>
  <TR>
    <TD>
      适用性
    </TD>
    <TD>
      <UL>
        <LI>
          当一个类不知道它所必须创建的对象的类的时候。
        </LI>
        <LI>
          当一个类希望由它的子类来指定它所创建的对象的时候。
        </LI>
        <LI>
          当类将创建对象的职责委托给多个帮助子类中的某一个，并且你希望将哪一个帮助子类是代理者这一信息局部化的时候。
        </LI>
      </UL>
    </TD>
  </TR>
  <TR>
    <TD>
      Code Example
    </TD>
    <TD>
      <ul>
        <li><a href="http://docs.oracle.com/javase/6/docs/api/java/util/Calendar.html#getInstance%28%29"><code>java.util.Calendar#getInstance()</code></a></li>
        <li><a href="http://docs.oracle.com/javase/6/docs/api/java/util/ResourceBundle.html#getBundle%28java.lang.String%29"><code>java.util.ResourceBundle#getBundle()</code></a></li>
        <li><a href="http://docs.oracle.com/javase/6/docs/api/java/text/NumberFormat.html#getInstance%28%29"><code>java.text.NumberFormat#getInstance()</code></a></li>
        <li><a href="http://docs.oracle.com/javase/6/docs/api/java/nio/charset/Charset.html#forName%28java.lang.String%29"><code>java.nio.charset.Charset#forName()</code></a></li>
        <li><a href="http://docs.oracle.com/javase/6/docs/api/java/net/URLStreamHandlerFactory.html"><code>java.net.URLStreamHandlerFactory#createURLStreamHandler(String)</code></a> (为每种协议返回单例对象)</li>
      </ul>
    </TD>
  </TR>
</TABLE>
<A NAME=AbstractFactory>
</A>
<BR/>
<BR/>
<TABLE cellspacing=1 cellpadding=10 WIDTH=94% BGCOLOR=GRAY ALIGN=CENTER>
  <TR>
    <TD>
      名称
    </TD>
    <TD>
      <B>
        Abstract Factory
      </B>
    </TD>
  </TR>
  <TR>
    <TD>
      结构
    </TD>
    <TD>
      <IMG SRC=../images/design_patterns/AbstractFactory.gif Title="Abstract Factory" />
    </TD>
  </TR>
  <TR>
    <TD>
      意图
    </TD>
    <TD>
      提供一个创建一系列相关或相互依赖对象的接口，而无需指定它们具体的类。
    </TD>
  </TR>
  <TR>
    <TD>
      适用性
    </TD>
    <TD>
      <UL>
        <LI>
          一个系统要独立于它的产品的创建、组合和表示时。
        </LI>
        <LI>
          一个系统要由多个产品系列中的一个来配置时。
        </LI>
        <LI>
          当你要强调一系列相关的产品对象的设计以便进行联合使用时。
        </LI>
        <LI>
          当你提供一个产品类库，而只想显示它们的接口而不是实现时。
        </LI>
      </UL>
    </TD>
  </TR>
  <TR>
    <TD>
      Code Example
    </TD>
    <TD>
      <ul>
        <li><a href="http://docs.oracle.com/javase/6/docs/api/javax/xml/parsers/DocumentBuilderFactory.html#newInstance%28%29"><code>javax.xml.parsers.DocumentBuilderFactory#newInstance()</code></a></li>
        <li><a href="http://docs.oracle.com/javase/6/docs/api/javax/xml/transform/TransformerFactory.html#newInstance%28%29"><code>javax.xml.transform.TransformerFactory#newInstance()</code></a></li>
        <li><a href="http://docs.oracle.com/javase/6/docs/api/javax/xml/xpath/XPathFactory.html#newInstance%28%29"><code>javax.xml.xpath.XPathFactory#newInstance()</code></a></li>
      </ul>
    </TD>
  </TR>
</TABLE>
<A NAME=Builder>
</A>
<BR/>
<BR/>
<TABLE cellspacing=1 cellpadding=10 WIDTH=94% BGCOLOR=GRAY ALIGN=CENTER>
  <TR>
    <TD>
      名称
    </TD>
    <TD>
      <B>
        Builder
      </B>
    </TD>
  </TR>
  <TR>
    <TD>
      结构
    </TD>
    <TD>
      <IMG SRC=../images/design_patterns/Builder.gif Title="Builder" />
    </TD>
  </TR>
  <TR>
    <TD>
      意图
    </TD>
    <TD>
      将一个复杂对象的构建与它的表示分离，使得同样的构建过程可以创建不同的表示。
    </TD>
  </TR>
  <TR>
    <TD>
      适用性
    </TD>
    <TD>
      <UL>
        <LI>
          当创建复杂对象的算法应该独立于该对象的组成部分以及它们的装配方式时。
        </LI>
        <LI>
          当构造过程必须允许被构造的对象有不同的表示时。
        </LI>
      </UL>
    </TD>
  </TR>
  <TR>
    <TD>
      Code Example
    </TD>
    <TD>
      <ul>
        <li><a href="http://docs.oracle.com/javase/6/docs/api/java/lang/StringBuilder.html#append%28boolean%29"><code>java.lang.StringBuilder#append()</code></a> (unsynchronized)</li>
        <li><a href="http://docs.oracle.com/javase/6/docs/api/java/lang/StringBuffer.html#append%28boolean%29"><code>java.lang.StringBuffer#append()</code></a> (synchronized)</li>
        <li><a href="http://docs.oracle.com/javase/6/docs/api/java/nio/ByteBuffer.html#put%28byte%29"><code>java.nio.ByteBuffer#put()</code></a> (<a href="http://docs.oracle.com/javase/6/docs/api/java/nio/CharBuffer.html#put%28char%29"><code>CharBuffer</code></a>, <a href="http://docs.oracle.com/javase/6/docs/api/java/nio/ShortBuffer.html#put%28short%29"><code>ShortBuffer</code></a>, <a href="http://docs.oracle.com/javase/6/docs/api/java/nio/IntBuffer.html#put%28int%29"><code>IntBuffer</code></a>, <a href="http://docs.oracle.com/javase/6/docs/api/java/nio/LongBuffer.html#put%28long%29"><code>LongBuffer</code></a>, <a href="http://docs.oracle.com/javase/6/docs/api/java/nio/FloatBuffer.html#put%28float%29"><code>FloatBuffer</code></a> 和 <a href="http://docs.oracle.com/javase/6/docs/api/java/nio/DoubleBuffer.html#put%28double%29"><code>DoubleBuffer</code></a> 也一样)</li>
        <li><a href="http://docs.oracle.com/javase/6/docs/api/javax/swing/GroupLayout.Group.html#addComponent%28java.awt.Component%29"><code>javax.swing.GroupLayout.Group#addComponent()</code></a></li>
        <li>所有 <a href="http://docs.oracle.com/javase/6/docs/api/java/lang/Appendable.html"><code>java.lang.Appendable</code></a> 的实现</li>
      </ul>
    </TD>
  </TR>
</TABLE>
<A NAME=Prototype>
</A>
<BR/>
<BR/>
<TABLE cellspacing=1 cellpadding=10 WIDTH=94% BGCOLOR=GRAY ALIGN=CENTER>
  <TR>
    <TD>
      名称
    </TD>
    <TD>
      <B>
        Prototype
      </B>
    </TD>
  </TR>
  <TR>
    <TD>
      结构
    </TD>
    <TD>
      <IMG SRC=../images/design_patterns/Prototype.gif Title="Prototype" />
    </TD>
  </TR>
  <TR>
    <TD>
      意图
    </TD>
    <TD>
      用原型实例指定创建对象的种类，并且通过拷贝这些原型创建新的对象。
    </TD>
  </TR>
  <TR>
    <TD>
      适用性
    </TD>
    <TD>
      <UL>
        <LI>
          当要实例化的类是在运行时刻指定时，例如，通过动态装载；或者
        </LI>
        <LI>
          为了避免创建一个与产品类层次平行的工厂类层次时；或者
        </LI>
        <LI>
          当一个类的实例只能有几个不同状态组合中的一种时。建立相应数目的原型并克隆它们可能比每次用合适的状态手工实例化该类更方便一些。
        </LI>
      </UL>
    </TD>
  </TR>
  <TR>
    <TD>
      Code Example
    </TD>
    <TD>
      <ul>
        <li><a href="http://docs.oracle.com/javase/6/docs/api/java/lang/Object.html#clone%28%29"><code>java.lang.Object#clone()</code></a> (类必须实现 <a href="http://docs.oracle.com/javase/6/docs/api/java/lang/Cloneable.html"><code>java.lang.Cloneable</code></a> 接口)</li>
      </ul>
    </TD>
  </TR>
</TABLE>
<A NAME=Singleton>
</A>
<BR/>
<BR/>
<TABLE cellspacing=1 cellpadding=10 WIDTH=94% BGCOLOR=GRAY ALIGN=CENTER>
  <TR>
    <TD>
      名称
    </TD>
    <TD>
      <B>
        Singleton
      </B>
    </TD>
  </TR>
  <TR>
    <TD>
      结构
    </TD>
    <TD>
      <IMG SRC=../images/design_patterns/Singleton.gif Title="Singleton" />
    </TD>
  </TR>
  <TR>
    <TD>
      意图
    </TD>
    <TD>
      保证一个类仅有一个实例，并提供一个访问它的全局访问点。
    </TD>
  </TR>
  <TR>
    <TD>
      适用性
    </TD>
    <TD>
      <UL>
        <LI>
          当类只能有一个实例而且客户可以从一个众所周知的访问点访问它时。
        </LI>
        <LI>
          当这个唯一实例应该是通过子类化可扩展的，并且客户应该无需更改代码就能使用一个扩展的实例时。
        </LI>
      </UL>
    </TD>
  </TR>
  <TR>
    <TD>
      Code Example
    </TD>
    <TD>
      <ul>
        <li><a href="http://docs.oracle.com/javase/6/docs/api/java/lang/Runtime.html#getRuntime%28%29"><code>java.lang.Runtime#getRuntime()</code></a></li>
        <li><a href="http://docs.oracle.com/javase/6/docs/api/java/awt/Desktop.html#getDesktop%28%29"><code>java.awt.Desktop#getDesktop()</code></a></li>
        <li><a href="http://docs.oracle.com/javase/6/docs/api/java/lang/System.html#getSecurityManager%28%29"><code>java.lang.System#getSecurityManager()</code></a></li>
      </ul>
    </TD>
  </TR>
</TABLE>
<A NAME=Adapter_Object>
</A>
<A NAME=Adapter_Class>
</A>
<BR/>
<BR/>
<TABLE cellspacing=1 cellpadding=10 WIDTH=94% BGCOLOR=GRAY ALIGN=CENTER>
  <TR>
    <TD>
      名称
    </TD>
    <TD>
      <B>
        Adapter
      </B>
    </TD>
  </TR>
  <TR>
    <TD>
      结构
    </TD>
    <TD>
      <IMG SRC=../images/design_patterns/Adapter_Object.gif Title="Adapter_Object" />
      </A>
      <BR/>
      <BR/>
      <IMG SRC=../images/design_patterns/Adapter_Class.gif Title="Adapter_Class" />
      </A>
    </TD>
  </TR>
  <TR>
    <TD>
      意图
    </TD>
    <TD>
      将一个类的接口转换成客户希望的另外一个接口。Adapter 模式使得原本由于接口不兼容而不能一起工作的那些类可以一起工作。
    </TD>
  </TR>
  <TR>
    <TD>
      适用性
    </TD>
    <TD>
      <UL>
        <LI>
          你想使用一个已经存在的类，而它的接口不符合你的需求。
        </LI>
        <LI>
          你想创建一个可以复用的类，该类可以与其他不相关的类或不可预见的类（即那些接口可能不一定兼容的类）协同工作。
        </LI>
        <LI>
          （仅适用于对象Adapter ）你想使用一些已经存在的子类，但是不可能对每一个都进行子类化以匹配它们的接口。对象适配器可以适配它的父类接口。
        </LI>
      </UL>
    </TD>
  </TR>
  <TR>
    <TD>
      Code Example
    </TD>
    <TD>
      <ul>
        <li><a href="http://docs.oracle.com/javase/6/docs/api/java/util/Arrays.html#asList%28T...%29"><code>java.util.Arrays#asList()</code></a></li>
        <li><a href="http://docs.oracle.com/javase/6/docs/api/java/io/InputStreamReader.html#InputStreamReader%28java.io.InputStream%29"><code>java.io.InputStreamReader(InputStream)</code></a> (返回 <code>Reader</code>)</li>
        <li><a href="http://docs.oracle.com/javase/6/docs/api/java/io/OutputStreamWriter.html#OutputStreamWriter%28java.io.OutputStream%29"><code>java.io.OutputStreamWriter(OutputStream)</code></a> (返回 <code>Writer</code>)</li>
        <li><a href="http://docs.oracle.com/javase/6/docs/api/javax/xml/bind/annotation/adapters/XmlAdapter.html#marshal%28BoundType%29"><code>javax.xml.bind.annotation.adapters.XmlAdapter#marshal()</code></a> 和 <a href="http://docs.oracle.com/javase/6/docs/api/javax/xml/bind/annotation/adapters/XmlAdapter.html#unmarshal%28ValueType%29"><code>#unmarshal()</code></a></li>
      </ul>
    </TD>
  </TR>
</TABLE>
<A NAME=Bridge>
</A>
<BR/>
<BR/>
<TABLE cellspacing=1 cellpadding=10 WIDTH=94% BGCOLOR=GRAY ALIGN=CENTER>
  <TR>
    <TD>
      名称
    </TD>
    <TD>
      <B>
        Bridge
      </B>
    </TD>
  </TR>
  <TR>
    <TD>
      结构
    </TD>
    <TD>
      <IMG SRC=../images/design_patterns/Bridge.gif Title="Bridge" />
    </TD>
  </TR>
  <TR>
    <TD>
      意图
    </TD>
    <TD>
      将抽象部分与它的实现部分分离，使它们都可以独立地变化。
    </TD>
  </TR>
  <TR>
    <TD>
      适用性
    </TD>
    <TD>
      <UL>
        <LI>
          你不希望在抽象和它的实现部分之间有一个固定的绑定关系。例如这种情况可能是因为，在程序运行时刻实现部分应可以被选择或者切换。
        </LI>
        <LI>
          类的抽象以及它的实现都应该可以通过生成子类的方法加以扩充。这时Bridge 模式使你可以对不同的抽象接口和实现部分进行组合，并分别对它们进行扩充。
        </LI>
        <LI>
          对一个抽象的实现部分的修改应对客户不产生影响，即客户的代码不必重新编译。
        </LI>
        <LI>
          （C++）你想对客户完全隐藏抽象的实现部分。在C++中，类的表示在类接口中是可见的。
        </LI>
        <LI>
          有许多类要生成。这样一种类层次结构说明你必须将一个对象分解成两个部分。Rumbaugh 称这种类层次结构为“嵌套的普化”（nested
          generalizations ）。
        </LI>
        <LI>
          你想在多个对象间共享实现（可能使用引用计数），但同时要求客户并不知道这一点。一个简单的例子便是Coplien 的String 类[Cop92]，在这个类中多个对象可以共享同一个字符串表示（StringRep）。
        </LI>
      </UL>
    </TD>
  </TR>
  <TR>
    <TD>
      Code Example
    </TD>
    <TD>
      <ul>
        <li>AWT (提供了抽象层映射于实际的操作系统)</li>
        <li>JDBC</li>
      </ul>
    </TD>
  </TR>
</TABLE>
<A NAME=Composite>
</A>
<BR/>
<BR/>
<TABLE cellspacing=1 cellpadding=10 WIDTH=94% BGCOLOR=GRAY ALIGN=CENTER>
  <TR>
    <TD>
      名称
    </TD>
    <TD>
      <B>
        Composite
      </B>
    </TD>
  </TR>
  <TR>
    <TD>
      结构
    </TD>
    <TD>
      <IMG SRC=../images/design_patterns/Composite.gif Title="Composite" />
    </TD>
  </TR>
  <TR>
    <TD>
      意图
    </TD>
    <TD>
      将对象组合成树形结构以表示“部分-整体”的层次结构。Composite 使得用户对单个对象和组合对象的使用具有一致性。
    </TD>
  </TR>
  <TR>
    <TD>
      适用性
    </TD>
    <TD>
      <UL>
        <LI>
          你想表示对象的部分-整体层次结构。
        </LI>
        <LI>
          你希望用户忽略组合对象与单个对象的不同，用户将统一地使用组合结构中的所有对象。
        </LI>
      </UL>
    </TD>
  </TR>
  <TR>
    <TD>
      Code Example
    </TD>
    <TD>
      <ul>
        <li><a href="http://docs.oracle.com/javase/6/docs/api/java/awt/Container.html#add%28java.awt.Component%29"><code>java.awt.Container#add(Component)</code></a> (几乎所有的SWING类都适用)</li>
        <li><a href="http://docs.oracle.com/javaee/6/api/javax/faces/component/UIComponent.html#getChildren%28%29"><code>javax.faces.component.UIComponent#getChildren()</code></a> (几乎所有的 JSF UI 类都适用)</li>
      </ul>
    </TD>
  </TR>
</TABLE>
<A NAME=Decorator>
</A>
<BR/>
<BR/>
<TABLE cellspacing=1 cellpadding=10 WIDTH=94% BGCOLOR=GRAY ALIGN=CENTER>
  <TR>
    <TD>
      名称
    </TD>
    <TD>
      <B>
        Decorator
      </B>
    </TD>
  </TR>
  <TR>
    <TD>
      结构
    </TD>
    <TD>
      <IMG SRC=../images/design_patterns/Decorator.gif Title="Decorator" />
    </TD>
  </TR>
  <TR>
    <TD>
      意图
    </TD>
    <TD>
      动态地给一个对象添加一些额外的职责。就增加功能来说，Decorator 模式相比生成子类更为灵活。
    </TD>
  </TR>
  <TR>
    <TD>
      适用性
    </TD>
    <TD>
      <UL>
        <LI>
          在不影响其他对象的情况下，以动态、透明的方式给单个对象添加职责。
        </LI>
        <LI>
          处理那些可以撤消的职责。
        </LI>
        <LI>
          当不能采用生成子类的方法进行扩充时。一种情况是，可能有大量独立的扩展，为支持每一种组合将产生大量的子类，使得子类数目呈爆炸性增长。另一种情况可能是因为类定义被隐藏，或类定义不能用于生成子类。
        </LI>
      </UL>
    </TD>
  </TR>
  <TR>
    <TD>
      Code Example
    </TD>
    <TD>
      <ul>
        <li>所有 <a href="http://docs.oracle.com/javase/6/docs/api/java/io/InputStream.html"><code>java.io.InputStream</code></a>的子类, <a href="http://docs.oracle.com/javase/6/docs/api/java/io/OutputStream.html"><code>OutputStream</code></a>, <a href="http://docs.oracle.com/javase/6/docs/api/java/io/Reader.html"><code>Reader</code></a> 和 <a href="http://docs.oracle.com/javase/6/docs/api/java/io/Writer.html"><code>Writer</code></a> 它们都有一个接受相同类型作为参数的构造函数。</li>
        <li><a href="http://docs.oracle.com/javase/6/docs/api/java/util/Collections.html"><code>java.util.Collections</code></a>, <a href="http://docs.oracle.com/javase/6/docs/api/java/util/Collections.html#checkedCollection%28java.util.Collection,%20java.lang.Class%29"><code>checkedXXX()</code></a>, <a href="http://docs.oracle.com/javase/6/docs/api/java/util/Collections.html#synchronizedCollection%28java.util.Collection%29"><code>synchronizedXXX()</code></a> 和 <a href="http://docs.oracle.com/javase/6/docs/api/java/util/Collections.html#unmodifiableCollection%28java.util.Collection%29"><code>unmodifiableXXX()</code></a> 方法</li>
        <li><a href="http://docs.oracle.com/javaee/6/api/javax/servlet/http/HttpServletRequestWrapper.html"><code>javax.servlet.http.HttpServletRequestWrapper</code></a> 方法 <a href="http://docs.oracle.com/javaee/6/api/javax/servlet/http/HttpServletResponseWrapper.html"><code>HttpServletResponseWrapper</code></a></li>
      </ul>
    </TD>
  </TR>
</TABLE>
<A NAME=Facade>
</A>
<BR/>
<BR/>
<TABLE cellspacing=1 cellpadding=10 WIDTH=94% BGCOLOR=GRAY ALIGN=CENTER>
  <TR>
    <TD>
      名称
    </TD>
    <TD>
      <B>
        Facade
      </B>
    </TD>
  </TR>
  <TR>
    <TD>
      结构
    </TD>
    <TD>
      <IMG SRC=../images/design_patterns/Facade.gif Title="Facade" />
    </TD>
  </TR>
  <TR>
    <TD>
      意图
    </TD>
    <TD>
      为子系统中的一组接口提供一个一致的界面，Facade 模式定义了一个高层接口，这个接口使得这一子系统更加容易使用。
    </TD>
  </TR>
  <TR>
    <TD>
      适用性
    </TD>
    <TD>
      <UL>
        <LI>
          当你要为一个复杂子系统提供一个简单接口时。子系统往往因为不断演化而变得越来越复杂。大多数模式使用时都会产生更多更小的类。这使得子系统更具可重用性，也更容易对子系统进行定制，但这也给那些不需要定制子系统的用户带来一些使用上的困难。Facade 可以提供一个简单的缺省视图，这一视图对大多数用户来说已经足够，而那些需要更多的可定制性的用户可以越过facade
          层。
        </LI>
        <LI>
          客户程序与抽象类的实现部分之间存在着很大的依赖性。引入facade 将这个子系统与客户以及其他的子系统分离，可以提高子系统的独立性和可移植性。
        </LI>
        <LI>
          当你需要构建一个层次结构的子系统时，使用facade 模式定义子系统中每层的入口点。如果子系统之间是相互依赖的，你可以让它们仅通过facade 进行通讯，从而简化了它们之间的依赖关系。
        </LI>
      </UL>
    </TD>
  </TR>
  <TR>
    <TD>
      Code Example
    </TD>
    <TD>
      <ul>
        <li><a href="http://docs.oracle.com/javaee/6/api/javax/faces/context/FacesContext.html"><code>javax.faces.context.FacesContext</code></a>, 它内部使用其他的抽象类或接口如 <a href="http://docs.oracle.com/javaee/6/api/javax/faces/lifecycle/Lifecycle.html"><code>LifeCycle</code></a>, <a href="http://docs.oracle.com/javaee/6/api/javax/faces/application/ViewHandler.html"><code>ViewHandler</code></a>, <a href="http://docs.oracle.com/javaee/6/api/javax/faces/application/NavigationHandler.html"><code>NavigationHandler</code></a> 以及更多的，最终用户没有必要去操心这些(这不过是通过注射重写).</li>
        <li><a href="http://docs.oracle.com/javaee/6/api/javax/faces/context/ExternalContext.html"><code>javax.faces.context.ExternalContext</code></a>, 内部使用了 <a href="http://docs.oracle.com/javaee/6/api/javax/servlet/ServletContext.html"><code>ServletContext</code></a>, <a href="http://docs.oracle.com/javaee/6/api/javax/servlet/http/HttpSession.html"><code>HttpSession</code></a>, <a href="http://docs.oracle.com/javaee/6/api/javax/servlet/http/HttpServletRequest.html"><code>HttpServletRequest</code></a>, <a href="http://docs.oracle.com/javaee/6/api/javax/servlet/http/HttpServletResponse.html"><code>HttpServletResponse</code></a> 等</li>
      </ul>
    </TD>
  </TR>
</TABLE>
<A NAME=Flyweight>
</A>
<BR/>
<BR/>
<TABLE cellspacing=1 cellpadding=10 WIDTH=94% BGCOLOR=GRAY ALIGN=CENTER>
  <TR>
    <TD>
      名称
    </TD>
    <TD>
      <B>
        Flyweight
      </B>
    </TD>
  </TR>
  <TR>
    <TD>
      结构
    </TD>
    <TD>
      <IMG SRC=../images/design_patterns/Flyweight.gif Title="Flyweight" />
    </TD>
  </TR>
  <TR>
    <TD>
      意图
    </TD>
    <TD>
      运用共享技术有效地支持大量细粒度的对象。
    </TD>
  </TR>
  <TR>
    <TD>
      适用性
    </TD>
    <TD>
      <UL>
        <LI>
          一个应用程序使用了大量的对象。
        </LI>
        <LI>
          完全由于使用大量的对象，造成很大的存储开销。
        </LI>
        <LI>
          对象的大多数状态都可变为外部状态。
        </LI>
        <LI>
          如果删除对象的外部状态，那么可以用相对较少的共享对象取代很多组对象。
        </LI>
        <LI>
          应用程序不依赖于对象标识。由于Flyweight 对象可以被共享，对于概念上明显有别的对象，标识测试将返回真值。
        </LI>
      </UL>
    </TD>
  </TR>
  <TR>
    <TD>
      Code Example
    </TD>
    <TD>
      <ul>
        <li><a href="http://docs.oracle.com/javase/6/docs/api/java/lang/Integer.html#valueOf%28int%29"><code>java.lang.Integer#valueOf(int)</code></a> (<a href="http://docs.oracle.com/javase/6/docs/api/java/lang/Boolean.html#valueOf%28boolean%29"><code>Boolean</code></a>, <a href="http://docs.oracle.com/javase/6/docs/api/java/lang/Byte.html#valueOf%28byte%29"><code>Byte</code></a>, <a href="http://docs.oracle.com/javase/6/docs/api/java/lang/Character.html#valueOf%28char%29"><code>Character</code></a>, <a href="http://docs.oracle.com/javase/6/docs/api/java/lang/Short.html#valueOf%28short%29"><code>Short</code></a>, <a href="http://docs.oracle.com/javase/6/docs/api/java/lang/Long.html#valueOf%28long%29"><code>Long</code></a> 和 <a href="https://docs.oracle.com/javase/8/docs/api/java/math/BigDecimal.html#valueOf-long-int-"><code>BigDecimal</code></a>也一样)</li>
      </ul>
    </TD>
  </TR>
</TABLE>
<A NAME=Proxy>
</A>
<BR/>
<BR/>
<TABLE cellspacing=1 cellpadding=10 WIDTH=94% BGCOLOR=GRAY ALIGN=CENTER>
  <TR>
    <TD>
      名称
    </TD>
    <TD>
      <B>
        Proxy
      </B>
    </TD>
  </TR>
  <TR>
    <TD>
      结构
    </TD>
    <TD>
      <IMG SRC=../images/design_patterns/Proxy.gif Title="Proxy" />
    </TD>
  </TR>
  <TR>
    <TD>
      意图
    </TD>
    <TD>
      为其他对象提供一种代理以控制对这个对象的访问。
    </TD>
  </TR>
  <TR>
    <TD>
      适用性
    </TD>
    <TD>
      <UL>
        <LI>
          在需要用比较通用和复杂的对象指针代替简单的指针的时候，使用Proxy 模式。下面是一 些可以使用Proxy 模式常见情况：
          <BR/>
          1) 远程代理（Remote Proxy ）为一个对象在不同的地址空间提供局部代表。 NEXTSTEP[Add94] 使用NXProxy 类实现了这一目的。Coplien[Cop92] 称这种代理为“大使” （Ambassador ）。
          <BR/>
          2 )虚代理（Virtual Proxy ）根据需要创建开销很大的对象。在动机一节描述的ImageProxy 就是这样一种代理的例子。
          <BR/>
          3) 保护代理（Protection Proxy ）控制对原始对象的访问。保护代理用于对象应该有不同 的访问权限的时候。例如，在Choices 操作系统[CIRM93]中KemelProxies 为操作系统对象提供了访问保护。
          <BR/>
          4 )智能指引（Smart Reference ）取代了简单的指针，它在访问对象时执行一些附加操作。 它的典型用途包括：
          <BR/>
        </LI>
        <LI>
          对指向实际对象的引用计数，这样当该对象没有引用时，可以自动释放它(也称为SmartPointers[Ede92] )。
        </LI>
        <LI>
          当第一次引用一个持久对象时，将它装入内存。
        </LI>
        <LI>
          在访问一个实际对象前，检查是否已经锁定了它，以确保其他对象不能改变它。
        </LI>
      </UL>
    </TD>
  </TR>
  <TR>
    <TD>
      Code Example
    </TD>
    <TD>
      <ul>
        <li><a href="http://docs.oracle.com/javase/6/docs/api/java/lang/reflect/Proxy.html"><code>java.lang.reflect.Proxy</code></a></li>
        <li><a href="http://docs.oracle.com/javase/6/docs/api/java/rmi/package-summary.html"><code>java.rmi.*</code></a>整个API.</li>
      </ul>
    </TD>
  </TR>
</TABLE>
<A NAME=ChainofResponsibility>
</A>
<BR/>
<BR/>
<TABLE cellspacing=1 cellpadding=10 WIDTH=94% BGCOLOR=GRAY ALIGN=CENTER>
  <TR>
    <TD>
      名称
    </TD>
    <TD>
      <B>
        Chain of Responsibility
      </B>
    </TD>
  </TR>
  <TR>
    <TD>
      结构
    </TD>
    <TD>
      <IMG SRC=../images/design_patterns/ChainofResponsibility.gif Title="Chain of Responsibility" />
    </TD>
  </TR>
  <TR>
    <TD>
      意图
    </TD>
    <TD>
      使多个对象都有机会处理请求，从而避免请求的发送者和接收者之间的耦合关系。将这些对象连成一条链，并沿着这条链传递该请求，直到有一个对象处理它为止。
    </TD>
  </TR>
  <TR>
    <TD>
      适用性
    </TD>
    <TD>
      <UL>
        <LI>
          有多个的对象可以处理一个请求，哪个对象处理该请求运行时刻自动确定。
        </LI>
        <LI>
          你想在不明确指定接收者的情况下，向多个对象中的一个提交一个请求。
        </LI>
        <LI>
          可处理一个请求的对象集合应被动态指定。
        </LI>
      </UL>
    </TD>
  </TR>
  <TR>
    <TD>
      Code Example
    </TD>
    <TD>
      <ul>
        <li><a href="http://docs.oracle.com/javase/6/docs/api/java/util/logging/Logger.html#log%28java.util.logging.Level,%20java.lang.String%29"><code>java.util.logging.Logger#log()</code></a></li>
        <li><a href="http://docs.oracle.com/javaee/6/api/javax/servlet/Filter.html#doFilter%28javax.servlet.ServletRequest,%20javax.servlet.ServletResponse,%20javax.servlet.FilterChain%29"><code>javax.servlet.Filter#doFilter()</code></a></li>
      </ul>
    </TD>
  </TR>
</TABLE>
<A NAME=Command>
</A>
<BR/>
<BR/>
<TABLE cellspacing=1 cellpadding=10 WIDTH=94% BGCOLOR=GRAY ALIGN=CENTER>
  <TR>
    <TD>
      名称
    </TD>
    <TD>
      <B>
        Command
      </B>
    </TD>
  </TR>
  <TR>
    <TD>
      结构
    </TD>
    <TD>
      <IMG SRC=../images/design_patterns/Command.gif Title="Command" />
    </TD>
  </TR>
  <TR>
    <TD>
      意图
    </TD>
    <TD>
      将一个请求封装为一个对象，从而使你可用不同的请求对客户进行参数化；对请求排队或记录请求日志，以及支持可撤消的操作。
    </TD>
  </TR>
  <TR>
    <TD>
      适用性
    </TD>
    <TD>
      <UL>
        <LI>
          抽象出待执行的动作以参数化某对象，你可用过程语言中的回调（callback）函数表达这种参数化机制。所谓回调函数是指函数先在某处注册，而它将在稍后某个需要的时候被调用。Command 模式是回调机制的一个面向对象的替代品。
        </LI>
        <LI>
          在不同的时刻指定、排列和执行请求。一个Command 对象可以有一个与初始请求无关的生存期。如果一个请求的接收者可用一种与地址空间无关的方式表达，那么就可将负责该请求的命令对象传送给另一个不同的进程并在那儿实现该请求。
        </LI>
        <LI>
          支持取消操作。Command 的Excute 操作可在实施操作前将状态存储起来，在取消操作时这个状态用来消除该操作的影响。Command 接口必须添加一个Unexecute 操作，该操作取消上一次Execute 调用的效果。执行的命令被存储在一个历史列表中。可通过向后和向前遍历这一列表并分别调用Unexecute 和Execute 来实现重数不限的“取消”和“重做”。
        </LI>
        <LI>
          支持修改日志，这样当系统崩溃时，这些修改可以被重做一遍。在Command 接口中添加装载操作和存储操作，可以用来保持变动的一个一致的修改日志。从崩溃中恢复的过程包括从磁盘中重新读入记录下来的命令并用Execute 操作重新执行它们。
        </LI>
        <LI>
          用构建在原语操作上的高层操作构造一个系统。这样一种结构在支持事务(transaction)的信息系统中很常见。一个事务封装了对数据的一组变动。Command 模式提供了对事务进行建模的方法。Command 有一个公共的接口，使得你可以用同一种方式调用所有的事务。同时使用该模式也易于添加新事务以扩展系统。
        </LI>
      </UL>
    </TD>
  </TR>
  <TR>
    <TD>
      Code Example
    </TD>
    <TD>
      <ul>
        <li>所有 <a href="http://docs.oracle.com/javase/6/docs/api/java/lang/Runnable.html"><code>java.lang.Runnable</code></a>的实现</li>
        <li>所有 <a href="http://docs.oracle.com/javase/6/docs/api/javax/swing/Action.html"><code>javax.swing.Action</code></a>的实现</li>
      </ul>
    </TD>
  </TR>
</TABLE>
<A NAME=Interpreter>
</A>
<BR/>
<BR/>
<TABLE cellspacing=1 cellpadding=10 WIDTH=94% BGCOLOR=GRAY ALIGN=CENTER>
  <TR>
    <TD>
      名称
    </TD>
    <TD>
      <B>
        Interpreter
      </B>
    </TD>
  </TR>
  <TR>
    <TD>
      结构
    </TD>
    <TD>
      <IMG SRC=../images/design_patterns/Interpreter.gif Title="Interpreter" />
    </TD>
  </TR>
  <TR>
    <TD>
      意图
    </TD>
    <TD>
      给定一个语言，定义它的文法的一种表示，并定义一个解释器，这个解释器使用该表示来解释语言中的句子。
    </TD>
  </TR>
  <TR>
    <TD>
      适用性
    </TD>
    <TD>
      <UL>
        <LI>
          当有一个语言需要解释执行, 并且你可将该语言中的句子表示为一个抽象语法树时，可使用解释器模式。而当存在以下情况时该模式效果最好：
        </LI>
        <LI>
          该文法简单对于复杂的文法, 文法的类层次变得庞大而无法管理。此时语法分析程序生成器这样的工具是更好的选择。它们无需构建抽象语法树即可解释表达式,
          这样可以节省空间而且还可能节省时间。
        </LI>
        <LI>
          效率不是一个关键问题最高效的解释器通常不是通过直接解释语法分析树实现的, 而是首先将它们转换成另一种形式。例如，正则表达式通常被转换成状态机。但即使在这种情况下,
          转换器仍可用解释器模式实现, 该模式仍是有用的。
        </LI>
      </UL>
    </TD>
  </TR>
  <TR>
    <TD>
      Code Example
    </TD>
    <TD>
      <ul>
        <li><a href="http://docs.oracle.com/javase/6/docs/api/java/util/regex/Pattern.html"><code>java.util.Pattern</code></a></li>
        <li><a href="http://docs.oracle.com/javase/6/docs/api/java/text/Normalizer.html"><code>java.text.Normalizer</code></a></li>
        <li>所有 <a href="http://docs.oracle.com/javase/6/docs/api/java/text/Format.html"><code>java.text.Format</code></a>的子类</li>
        <li>所有 <a href="http://docs.oracle.com/javaee/6/api/javax/el/ELResolver.html"><code>javax.el.ELResolver</code></a>的子类</li>
      </ul>
    </TD>
  </TR>
</TABLE>
<A NAME=Iterator>
</A>
<BR/>
<BR/>
<TABLE cellspacing=1 cellpadding=10 WIDTH=94% BGCOLOR=GRAY ALIGN=CENTER>
  <TR>
    <TD>
      名称
    </TD>
    <TD>
      <B>
        Iterator
      </B>
    </TD>
  </TR>
  <TR>
    <TD>
      结构
    </TD>
    <TD>
      <IMG SRC=../images/design_patterns/Iterator.gif Title="Iterator" />
    </TD>
  </TR>
  <TR>
    <TD>
      意图
    </TD>
    <TD>
      提供一种方法顺序访问一个聚合对象中各个元素, 而又不需暴露该对象的内部表示。
    </TD>
  </TR>
  <TR>
    <TD>
      适用性
    </TD>
    <TD>
      <UL>
        <LI>
          访问一个聚合对象的内容而无需暴露它的内部表示。
        </LI>
        <LI>
          支持对聚合对象的多种遍历。
        </LI>
        <LI>
          为遍历不同的聚合结构提供一个统一的接口(即, 支持多态迭代)。
        </LI>
      </UL>
    </TD>
  </TR>
  <TR>
    <TD>
      Code Example
    </TD>
    <TD>
      <ul>
        <li>所有 <a href="http://docs.oracle.com/javase/6/docs/api/java/util/Iterator.html"><code>java.util.Iterator</code></a> 的实现(<a href="http://docs.oracle.com/javase/6/docs/api/java/util/Scanner.html"><code>java.util.Scanner</code></a>也类似!).</li>
        <li>所有 <a href="http://docs.oracle.com/javase/6/docs/api/java/util/Enumeration.html"><code>java.util.Enumeration</code></a>的实现</li>
      </ul>
    </TD>
  </TR>
</TABLE>
<A NAME=Mediator>
</A>
<BR/>
<BR/>
<TABLE cellspacing=1 cellpadding=10 WIDTH=94% BGCOLOR=GRAY ALIGN=CENTER>
  <TR>
    <TD>
      名称
    </TD>
    <TD>
      <B>
        Mediator
      </B>
    </TD>
  </TR>
  <TR>
    <TD>
      结构
    </TD>
    <TD>
      <IMG SRC=../images/design_patterns/Mediator.gif Title="Mediator" />
    </TD>
  </TR>
  <TR>
    <TD>
      意图
    </TD>
    <TD>
      用一个中介对象来封装一系列的对象交互。中介者使各对象不需要显式地相互引用，从而使其耦合松散，而且可以独立地改变它们之间的交互。
    </TD>
  </TR>
  <TR>
    <TD>
      适用性
    </TD>
    <TD>
      <UL>
        <LI>
          一组对象以定义良好但是复杂的方式进行通信。产生的相互依赖关系结构混乱且难以理解。
        </LI>
        <LI>
          一个对象引用其他很多对象并且直接与这些对象通信,导致难以复用该对象。
        </LI>
        <LI>
          想定制一个分布在多个类中的行为，而又不想生成太多的子类。
        </LI>
      </UL>
    </TD>
  </TR>
  <TR>
    <TD>
      Code Example
    </TD>
    <TD>
      <ul>
        <li><a href="http://docs.oracle.com/javase/6/docs/api/java/util/Timer.html"><code>java.util.Timer</code></a> (所有<code>scheduleXXX()</code> 方法)</li>
        <li><a href="http://docs.oracle.com/javase/6/docs/api/java/util/concurrent/Executor.html#execute%28java.lang.Runnable%29"><code>java.util.concurrent.Executor#execute()</code></a></li>
        <li><a href="http://docs.oracle.com/javase/6/docs/api/java/util/concurrent/ExecutorService.html"><code>java.util.concurrent.ExecutorService</code></a> (<code>invokeXXX()</code> 和 <code>submit()</code> 方法)</li>
        <li><a href="http://docs.oracle.com/javase/6/docs/api/java/util/concurrent/ScheduledExecutorService.html"><code>java.util.concurrent.ScheduledExecutorService</code></a> (所有 <code>scheduleXXX()</code> 方法)</li>
        <li><a href="http://docs.oracle.com/javase/6/docs/api/java/lang/reflect/Method.html#invoke%28java.lang.Object,%20java.lang.Object...%29"><code>java.lang.reflect.Method#invoke()</code></a></li>
      </ul>
    </TD>
  </TR>
</TABLE>
<A NAME=Memento>
</A>
<BR/>
<BR/>
<TABLE cellspacing=1 cellpadding=10 WIDTH=94% BGCOLOR=GRAY ALIGN=CENTER>
  <TR>
    <TD>
      名称
    </TD>
    <TD>
      <B>
        Memento
      </B>
    </TD>
  </TR>
  <TR>
    <TD>
      结构
    </TD>
    <TD>
      <IMG SRC=../images/design_patterns/Memento.gif Title="Memento" />
    </TD>
  </TR>
  <TR>
    <TD>
      意图
    </TD>
    <TD>
      在不破坏封装性的前提下，捕获一个对象的内部状态，并在该对象之外保存这个状态。这样以后就可将该对象恢复到原先保存的状态。
    </TD>
  </TR>
  <TR>
    <TD>
      适用性
    </TD>
    <TD>
      <UL>
        <LI>
          必须保存一个对象在某一个时刻的(部分)状态, 这样以后需要时它才能恢复到先前的状态。
        </LI>
        <LI>
          如果一个用接口来让其它对象直接得到这些状态，将会暴露对象的实现细节并破坏对象的封装性。
        </LI>
      </UL>
    </TD>
  </TR>
  <TR>
    <TD>
      Code Example
    </TD>
    <TD>
      <ul>
        <li><a href="http://docs.oracle.com/javase/6/docs/api/java/util/Date.html"><code>java.util.Date</code></a> (setter方法实现这种模式, <code>Date</code> 在内部使用了一个<code>long</code> 型来做这个快照)</li>
        <li>所有 <a href="http://docs.oracle.com/javase/6/docs/api/java/io/Serializable.html"><code>java.io.Serializable</code></a>的实现</li>
        <li>所有 <a href="http://docs.oracle.com/javaee/6/api/javax/faces/component/StateHolder.html"><code>javax.faces.component.StateHolder</code></a>的实现</li>
      </ul>
    </TD>
  </TR>
</TABLE>
<A NAME=Observer>
</A>
<BR/>
<BR/>
<TABLE cellspacing=1 cellpadding=10 WIDTH=94% BGCOLOR=GRAY ALIGN=CENTER>
  <TR>
    <TD>
      名称
    </TD>
    <TD>
      <B>
        Observer
      </B>
    </TD>
  </TR>
  <TR>
    <TD>
      结构
    </TD>
    <TD>
      <IMG SRC=../images/design_patterns/Observer.gif Title="Observer" />
    </TD>
  </TR>
  <TR>
    <TD>
      意图
    </TD>
    <TD>
      定义对象间的一种一对多的依赖关系,当一个对象的状态发生改变时, 所有依赖于它的对象都得到通知并被自动更新。
    </TD>
  </TR>
  <TR>
    <TD>
      适用性
    </TD>
    <TD>
      <UL>
        <LI>
          当一个抽象模型有两个方面, 其中一个方面依赖于另一方面。将这二者封装在独立的对象中以使它们可以各自独立地改变和复用。
        </LI>
        <LI>
          当对一个对象的改变需要同时改变其它对象, 而不知道具体有多少对象有待改变。
        </LI>
        <LI>
          当一个对象必须通知其它对象，而它又不能假定其它对象是谁。换言之, 你不希望这些对象是紧密耦合的。
        </LI>
      </UL>
    </TD>
  </TR>
  <TR>
    <TD>
      Code Example
    </TD>
    <TD>
      <ul>
        <li><a href="http://docs.oracle.com/javase/6/docs/api/java/util/Observer.html"><code>java.util.Observer</code></a>/<a href="http://docs.oracle.com/javase/6/docs/api/java/util/Observable.html"><code>java.util.Observable</code></a> (几乎很少被使用)</li>
        <li>所有 <a href="http://docs.oracle.com/javase/6/docs/api/java/util/EventListener.html"><code>java.util.EventListener</code></a> (几乎所有的Swing都适用)的实现</li>
        <li><a href="http://docs.oracle.com/javaee/6/api/javax/servlet/http/HttpSessionBindingListener.html"><code>javax.servlet.http.HttpSessionBindingListener</code></a></li>
        <li><a href="http://docs.oracle.com/javaee/6/api/javax/servlet/http/HttpSessionAttributeListener.html"><code>javax.servlet.http.HttpSessionAttributeListener</code></a></li>
        <li><a href="http://docs.oracle.com/javaee/6/api/javax/faces/event/PhaseListener.html"><code>javax.faces.event.PhaseListener</code></a></li>
      </ul>
    </TD>
  </TR>
</TABLE>
<A NAME=State>
</A>
<BR/>
<BR/>
<TABLE cellspacing=1 cellpadding=10 WIDTH=94% BGCOLOR=GRAY ALIGN=CENTER>
  <TR>
    <TD>
      名称
    </TD>
    <TD>
      <B>
        State
      </B>
    </TD>
  </TR>
  <TR>
    <TD>
      结构
    </TD>
    <TD>
      <IMG SRC=../images/design_patterns/State.gif Title="State" />
    </TD>
  </TR>
  <TR>
    <TD>
      意图
    </TD>
    <TD>
      允许一个对象在其内部状态改变时改变它的行为。对象看起来似乎修改了它的类。
    </TD>
  </TR>
  <TR>
    <TD>
      适用性
    </TD>
    <TD>
      <UL>
        <LI>
          一个对象的行为取决于它的状态, 并且它必须在运行时刻根据状态改变它的行为。
        </LI>
        <LI>
          一个操作中含有庞大的多分支的条件语句，且这些分支依赖于该对象的状态。这个状态通常用一个或多个枚举常量表示。通常, 有多个操作包含这一相同的条件结构。State模式将每一个条件分支放入一个独立的类中。这使得你可以根据对象自身的情况将对象的状态作为一个对象，这一对象可以不依赖于其他对象而独立变化。
        </LI>
      </UL>
    </TD>
  </TR>
  <TR>
    <TD>
      Code Example
    </TD>
    <TD>
      <ul>
        <li><a href="http://docs.oracle.com/javaee/6/api/javax/faces/lifecycle/Lifecycle.html#execute%28javax.faces.context.FacesContext%29"><code>javax.faces.lifecycle.LifeCycle#execute()</code></a> (由 <a href="http://docs.oracle.com/javaee/6/api/javax/faces/webapp/FacesServlet.html"><code>FacesServlet</code></a>控制, 行为依赖于当前JSF生命周期的状态)</li>
      </ul>
    </TD>
  </TR>
</TABLE>
<A NAME=Strategy>
</A>
<BR/>
<BR/>
<TABLE cellspacing=1 cellpadding=10 WIDTH=94% BGCOLOR=GRAY ALIGN=CENTER>
  <TR>
    <TD>
      名称
    </TD>
    <TD>
      <B>
        Strategy
      </B>
    </TD>
  </TR>
  <TR>
    <TD>
      结构
    </TD>
    <TD>
      <IMG SRC=../images/design_patterns/Strategy.gif Title="Strategy" />
    </TD>
  </TR>
  <TR>
    <TD>
      意图
    </TD>
    <TD>
      定义一系列的算法,把它们一个个封装起来, 并且使它们可相互替换。本模式使得算法可独立于使用它的客户而变化。
    </TD>
  </TR>
  <TR>
    <TD>
      适用性
    </TD>
    <TD>
      <UL>
        <LI>
          许多相关的类仅仅是行为有异。“策略”提供了一种用多个行为中的一个行为来配置一个类的方法。
        </LI>
        <LI>
          需要使用一个算法的不同变体。例如，你可能会定义一些反映不同的空间/时间权衡的算法。当这些变体实现为一个算法的类层次时[HO87]
          ,可以使用策略模式。
        </LI>
        <LI>
          算法使用客户不应该知道的数据。可使用策略模式以避免暴露复杂的、与算法相关的数据结构。
        </LI>
        <LI>
          一个类定义了多种行为, 并且这些行为在这个类的操作中以多个条件语句的形式出现。将相关的条件分支移入它们各自的Strategy
          类中以代替这些条件语句。
        </LI>
      </UL>
    </TD>
  </TR>
  <TR>
    <TD>
      Code Example
    </TD>
    <TD>
      <ul>
        <li><a href="http://docs.oracle.com/javase/6/docs/api/java/util/Comparator.html#compare%28T,%20T%29"><code>java.util.Comparator#compare()</code></a>,这个方法被<code>Collections#sort()</code>所调用 </li>
        <li><a href="http://docs.oracle.com/javaee/6/api/javax/servlet/http/HttpServlet.html"><code>javax.servlet.http.HttpServlet</code></a>, <code>service()</code> 和所有 <code>doXXX()</code> 方法都接受 <code>HttpServletRequest</code> 和 <code>HttpServletResponse</code>参数 HttpServlet的所有继承类必须去自己处理这些参数。</li>
        <li><a href="http://docs.oracle.com/javaee/6/api/javax/servlet/Filter.html#doFilter%28javax.servlet.ServletRequest,%20javax.servlet.ServletResponse,%20javax.servlet.FilterChain%29"><code>javax.servlet.Filter#doFilter()</code></a></li>
      </ul>
    </TD>
  </TR>
</TABLE>
<A NAME=TemplateMethod>
</A>
<BR/>
<BR/>
<TABLE cellspacing=1 cellpadding=10 WIDTH=94% BGCOLOR=GRAY ALIGN=CENTER>
  <TR>
    <TD>
      名称
    </TD>
    <TD>
      <B>
        Template Method
      </B>
    </TD>
  </TR>
  <TR>
    <TD>
      结构
    </TD>
    <TD>
      <IMG SRC=../images/design_patterns/TemplateMethod.gif Title="Template Method" />
    </TD>
  </TR>
  <TR>
    <TD>
      意图
    </TD>
    <TD>
      定义一个操作中的算法的骨架，而将一些步骤延迟到子类中。TemplateMethod 使得子类可以不改变一个算法的结构即可重定义该算法的某些特定步骤。
    </TD>
  </TR>
  <TR>
    <TD>
      适用性
    </TD>
    <TD>
      <UL>
        <LI>
          一次性实现一个算法的不变的部分，并将可变的行为留给子类来实现。
        </LI>
        <LI>
          各子类中公共的行为应被提取出来并集中到一个公共父类中以避免代码重复。这是Opdyke 和Johnson 所描述过的“重分解以一般化”的一个很好的例子[OJ93]。首先识别现有代码中的不同之处，并且将不同之处分离为新的操作。最后，用一个调用这些新的操作的模板方法来替换这些不同的代码。
        </LI>
        <LI>
          控制子类扩展。模板方法只在特定点调用“hook ”操作（参见效果一节），这样就只允许在这些点进行扩展。
        </LI>
      </UL>
    </TD>
  </TR>
  <TR>
    <TD>
      Code Example
    </TD>
    <TD>
      <ul>
        <li>所有 <a href="http://docs.oracle.com/javase/6/docs/api/java/io/InputStream.html"><code>java.io.InputStream</code></a>, <a href="http://docs.oracle.com/javase/6/docs/api/java/io/OutputStream.html"><code>java.io.OutputStream</code></a>, <a href="http://docs.oracle.com/javase/6/docs/api/java/io/Reader.html"><code>java.io.Reader</code></a> 和 <a href="http://docs.oracle.com/javase/6/docs/api/java/io/Writer.html"><code>java.io.Writer</code></a>的非抽象方法</li>
        <li>所有 <a href="http://docs.oracle.com/javase/6/docs/api/java/util/AbstractList.html"><code>java.util.AbstractList</code></a>, <a href="http://docs.oracle.com/javase/6/docs/api/java/util/AbstractSet.html"><code>java.util.AbstractSet</code></a> 和 <a href="http://docs.oracle.com/javase/6/docs/api/java/util/AbstractMap.html"><code>java.util.AbstractMap</code></a>的非抽象方法</li>
        <li><a href="http://docs.oracle.com/javaee/6/api/javax/servlet/http/HttpServlet.html"><code>javax.servlet.http.HttpServlet</code></a>, 所有 <code>doXXX()</code> 方法默认返回HTTP 405 "Method Not Allowed"错误响应。你可以自由地选择实现一些或者不实现这些方法</li>
      </ul>
    </TD>
  </TR>
</TABLE>
<A NAME=Visitor>
</A>
<BR/>
<BR/>
<TABLE cellspacing=1 cellpadding=10 WIDTH=94% BGCOLOR=GRAY ALIGN=CENTER>
  <TR>
    <TD>
      名称
    </TD>
    <TD>
      <B>
        Visitor
      </B>
    </TD>
  </TR>
  <TR>
    <TD>
      结构
    </TD>
    <TD>
      <IMG SRC=../images/design_patterns/Visitor.gif Title="Visitor" />
    </TD>
  </TR>
  <TR>
    <TD>
      意图
    </TD>
    <TD>
      表示一个作用于某对象结构中的各元素的操作。它使你可以在不改变各元素的类的前提下定义作用于这些元素的新操作。
    </TD>
  </TR>
  <TR>
    <TD>
      适用性
    </TD>
    <TD>
      <UL>
        <LI>
          一个对象结构包含很多类对象，它们有不同的接口，而你想对这些对象实施一些依赖于其具体类的操作。
        </LI>
        <LI>
          需要对一个对象结构中的对象进行很多不同的并且不相关的操作，而你想避免让这些操作“污染”这些对象的类。Visitor 使得你可以将相关的操作集中起来定义在一个类中。当该对象结构被很多应用共享时，用Visitor 模式让每个应用仅包含需要用到的操作。
        </LI>
        <LI>
          定义对象结构的类很少改变，但经常需要在此结构上定义新的操作。改变对象结构类需要重定义对所有访问者的接口，这可能需要很大的代价。如果对象结构类经常改变，那么可能还是在这些类中定义这些操作较好。
        </LI>
      </UL>
    </TD>
  </TR>
  <TR>
    <TD>
      Code Example
    </TD>
    <TD>
      <ul>
        <li><a href="http://docs.oracle.com/javase/6/docs/api/javax/lang/model/element/AnnotationValue.html"><code>javax.lang.model.element.AnnotationValue</code></a> 和<a href="http://docs.oracle.com/javase/6/docs/api/javax/lang/model/element/AnnotationValueVisitor.html"><code>AnnotationValueVisitor</code></a></li>
        <li><a href="http://docs.oracle.com/javase/6/docs/api/javax/lang/model/element/Element.html"><code>javax.lang.model.element.Element</code></a> 和<a href="http://docs.oracle.com/javase/6/docs/api/javax/lang/model/element/ElementVisitor.html"><code>ElementVisitor</code></a></li>
        <li><a href="http://docs.oracle.com/javase/6/docs/api/javax/lang/model/type/TypeMirror.html"><code>javax.lang.model.type.TypeMirror</code></a> 和<a href="http://docs.oracle.com/javase/6/docs/api/javax/lang/model/type/TypeVisitor.html"><code>TypeVisitor</code></a></li>
        <li><a href="http://docs.oracle.com/javase/7/docs/api/java/nio/file/FileVisitor.html"><code>java.nio.file.FileVisitor</code></a> 和<a href="http://docs.oracle.com/javase/7/docs/api/java/nio/file/SimpleFileVisitor.html"><code>SimpleFileVisitor</code></a></li>
      </ul>
    </TD>
  </TR>
</TABLE>

## 设计模式比较

1. 创建者模式

    1. 工厂模式注重的是整体对象的创建方法，而建造者模式注重的是部件构建的过程，旨在通过一步步的精确构造创建出一个复杂的对象。抽象工厂模式实现对产品家族的创建。

    2.（抽象）工厂模式与创建者模式的不同：

        1. 意图不同： 工厂模式关注的是一个产品的整体，而建造者模式由一个个产品组成部分的创建过程。

        2. 产品的复杂度不同：工厂模式创建的一般都是单一产品，而建造者模式创建的是一个复杂的产品

    3. 原型模式：原型模式其实是从一个对象再创建另个一个可定制的对象，而且不需知道任何创建的细节。一般在初始化的信息不发生变化的情况下，克隆是最好的办法。

    4. 单例模式：创建唯一的一个实例。原型模式通过原型拷贝n个实例。

2. 结构类模式：通过组合类或对象产生更大结构以适应更高层次的逻辑需求。

    1. 代理模式与装饰模式很像。代理模式关注控制过程的访问，使用者关注的是原来的功能；而装饰模式关注的是在一个对象上动态的添加方法，使用者关注的是装饰之后的功能。从行为上说，当使用代理模式的时候，我们常常在一个代理类中创建一个对象的实例。而使用装饰器模式的时候，通常的做法是将原始对象作为一个参数传给装饰者的构造器。

    2. 装饰模式和适配器模式差别比较大，但它们的功能也有相似的地方：都是包装作用，都是通过委托方式实现其功能。不同点：装饰模式包装的是自己的兄弟类，率属于同一个家族（相同接口或者父类），适配器模式则修饰非血缘关系类，关注的是两个对象之间的转换。

    3. 桥接模式和适配器模式的共同点：桥接和适配器都是让两个东西配合工作；不同点：出发点不同。适配器是改变已有的两个接口，让他们相容。桥接模式是分离抽象化和实现，使两者的接口可以不同，目的是分离

    4. 组合模式以类为主导，装饰模式以对象为主导。组合模式弊端，组合的种类多种多样，为每种组合创造一个类，类的数量急剧的增加。装饰模式弊端，会造成对象的嵌套层次太深

3. 行为类模式

    1. 命令模式与策略模式的区别：类图相似，但是命令模式多了个接受者（Receiver）。关注点不同：策略模式关注的是算法的替换问题，命令模式关注的是解耦问题：请求者、接受者之间的解耦，命令之间的解耦。

    2. 策略模式VS状态模式：策略模式旨在解决内部算法如果改变问题，保证的是算法可自由切换；状态模式旨在解决内在状态的改变而引起行为改变的问题，它的出发点是事物的状态，封装状态而暴露行为。

参考：

* [设计模式迷你手册](http://www.uml.org.cn/chanpin/intro/WebHelp/%E8%AE%BE%E8%AE%A1%E6%A8%A1%E5%BC%8F%E8%BF%B7%E4%BD%A0%E6%89%8B%E5%86%8C.htm)
* [Examples of GoF Design Patterns in Java's core libraries](http://stackoverflow.com/questions/1673841/examples-of-gof-design-patterns-in-javas-core-libraries)
* [JDK里的设计模式](http://coolshell.cn/articles/3320.html)
* [设计模式比较](http://my.oschina.net/rainingcn/blog/41458)
