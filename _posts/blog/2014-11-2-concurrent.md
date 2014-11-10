---
layout: post
title: 并发
description: 并发编程实战读书笔记。
category: blog
---


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


###安全发布
任何线程都可以在不需要额外同步的情况下安全地访问不可变对象，即使在发布这些对象时没有使用同步。

安全发布的常用模式 

* 在静态初始化函数中初始化一个对象引用。
* 将对象的引用保存到volatile类型的域或者AtomicReferance对象中。
* 将对象的引用保存到某个正确构造对象的final类型域中。
* 将对象的引用保存到一个由锁保护的域中。



##组合对象
###设计线程安全的类
###实例封闭

	@ThreadSafe
	public class PersonSet {
		@GuardBy("this")
		private final Set<Person> mySet = new HashSet<Person>();
		
		public synchronized void addPerson(Person p) {
			mySet.add(p);
		}
		
		public synchronized boolean containsPerson(Person p) {
			return mySet.contains(p);
		}
	}
	
	java监视器模式
	
	@ThreadSafe
	public final class Counter {
		private long value = 0;
	
		public synchronized long getValue() {
			return value;
		}
	
		public synchronized long increment() {
			if(value == Long.MAX_VALUE)
				throw new IllegalStateException("counter overflow");
			return value++;
		}
	}
	
	
	@ThreadSafe
	public class MonitorVehicleThracker {
		private final Map<String, MutablePoint> locations;
	
		public MonitorVehicleThracker(Map<String, MutablePoint> locations) {
			this.locations =deepcopy(locations);
		}
	
		public synchronized Map<String, MutablePoint> getLocations() {
		return deepcopy(locations);
		}
	
		public synchronized  MutablePoint getLocation(String id) {
		MutablePoint loc = locations.get(id);
		return loc == null?null: new MutablePoint(loc);
		}
	
		public synchronized void setLocation(String id, int x, int y) {
			MutablePoint loc = locations.get(id);
			if(loc == null)
				throw new IllegalArgumentException("No such ID: "+ id);
			loc.x = x;
			loc.y = y;
		}
	
		private static Map<String, MutablePoint> deepCopy(Map<String, MutablePoint> m) {
			Map<String, MutablePoint> result = new HashMap<String, MutablePoint>();
			for(String id:m.keySet())
				result.put(id, new MutablePoint(m.get(id)));
			return Collections.unmodifiableMap(result);
		}
	
	
	
	}
	
	
	@NotThreadSafe
	public class MutablePoint {
		public int x, y;
	
		public MutablePoint() {
			x = 0;
			y = 0;
		}
	
		public MultablePoint(MultablePoint p) {
			this.x = x;
			this.y = y;
		}
	}



###委托线程安全

	@Immutable
	public class Point {
		public final int x, y;
		
		public Point(int x, int y) {
			this.x = x;
			this.y = y;
		}
	}
	
	@ThreadSafe
	public class DelegatingVehicleTracker {
		private final ConcurrentMap<String, Point> locations;
		private final Map<String, Point> unmodifiableMap;
		
		public DelegatingVehicleTracker(Map<String, Point> points) {
			locations = new ConcurrentHashMap<String, Point>(points);
			unmodifiableMap = Collections.unmodifiableMap(locations);
		}
		
		public Map<String, Point> getLocations() {
			return unmodifiableMap;
		}
		
		public Point getLocation(String id) {
			return locations.get(id);
		}
		
		public void setLocation(String id, int x, int y) {
			if(locations.replace(id, new Point(x, y)) == null)
				throw new IllegalArgumentException(
					"invalid vehicle name: " + id);
		}
	}
	
		

###向已有的线程安全类添加功能
添加一个新原子操作的最安全方法是修改原始的类，以支持期望的操作，但通常因为无法访问源代码而无法实现。直接向类中添加新方法，意味着所有实现类同步策略的代码仍然包含在一个源代码文件中。
另一种方法是扩展类，扩展后同步策略的实现会被分布到多分独立维护的源代码文件中，因此扩展比直接在类中加入代码更脆弱。

	//扩展的Vector包含一个“缺少即加入”方法
	@TheadSafe
	public class BetterVector<E> extends Vector<E> {	
		public synchronized boolean putIfAbsent(E x) {
			boolean absent = !contains(x);
			if(absent)
				add(x);
			return absent;
		}
	}
	
####客户端加锁

	//实现的"缺少即加入"
	@ThreadSafe
	public class ListHelper<E> {
		Collections.synchronizedList(new ArrayList<E>());
		
		public boolean putIfAbsent(E x) {
			synchronized(list) {
				boolean absent = !list.contains(x);
				if(absent)
					list.add(x);
				return absent;
			}
		}
	}
	
####组合

	@ThreadSafe
	public class ImprovedList<T> implements List<T> {
		private final List<T> list;
		
		public ImprovedList(<List<T> list) { this.list = list; }
		
		public synchronized boolean putIfAbsent(T x) {
			boolean contains = list.contains(x);
			if(contains) 
				list.add(x);
			return !contains;
		}
		
		public synchronized void clear() { list.clear(); )
		
		//... similarly delegate other List methods
	}

	
	
###同步策略的文档化
为类的用户编写类线程安全性担保的文档，为类的维护者编写类的同步策略文档。

##构建块
###同步容器
###并发容器
###阻塞队列和生产者消费者模式
###阻塞可中断的方法
###Synchronizer
###为计算结果建立高效、可伸缩的高速缓存



[SV]: http://supervisord.org/ "Supervisor"
[Nginx]: http://nginx.com/ "Nginx"
[NovelAssistant]: http://xuanpai.sinaapp.com/ "novel"
