---
layout: post
title: 编程工具
description: 工欲善其事必先利其器。关键字：Vim, Sublime Text2, Notepad++, secureCTR, beyondcompare, StackEdit
category: blog
---

世事如棋局常新，人生如戏靠演技。曾经有人说游戏的本质是打怪升级换装备，其实人生又何尝不是如此呢？

##开始

          Phase                                      Event

    建立TCP连接                               接收到TCP的SYN包     
    开始接收用户请求                          接收到TCP中的ACK包表示连接建立
    接收到用户请求并分析已接收的请求是否完整  接收到用户的数据包
    接收完整的请求后开始处理                  接收到用户的数据包
	由目标静态文件读取部分内容直接发送给用户  接收到用户的数据包或ACK包表示用户已接收数据包，TCP窗口向前滑动
	对非keep-alive请求在发送完文件后关闭连接  接收到ACK包表示用户已接收到之前发送的所有数据包
	用户关闭连接结束请求                      接收到FIN包

nginx模块组成是这样的


    ┌—— ngx_conf_module  //配置模块
    │ 
    └── ngx_mail_module  //定义mail模块
    │   ├── ngx_mail_core_module
    │   ├── ngx_mail_imap_module
    │   ├── ngx_mail_proxy_module
    │   ├── ngx_mail_pop3_module
    │   ├── ngx_mail_ssl_module
    │   └── ngx_mail_smtp_module 
    │
    ├── ngx_http_module  //定义http模块
    │   ├── ngx_http_core_module
    │   ├── ngx_http_headers_filter_module
    │   ├── ngx_http_log_module
    │   ├── ngx_http_write_filter_module
    │   ├── ngx_http_upstream_module
    │   ├── ngx_http_rewrite_module
    │   ├── ngx_http_static_module
    │   └── ngx_http_proxy_module  
    │   
	├── ngx_events_module  //定义事件模块
    │   ├── ngx_event_core_module
    │   ├── ngx_epoll_module
    │   ├── ngx_selet_module
    │   ├── ngx_kqueue_module
    │   ├── ngx_poll_module
    │   └── ngx_aio_module  
    │   
	├── ngx_core_module  
    │   
	├── ngx_openssl_module  
    │
    └── ngx_errlog_module  
 
核心结构体
	
	typedef struct {
		//核心模块名称
		ngx_str_t name;
		//解析配置项前，Nginx框架调用create_conf方法
		void *(*create_conf)(ngx_cycle_t *cycle);
		//解析配置项完成后，Nginx框架会调用init_conf方法
		char *(*init_conf)(ngx_cycle_t *cycle, void *conf);
	} ngx_core_module_t;
   


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


####ThreadLocal实例

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
 
    /*RRMMM@QRMRMMMRMRDMEbbMStYt2XhP0MEPY1h2Yb9MMMpJhYr2YhDME
    REZR@RESbMRZZZQMDpDDDJ7YfFbZRRD2YrY2Y7Pb0PXYr7r:7cjP0bDDD
    REMMQPfhDDZMDMpX2D0F7LfpMQRM1Yii:YFYUPSFj7::7i:i7JJJ1bMRR
    ZhD0bJY19EMRDYXSEXjJSPDQRFLi:::iJhUhSU7::.:7i.i7Ui77YXMRR
    0h09L77r0RZMr1DZfYctYfFY:..:::rUJ77ri:...:7:.:rL:rrirtpZE
    DF0Urii7PYRrFbtrrii:i:.,....:rLiiii:.,..i:.,.:r:::::YJ1EM
    X0977Jcj70177.,.,...,,,,..:irr::::....,.,,,.i7::iiiYJccpR
    L92J1fUcU9Yriiiri::......:iri::., , , ,,.irLUJj7JUUrr7rt@
    iL7c7r::7jcYJ1hpbbXXUY7i:::ri:i77cLJt1tjLYrrriiri7ri7r:YR
    r:ir7LYYYri7U7Ljrrrr777riiiiii7LJt1tFtf1Li7rir7r7ii::::7R
    7iii7US0Ui.rM@RS.r7iirri..,,,..::ri77:,Z@@@7:UF2Yr:::::7D
    t:iiiiirri:..::,:::::ii::., ,.:::::ii:.,::,,.:i::...:::7R
    fiii:::::i:i:::iii:::i:i:.,,.::::..::i::.,...:.....::::pM
    97i::...:.:::::::.:::::::,,,..::.....::::::....,..:::.cRP
    pbi:::...:.:::.:..:i:ii:..,,,:.:::.....:::::.......:::PP2
    SRP::::::.........:irii:..,,..:.:::....,..........:::jQDX
    FRQX::::.:.......:i7ri:.,,,,,...::ii....,........:::iMQQR
    1b@QS::::::.:.....ir:::.,,,   ,...:i...,......::::::jQRMR
    tbQ@QU:::i::.....:.:ir77::...::::::.,........:::::.iMQZMD
    SD@Q@Qc.::i::.:.:....:rr7iii::iii.,,.,,.......:.:.:1@ZZED
    Q@Q@R@Qc.:::::.:.:::::::............,,,......:..,.URZRZMZ
    RbDPER@QS:::i:::iirii:::, ...,,,..:.:::.........:1QZMDb9b
    2J29M@Q@QEri:iiirL7777777i...:i7ii:ir7rr::...::rb@QQQ@QRb
    @QRDEFUY7r77ri::::iLj7c7LcY7c7rr77Y7::::::::::77ri7JpR@@@
    Jci:::...:7Yrrii:::i77r:..::...iiri:...::::iiirr.,,,,,.:r
    ,,,,.,..::77iirii:i::i7r7r7r7r7rr:::::::::i:::ii:,,,, ,  
    ,,,,,,..:irr:::rii::::.............:.:.:::::.::i:.,      
    ,,,,....:ir:i:::iiri::.......,,,....::i::......:i..,, ,  
    ,,,.,...:iii::::.::iiiii::.:.:.::::i::..........::....,,,
    .,.,.,..:::::.:::...::iirirrrirri:::.......,.,.........*/


##安全发布
任何线程都可以在不需要额外同步的情况下安全地访问不可变对象，即使在发布这些对象时没有使用同步。

安全发布的常用模式 

* 在静态初始化函数中初始化一个对象引用。
* 将对象的引用保存到volatile类型的域或者AtomicReferance对象中。
* 将对象的引用保存到某个正确构造对象的final类型域中。
* 将对象的引用保存到一个由锁保护的域中。


##几个链接而已
<ul>
  <li><a href="https://zorrock.disqus.com/admin/settings/universalcode/" target="_blank" class="external">disqus添加到你的博客</a></li>
  <li><a href="https://zorrock.disqus.com/admin/settings/universalcode/" target="_blank" class="external">流量统计系统</a></li>
  <li><a href="http://www.linezing.com/login2.php" target="_blank" class="external">IP来源分析</a></li>
  <li><a href="http://ip.taobao.com/ipSearch.php?ipAddr=101.71.243.139" target="_blank" class="external">淘宝IP地址库</a></li>
  <li><a href="http://ip.taobao.com/ipSearch.php?ipAddr=101.71.243.139" target="_blank" class="external">并行逻辑回归</a></li>
  <li><a href="http://xuanpai.sinaapp.com/fuzhus" target="_blank" class="external">网络小说辅助设定</a></li>
</ul>

[NovelAssistant][NovelAssistant]可以帮助那些闲的蛋痛的盆友动手写小说，譬如：
<ul>
  <li>动作语言描写</li>
  <li>情节辅助设定</li>
  <li>人物活动背景设定</li>
  <li>等等</li>
</ul>


[SV]: http://supervisord.org/ "Supervisor"
[Nginx]: http://nginx.com/ "Nginx"
[NovelAssistant]: http://xuanpai.sinaapp.com/ "novel"
