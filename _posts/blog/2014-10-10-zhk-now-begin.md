---
layout: post
title: 编程工具
description: 工欲善其事必先利其器。关键字：Vim, Sublime Text2, Notepad++, secureCTR, beyondcompare, StackEdit
category: blog
---

曾经有个叫兽说游戏的本质是打怪升级换装备，其实人生又何尝不是如此呢？

<ul>
  <li><a href="https://zorrock.disqus.com/admin/settings/universalcode/" target="_blank" class="external">disqus添加到你的博客</a></li>
  <li><a href="https://zorrock.disqus.com/admin/settings/universalcode/" target="_blank" class="external">流量统计系统</a></li>
  <li><a href="http://www.linezing.com/login2.php" target="_blank" class="external">IP来源分析</a></li>
  <li><a href="http://ip.taobao.com/ipSearch.php?ipAddr=101.71.243.139" target="_blank" class="external">淘宝IP地址库</a></li>
  <li><a href="http://ip.taobao.com/ipSearch.php?ipAddr=101.71.243.139" target="_blank" class="external">并行逻辑回归</a></li>
  <li><a href="http://xuanpai.sinaapp.com/fuzhus" target="_blank" class="external">网络小说辅助设定</a></li>
</ul>

我们目标实现一个支持多个独立域名网站的线上Python环境，这会用到[Virtualenv][SV]，[Nginx][Nginx]。

##为每个APP创建Virtualenv

[Virtualenv][VE]可以为每个Python应用创建独立的开发环境，使他们互不影响，Virtualenv能够做到：
<ul>
  <li>在没有权限的情况下安装新套件</li>
  <li>不同应用可以使用不同的套件版本</li>
  <li>套件升级不影响其他应用</li>
</ul>

##安装Flask

最终的目录结构应该是这样的

    /home/
    └── bob  //用户目录
    │   ├── logs
    │   └── dylan  //项目目录
    │       ├── bin
    │       │   └── python
    │       ├── lib
    │       │   └── python2.7
    │       ├── local
    │       │   └── lib -> /home/shenye/shenyefuli/lib
    │       │
    │       │ //以上目录是Virtualenv生成的
    │       ├── gunicorn_conf.py  //Gunicorn的配置文件
    │       └── runserver.py  //hello_world程序
    │
    └── michael  //用户目录
        ├── logs
        └── jackson //项目目录
            ├── bin
            │   ├── activate
            │   └── python
            ├── include
            │   └── python2.7 -> /usr/include/python2.7
            ├── lib
            └── runserver.py  //hello_world程序

##oracle的几条命令

	lsnrctl status 
	lsnrctl start
	sqlplus nolog
	conn / as sysdba
	conn sys/123@orcl as sysdba
	startup
	shutdown
	

###不要在构造过程中使this引用逸出
一个常见的错误就是在构造函数中启动一个线程，要是希望在构造函数中注册一个事件监听器和启动线程，可以由一个私有的构造函数和公共的工厂方法来避免。
	
	public class SafeListener {
		private final EventListener listener;
		
		private SafeListener() {
			listener = new EventListener() {
				public void onEvent(Event e) {
					SafeListener safe = new SafeListener();
					source.registerListener(safe.listener);
					return safe;
				}
			};			
		}
	}

	
###线程封闭
只在单线程内访问数据部共享数据叫线程封闭。常见的两种技术为Swing和JDBC。其中JDBC不要求Connection对象线程安全，对servlet而言，都是由单个线程采用同步的方式来处理，并且在Connection对象返回前，连接池不再将其分配给其他线程，这种连接管理模式在处理请求时隐含地将Connection对象封闭于线程中。

* Ad-hoc线程封闭 比较脆弱，尽量少用。
* 栈封闭	
* ThreadLocal类 维持线程封闭性更规范的方法。ThreadLocal对象通常用于防止对可变的单实例变量或全局变量进行共享。

####栈封闭实例

	public int loadTheArk(Collection<Animal> candidates) {
		SortedSet<Animal> animals;
		int numPairs = 0;
		Animal candidate = null;
		
		//animals被封闭在方法中，不要使他们逸出
		animals = new TreeSet<Animal>(new SpeciesGenderComparator());
		animals.addAll(candidates);
		for(Animal a:animals) {
			if(candidate == null || candidate.isPotentialMate(a))
				candidate = a;
			else {
				ark.load(new AnimalPair(candidate, a));
				++numPairs;
				candidate = null;
			}
		}
		return numPairs;		
	}


####栈封闭实例

	private static ThreadLocal<Connection> connectionHolder
		= new ThreadLocal<Connection>() {
			public Connection initialValue() {
				return DriverManager.getConnection(DB_URL);
			}
		};
		
	public static Connection getConnection() {
		return connectionHolder.get();
	}

##不变性
不可变对象一定是线程安全的。

	@Immutable
	public final class ThreeStooges {
		private final Set<String> stooges = new HashSet<String>();
		
		public ThreeStooges() {
			stooges.add("Moe");
			stooges.add("Larry");
			stooges.add("Curly");
		}
		
		public boolean isStooge(String name) {
			return stooges.contains(name);
		}
	}
	
* Final域 如“除非需要更高的可见性，否则应该将所有的域声明为私有域。”，除非需要某个域是可变的，否则应将其声明为final域。

* 使用Volatile类型来发布不可变对象

####实例
	@Immutable
	class OneValueCache {
		private final BigInteger lastNumber;
		private final BigInteger[] lastFactors;
		
		public OneValueCache(BigInteger i,
							BigInteger[] factors) {
			lastNumber = i;
			lastFactors = Array.copyOf(factors, factors.length);
							
		}
		
		public BigInteger[] getFactors(BigInteger i) {
			if(lastNumber == null || !lastNumber.equal(i)) {
				return null;
			} else {
				return Array.copyOf(lastFactors, lastFactors.length);
			}
			
		}
	}
	
	
	@ThreadSafe
	public class VolatileCachedFactorizer implements Servlet {
		private volatile OneValueCache cache = 
			new OneValueCache(null, null);
			
		public void service(ServletRequest req, ServletResponse resp) {
			BigInteger i = extractFromRequest(req);
			BigInteger[] factors = cache.getFactors(i);
			if(factors == null) {
				factors = factor(i);
				cache = new OneValueCache(i, factors);				
			}
			encodeIntoResponse(resp, factors);			
		}
	}

##安全发布
任何线程都可以在不需要额外同步的情况下安全地访问不可变对象，即使在发布这些对象时没有使用同步。
安全发布的常用模式 
在静态初始化函数中初始化一个对象引用。
将对象的引用保存到volatile类型的域或者AtomicReferance对象中。
将对象的引用保存到某个正确构造对象的final类型域中。
将对象的引用保存到一个由锁保护的域中。








[SV]: http://supervisord.org/ "Supervisor"
[Nginx]: http://nginx.com/ "Nginx"
