# 饭否精选 

### Screenshots

![mockup](Screenshots/Mockup.png)

### Intro

饭否精选是由 [@.rex](https://fanfou.com/zhasm) 维护的一个饭否周边网站，收集每日/每周饭否里比较火（似乎是收藏比较多）的消息，网站[在此](http://blog.fanfou.com/digest/)。FanfouExpress 根据 [FanfouDailyApiDoc](https://github.com/Anthonyeef/FanfouDailyApiDoc) 整理的 API 将饭否精选呈现在 iOS 上。由于算是一个比较私人的作品，加上饭否精选的 API 在 2018 年 2 月 11 日暂停更新，所以功能不多；未来如果饭否精选恢复更新了，应该会再加入一些新的功能。

目前的功能主要有：

- “摇一摇” 手机，可以随机阅读从 2015-10-05 到 2018-02-11 之间某一天的精选内容（原本的设置是默认显示当天的精选内容，但由于饭否精选的 API 在 2018 年 2 月 11 日暂停更新，所以只能在已有的数据中读取）。
- 可以打开消息中的链接（使用 SFSafariViewController）。图片浏览器中可双击放大图片，长按图片保存到相册，播放 GIF 图等。分享精选内容到其它 App。

### Memo

- 用到的楷体字体，是直接添加到项目里的。这里可能比较麻烦的是需要在 `info.plist` 中指定字体文件真正的名称，所以我写了一个 [FontShow](https://github.com/zchan0/FontShow) 可以比较快的查阅。
- 实现了`UIViewControllerAnimatedTransitioning` 协议，定义了列表页和详情页之间转场动画，以及打开/关闭图片时的小动画。具体可以查看 TimelineAnimator 和 PhotoBrowserAnimator 两个文件。
- `ImageScrollView` 是参考 [PhotoScroller](https://developer.apple.com/library/content/samplecode/PhotoScroller/Introduction/Intro.html#//apple_ref/doc/uid/DTS40010080-Intro-DontLinkElementID_2) 实现的
- [UI设计稿](https://www.dropbox.com/s/xmzlqb5336wrnpk/FanfouExpress.sketch?dl=0)











