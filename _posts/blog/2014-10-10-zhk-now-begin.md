---
layout: post
title: 编程工具
description: 工欲善其事必先利其器。关键字：Vim, Sublime Text2, Notepad++, secureCTR, beyondcompare, StackEdit
category: blog
---

世事如棋局常新，人生如戏靠演技。曾经有人说游戏的本质是打怪升级换装备，其实人生又何尝不是如此呢？

##开始

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
	

    0000000100000000000000000000111111100000000111111111100010001111111111110000000000
    0000111100000000000010000011111110000000111111101111100111111111111111111100000000
    00001110010000001011100011110000000011111111110111001111111 1111111111111110000000
    1011111100000001101000111100100001111111111101110111111 1  111 1111111111110000000
    10111111000000111000111111111011   11111111111111111     111 111111111111111000000
    01111111011001100111111111111       1  11111111111      111   11111111111111100000
    111111111100 10111111111             11111111111      111      11 1111111111110000
    11111111110111                   111111111111               1111111111111111110000
    1111111110111111111111           111111111              11111111111111111111111000
    1111111111111111000000001111111 1 111111111111111111111111111111111111111111111000
    1111111111111111111111111111111111111111111111100010111111   1   11111111111111000
    1111110011111001110111111111111111111111111111111111110111101111111111111111111000
    11111111111  1000011 11111111111           111111111 1000000  1111111111 111111000
    1111111111111       11 1111111111         1111111111    1     1111111    111111001
    1111111111111111 111111111111111       1 1 1   1 11111        1111     11111 11011
    111 1 1 11111111111111  11111111        1 1 1     1111111 1           111111110011
    1111   1 1 1 1111111   111111111         1     1   1111111 1           11111101111
    111111        1 1     111111111         1   1 1         111             1111101111
    11111111              1111111111         1 1111                        11111000110
    1111111 1             1111111 1             11111                     111110000000
    0011111111     1       1111111               11111                 111111110000000
    0001111111111 1       11111 1                  11               1 1111111100000000
    000011111111             11111111       1111 111               1 11111111000000000
    000001111111111           11111111111111111111                  1 111 111000000000
    0000001111111111 1 1         111 1 1 1                                110000000000
    000000011 1111111 1 1 111111111             1 111               1    1100000000000
    1110000011111111111111111111111                1 111 1         1    10000000000000
    1100000000111111111111111111111111      11111 1 111111111     1  11000000000000100
    00000001111111111111111111111111111111111111111111111111 1 1 111111111100000000000
    111111111111111111111  11111111 11111111  1111111       11111111111     1111110000
           1 11111111111111111111111   1     1111111     1 1 11111111111             1
            111111111111111111111111111111111111111 1111111 11111 111111              
            11111111111111111111 1 1 111111111     1 1 1   11111 1 1 111              
            1111111111111111111                         11111 1       111             
           11111111111111111111111                 1111111 1 1         111            

    %%#*%*%**++**##%%%@#+*#*#%#*+*#####%%#+=-------==##++#*++=--::::-+-::--+*=-=++=*#%%%%%%
    %%*#%*#=+=++=%@#%@#-+*#%#*++**+=+*#+=:::-:----=+*====--=-::.:::=+:::--=+--===-=+*#%#%#@
    #%*#*%+======%*+@#-+%%*+=====-=+==::::::::::-++=-=-----:.::::==-.:::-==-------=+**#%#%@
    #%###*=-====**-%%:*%+--------::.......:.::--==-:-----::::.::-:..:.::--::-:---=**++*%%%@
    +####+=+**+*+=*@=++:...:...:.:.......::--===--:--:::::.:.... ....:=+=---==--=*+==++#%%%
    +=##*+***+*+++#++=--=------:::::::::::-:--=--:-:. ...   ....::===+++++++++*++--++==#@%%
    *=++=+++==---+**+**####%%@%%##*+===-:::-----::--==-=-==+++++++++++=+======+=-===-=-*@%%
    #==-=====-----=-=-------=====++++++==---===-==++***#######*+=-::::::::::-----------*@%%
    %=-=-==++**##*==-=%%#**%*-=+---=====------:----=-======+=-+#**+*%*-+*#**++=--------+%%%
    @==-=--=++***+-::.=#@%%*-.-=+---===--::......:::----====- -%@@@@#:.-++*++==:-:-----+%%%
    %*-=-------===---:..::...-::--:------::... .::::::----:--:..:-:. .:::---:::::::----+%%*
    #*=-=--------------:::-------:::-----::....:::::-:::-:-----:....::::-:::::::::---:-*@#*
    *#+=----:::::-:-:---------:::::-----::.....:::::::::::::----:-:::::::::::::::-:-::*@##*
    ###=-----:::::::::-:---::::::--------:......::::::::::::-:-----::::::::...::::--:=%#***
    *#%*-----::::::::::-::::::::--------::......:::::::::::::::::-:-::::::.:.:::::---##**#*
    **#%*------:::::::::::::::::--=----::.:.....::::::-::::::.....:.:::::::::::::---*%%#*##
    **#@@#----::::::::.:.:.:::::-===--:::......:.::::-----::.:.........:.::::::----=%@%%%%%
    **#%@@#-----::::::::::::::::-==---:::.... . ..::::::---::.:.:.:::.:.::::::-:---*@%%%%%%
    **#%%@@%--------:::::::::::--=-::-::.....  . ...::.::-::::.:.::::::::::-:::---=@%%%%%%%
    **#%@@@@%--------:::::::::::::--==+=-::...::::-:-:::-...:::.:.::::::::-:-:----%@%%%%%%%
    ***%%@@@@#--------::::::::::::::-==+++=-------====-:.........::::::::::::-:::*@%%%%%#%#
    @%@@@%@%@@#-::-----:-:::-::::::::::--:::::::.::::::.........::::::::::::::::*%%%%%%%%%%
    @@@@@@%@%@@%=::-----:::::-:---------::.....:.:.::::::-::.:...:.:::::::::.:-*%%#%%%%%%%#
    @%%#####%%@@@*------------=-=------::. .:::.. ....::::-:-::::::::::::::::=#%%##%%######
    #+=++*##%@@@@@@+-------=-==+==-=====---:...::-----::::-=-=-=-::::::::::-#@%@%%%@@%%%#%%
    @@%%%%%%%###***+===--------==+*+++++***++==++++++++=++=-=----:::::-:--==+++*##%@@@@@@@@
    @@%%**++==------=+==----::::-====---:::-==--:::::--==-::.::::::-:----===:::::--==**#%@@
    +---::::::::::--=======--------====--:::::::::--=-=--:::::-:::--------=-:...........::-
    ...:.:.:.:::::-====--===---------======+=+========--:-:---:::-----:-:--=::............ 
    ..........:.::-===------=------:::::::-:-:-:-:::::::::::::::---:::::::---:...     . .. 
    .......:.::::--==--------=----:-::::.:...........::::::::----::::::::::---....     . . 
    ......:.::::::--=-----------=------::::::::::...::::-:-----:::::::::::::---::......... 
	
    MA@AM#A9XXMMGMMM##MXAh2&#AASssXAAH@@@#B9Srr;;;r;3ASShAH35iirr:,;2r:;;;i52isS9GHM@#@#M
    AG#9#&XSSh2HAMM#@HihAhHBAXiXAHAGH#MA2i;;:;;;;rsAGS2A32isr;::,,r5;,:;;S9r;sSis2AMM####
    9&BGBsSriirM@HM@A;ihH#AXSiX35s53A2r,,:;:;::;s59srii;rr;:,,:,:si:::;;ii;;sis;ri3ABB#B@
    XHGMSirrrri#Gi@A:5##G2iissr;risr:,,,,:::,:;iSs;rr;;r;:.,,,,rs;.:,:;rs;;;;;;;ri29A#B#@
    &GAhrrrrrs32;##:3#2;;;;;;:;,,,.....,,,,,;;sr;:;:;;;,,,:,,:;:..,,,,r:::;:;;;rX355GM##@
    HAA2s5X3225s2@rSS:...,,..,,,...,.,.,:;;rrr;::;;:,,,,.,...,   ..:rSr;:rrr;;rX5si2iB###
    &HXS3992255SB25r;;r;rrr;:,:,,,:,:,::;:;;r;;::,. .       .,::rssS2i222i52X25;riSirA@##
    i2s2iisr;;;iXX5X9&AHB##@#MAAX5isr;:::::;;;:::rrrr;;rsii5i5S525sSsissssrsii;rsi;r;9@##
    rrrrsrr;;;rrr;rr;;;;;;rssrsiSiSiirr;;;rrrrrrS5XX&GAAAAH&h5r;:,,,:,,,::;;;;;;;:;;;2#M#
    ;r;rrS29GHAhsr;s#M&9h#h:ri;;;rrrrr;;:;:;:;:;;r;rrrrrsir;SA9XSG@3;S9&32Sir;;;:;;;;5MM#
    rrr;rrS533Xir:,.sA@##G;.riS;;;rrr;:,,.....,,::;;r;riis; ;B@@@@&,.;iS2Sirr:::::;;;SMB#
    ;r;r;;;;;rrr;r;:..,:...:::;;:;;;;;;:,, . .,:,::::;;;:;::  ,::. ,,::;;;::,,,::;;;;2##G
    r;rrr;;:;;;;;;;;;:::;;rrr;;:::;;;:;:,,,..,:::::,,,::;;r;;,,...,,::;::,:,::::;;;:;9@&3
    ir;;;;::,::::;:;;;;;;;;;::,::;:;;;::.,...,,:::,:,,,:,::;:;::::::,:,,,,,,,::;:;::h@HGX
    &r;;;::,:,:,::::::;:;::,::::;;;;;;;,,.....:::,:,:,:,,,::;:;::::,:,,,,.,.,,::;::r#&G33
    #h;;;;::::,,,:,:::::,:,:,::;;;;;;;:,.....,,:,:::::::,,,,,:::::::,,,,,,.,,,,:::;&A9XG3
    B#h;;;;::::::,,,,,,,,,,,::;;r;;;;::,,.....,,::::;::,,,,.....,,,,,,:,:,:,::::::9MMAh&B
    A@@G;;;;::::,,,,,,,,,,,:,:;rrrr;::,,.....,,,,:,::;::,,,,...,.,.,.,.,,,,::::;:i#@#@##B
    H#@@H;;;;:::::,,:,:,,,:,::rsr;;;:,,....   ..,,::::;;;,:,,.,.,,,.,.,,:,::::;;;9@######
    &##@@M;;;;;;::::::,:,,,:::;r;:,:,,....     ..,,,.,:;,,,:,,.,,,,,,,,::;:::;;;s@#######
    &B@@@@B;;;;;;:;::,,,,,,,:,::;;rrir;::.,.,,::;:::::;,..,,,.,.,,,,:,:::::::::;M@#M#M#M#
    h##@#@@B;;:;;;;;::,:,:::,,,,,:;ssiiirr;;;;;rrsrs::...,...,.,,,,:,:,:,::::::h@#BMBMHBH
    @@@@@#@@B;::;;;::::::::,,,,,,,:,::;::,:::,.,,,,,,...,.....,,,,,,,,:,:::,::9B###M#M#MM
    @@@@@@#@@#i::;;;;;::,::;:;;;;;;;:;:,.....,.,.,,:::::,,.,.,.,,,,,,,,:,:.,;h#BA#M#M#M#B
    BHB&&&##@@@Gr:;;;;;;;;;;r;r;;;;:;:,.  ,:,.. ..,.,,:,:::::,:,,,,,:::,:,,rA#MHBMMAAABAA
    si2GhB@@@@@@@2;;;;;;;r;rrSsrrrrrrrrr:,...,,:;;;;::::;rrrrr;:,:,,:::::;A@#@##@@@@#M&BM
    ######@BHAGXX5irr;;;;:;;;rsiX52525XXX2irii25SS5iSi5Ss;r;;;::::::::;;ssSS23AH#@@@@@@@@
    #MGh5irr;;;;;;r5srrr;;::,,:rsirr;::::;rs;r:,,::;;rr;,,.,,:,::::;;;rrsr:,,,,:;rs2XA#@@
    ;::,:,:,:,:::;sisrrrr;;;;:;;rrisr;:::::,:,:,;;r;r;:::,:,::::::;;;;;;rr:........ ..,,:
    .,,,.,.,,,,:;rssr;;rrr;;;;;;:;;rsssisisisissrsrr;::::::;::::;r;::::;;r:,.... ... . . 
    ........,,::;rsrr;;;;rr;;:;:;::::::::::::::::,,,:,:::::,::;;;::::::::;;,...          
    .....,.,,:,;;rrr;;;;;;;r;r;;::::,,.,.,...... ..,,,,,,::;:;::::::,:,,,;;;,.           
    ..,.,.,,:,::;rr;;;;:;;::;;rrr;;:;::::,,,,,:.,.,,::::;;;;;::,:::,:,,,,:;;:,,...... .. 
           . ..,,:,,,,...,...,,,,:::::::::,,,,,,,:::,:,:,,.. ..... .     ..... . .       
	

    4046052336626666663537264577732460006637777777735772463777777 777 777777777326600006
    203627772744666067352664773264240647777777777755774377777    777  777377777774660666
    2626777777604604772604777737773477   7 777777377777777      77   7777777777773466660
    626777777702704 766277777777777          77777777777      777    7777777777777346660
    24377777737766 367777777 7             77777 77777       7       77  7 7777337726600
    4477773777770777                    7777777 77                 7777 7777777777776000
    477332777776777777777777           7 77777 7               7777777777777777777775060
    777777777773377355666600642377777    7777  77777777777777777777777777777777777773066
    777777777777777777777777777777777777777777777332244456237777         777777777777060
    777777324437777665330277777777777777777 77777777777777776377203773537777777777777666
    777777733777   7406027 77777777777           777777777 7600005  77777777   7 7777660
    77777777777777        7  777777777             7777777            777      777777662
    7777777777777777   7777777   77777               7 77777         7         777 73023
    77777       77777777777     77777                    7777 7               7 7  20423
    77777          7 777     7 7777777                     777 7               77 765233
    3777777                  77777777                         7 7                7542323
    037777 7                 7777777               7                         77773664256
    0027777                  777777               77777                     777776060666
    6006777777               777777                  777                   7 77730666060
    6000677777777           7777                      7                 7   777700060606
    60000677777777             7777777         7 7   7                 7 7 7777600666666
    600000677777777              7777777777777777777                      7   2066666666
    000000067 777777 7             7 7                                       36606666666
    0000000007  77777     7 777777777                                      7266406666666
    66525000002777777777777777777777                     7 7              74066666444644
    77226000000077777777777777777777777       77777    7777777      7   7406006000066566
    6060006652777777777777777777777777737777777777777777777777       7777777346000000000
    623777777777777777777     7777777   77777     77777         7 7777777     7777774000
               7777777777777 777777777         7777777          777777777              7
               7777777777777777777777777777777777777    777    7777 77777               
               77777777777777777         7                   777       777              
              77777777777777777 7                         7777          777             

    
    2BSBi7rr7r70S7@S;Z00S27777rrri7r;::;:;;;;;rii7rrrrrrr;.::;;r7r:;:;r77rrrrrrrr7ZMB0B0@
    SSBSrrrr772Zr00;X0Zrr;rrr;r;::.....:::;:rr7rr;r;rrr:::;:;;r;..:.:;r;;;;;rrrrXXZZSB00@
    BBBZ7ZXX22Z72@7ii;...:...:::...:.::;;rrrr7rr;rr;::::.:...:. ...;rirr;rr7rr72Z7727B000
    SB2iMSSZ2ZZiBZZ7rr7rrrr;;;;;::;;;;;;;;rrrrr;;;. . .   . ..;;r77iZiZZZiZZ22Zrr7i77S@00
    7Z7Z777rrrri22Z2XSSBB00@0BSSXZ77rr;;;;;rrr;;;rrrrrr77i7Z7iiZZZ7i7777777777rr77rrrX@00
    rrr7777rrrrrrr7rrrrrrrr77777Zii77rrrrrrr7rr7iZXXSSBSSSBSSZ7r;::;;;::;;rrrrrrr;rrr2000
    rrrr7iZMSBSS77r7B0SSS0S;r7rrrrr7rrrr;r;r;rrrrrr7r7rr77r;ZBM2iS0XrZMSX2ii7r;rrrrr;ZBB0
    rrrrr7iZMX2ir;:.7S@00Sr.r7irrrrrrr;;:.....::;;rrrrr777; rB@@@@S;.rii2i77r;;;;;rrriBB0
    rrrrrrrrrrrrrrr;..:;..:r;;;r;rrrrr;;:: . .:;;;;;;rrr;r;;..:;;. ::;;rrr;;:;;;;r;rrZ00S
    rrrrrrr;rrrrrrrrr;;;rrrrrrr;;;rrr;r;;.:..:;;;;;;;;;;rrrr;;:...::;;;;;:;:;;;;rrr;rS@SM
    7rrrrr;;;;;;;r;rrrrrrrrr;;;;;rrr;r;;::...:;;;;;;:::;;;;r;r;;;;;;;;:::::::;;;;r;;S@BSX
    Srrrr;;;;;;;;;;;;;r;r;;;;;;;rrr;rrr::.....;;;;;:;;;::;;;r;r;;;;:;::::.:.::;;r;;70SSX2
    0Srrrr;;;;;;;;;;;;;;:;:;;;;rrrrrrr;:.....::;;;;;;;;;:;:;:;;;;;;;:::::::::;;;;;rSBSXSM
    B@Srrrr;;;;;;:;:::::::;;;;rrrrrrr;;::....:;;;;;;r;;;;::.....:.;;;;;;;:;;;;;;;;M00BSSB
    B@@Srrrr;;;;:;::.:::.::;;;r777rr;;::.....::::;;;;r;;;::....:.:.:.:.::::;;;;r;70@0@00B
    B0@@Brrrr;;;;;;:;;;;;:;;;;r7rrrr;::...  . ..::;;;;rrr;;::.:.:::::.::;;;;;;rrrS@000000
    S00@@0rrrrrr;;;;;;;;:::;;;rrr;;;;:......   ...::.:;r:::;::.::::::;:;;;;;;rrr7@0000000
    SB@@@@Brrrrrrrr;;:::::::;;;;rrr777r;;::.::;;;;;;;;r:..:::.:.::::;;;;;;;;;;rrB@0B0B000
    S00@@@@Brr;rrrrr;;:;:;;;:::;:;r77i77rrrrrrrrr777;;...:...::::;:;:;;;;;;;;;;S@0BBBBBBB
    @@@@@0@@Br;;r;r;;;;;;;;:::::;:;:;;r;;;;;;:::;::::...:.....::;;::;:;;;;;:;;SB000B0B0BB
    @@@@@@0@@@7;;r;rrr;;;;;;;rrrrrrr;r;:.....:.:.;;;;;;;::.:.:.::::::;;;;;.;;S0BS0BBB000B
    BBBSSS00@@@Sr;rrrrrrrrrrrrrrrrr;;;;. .;;;.. ..:.::;;;;;;;:;:::;:;;;;;:;7S0BBBBBBBSBBS
    7iZSSB@@@@@@@2rrrrrrrrr77i7rr7rrrrrr;:...::;rrrr;;;;rrrrrrr;;;:;;;;;;rS@0@00@@@@00SBB
    0000@00BBSS22i77rrrrr;rrrr772ZZZZZ22MZir7iZiZiiii7Zi7rrrrr;;;;;;;;rr77iiZMSB0@@@@@@@@
    0BSSZirrrrrr;rrZ77rrrr;;::;777rrr;;;;rr7rr;;:;;rrrrr;:.::;;;;;;rrrr77r;;:;;;r7722S0@@
    r;;:;:;;;;;;rr777r7rrrrrr;rrr7777rr;;;;;;:;:rrrrrr;;;:;;;;;;;;rrrrrrrr;.....:.....:;;
    .:.:.:.::::;rr77rrrrrrrrrrrrrrr777777777777777rrr;;;;r;r;;;;rrrr;;;rrr;:.... ... ... 
    ........::;;rr7rrrrrrrrrr;rrr;;;;;;;;;;;;;;;;:;;;;;;;;;;;;rrr;;;;;;;;rr:...     . .  
    .....:.::;;rrrrrrrrrrrrrrrrr;;;;::.:.:::.......::::;:;;rrrr;;;;;;;:;;rrr:...     . . 
    :.:.::::;;;;rrrrrrr;r;;;rrrrrrr;;;;;;;;:;:;.:.::;;;;rrr;r;;:;;;;;:::;;rr;::.:....... 	
	
    @GB@@@@@BB9G@B@BBBBB@B@GGGBGBBGhis2XXMGGBBBBBG9hir3923i3GGGGGGGXhrs2rrih3i9BGGBGBBBBB
    BGB@@@B999S@B@BBBGB@BBGSGBGBGhrihX39GBB@BBGXiirirhGhrih9GG9Mhhrr;iirrrrhi993XGGBBBB@B
    BG@GBBGSXXBB9BBBBBBXG9h9BG9hii29GG@@@BBSsrrrrrrrX9ss9GGMhsirr;,r2r;rrrih3iisM9GB@@@BB
    99BSB92hsS2GGBBB@GiSGSGBG2i2GGG9GBBG3irr;rrrrri99s3GM3iirr;;,:rhr,;rrsMrrihii2GBB@BBB
    M9B9BihriiiB@GB@Grs9B@G2ii22hi3MG3r,,;;;r;;;ihMiriirrrr;,:;:;ii;;;rrisrriiiriiXGBGBB@
    2G9Bsirriri@9i@G;hBB92iiiirrriir,,:;,;;;,;riiirrrrrrr;:::,,rir:;,;riir;rrrrrri2SGBBB@
    99GSrrrrriX3rBB;MB3rr;rrr;;,,:: ::::::,,rrirr;r;rrr,,,;:,;r;:::::;r;;;;;rrrrXXhs9BB@@
    GGGhrsXM223i2@rsi;:::,:::::::::::::;;rrrrrr;;r;;,,::::::::   ::;rsrr;rrrrri2hii2iB@BB
    GG2sXS932hhsB3hrrrrrrrrr;,;,,:;,;,,;;;rrrrr;;,: :       ::;;riishs32hihh23hrrisir9@B@
    i3ihiirrrrrs22h2X9GGGBB@BBG9Xhiirr;;;;;rrr;;;rrrrrrriiihihihhhisiiiiiiriiirriirrrM@BB
    rrrrirrrrrrrrrrrrrrrrrriiiiihsiiirrrrrrrrrrrhhX299GGGGG99hir;,:,;,,,;;rrrrrrr;rrr2@BB
    rrrrrihX9GGSirriBB9SSB9;rirrrrrrrrrr;r;r;rrrrrrrrirrrir;hGM2s9@XrhM923sirr;r;r;r;hBBB
    rrrrrrihMM2ir;,:iG@BB9r:risrrrrrrrr;,:::::::;;rrrrriii; rB@@@@9,:ris2iiir;;;;;rrrhBB@
    rrrrrrrrrrrrrr;;::,;:::;;;;r;rrrrrr;,:   ::,,;;;r;rr;r;;  :;,: :,;;rrr;;,,,;;r;rr3BB9
    rrrrrrr;rrrrrrrrr;;;rrrrrrr;;;rrrrr;;:::::;,;;;,,,;;rrrrr;::::,:;;r;;,;,;,;;rrr;rS@9X
    irrrrr;;,;;;;r;rrrrrrrrr;;,;;r;rrr;;:::::,,;;;,;,,,;,;;r;r;;;;,;;;,,:,:,,;;;;r;;9@G9X
    9rrrr;;,;,;,;,;;;;r;r;;;;,;;rrr;rrr,::::::;;;,,,;,;,,;;;r;;;;;;,,:,:::::,,;;r;;iB99XX
    B9rrrr;;;;,,,;,;;;;;,;,,,;;rrrrrrr;::::::::;,;,;;;,;,;:,,;;;;;;;,,:::::,,,;;;;rGGSX9M
    B@Srrrr;;;;,;:,:,:,:::,,;;rrrrrrr;;:::::::,,;;;;;;;,,:,:::::::,,,,;,;:;;;,;;;;MBBG99G
    G@@9rrrr;;;;,,:,:::::,,;,;rirrrr;;:::: ::::,,;,;;r;;,,::::::::::::::,,:;;;;r;iB@B@BBB
    GB@@Grrrr;;;;;;,;,;;;:,,;;rirrrr;:::::    ::::;;;;rr;,;:::::,:::,:::,,;;;;;rrS@BBB@BB
    9BB@@Brrrrrr;;;;,;,;:,:;,;rrr;;;;,::::     ::::,::;r,,,,:::::,:,:,,;;;;;;rrri@@BBBB@B
    GB@@@@Brrrrrr;r;;:,:,:,,;,;;rrrrirr;;:::::;;;;;;;;r:::,:::::::,:;;;;r;;;;;;rB@BBBBBBB
    9B@@@@@Grr;rrrrr;;,;,;;;,,,,,;riiiiirrrrrrrrriir;;:::::::::::,,;,;,;;;;;;;;9@BBBBBBBG
    @@@@@@@@Br;;rrr;;;;;;;;,,:,:;:,,;;r;;,;;;:::,,::::::::::::::,,,:,,;,;;;:;;MBBBBBBBBBB
    @@@@@@B@@@i;;r;rrr;;,;;;;rrrrrrr;r;::::::,:::,,;;;;;:,:::::::::,:;,;;;:,r9BBGBBBBBBBB
    BGB999@@@@@9r;rrrrr;rrrrrrrrrrr;;;,   ,;,:  :::::,;,;;;;;,;:,,,:;,;,,:;rG@BGBBBGGGBGG
    ii299G@@@@@@@3rrrrrrrrrrisirrrrrrrrr;::::::;rrrr;;;;rrrrrrr;,;,,;;,;;r9@B@BB@@@@BB9BB
    @B@B@@@BGG922hirrrrrrrrrrrri2hhh2h22Xhiriihhhssisihsirrrrr;;;,;;;;rriiss3XGB@@@@@@@@@
    @B9Shirrrrrr;rrhirrrrr;;:,;riirrrr,;;rrirr;,,;;rrrrr;:::,;;;;;;rrrrrrr;,:,,;rri22G@@@
    r;;,,:;,;;;;;riiirrrrrrrr;r;rriirr;;;;;,;,,,rrrrrrr;;,,,;;;;;;rrrrrrrr;:::::: : :::;;
    :::::::::,,;;riirrrrrrrrrrrrrrrrriiiiiiiiiiirirrr;;;;r;;;;,;rrrr;;;;rr;::::: ::::: : 
    ::::::::::;;rrirrrrrrrrrr;r;r;;;;,;;;;;;;;;;;,,,,,;;;;;,;;rrr;;,;,;;;rr,::           
    ::::::::,;;;rrrrrrrrrrrrrrrr;;;;:::::::::: : ::::,:,:;;rrrr;;;;;,;,,,;rr:: :         
    ::::::,:;,;;rrrrrrr;r;;;rrrrrrr;;;;;,,;:;,,:::,,;;;;rrrrr;;,;;;,;,,,;;rr;:::::: :::: 
           : :::,;,,::::::::::::,;;;;;;;;,:::,,,,;,;;;,;,::: : : :       ::::: :         

 
    RRMMM@QRMRMMMRMRDMEbbMStYt2XhP0MEPY1h2Yb9MMMpJhYr2YhDMEZ0
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
    .,.,.,..:::::.:::...::iirirrrirri:::.......,.,.........,.



##安全发布
任何线程都可以在不需要额外同步的情况下安全地访问不可变对象，即使在发布这些对象时没有使用同步。
安全发布的常用模式 
在静态初始化函数中初始化一个对象引用。
将对象的引用保存到volatile类型的域或者AtomicReferance对象中。
将对象的引用保存到某个正确构造对象的final类型域中。
将对象的引用保存到一个由锁保护的域中。


##几个链接而已
<ul>
  <li><a href="https://zorrock.disqus.com/admin/settings/universalcode/" target="_blank" class="external">disqus添加到你的博客</a></li>
  <li><a href="https://zorrock.disqus.com/admin/settings/universalcode/" target="_blank" class="external">流量统计系统</a></li>
  <li><a href="http://www.linezing.com/login2.php" target="_blank" class="external">IP来源分析</a></li>
  <li><a href="http://ip.taobao.com/ipSearch.php?ipAddr=101.71.243.139" target="_blank" class="external">淘宝IP地址库</a></li>
  <li><a href="http://ip.taobao.com/ipSearch.php?ipAddr=101.71.243.139" target="_blank" class="external">并行逻辑回归</a></li>
  <li><a href="http://xuanpai.sinaapp.com/fuzhus" target="_blank" class="external">网络小说辅助设定</a></li>
</ul>

[NovelAssistant][NovelAssistant]可以为帮助那些闲的蛋痛的盆友动手写小说，譬如：
<ul>
  <li>动作语言描写</li>
  <li>情节辅助设定</li>
  <li>人物活动背景设定</li>
  <li>等等</li>
</ul>


[SV]: http://supervisord.org/ "Supervisor"
[Nginx]: http://nginx.com/ "Nginx"
[NovelAssistant]: http://xuanpai.sinaapp.com/ "novel"
