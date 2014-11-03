---
layout: post
title: Java代码规范
description: 写不把别人逼上绝路的代码
category: blog
---


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
	  
块注释可以以/*-开头，这样indent(1)就可以将之识别为一个代码块的开始，而不会重排它。

	/*-
     * Here is a block comment with some very special
     * formatting that I want indent(1) to ignore.
     *
     *    one
     *        two
     *            three
     */
	  
注意：如果你不使用indent(1)，就不必在代码中使用/*-，或为他人可能对你的代码运行indent(1)作让步。

参见"文档注释"

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

若想了解更多，参见"How to Write Doc Comments for Javadoc"，其中包含了有关文档注释标记的信息(@return, @param, @see)：

http://java.sun.com/javadoc/writingdoccomments/index.html

若想了解更多有关文档注释和javadoc的详细资料，参见javadoc的主页：

http://java.sun.com/javadoc/index.html

文档注释描述Java的类、接口、构造器，方法，以及字段(field)。每个文档注释都会被置于注释定界符/**...*/之中，一个注释对应一个类、接口或成员。该注释应位于声明之前：

	/**
	* The Example class provides ...
	*/
	public class Example { ...
	  
注意顶层(top-level)的类和接口是不缩进的，而其成员是缩进的。描述类和接口的文档注释的第一行(/**)不需缩进；随后的文档注释每行都缩进1格(使星号纵向对齐)。成员，包括构造函数在内，其文档注释的第一行缩进4格，随后每行都缩进5格。

若你想给出有关类、接口、变量或方法的信息，而这些信息又不适合写在文档中，则可使用实现块注释(见5.1.1)或紧跟在声明后面的单行注释(见5.1.2)。例如，有关一个类实现的细节，应放入紧跟在类声明后面的实现块注释中，而不是放在文档注释中。

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
- 右大括号"}"另起一行，与相应的声明语句对齐，除非是一个空语句，"}"应紧跟在"{"之后

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
	  
- 方法与方法之间以空行分隔
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
- 块注释（参见"5.1.1"）或单行注释（参见"5.1.2"）之前
- 一个方法内的两个逻辑段之间，用以提高可读性

###空格(Blank Spaces)

下列情况应该使用空格：

- 一个紧跟着括号的关键字应该被空格分开，例如：

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
	
- for语句中的表达式应该被空格分开，例如：

    for (expr1; expr2; expr3)
	  
- 强制转型后应该跟一个空格，例如：

    myMethod((byte) aNum, (Object) x);
    myMethod((int) (cp + 5), ((int) (i + 3)) + 1);
	  
##命名规范(Naming Conventions)

命名规范使程序更易读，从而更易于理解。它们也可以提供一些有关标识符功能的信息，以助于理解代码，例如，不论它是一个常量，包，还是类。

	标识符类型									命名规则										例子
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


[SV]: http://supervisord.org/ "Supervisor"
[Nginx]: http://nginx.com/ "Nginx"
[NovelAssistant]: http://xuanpai.sinaapp.com/ "novel"
