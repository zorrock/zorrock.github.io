---
layout: post
title: face tracker, tracker
description: 能不能拯救中国动画于水火，能不能。
category: project
---

####表情跟踪
每每看到中国动画里的人物一个个像木偶般要么表情僵硬要么就是极度扭曲，心里就难受。于是乎，我冒出个想法。于是乎，这个想法一直没有实践过。偶然滴前几天逛github居然逛到了facetracker，编译运行了下，效果还是很不错的。可以把人物的眼耳口鼻跟踪捕获出来。要是将这些点和三维模型绑定到一起，玩起来还是很欢乐的。
(PS:后面gintama的gif没用上跟踪提取出来的特征点，因为用上后还是扭曲丑陋滴。。。)

我把玩了一下下：[myvideo][myvideo]

<a href="https://http://video.weibo.com/show?fid=1034:a5a6ac8657efe015eb68a360084d1403" title="motion"><img src="/images/facetracker/motion.png" alt="Nature"></a>

<div id="transform1">
<div class="inner">
<img src="/images/facetracker/win.gif" alt="Nature">
<img src="/images/facetracker/faceline.gif" alt="Nature">
<img src="/images/facetracker/gintama.gif" alt="Nature">
</div>
</div>

[facetracker][facetracker]

[facetracker]: https://github.com/kylemcdonald/ofxFaceTracker/ "facetracker"
[myvideo]: http://video.weibo.com/show?fid=1034:a5a6ac8657efe015eb68a360084d1403 "myvideo"