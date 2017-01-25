![76@2x](https://o90qqsid7.qnssl.com/76@2x-1.png)
湖南工业大学校园助手iOS端
# 项目总体概况
> 截止到17年1月24日，上架三个月的时间里，使用者已经达到2500人，主要使用对象为湖南工业大学学生，开发语言采用Objective-c，开发软件为Xcode，适配iOS8以上系统，后端数据部分采用JSON，由实验室网络组负责。
![](/https://o90qqsid7.qnssl.com/14853135352743.jpg)

> 下载方式: AppStore搜索工大助手
<!--more-->
## 目前实现功能如下
![功能情况](https://o90qqsid7.qnssl.com/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202016-11-06%2016.35.51.png)

## 上架情况
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
> [LeftSlide - 主界面框架](https://github.com/chennyhuang/LeftSlide)
> [MBProgressHUD - 等待框动画](https://github.com/jdg/MBProgressHUD)
> [GWPCourseListView - 课程表界面](https://github.com/GanWenpeng/GWPCourseListView)
> [LGPlusButtonsView - 按钮控件](https://github.com/Friend-LGA/LGPlusButtonsView)
> [UUCharView - 成绩曲线图标](https://github.com/ZhipingYang/UUChartView)
> [SKSTableView - 成绩列表](https://github.com/sakkaras/SKSTableView)




