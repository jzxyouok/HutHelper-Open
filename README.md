![76@2x](https://o90qqsid7.qnssl.com/76@2x-1.png)
湖南工业大学校园助手iOS端
# 项目总体概况
> 截止到17年1月24日，上架三个月的时间里，iOS端使用者已经达到2500人，另外Android端使用人数已过8000+,主要使用对象为湖南工业大学学生，覆盖全校60%以上人群，iOS端开发语言采用Objective-c，开发软件为Xcode，适配iOS8以上系统，后端数据部分采用JSON。
> 下载方式: [AppStore](https://itunes.apple.com/cn/app/gong-da-zhu-shou-hu-nan-gong/id1164848835)

# 项目框架
```
.
	├── HutHelper
	│   ├── 3rd：因为各种原因没有用Pods管理的第三方库
	│   ├── Utils：一些工具类等
	│   ├── Request：网络请求
	│   ├── Models：数据模型
	│   ├── View：界面，xib或者storyboard之类的文件
	│   ├── Supporting Files：一些支持文件
	│   └── Controllers
	│       ├── Main：主界面
	│       ├── Login：登录界面
	│       ├── Class：课程表
	│       ├── Score：考试成绩
	│       ├── Exam：考试计划查询
	│       ├── User：用户界面
	│       ├── FeedBack：反馈界面
	│       ├── Power：寝室电费查询
	│       ├── Set：用户设置界面
	│       ├── Lost：失物招领界面
	│       ├── Day：校历界面
	│       ├── HomeWork：网上作业界面
	│       ├── Hand：二手市场界面
	│       ├── Library：图书馆界面
	│       ├── Other：其他
	└── Pods：项目使用了[CocoaPods](http://code4app.com/article/cocoapods-install-usage)这个类库管理工具
	└── json:请求的示例数据
```
请注意，因为使用了Pods,所以请下载完项目后先运行
```
pod install
```
另外考虑到在校用户信息的安全性,**App的接口地址全部换成了镜像接口,与线上版本不同**
除此之外，一切和上线版本代码全部一致
同时因为镜像接口的数据是固定的,所以测试时，**登录界面，无论输入什么，点登录就可以**
课程数据,考试数据,用户数据,课表数据,说说数据,二手数据这些也都是固定的
**如果要进行二次开发，可以直接把请求的地址改成自己后端的地址，然后把接受的数据改一下即可.**
请求的数据可以在json文件夹中查看


# 上架情况
![上架情况](https://o90qqsid7.qnssl.com/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202016-11-06%2016.37.49.png)

# 功能介绍
## 登录界面
登录界面采用简洁的方式展示，界面直接使用xib做成。用户输入学号和密码后，将通过JSON连接网络，得到Msg信息，若成功，读取学生个人信息，以及拿到密匙。若失败返回Msg错误信息。
![登录界面](https://o90qqsid7.qnssl.com/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202016-11-06%2018.56.58.png)
同时为了避免忘记密码的情况发生，设置重置密码的链接，这里直接使用了一个浏览器展示重置密码的网页。
![重置密码](https://o90qqsid7.qnssl.com/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202016-11-06%2019.01.37.png)
## 主界面
同样的这个界面也是使用xib的方式，一个Image控件，然后九个Button控件以及相应的TextView控件写明按钮名称，很简单没啥技术含量。
只是在这个主界面启动时，有很多数据需要初始化。
> viewDidLoad()方法中，需要计算APP打开的此时的周数，并且通过NSUserDefaults类将其数据存储到plist文件中
> 判断是否为第一次登陆，是的话跳转到登陆界面
> 判断设置中是否设置自动打开课程表，是的话跳转到课程表
> 判断用户信息的标签是否上传
> 初始化抽屉界面
> ...

![主界面](https://o90qqsid7.qnssl.com/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202016-11-06%2019.05.00.png)

## 成绩查询
这里调用了[UUCharView - 成绩曲线图标](https://github.com/ZhipingYang/UUChartView)开源项目，展现了用户成绩数据，首先第一次打开这个界面会读取用户成绩数据，并缓存，后面几次打开时会直接读取缓存数据。如果需要刷新的话可以点刷新按钮。
![曲线成绩](https://o90qqsid7.qnssl.com/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202016-11-06%2019.13.48.png)
点右上角的按钮可以查询所有课程的成绩数据，同时也可以折叠数据。
![所有成绩查询](https://o90qqsid7.qnssl.com/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202016-11-06%2019.16.47.png)
## 课程表
这里使用了[GWPCourseListView - 课程表界面](https://github.com/GanWenpeng/GWPCourseListView)开源项目，做了一些调整，并且修复了一些bug，开发者已经接受了我的pull。
同时自己集成了[LGPlusButtonsView - 按钮控件](https://github.com/Friend-LGA/LGPlusButtonsView)开源项目的按钮控件，使课程表数据可以上下周的调整。
> 另外加入了实验课程表，可以单独显示，也可以在设置里面设置成一起显示

![课程表](https://o90qqsid7.qnssl.com/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202016-11-06%2019.17.43.png)

## 考试计划
考试计划中将显示教务处正在计划和已经确定的考试，其中已经确定的用绿灯表示，正在计划的用红灯表示。
![考试计划](https://o90qqsid7.qnssl.com/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202016-11-06%2019.37.30.png)

## 电费查询
简单的调用接口查询，没什么技术含量
![电费查询](https://o90qqsid7.qnssl.com/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202016-11-06%2019.39.13.png)

## 图书馆/校园说说/二手市场/网上作业
这四个都直接用的Web端，还没有时间来得及做，会尽快补上，先直接放浏览图吧
![图书馆](https://o90qqsid7.qnssl.com/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202016-11-06%2019.41.19.png)
![校园说说](https://o90qqsid7.qnssl.com/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202016-11-06%2019.41.30.png)
![二手市场](https://o90qqsid7.qnssl.com/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202016-11-06%2019.41.36.png)
![网上作业](https://o90qqsid7.qnssl.com/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202016-11-06%2019.41.41.png)

# 项目使用的开源项目
- [LeftSlide - 主界面框架](https://github.com/chennyhuang/LeftSlide)
- [MBProgressHUD - 等待框动画](https://github.com/jdg/MBProgressHUD)
- [GWPCourseListView - 课程表界面](https://github.com/GanWenpeng/GWPCourseListView)
- [LGPlusButtonsView - 按钮控件](https://github.com/Friend-LGA/LGPlusButtonsView)
- [UUCharView - 成绩曲线图标](https://github.com/ZhipingYang/UUChartView)
- [SKSTableView - 成绩列表](https://github.com/sakkaras/SKSTableView)
- [TZImagePickerController - 照片选择器]
- [SDWebImage - 异步多图加载]
- [MJRefresh - 上拉下拉刷新]
- [YYModel - Json转Model]
- [AFNetworking - 请求异步加载]
- [UMengUShare - 友盟分享]
- [ASIHTTPRequest - 照片同步上传]

# 最后
这是本人刚进大二,在湖南工业大学实验室写的一款App，目的主要是为湖南工业大学的学生提供一些便利,同时也是湖南省省级项目,App中有很多不足的地方,代码的可读性也不是很好,甚至于最开始的版本，网络请求都是同步请求，没有加载框，很容易卡死。但是不管如何，我都在完善。
这是开源的第一个版本,在后续每当上线版本有大的更新后，我都会同步发布在这里
其目的是，如果有其他学校的同学也需要开发一个服务于自己母校的iOS App，可以从这得到一定的参考
如果有任何问题也可以在issues留言

**最后,求一个Star**
我的个人网站是[www.wxz.name](www.wxz.name)

# License
[Apache Licene 2.0](http://www.apache.org/licenses/LICENSE-2.0.html)



