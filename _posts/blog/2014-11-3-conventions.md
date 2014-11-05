---
layout: post
title: Java代码规范
description: 写不把别人逼上绝路的代码。
category: blog
---

##前言

这份文档是Google Java编程风格规范的完整定义。当且仅当一个Java源文件符合此文档中的规则， 我们才认为它符合Google的Java编程风格。

与其它的编程风格指南一样，这里所讨论的不仅仅是编码格式美不美观的问题， 同时也讨论一些约定及编码标准。然而，这份文档主要侧重于我们所普遍遵循的规则， 对于那些不是明确强制要求的，我们尽量避免提供意见。

###术语说明
在本文档中，除非另有说明：

术语class可表示一个普通类，枚举类，接口或是annotation类型(@interface)
术语comment只用来指代实现的注释(implementation comments)，我们不使用“documentation comments”一词，而是用Javadoc。
其他的术语说明会偶尔在后面的文档出现。

###指南说明
本文档中的示例代码并不作为规范。也就是说，虽然示例代码是遵循Google编程风格，但并不意味着这是展现这些代码的唯一方式。 示例中的格式选择不应该被强制定为规则。

##源文件基础

###文件名
源文件以其最顶层的类名来命名，大小写敏感，文件扩展名为.java。

###文件编码：UTF-8
源文件编码格式为UTF-8。

###特殊字符
####空白字符
除了行结束符序列，ASCII水平空格字符(0x20，即空格)是源文件中唯一允许出现的空白字符，这意味着：

所有其它字符串中的空白字符都要进行转义。
制表符不用于缩进。
####特殊转义序列
对于具有特殊转义序列的任何字符(\b, \t, \n, \f, \r, \“, \‘及\)，我们使用它的转义序列，而不是相应的八进制(比如\012)或Unicode(比如\u000a)转义。

####非ASCII字符
对于剩余的非ASCII字符，是使用实际的Unicode字符(比如∞)，还是使用等价的Unicode转义符(比如\u221e)，取决于哪个能让代码更易于阅读和理解。

	Tip: 在使用Unicode转义符或是一些实际的Unicode字符时，建议做些注释给出解释，这有助于别人阅读和理解。
	例如：
	
	String unitAbbrev = "μs";                                 | 赞，即使没有注释也非常清晰
	String unitAbbrev = "\u03bcs"; // "μs"                    | 允许，但没有理由要这样做
	String unitAbbrev = "\u03bcs"; // Greek letter mu, "s"    | 允许，但这样做显得笨拙还容易出错
	String unitAbbrev = "\u03bcs";                            | 很糟，读者根本看不出这是什么
	return '\ufeff' + content; // byte order mark             | Good，对于非打印字符，使用转义，并在必要时写上注释
	Tip: 永远不要由于害怕某些程序可能无法正确处理非ASCII字符而让你的代码可读性变差。当程序无法正确处理非ASCII字符时，它自然无法正确运行， 你就会去fix这些问题的了。(言下之意就是大胆去用非ASCII字符，如果真的有需要的话)
	

##源文件结构

一个源文件包含(按顺序地)：

* 许可证或版权信息(如有需要)
* package语句
* import语句
* 一个顶级类(只有一个)
* 以上每个部分之间用一个空行隔开。

###许可证或版权信息
如果一个文件包含许可证或版权信息，那么它应当被放在文件最前面。

###package语句
package语句不换行，列限制并不适用于package语句。(即package语句写在一行里)

###import语句
####import不要使用通配符
即，不要出现类似这样的import语句：import java.util.*;

####不要换行
import语句不换行，列限制并不适用于import语句。(每个import语句独立成行)

####顺序和间距
import语句可分为以下几组，按照这个顺序，每组由一个空行分隔：

* 所有的静态导入独立成组
* com.google imports(仅当这个源文件是在com.google包下)
* 第三方的包。每个顶级包为一组，字典序。例如：android, com, junit, org, sun
* java imports
* javax imports

组内不空行，按字典序排列。

###类声明
####只有一个顶级类声明
每个顶级类都在一个与它同名的源文件中(当然，还包含.java后缀)。

例外：package-info.java，该文件中可没有package-info类。

####类成员顺序
类的成员顺序对易学性有很大的影响，但这也不存在唯一的通用法则。不同的类对成员的排序可能是不同的。 最重要的一点，每个类应该以某种逻辑去排序它的成员，维护者应该要能解释这种排序逻辑。比如， 新的方法不能总是习惯性地添加到类的结尾，因为这样就是按时间顺序而非某种逻辑来排序的。

#####重载：永不分离
当一个类有多个构造函数，或是多个同名方法，这些函数/方法应该按顺序出现在一起，中间不要放进其它函数/方法。

##格式

术语说明：块状结构(block-like construct)指的是一个类，方法或构造函数的主体。需要注意的是，数组初始化中的初始值可被选择性地视为块状结构(#####节)。

###大括号
####使用大括号(即使是可选的)
大括号与if, else, for, do, while语句一起使用，即使只有一条语句(或是空)，也应该把大括号写上。

####非空块：K&R风格
对于非空块和块状结构，大括号遵循Kernighan和Ritchie风格 (Egyptian brackets):

* 左大括号前不换行
* 左大括号后换行
* 右大括号前换行
* 如果右大括号是一个语句、函数体或类的终止，则右大括号后换行;否则不换行。例如，如果右大括号后面是else或逗号，则不换行。

示例：

	return new MyClass() {
		@Override public void method() {
			if (condition()) {
				try {
					something();
				} catch (ProblemException e) {
					recover();
				}
			}
		}
	};
	


####空块：可以用简洁版本
一个空的块状结构里什么也不包含，大括号可以简洁地写成{}，不需要换行。例外：如果它是一个多块语句的一部分(if/else 或 try/catch/finally) ，即使大括号内没内容，右大括号也要换行。

示例：

	void doNothing() {}
	
###块缩进：2个空格
每当开始一个新的块，缩进增加2个空格，当块结束时，缩进返回先前的缩进级别。缩进级别适用于代码和注释。

###一行一个语句
每个语句后要换行。

###列限制：80或100
一个项目可以选择一行80个字符或100个字符的列限制，除了下述例外，任何一行如果超过这个字符数限制，必须自动换行。

例外：

* 不可能满足列限制的行(例如，Javadoc中的一个长URL，或是一个长的JSNI方法参考)。
* package和import语句。
* 注释中那些可能被剪切并粘贴到shell中的命令行。

###自动换行
术语说明：一般情况下，一行长代码为了避免超出列限制(80或100个字符)而被分为多行，我们称之为自动换行(line-wrapping)。

我们并没有全面，确定性的准则来决定在每一种情况下如何自动换行。很多时候，对于同一段代码会有好几种有效的自动换行方式。

* Tip: 提取方法或局部变量可以在不换行的情况下解决代码过长的问题(是合理缩短命名长度吧)
####从哪里断开
自动换行的基本准则是：更倾向于在更高的语法级别处断开。

如果在非赋值运算符处断开，那么在该符号前断开(比如+，它将位于下一行)。注意：这一点与Google其它语言的编程风格不同(如C++和JavaScript)。 这条规则也适用于以下“类运算符”符号：点分隔符(.)，类型界限中的&（<T extends Foo & Bar>)，catch块中的管道符号(catch (FooException | BarException e)
如果在赋值运算符处断开，通常的做法是在该符号后断开(比如=，它与前面的内容留在同一行)。这条规则也适用于foreach语句中的分号。
方法名或构造函数名与左括号留在同一行。
逗号(,)与其前面的内容留在同一行。
####自动换行时缩进至少+4个空格
自动换行时，第一行后的每一行至少比第一行多缩进4个空格。

当存在连续自动换行时，缩进可能会多缩进不只4个空格(语法元素存在多级时)。一般而言，两个连续行使用相同的缩进当且仅当它们开始于同级语法元素。



###空白
####垂直空白
以下情况需要使用一个空行：

* 类内连续的成员之间：字段，构造函数，方法，嵌套类，静态初始化块，实例初始化块。
* 例外：两个连续字段之间的空行是可选的，用于字段的空行主要用来对字段进行逻辑分组。
* 在函数体内，语句的逻辑分组间使用空行。
* 类内的第一个成员前或最后一个成员后的空行是可选的(既不鼓励也不反对这样做，视个人喜好而定)。
* 要满足本文档中其他节的空行要求
* 多个连续的空行是允许的，但没有必要这样做(我们也不鼓励这样做)。

####水平空白
除了语言需求和其它规则，并且除了文字，注释和Javadoc用到单个空格，单个ASCII空格也出现在以下几个地方：

分隔任何保留字与紧随其后的左括号(()(如if, for catch等)。
分隔任何保留字与其前面的右大括号(})(如else, catch)。
在任何左大括号前({)，两个例外：
@SomeAnnotation({a, b})(不使用空格)。
String[][] x = foo;(大括号间没有空格，见下面的Note)。
在任何二元或三元运算符的两侧。这也适用于以下“类运算符”符号：
类型界限中的&(<T extends Foo & Bar>)。
catch块中的管道符号(catch (FooException | BarException e)。
foreach语句中的分号。
在, : ;及右括号())后
如果在一条语句后做注释，则双斜杠(//)两边都要空格。这里可以允许多个空格，但没有必要。
类型和变量之间：List list。
数组初始化中，大括号内的空格是可选的，即new int[] {5, 6}和new int[] { 5, 6 }都是可以的。
Note：这个规则并不要求或禁止一行的开关或结尾需要额外的空格，只对内部空格做要求。
####水平对齐：不做要求
术语说明：水平对齐指的是通过增加可变数量的空格来使某一行的字符与上一行的相应字符对齐。

这是允许的(而且在不少地方可以看到这样的代码)，但Google编程风格对此不做要求。即使对于已经使用水平对齐的代码，我们也不需要去保持这种风格。

以下示例先展示未对齐的代码，然后是对齐的代码：

	private int x; // this is fine
	private Color color; // this too
	
	private int   x;      // permitted, but future edits
	private Color color;  // may leave it unaligned

* Tip：对齐可增加代码可读性，但它为日后的维护带来问题。考虑未来某个时候，我们需要修改一堆对齐的代码中的一行。 这可能导致原本很漂亮的对齐代码变得错位。很可能它会提示你调整周围代码的空白来使这一堆代码重新水平对齐(比如程序员想保持这种水平对齐的风格)， 这就会让你做许多的无用功，增加了reviewer的工作并且可能导致更多的合并冲突。
###用小括号来限定组：推荐
除非作者和reviewer都认为去掉小括号也不会使代码被误解，或是去掉小括号能让代码更易于阅读，否则我们不应该去掉小括号。 我们没有理由假设读者能记住整个Java运算符优先级表。

###具体结构
####枚举类
枚举常量间用逗号隔开，换行可选。

没有方法和文档的枚举类可写成数组初始化的格式：

	private enum Suit { CLUBS, HEARTS, SPADES, DIAMONDS }
	
由于枚举类也是一个类，因此所有适用于其它类的格式规则也适用于枚举类。

####变量声明
##### 每次只声明一个变量
不要使用组合声明，比如int a, b;。

##### 需要时才声明，并尽快进行初始化
不要在一个代码块的开头把局部变量一次性都声明了(这是c语言的做法)，而是在第一次需要使用它时才声明。 局部变量在声明时最好就进行初始化，或者声明后尽快进行初始化。

####数组
##### 数组初始化：可写成块状结构
数组初始化可以写成块状结构，比如，下面的写法都是OK的：

	new int[] {
	0, 1, 2, 3 
	}
	
	new int[] {
	0,
	1,
	2,
	3
	}
	
	new int[] {
	0, 1,
	2, 3
	}
	
	new int[]
		{0, 1, 2, 3}
		
#####非C风格的数组声明
中括号是类型的一部分：String[] args， 而非String args[]。

####switch语句
术语说明：switch块的大括号内是一个或多个语句组。每个语句组包含一个或多个switch标签(case FOO:或default:)，后面跟着一条或多条语句。

#####缩进
与其它块状结构一致，switch块中的内容缩进为2个空格。

每个switch标签后新起一行，再缩进2个空格，写下一条或多条语句。

##### Fall-through：注释
在一个switch块内，每个语句组要么通过break, continue, return或抛出异常来终止，要么通过一条注释来说明程序将继续执行到下一个语句组， 任何能表达这个意思的注释都是OK的(典型的是用// fall through)。这个特殊的注释并不需要在最后一个语句组(一般是default)中出现。示例：

	switch (input) {
	case 1:
	case 2:
		prepareOneOrTwo();
		// fall through
	case 3:
		handleOneTwoOrThree();
		break;
	default:
		handleLargeNumber(input);
	}
	
##### default的情况要写出来
每个switch语句都包含一个default语句组，即使它什么代码也不包含。

####注解(Annotations)
注解紧跟在文档块后面，应用于类、方法和构造函数，一个注解独占一行。这些换行不属于自动换行，因此缩进级别不变。例如：

	@Override
	@Nullable
	public String getNameIfPresent() { ... }
	例外：单个的注解可以和签名的第一行出现在同一行。例如：
	
	@Override public int hashCode() { ... }
	应用于字段的注解紧随文档块出现，应用于字段的多个注解允许与字段出现在同一行。例如：
	
	@Partial @Mock DataLoader loader;
	参数和局部变量注解没有特定规则。

####注释
##### 块注释风格
块注释与其周围的代码在同一缩进级别。它们可以是/* ... */风格，也可以是// ...风格。对于多行的/* ... */注释，后续行必须从*开始， 并且与前一行的*对齐。以下示例注释都是OK的。

	/*
	* This is          // And so           /* Or you can
	* okay.            // is this.          * even do this. */
	*/
	
注释不要封闭在由星号或其它字符绘制的框架里。

* Tip：在写多行注释时，如果你希望在必要时能重新换行(即注释像段落风格一样)，那么使用/* ... */。
####Modifiers
类和成员的modifiers如果存在，则按Java语言规范中推荐的顺序出现。

public protected private abstract static final transient volatile synchronized native strictfp
##命名约定

###对所有标识符都通用的规则
标识符只能使用ASCII字母和数字，因此每个有效的标识符名称都能匹配正则表达式\w+。

在Google其它编程语言风格中使用的特殊前缀或后缀，如name_, mName, s_name和kName，在Java编程风格中都不再使用。

###标识符类型的规则
####包名
包名全部小写，连续的单词只是简单地连接起来，不使用下划线。

####类名
类名都以UpperCamelCase风格编写。

类名通常是名词或名词短语，接口名称有时可能是形容词或形容词短语。现在还没有特定的规则或行之有效的约定来命名注解类型。

测试类的命名以它要测试的类的名称开始，以Test结束。例如，HashTest或HashIntegrationTest。

####方法名
方法名都以lowerCamelCase风格编写。

方法名通常是动词或动词短语。

下划线可能出现在JUnit测试方法名称中用以分隔名称的逻辑组件。一个典型的模式是：test<MethodUnderTest>_<state>，例如testPop_emptyStack。 并不存在唯一正确的方式来命名测试方法。

####常量名
常量名命名模式为CONSTANT_CASE，全部字母大写，用下划线分隔单词。那，到底什么算是一个常量？

每个常量都是一个静态final字段，但不是所有静态final字段都是常量。在决定一个字段是否是一个常量时， 考虑它是否真的感觉像是一个常量。例如，如果任何一个该实例的观测状态是可变的，则它几乎肯定不会是一个常量。 只是永远不打算改变对象一般是不够的，它要真的一直不变才能将它示为常量。

	// Constants
	static final int NUMBER = 5;
	static final ImmutableList<String> NAMES = ImmutableList.of("Ed", "Ann");
	static final Joiner COMMA_JOINER = Joiner.on(',');  // because Joiner is immutable
	static final SomeMutableType[] EMPTY_ARRAY = {};
	enum SomeEnum { ENUM_CONSTANT }
	
	// Not constants
	static String nonFinal = "non-final";
	final String nonStatic = "non-static";
	static final Set<String> mutableCollection = new HashSet<String>();
	static final ImmutableSet<SomeMutableType> mutableElements = ImmutableSet.of(mutable);
	static final Logger logger = Logger.getLogger(MyClass.getName());
	static final String[] nonEmptyArray = {"these", "can", "change"};
	
这些名字通常是名词或名词短语。

####非常量字段名
非常量字段名以lowerCamelCase风格编写。

这些名字通常是名词或名词短语。

####参数名
参数名以lowerCamelCase风格编写。

参数应该避免用单个字符命名。

####局部变量名
局部变量名以lowerCamelCase风格编写，比起其它类型的名称，局部变量名可以有更为宽松的缩写。

虽然缩写更宽松，但还是要避免用单字符进行命名，除了临时变量和循环变量。

即使局部变量是final和不可改变的，也不应该把它示为常量，自然也不能用常量的规则去命名它。

####类型变量名
类型变量可用以下两种风格之一进行命名：

单个的大写字母，后面可以跟一个数字(如：E, T, X, T2)。
以类命名方式，后面加个大写的T(如：RequestT, FooBarT)。
###驼峰式命名法(CamelCase)
驼峰式命名法分大驼峰式命名法(UpperCamelCase)和小驼峰式命名法(lowerCamelCase)。 有时，我们有不只一种合理的方式将一个英语词组转换成驼峰形式，如缩略语或不寻常的结构(例如"IPv6"或"iOS")。Google指定了以下的转换方案。

名字从散文形式(prose form)开始:

把短语转换为纯ASCII码，并且移除任何单引号。例如："Müller’s algorithm"将变成"Muellers algorithm"。
把这个结果切分成单词，在空格或其它标点符号(通常是连字符)处分割开。
推荐：如果某个单词已经有了常用的驼峰表示形式，按它的组成将它分割开(如"AdWords"将分割成"ad words")。 需要注意的是"iOS"并不是一个真正的驼峰表示形式，因此该推荐对它并不适用。
现在将所有字母都小写(包括缩写)，然后将单词的第一个字母大写：
每个单词的第一个字母都大写，来得到大驼峰式命名。
除了第一个单词，每个单词的第一个字母都大写，来得到小驼峰式命名。
最后将所有的单词连接起来得到一个标识符。
示例：

	Prose form                Correct               Incorrect
	------------------------------------------------------------------
	"XML HTTP request"        XmlHttpRequest        XMLHTTPRequest
	"new customer ID"         newCustomerId         newCustomerID
	"inner stopwatch"         innerStopwatch        innerStopWatch
	"supports IPv6 on iOS?"   supportsIpv6OnIos     supportsIPv6OnIOS
	"YouTube importer"        YouTubeImporter
							YoutubeImporter*
	加星号处表示可以，但不推荐。

* Note：在英语中，某些带有连字符的单词形式不唯一。例如："nonempty"和"non-empty"都是正确的，因此方法名checkNonempty和checkNonEmpty也都是正确的。
##编程实践

###@Override：能用则用
只要是合法的，就把@Override注解给用上。

###捕获的异常：不能忽视
除了下面的例子，对捕获的异常不做响应是极少正确的。(典型的响应方式是打印日志，或者如果它被认为是不可能的，则把它当作一个AssertionError重新抛出。)

如果它确实是不需要在catch块中做任何响应，需要做注释加以说明(如下面的例子)。

	try {
		int i = Integer.parseInt(response);
		return handleNumericResponse(i);
	} catch (NumberFormatException ok) {
		// it's not numeric; that's fine, just continue
	}
	return handleTextResponse(response);
	
例外：在测试中，如果一个捕获的异常被命名为expected，则它可以被不加注释地忽略。下面是一种非常常见的情形，用以确保所测试的方法会抛出一个期望中的异常， 因此在这里就没有必要加注释。

	try {
	  emptyStack.pop();
	  fail();
	} catch (NoSuchElementException expected) {
	}
	
###静态成员：使用类进行调用
使用类名调用静态的类成员，而不是具体某个对象或表达式。

	Foo aFoo = ...;
	Foo.aStaticMethod(); // good
	aFoo.aStaticMethod(); // bad
	somethingThatYieldsAFoo().aStaticMethod(); // very bad
	
###Finalizers: 禁用
极少会去重载Object.finalize。

* Tip：不要使用finalize。如果你非要使用它，请先仔细阅读和理解Effective Java 第7条款：“Avoid Finalizers”，然后不要使用它。
##Javadoc

###格式
####一般形式
Javadoc块的基本格式如下所示：

	/**
	* Multiple lines of Javadoc text are written here,
	* wrapped normally...
	*/
	public int method(String p1) { ... }
	
或者是以下单行形式：

	/** An especially short bit of Javadoc. */

基本格式总是OK的。当整个Javadoc块能容纳于一行时(且没有Javadoc标记@XXX)，可以使用单行形式。

####段落
空行(即，只包含最左侧星号的行)会出现在段落之间和Javadoc标记(@XXX)之前(如果有的话)。 除了第一个段落，每个段落第一个单词前都有标签<p>，并且它和第一个单词间没有空格。

####Javadoc标记
标准的Javadoc标记按以下顺序出现：@param, @return, @throws, @deprecated, 前面这4种标记如果出现，描述都不能为空。 当描述无法在一行中容纳，连续行需要至少再缩进4个空格。

###摘要片段
每个类或成员的Javadoc以一个简短的摘要片段开始。这个片段是非常重要的，在某些情况下，它是唯一出现的文本，比如在类和方法索引中。

这只是一个小片段，可以是一个名词短语或动词短语，但不是一个完整的句子。它不会以A {@code Foo} is a...或This method returns...开头, 它也不会是一个完整的祈使句，如Save the record...。然而，由于开头大写及被加了标点，它看起来就像是个完整的句子。

* Tip：一个常见的错误是把简单的Javadoc写成/** @return the customer ID */，这是不正确的。它应该写成/** Returns the customer ID. */。
###哪里需要使用Javadoc
至少在每个public类及它的每个public和protected成员处使用Javadoc，以下是一些例外：

####例外：不言自明的方法
对于简单明显的方法如getFoo，Javadoc是可选的(即，是可以不写的)。这种情况下除了写“Returns the foo”，确实也没有什么值得写了。

单元测试类中的测试方法可能是不言自明的最常见例子了，我们通常可以从这些方法的描述性命名中知道它是干什么的，因此不需要额外的文档说明。

Tip：如果有一些相关信息是需要读者了解的，那么以上的例外不应作为忽视这些信息的理由。例如，对于方法名getCanonicalName， 就不应该忽视文档说明，因为读者很可能不知道词语canonical name指的是什么。
####例外：重载
如果一个方法重载了超类中的方法，那么Javadoc并非必需的。

####可选的Javadoc
对于包外不可见的类和方法，如有需要，也是要使用Javadoc的。如果一个注释是用来定义一个类，方法，字段的整体目的或行为， 那么这个注释应该写成Javadoc，这样更统一更友好。

##后记

本文档翻译自Google Java Style， 译者@Hawstein。



##还有

##文件组织(File Organization)

一个文件由被空行分割而成的段落以及标识每个段落的可选注释共同组成。超过2000行的程序难以阅读，应该尽量避免。"Java源文件范例"提供了一个布局合理的Java程序范例。

###Java源文件(Java Source Files)

每个Java源文件都包含一个单一的公共类或接口。若私有类和接口与一个公共类相关联，可以将它们和公共类放入同一个源文件。公共类必须是这个文件中的第一个类或接口。

Java源文件还遵循以下规则：

- 开头注释（参见"开头注释"）
- 包和引入语句（参见"包和引入语句"）
- 类和接口声明（参见"类和接口声明"）

####开头注释(Beginning Comments)

所有的源文件都应该在开头有一个C语言风格的注释，其中列出类名、版本信息、日期和版权声明：

	/*
	* Classname
	*
	* Version information
	*
	* Date
	*
	* Copyright notice
	*/
	  
####包和引入语句(Package and Import Statements)

在多数Java源文件中，第一个非注释行是包语句。在它之后可以跟引入语句。例如：

	package java.awt;
	
	import java.awt.peer.CanvasPeer;
	  
####类和接口声明(Class and Interface Declarations)

下表描述了类和接口声明的各个部分以及它们出现的先后次序。参见"Java源文件范例"中一个包含注释的例子。

	类/接口声明的各部分							注解
	类/接口文档注释(/**……*/)	该注释中所需包含的信息，参见"文档注释"
	类或接口的声明	 
	类/接口实现的注释(/*……*/)	如果有必要的话	该注释应包含任何有关整个类或接口的信息，而这些信息又不适合作为类/接口文档注释。
	类的(静态)变量	首先是类的公共变量，随后是保护变量，再后是包一级别的变量(没有访问修饰符，access modifier)，最后是私有变量。
	实例变量	首先是公共级别的，随后是保护级别的，再后是包一级别的(没有访问修饰符)，最后是私有级别的。
	构造器	 
	方法	这些方法应该按功能，而非作用域或访问权限，分组。例如，一个私有的类方法可以置于两个公有的实例方法之间。其目的是为了更便于阅读和理解代码。

##缩进排版(Indentation)

4个空格常被作为缩进排版的一个单位。缩进的确切解释并未详细指定(空格 vs. 制表符)。一个制表符等于8个空格(而非4个)。

###行长度(Line Length)

尽量避免一行的长度超过80个字符，因为很多终端和工具不能很好处理之。

注意：用于文档中的例子应该使用更短的行长，长度一般不超过70个字符。

###换行(Wrapping Lines)

当一个表达式无法容纳在一行内时，可以依据如下一般规则断开之：

- 在一个逗号后面断开
- 在一个操作符前面断开
- 宁可选择较高级别(higher-level)的断开，而非较低级别(lower-level)的断开
- 新的一行应该与上一行同一级别表达式的开头处对齐
- 如果以上规则导致你的代码混乱或者使你的代码都堆挤在右边，那就代之以缩进8个空格。

以下是断开方法调用的一些例子：

	someMethod(longExpression1, longExpression2, longExpression3, 
					longExpression4, longExpression5);
	
	var = someMethod1(longExpression1, 
							someMethod2(longExpression2, 
												longExpression3));
	  
以下是两个断开算术表达式的例子。前者更好，因为断开处位于括号表达式的外边，这是个较高级别的断开。

	longName1 = longName2 * (longName3 + longName4 - longName5)
					+ 4 * longname6; //PREFFER
	
	longName1 = longName2 * (longName3 + longName4 
										- longName5) + 4 * longname6; //AVOID
	  
以下是两个缩进方法声明的例子。前者是常规情形。后者若使用常规的缩进方式将会使第二行和第三行移得很靠右，所以代之以缩进8个空格

	//CONVENTIONAL INDENTATION
	someMethod(int anArg, Object anotherArg, String yetAnotherArg, 
					Object andStillAnother) {
	...
	}
	
	//INDENT 8 SPACES TO AVOID VERY DEEP INDENTS
	private static synchronized horkingLongMethodName(int anArg,
			Object anotherArg, String yetAnotherArg,
			Object andStillAnother) {
	...
	}
	  
if语句的换行通常使用8个空格的规则，因为常规缩进(4个空格)会使语句体看起来比较费劲。比如：

	//DON’T USE THIS INDENTATION
	if ((condition1 && condition2)
		|| (condition3 && condition4)
		||!(condition5 && condition6)) { //BAD WRAPS
		doSomethingAboutIt();             //MAKE THIS LINE EASY TO MISS
	}
	
	//USE THIS INDENTATION INSTEAD
	if ((condition1 && condition2)
			|| (condition3 && condition4)
			||!(condition5 && condition6)) {
		doSomethingAboutIt();
	}
	
	//OR USE THIS
	if ((condition1 && condition2) || (condition3 && condition4)
			||!(condition5 && condition6)) {
		doSomethingAboutIt();
	}
	  
这里有三种可行的方法用于处理三元运算表达式：

	alpha = (aLongBooleanExpression) ? beta : gamma;
	
	alpha = (aLongBooleanExpression) ? beta
									: gamma;
	
	alpha = (aLongBooleanExpression)
			? beta
			: gamma;
	  
##注释(Comments)

Java程序有两类注释：实现注释(implementation comments)和文档注释(document comments)。实现注释是那些在C++中见过的，使用/*...*/和//界定的注释。文档注释(被称为"doc comments")是Java独有的，并由/**...*/界定。文档注释可以通过javadoc工具转换成HTML文件。

实现注释用以注释代码或者实现细节。文档注释从实现自由(implementation-free)的角度描述代码的规范。它可以被那些手头没有源码的开发人员读懂。

注释应被用来给出代码的总括，并提供代码自身没有提供的附加信息。注释应该仅包含与阅读和理解程序有关的信息。例如，相应的包如何被建立或位于哪个目录下之类的信息不应包括在注释中。

在注释里，对设计决策中重要的或者不是显而易见的地方进行说明是可以的，但应避免提供代码中己清晰表达出来的重复信息。多余的的注释很容易过时。通常应避免那些代码更新就可能过时的注释。

注意：频繁的注释有时反映出代码的低质量。当你觉得被迫要加注释的时候，考虑一下重写代码使其更清晰。

注释不应写在用星号或其他字符画出来的大框里。注释不应包括诸如制表符和回退符之类的特殊字符。

###实现注释的格式(Implementation Comment Formats)

程序可以有4种实现注释的风格：块(block)、单行(single-line)、尾端(trailing)和行末(end-of-line)。

####块注释(Block Comments)

块注释通常用于提供对文件，方法，数据结构和算法的描述。块注释被置于每个文件的开始处以及每个方法之前。它们也可以被用于其他地方，比如方法内部。在功能和方法内部的块注释应该和它们所描述的代码具有一样的缩进格式。

块注释之首应该有一个空行，用于把块注释和代码分割开来，比如：

	/*
	* Here is a block comment.
	*/
	  

####单行注释(Single-Line Comments)

短注释可以显示在一行内，并与其后的代码具有一样的缩进层级。如果一个注释不能在一行内写完，就该采用块注释(参见"块注释")。单行注释之前应该有一个空行。以下是一个Java代码中单行注释的例子：

	if (condition) {
	
		/* Handle the condition. */
		...
	}
	  
####尾端注释(Trailing Comments)

极短的注释可以与它们所要描述的代码位于同一行，但是应该有足够的空白来分开代码和注释。若有多个短注释出现于大段代码中，它们应该具有相同的缩进。

以下是一个Java代码中尾端注释的例子：

	if (a == 2) {
		return TRUE;              /* special case */
	} else {
		return isPrime(a);         /* works only for odd a */
	}
	  
####行末注释(End-Of-Line Comments)

注释界定符"//"，可以注释掉整行或者一行中的一部分。它一般不用于连续多行的注释文本；然而，它可以用来注释掉连续多行的代码段。以下是所有三种风格的例子：

	if (foo > 1) {
	
		// Do a double-flip.
		...
	}
	else {
		return false;          // Explain why here.
	}
	
	//if (bar > 1) {
	//
	//    // Do a triple-flip.
	//    ...
	//}
	//else {
	//    return false;
	//}
	  
###文档注释(Documentation Comments)

注意：此处描述的注释格式之范例，参见"Java源文件范例"

若想了解更多，参见[javadoc][javadoc]。


文档注释描述Java的类、接口、构造器，方法，以及字段(field)。每个文档注释都会被置于注释定界符/**...*/之中，一个注释对应一个类、接口或成员。该注释应位于声明之前：

	/**
	* The Example class provides ...
	*/
	public class Example { ...
	  
注意顶层(top-level)的类和接口是不缩进的，而其成员是缩进的。描述类和接口的文档注释的第一行(/**)不需缩进；随后的文档注释每行都缩进1格(使星号纵向对齐)。成员，包括构造函数在内，其文档注释的第一行缩进4格，随后每行都缩进5格。

若你想给出有关类、接口、变量或方法的信息，而这些信息又不适合写在文档中，则可使用实现块注释或紧跟在声明后面的单行注释。例如，有关一个类实现的细节，应放入紧跟在类声明后面的实现块注释中，而不是放在文档注释中。

文档注释不能放在一个方法或构造器的定义块中，因为Java会将位于文档注释之后的第一个声明与其相关联。

##声明(Declarations)

###每行声明变量的数量(Number Per Line)

推荐一行一个声明，因为这样以利于写注释。亦即，

	int level;  // indentation level
	int size;   // size of table
	  
要优于，

	int level, size;

不要将不同类型变量的声明放在同一行，例如：

	int foo,  fooarray[];   //WRONG!
	  
注意：上面的例子中，在类型和标识符之间放了一个空格，另一种被允许的替代方式是使用制表符：

	int		level;         // indentation level
	int		size;          // size of table
	Object	currentEntry;  // currently selected table entry
	  
###初始化(Initialization)

尽量在声明局部变量的同时初始化。唯一不这么做的理由是变量的初始值依赖于某些先前发生的计算。

###布局(Placement)

只在代码块的开始处声明变量。（一个块是指任何被包含在大括号"{"和"}"中间的代码。）不要在首次用到该变量时才声明之。这会把注意力不集中的程序员搞糊涂，同时会妨碍代码在该作用域内的可移植性。

	void myMethod() {
		int int1 = 0;         // beginning of method block
	
		if (condition) {
			int int2 = 0;     // beginning of "if" block
			...
		}
	}
	  
该规则的一个例外是for循环的索引变量

	for (int i = 0; i < maxLoops; i++) { ... }
	  
避免声明的局部变量覆盖上一级声明的变量。例如，不要在内部代码块中声明相同的变量名：

	int count;
	...
	myMethod() {
		if (condition) {
			int count = 0;     // AVOID!
			...
		}
		...
	}
	  
###类和接口的声明(Class and Interface Declarations)

当编写类和接口是，应该遵守以下格式规则：

- 在方法名与其参数列表之前的左括号"("间不要有空格
- 左大括号"{"位于声明语句同行的末尾
- 方法与方法之间以空行分隔
- 右大括号"}"另起一行，与相应的声明语句对齐，除非是一个空语句，"}"应紧跟在"{"之后

例如：

	class Sample extends Object {
		int ivar1;
		int ivar2;
	
		Sample(int i, int j) {
			ivar1 = i;
			ivar2 = j;
		}
	
		int emptyMethod() {}
	
		...
	}
	  

##语句(Statements)

###简单语句(Simple Statements)

每行至多包含一条语句，例如：

	argv++;       // Correct
	argc--;       // Correct
	argv++; argc--;       // AVOID!
	  
###复合语句(Compound Statements)

复合语句是包含在大括号中的语句序列，形如"{ 语句 }"。例如下面各段。

- 被括其中的语句应该较之复合语句缩进一个层次
- 左大括号"{"应位于复合语句起始行的行尾；右大括号"}"应另起一行并与复合语句首行对齐。
- 大括号可以被用于所有语句，包括单个语句，只要这些语句是诸如if-else或for控制结构的一部分。这样便于添加语句而无需担心由于忘了加括号而引入bug。

###返回语句(return Statements)

一个带返回值的return语句不使用小括号"()"，除非它们以某种方式使返回值更为显见。例如：

	return;
	
	return myDisk.size();
	
	return (size ? size : defaultSize);
	  
###if，if-else，if else-if else语句(if, if-else, if else-if else Statements)

if-else语句应该具有如下格式：

	if (condition) {
		statements;
	}
	
	if (condition) {
		statements;
	} else {
		statements;
	}
	
	if (condition) {
		statements;
	} else if (condition) {
		statements;
	} else{
		statements;
	}
	  
注意：if语句总是用"{"和"}"括起来，避免使用如下容易引起错误的格式：

	if (condition) //AVOID! THIS OMITS THE BRACES {}!
		statement;
	  
##for语句(for Statements)

一个for语句应该具有如下格式：

	for (initialization; condition; update) {
		statements;
	}
	  
一个空的for语句(所有工作都在初始化，条件判断，更新子句中完成）应该具有如下格式：

	for (initialization; condition; update);
	  
当在for语句的初始化或更新子句中使用逗号时，避免因使用三个以上变量，而导致复杂度提高。若需要，可以在for循环之前(为初始化子句)或for循环末尾(为更新子句)使用单独的语句。

##while语句(while Statements)

一个while语句应该具有如下格式

	while (condition) {
		statements;
	}
	  
一个空的while语句应该具有如下格式：

	while (condition);
	  
##do-while语句(do-while Statements)

一个do-while语句应该具有如下格式：

	do {
		statements;
	} while (condition);
	  
##switch语句(switch Statements)

一个switch语句应该具有如下格式：

	switch (condition) {
	case ABC:
		statements;
		/* falls through */
	case DEF:
		statements;
		break;
	
	case XYZ:
		statements;
		break;
	
	default:
		statements;
		break;
	}
	  
每当一个case顺着往下执行时(因为没有break语句)，通常应在break语句的位置添加注释。上面的示例代码中就包含注释/* falls through */。

##try-catch语句(try-catch Statements)

一个try-catch语句应该具有如下格式：

	try {
		statements;
	} catch (ExceptionClass e) {
		statements;
	}
	  
一个try-catch语句后面也可能跟着一个finally语句，不论try代码块是否顺利执行完，它都会被执行。

	try {
		statements;
	} catch (ExceptionClass e) {
		statements;
	} finally {
		statements;
	}
	  
##空白(White Space)

###空行(Blank Lines)

空行将逻辑相关的代码段分隔开，以提高可读性。

下列情况应该总是使用两个空行：

- 一个源文件的两个片段(section)之间
- 类声明和接口声明之间

下列情况应该总是使用一个空行：

- 两个方法之间
- 方法内的局部变量和方法的第一条语句之间
- 块注释或单行注释之前
- 一个方法内的两个逻辑段之间，用以提高可读性

###空格(Blank Spaces)

下列情况应该使用空格：

- 一个紧跟着括号的关键字应该被空格分开，

例如：

	while (true) {
		...
	}
	  
注意：空格不应该置于方法名与其左括号之间。这将有助于区分关键字和方法调用。
- 空白应该位于参数列表中逗号的后面
- 所有的二元运算符，除了"."，应该使用空格将之与操作数分开。一元操作符和操作数之间不因该加空格，比如：负号("-")、自增("++")和自减("--")。例如：

	a += c + d;
	a = (a + b) / (c * d);
	
	while (d++ = s++) {
		n++;
	}
	printSize("size is " + foo + "\n");
	
- for语句中的表达式应该被空格分开，

例如：

    for (expr1; expr2; expr3)
	  
- 强制转型后应该跟一个空格，

例如：

    myMethod((byte) aNum, (Object) x);
    myMethod((int) (cp + 5), ((int) (i + 3)) + 1);
	  
##命名规范(Naming Conventions)

命名规范使程序更易读，从而更易于理解。它们也可以提供一些有关标识符功能的信息，以助于理解代码，例如，不论它是一个常量，包，还是类。

	标识符类型								命名规则										例子
	包(Packages)	一个唯一包名的前缀总是全部小写的ASCII字母并且是一个顶级域名，   com.sun.eng
					通常是com，edu，gov，mil，net，org，或1981年ISO 3166标准所指	com.apple.quicktime.v2
					定的标识国家的英文双字符代码。包名的后续部分根据不同机构各自	edu.cmu.cs.bovik.cheese
					内部的命名规范而不尽相同。这类命名规范可能以特定目录名的组成
					来区分部门(department)，项目(project)，机器(machine)，或注册
					名(login names)。	


	类(Classes)		命名规则：类名是个一名词，采用大小写混合的方式，每个单词的首	edu.cmu.cs.bovik.cheese
					字母大写。尽量使你的类名简洁而富于描述。使用完整单词，避免缩	class ImageSprite;
					写词(除非该缩写词被更广泛使用，像URL，HTML)

	接口(Interfaces)	命名规则：大小写规则与类名相似								interface RasterDelegate;interface Storing;

	方法(Methods)	方法名是一个动词，采用大小写混合的方式，第一个单词的首字母小	run();  runFast(); getBackground();
					写，其后单词的首字母大写。	


	变量(Variables)	除了变量名外，所有实例，包括类，类常量，均采用大小写混合的方	char c;
					式，第一个单词的首字母小写，其后单词的首字母大写。变量名不应	int i;
					以下划线或美元符号开头，尽管这在语法上是允许的。变量名应简短	float myWidth;
					且富于描述。变量名的选用应该易于记忆，即，能够指出其用途。尽
					量避免单个字符的变量名，除非是一次性的临时变量。临时变量通常
					被取名为i，j，k，m和n，它们一般用于整型；c，d，e，它们一般用
					于字符型。	


	实例变量(Instance Variables)  大小写规则和变量名相似，除了前面需要一个下划线	int _employeeId;String _name;Customer _customer;


	常量(Constants)	类常量和ANSI常量的声明，应该全部大写，单词间用下划线隔开。(尽	static final int MIN_WIDTH = 4;static final int MAX_WIDTH = 999;
					量避免ANSI常量，容易引起错误)									static final int GET_THE_CPU = 1;



##编程惯例(Programming Practices)

###提供对实例以及类变量的访问控制(Providing Access to Instance and Class Variables)

若没有足够理由，不要把实例或类变量声明为公有。通常，实例变量无需显式的设置(set)和获取(gotten)，通常这作为方法调用的边缘效应 (side effect)而产生。

一个具有公有实例变量的恰当例子，是类仅作为数据结构，没有行为。亦即，若你要使用一个结构(struct)而非一个类(如果java支持结构的话)，那么把类的实例变量声明为公有是合适的。

###引用类变量和类方法(Referring to Class Variables and Methods)

避免用一个对象访问一个类的静态变量和方法。应该用类名替代。例如：
	
	classMethod();             //OK
	AClass.classMethod();      //OK
	anObject.classMethod();    //AVOID!
	  
###常量(Constants)

位于for循环中作为计数器值的数字常量，除了-1,0和1之外，不应被直接写入代码。

###变量赋值(Variable Assignments)

避免在一个语句中给多个变量赋相同的值。它很难读懂。例如：

	fooBar.fChar = barFoo.lchar = 'c'; // AVOID!
	  
不要将赋值运算符用在容易与相等关系运算符混淆的地方。例如：

	if (c++ = d++) {        // AVOID! (Java disallows)
		...
	}
	  
应该写成
	
	if ((c++ = d++) != 0) {
	...
	}
	  
不要使用内嵌(embedded)赋值运算符试图提高运行时的效率，这是编译器的工作。例如：

	d = (a = b + c) + r;        // AVOID!
	  
应该写成

	a = b + c;
	d = a + r;
	  
###其它惯例(Miscellaneous Practices)

####圆括号(Parentheses)

一般而言，在含有多种运算符的表达式中使用圆括号来避免运算符优先级问题，是个好方法。即使运算符的优先级对你而言可能很清楚，但对其他人未必如此。你不能假设别的程序员和你一样清楚运算符的优先级。

	if (a == b && c == d)     // AVOID!
	if ((a == b) && (c == d))  // RIGHT
	  
####返回值(Returning Values)

设法让你的程序结构符合目的。

	例如：
	
	if (booleanExpression) {
		return true;
	} else {
		return false;
	}
	
	应该代之以如下方法：
	
	return booleanExpression;
	
	类似地：
	
	if (condition) {
		return x;
	}
	return y;
	  
	应该写做：

	return (condition ? x : y);
	  
####条件运算符"?"前的表达式(Expressions before '?' in the Conditional Operator)

如果一个包含二元运算符的表达式出现在三元运算符" ? : "的"?"之前，那么应该给表达式添上一对圆括号。例如：

	(x >= 0) ? x : -x;
	  
####特殊注释(Special Comments)

在注释中使用XXX来标识某些未实现(bogus)的但可以工作(works)的内容。用FIXME来标识某些假的和错误的内容。

##代码范例(Code Examples)

###Java源文件范例(Java Source File Example)

下面的例子，展示了如何合理布局一个包含单一公共类的Java源程序。接口的布局与其相似。更多信息参见"类和接口声明"以及"文挡注释"。

	/*
	* @(#)Blah.java        1.82 99/03/18
	*
	* Copyright (c) 1994-1999 Sun Microsystems, Inc.
	* 901 San Antonio Road, Palo Alto, California, 94303, U.S.A.
	* All rights reserved.
	*
	* This software is the confidential and proprietary information of Sun
	* Microsystems, Inc. ("Confidential Information").  You shall not
	* disclose such Confidential Information and shall use it only in
	* accordance with the terms of the license agreement you entered into
	* with Sun.
	*/
	
	
	package java.blah;
	
	import java.blah.blahdy.BlahBlah;
	
	/**
	* Class description goes here.
	*
	* @version 	1.82 18 Mar 1999
	* @author 	Firstname Lastname
	*/
	public class Blah extends SomeClass {
		/* A class implementation comment can go here. */
	
		/** classVar1 documentation comment */
		public static int classVar1;
	
		/**
		* classVar2 documentation comment that happens to be
		* more than one line long
		*/
		private static Object classVar2;
	
		/** instanceVar1 documentation comment */
		public Object instanceVar1;
	
		/** instanceVar2 documentation comment */
		protected int instanceVar2;
	
		/** instanceVar3 documentation comment */
		private Object[] instanceVar3;
	
		/**
		* ...constructor Blah documentation comment...
		*/
		public Blah() {
			// ...implementation goes here...
		}
	
		/**
		* ...method doSomething documentation comment...
		*/
		public void doSomething() {
			// ...implementation goes here...
		}
	
		/**
		* ...method doSomethingElse documentation comment...
		* @param someParam description
		*/
		public void doSomethingElse(Object someParam) {
			// ...implementation goes here...
		}
	}

	

[javadoc]:http://java.sun.com/javadoc/writingdoccomments/index.html "How to Write Doc Comments for Javadoc"

[SV]: http://supervisord.org/ "Supervisor"
[Nginx]: http://nginx.com/ "Nginx"
[NovelAssistant]: http://xuanpai.sinaapp.com/ "novel"
