---
layout: post
title: 编程工具
description: 工欲善其事必先利其器。关键字：Vim, Sublime Text2, Notepad++, secureCTR, beyondcompare, StackEdit
category: blog
---

新用户注册购买[DigitalOcean][DO]的VPS，现在使用我的[Refer][DO]注册，即刻获得$10赠送，低配的可用两个月。DO采取丧心病狂的低价竞争策略，每月$5即可享用全功能的SSD硬盘VPS，具体去看看[这里][DO]吧。


disqus添加到你的博客
    
	https://zorrock.disqus.com/admin/settings/universalcode/
	
流量统计系统

	https://zorrock.disqus.com/admin/settings/universalcode/
	
IP来源分析

	http://www.linezing.com/login2.php
	
淘宝IP地址库

	http://ip.taobao.com/ipSearch.php?ipAddr=101.71.243.139
	
并行逻辑回归

	http://ip.taobao.com/ipSearch.php?ipAddr=101.71.243.139
	
网络小说辅助设定

	http://xuanpai.sinaapp.com/fuzhus

我们目标实现一个支持多个独立域名网站的线上Python环境，这会用到[Virtualenv][VE]， [Flask][Flask]， [Gunicorn][GU]， [Supervisor][SV]， [Nginx][Nginx]。

##配置用户环境
因为要跑多个站，所以最好将他们完全隔离，每个站对应一个用户，于是我们有了：

     User        Site

     bob         dylan     ##bob用户有一个dylan的站
    michael     jackson    ##michael用户有一个jackson的站

注册成功后，会收到DO发来的`root`账户的密码邮件，`ssh root@你的IP地址`登录上去开始添加用户。

    ##推荐安装zsh作为默认shell
    sudo apt-get update
    sudo apt-get install zsh

    ##安装oh-my-zsh插件
    cd ~/.
    ##自动安装脚本
    wget --no-check-certificate https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh

    ##添加用户bob
    ##参数-d：指定用户目录
    ##参数-m：如果目录不存在则创建
    ##参数-s：只用用户使用的 shell
    useradd bob -d /home/bob -m -s /bin/zsh

    #添加用户michael
    useradd michael -d /home/michael -m -s /bin/zsh

    ##以上参数也可以修改passwd文件来调整
    sudo vim /etc/passwd

    ##sudo和用户组管理在
    visudo
    sudo vim /etc/sudoers

新增用户之后，需要解锁：

    ##为新增用户设置一个初始密码即可解锁
    passwd bob
    passwd michael

用ssh-keygen建立信任关系可以方便登录管理：

    ##本地机器
    ##会在~/.ssh目录下生成秘钥文件id_rsa、id_rsa.pub
    ssh-keygen -t [rsa|dsa]

    ##复制公钥文件id_rsa.pub
    scp ~/.ssh/id_rsa.pub bob@digitalocean:~/.ssh

    ##VPS上，添加本地机器的信任关系
    cd ~/.ssh
    cat id_rsa.pub >> ~/.ssh/authorized_keys

    ##OK，从本地机器登录到VPS的bob用户就不需要密码了
    ##同理，也可以添加到michael用户的.ssh目录下

更多资料可以阅读：
<ul>
  <li><a href="http://www.chinaunix.net/old_jh/4/438660.html" target="_blank" class="external">Linux的用户和用户组管理</a></li>
  <li><a href="http://sofish.de/1685" target="_blank" class="external">把 Mac 上的 bash 换成 zsh</a></li>
  <li><a href="http://leeiio.me/bash-to-zsh-for-mac/" target="_blank" class="external">zsh – 给你的Mac不同体验的Terminal</a></li>
  <li><a href="http://blog.csdn.net/kongqz/article/details/6338690" target="_blank" class="external">ssh-keygen的使用方法</a></li>
  <li><a href="http://www.ruanyifeng.com/blog/2014/03/server_setup.html" target="_blank" class="external">Linux服务器的初步配置流程</a></li>
  <li><a href="http://www.ruanyifeng.com/blog/2014/03/server_setup.html" target="_blank" class="external">Linux服务器的初步配置流程</a></li>
</ul>

##为每个APP创建Virtualenv

[Virtualenv][VE]可以为每个Python应用创建独立的开发环境，使他们互不影响，Virtualenv能够做到：
<ul>
  <li>在没有权限的情况下安装新套件</li>
  <li>不同应用可以使用不同的套件版本</li>
  <li>套件升级不影响其他应用</li>
</ul>

##安装Flask
[Flask][Flask]是Python流行的一个web框架，但是Flask比Django轻量了许多，使用更加直观，这里并不展开讲Flask的细节，当做一个Hello Wordld来用就好了。

    ##安装Flask
    ##依然在virtualenv activate的环境下
    pip install Flask

    ##根目录下
    vim runserver.py

    ##写入Flask的Hello World
    from flask import Flask
    app = Flask(__name__)

    @app.route('/')
    def hello_world():
        return 'Hello World!'

        if __name__ == '__main__':
            app.run()

写入之后，如果在本地机器上可以运行`python runserver.py`，然后打开`127.0.0.1:5000`看到Hello World!了，但在VPS，这样不行，等待后面配置吧。

##安装Gunicorn
[Gunicorn][Gu]是用于部署WSGI应用的，任何支持WSGI的都可以，虽说直接`python runserver.py`这样网站也能跑起来，但那是方便开发而已，在线上环境，还是需要更高效的组件来做。

    ##安装Gunicorn
    ##依然在Virtualenv环境下
    pip install gunicorn

Gunicorn的配置是必须的，因为我们要上两个独立的站，所以不能都用默认的配置：

    ##在bob的dylan项目下
    cd /home/bob/dylan
    vim gunicorn.conf

    ##文件内写入以下内容
    ##指定workers的数目，使用多少个进程来处理请求
    ##绑定本地端口
    workers = 3
    bind = '127.0.0.1:8000'

    ##在michael的jackson项目下
    cd /home/michael/jackson
    vim gunicorn.conf

    ##写入文件内容
    ##与dylan的端口要不一样
    workers = 3
    bind = '127.0.0.1:8100'

最终的目录结构应该是这样的

    /home/
    └── bob  //用户目录
    │   ├── logs
    │   └── dylan  //项目目录
    │       ├── bin
    │       │   ├── activate
    │       │   ├── easy_install
    │       │   ├── gunicorn
    │       │   ├── pip
    │       │   └── python
    │       ├── include
    │       │   └── python2.7 -> /usr/include/python2.7
    │       ├── lib
    │       │   └── python2.7
            ├── local
    │       │   ├── bin -> /home/shenye/shenyefuli/bin
    │       │   ├── include -> /home/shenye/shenyefuli/include
    │       │   └── lib -> /home/shenye/shenyefuli/lib
    │       │
    │       │ //以上目录是Virtualenv生成的
    │       ├── gunicorn_conf.py  //Gunicorn的配置文件
    │       └── runserver.py  //hello_world程序
    │
    │
    └── michael  //用户目录
        ├── logs
        └── jackson //项目目录
            ├── bin
            │   ├── activate
            │   ├── easy_install
            │   ├── gunicorn
            │   ├── pip
            │   └── python
            ├── include
            │   └── python2.7 -> /usr/include/python2.7
            ├── lib
            │   └── python2.7
            ├── local  //以上这些文件都是Virtualenv需要的
            │   ├── bin -> /home/shenye/shenyefuli/bin
            │   ├── include -> /home/shenye/shenyefuli/include
            │   └── lib -> /home/shenye/shenyefuli/lib
            │
            │ //以上目录是Virtualenv生成的
            ├── gunicorn_conf.py  //Gunicorn的配置文件
            └── runserver.py  //hello_world程序

##oracle的几条命令

	lsnrctl status 
	lsnrctl start
	sqlplus nolog
	conn / as sysdba
	conn sys/123@orcl as sysdba
	startup
	shutdown
	

###多线程下的单例模式
曾经有个叫兽说游戏的本质是打怪升级换装备，其实人生又何尝不是如此呢？

###不要在构造过程中使this引用逸出
	一个常见的错误就是在构造函数中启动一个线程
	在构造函数中调用一个可以改写的实例方法
	又是希望在构造函数中注册一个事件监听器和启动线程，可以由一个私有的构造函数和公共的工厂方法来避免
	
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









[DO]: https://www.digitalocean.com/?refcode=f95f7297ed94 "DigitalOcean"
[VE]: http://www.virtualenv.org/en/latest/ "Virtualenv"
[Flask]: http://flask.pocoo.org/docs/ "Flask"
[GU]: http://gunicorn.org/ "Gunicorn"
[SV]: http://supervisord.org/ "Supervisor"
[Nginx]: http://nginx.com/ "Nginx"
