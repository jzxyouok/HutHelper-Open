//
//  MainPageViewController.m
//  LeftSlide
//
//  Created by huangzhenyu on 15/6/18.
//  Copyright (c) 2015年 eamon. All rights reserved.
//

#import "MainPageViewController.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "HomeWorkViewController.h"
#import "ClassViewController.h"
#import "PowerViewController.h"
#import "LibraryViewController.h"
#import "NoticeViewController.h"
#import "DayViewController.h"
#import "UMessage.h"
#import "UMMobClick/MobClick.h"
#import "FirstLoginViewController.h"
#import<CommonCrypto/CommonDigest.h>
#import "ScoreViewController.h"
#import "MBProgressHUD.h"
#import "RootViewController.h"
#import "UINavigationBar+Awesome.h"
#import "APIManager.h"
#import "YYModel.h"
#import "User.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "SayViewController.h"
#import "HandTableViewController.h"
#import "Math.h"
#define vBackBarButtonItemName  @"backArrow.png"    //导航条返回默认图片名
@interface MainPageViewController ()

@property (weak, nonatomic) IBOutlet UILabel *Scontent;
@property (weak, nonatomic) IBOutlet UILabel *Time;


@end

@implementation NSString (MD5)
- (id)MD5
{
    const char *cStr           = [self UTF8String];
    unsigned char digest[16];
    unsigned int x=(int)strlen(cStr) ;
    CC_MD5( cStr, x, digest );
    // This is the md5 call
    NSMutableString *output    = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i                  = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}
@end

@implementation MainPageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    /**标题文字*/
    //  self.navigationItem.title                 = @"主界面";
    UIColor *greyColor                        = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    self.view.backgroundColor                 = greyColor;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];   //标题字体颜色
    
    /**友盟统计*/
    Class cls                                 = NSClassFromString(@"UMANUtil");
    SEL deviceIDSelector                      = @selector(openUDIDString);
    NSString *deviceID                        = nil;
    if(cls && [cls respondsToSelector:deviceIDSelector]){
        deviceID                                  = [cls performSelector:deviceIDSelector];
    }
    NSData* jsonData                          = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
                                                                                options:NSJSONWritingPrettyPrinted
                                                                                  error:nil];
    
    /**主界面*/
    UIButton *menuBtn                         = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame                             = CGRectMake(0, 0, 20, 18);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(openOrCloseLeftList) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem     = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    [self isAppFirstRun];
    /**  首次登陆 */
    NSDictionary *User_All=[defaults objectForKey:@"User"];
    if(User_All==NULL){
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        FirstLoginViewController *firstlogin                = [[FirstLoginViewController alloc] init];
        [tempAppDelegate.mainNavigationController pushViewController:firstlogin animated:YES];
    }
    
    /**   判断第几周 */
    NSDate *now                               = [NSDate date];
    NSCalendar *calendar                      = [NSCalendar currentCalendar];
    NSUInteger unitFlags                      = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent           = [calendar components:unitFlags fromDate:now];
    int year                                  = [dateComponent year];//年
    int month                                 = [dateComponent month];//月
    int day                                   = [dateComponent day];//日
    [defaults setInteger:[Math CountWeeks:year m:month d:day] forKey:@"NowWeek"];
    
   
    NSArray *array                            = [defaults objectForKey:@"array_class"];
    NSString *autoclass=[defaults objectForKey:@"autoclass"];
    /**  是否自动打开课程表  */
    if(array!=NULL&&[autoclass isEqualToString:@"打开"]){
        UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ClassViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Class"];
        AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:NO];
    }
    /** 添加标签 */
    NSString *class_name                      = [defaults objectForKey:@"class_name"];
    NSString *dep_name                        = [defaults objectForKey:@"dep_name"];
    [UMessage addTag:class_name
            response:^(id responseObject, NSInteger remain, NSError *error) {
                
            }];//班级
    [UMessage addTag:dep_name
            response:^(id responseObject, NSInteger remain, NSError *error) {
                //add your codes
            }];  //学院
    /** 添加别名*/
    User *user = [User yy_modelWithJSON:User_All];
    [UMessage addAlias:user.data.studentKH type:kUMessageAliasTypeSina response:^(id responseObject, NSError *error) {
    }];
    /** 标题栏样式 */
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0/255.0 green:224/255.0 blue:208/255.0 alpha:1]];
    /** 预留方法 */
    [self jspath];
    /**时间Label*/
    [self SetTimeLabel];
}

- (void) openOrCloseLeftList  //侧栏滑动
{
    AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (tempAppDelegate.LeftSlideVC.closed)
    {
        [tempAppDelegate.LeftSlideVC openLeftView];
        
    }
    else
    {
        [tempAppDelegate.LeftSlideVC closeLeftView];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
    UIColor *ownColor                = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    [[UINavigationBar appearance] setBarTintColor: ownColor];  //颜色
    [self.navigationController.navigationBar lt_reset];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:YES];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDate *now                               = [NSDate date];
    NSCalendar *calendar                      = [NSCalendar currentCalendar];
    NSUInteger unitFlags                      = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent           = [calendar components:unitFlags fromDate:now];
    int year                                  = [dateComponent year];//年
    int month                                 = [dateComponent month];//月
    int day                                   = [dateComponent day];//日
    [defaults setInteger:[Math CountWeeks:year m:month d:day] forKey:@"NowWeek"];
    [defaults setInteger:[Math CountWeeks:year m:month d:day] forKey:@"TrueWeek"];
    //判断完毕//
    /**导航栏变为透明*/
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:0];
    /**让黑线消失的方法*/
    self.navigationController.navigationBar.shadowImage=[UIImage new];
}
int class_error_;
- (IBAction)ClassFind:(id)sender {  //课表界面
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSArray *array_class                            = [defaults objectForKey:@"array_class"];
    NSArray *array_xp                            = [defaults objectForKey:@"array_xp"];
    NSDictionary *User_Data=[defaults objectForKey:@"User"];
    User *user=[User yy_modelWithJSON:User_Data];
    if(array_class==NULL&&array_xp==NULL){
        /**拼接地址*/
        [MBProgressHUD showMessage:@"查询中" toView:self.view];
        NSString *Url_String=@"http://app.wxz.name/api/Class_ps";
        NSLog(@"平时课表地址:%@",Url_String);
        NSString *UrlXP_String=@"http://app.wxz.name/api/Class_xp";
        NSLog(@"实验课表地址:%@",UrlXP_String);
        /**设置9秒超时*/
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 9.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        /**请求平时课表*/
        [manager GET:Url_String parameters:nil progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSDictionary *Class_All = [NSDictionary dictionaryWithDictionary:responseObject];
                 NSString *Msg=[Class_All objectForKey:@"msg"];
                 if ([Msg isEqualToString:@"ok"]) {
                     NSArray *array               = [Class_All objectForKey:@"data"];
                     [defaults setObject:array forKey:@"array_class"];
                     [defaults synchronize];
                     /**请求实验课表*/
                     [manager GET:UrlXP_String parameters:nil progress:nil
                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              NSDictionary *ClassXP_All = [NSDictionary dictionaryWithDictionary:responseObject];
                              NSString *Msg=[ClassXP_All objectForKey:@"msg"];
                              if ([Msg isEqualToString:@"ok"]) {
                                  NSArray *array               = [ClassXP_All objectForKey:@"data"];
                                  [defaults setObject:array forKey:@"array_xp"];
                                  [defaults synchronize];
                                  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                  UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                  ClassViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Class"];
                                  AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                  [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:NO];
                              }
                          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                              [MBProgressHUD showError:@"网络错误，实验课表查询失败"];
                          }];
                 }
                 else if([Msg isEqualToString:@"令牌错误"]){
                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                     [MBProgressHUD showError:@"登录过期,请重新登录"];
                 }
                 else{
                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                     [MBProgressHUD showError:@"查询失败"];
                 }
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 [MBProgressHUD showError:@"网络错误，平时课表查询失败"];
             }];
    }
    else{
        UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ClassViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Class"];
        AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:NO];
    }
    
    
    
    
} //课程表

- (IBAction)ClassXPFind:(id)sender {  //课表界面
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSArray *array_class                            = [defaults objectForKey:@"array_class"];
    NSArray *array_xp                            = [defaults objectForKey:@"array_xp"];
    NSDictionary *User_Data=[defaults objectForKey:@"User"];
    User *user=[User yy_modelWithJSON:User_Data];
    if(array_class==NULL&&array_xp==NULL){
        /**拼接地址*/
        [MBProgressHUD showMessage:@"查询中" toView:self.view];
        NSString *Url_String=@"http://app.wxz.name/api/Class_ps";
        NSLog(@"平时课表地址:%@",Url_String);
        NSString *UrlXP_String=@"http://app.wxz.name/api/Class_xp";
        NSLog(@"实验课表地址:%@",UrlXP_String);
        /**设置9秒超时*/
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 9.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        /**请求平时课表*/
        [manager GET:Url_String parameters:nil progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSDictionary *Class_All = [NSDictionary dictionaryWithDictionary:responseObject];
                 NSString *Msg=[Class_All objectForKey:@"msg"];
                 if ([Msg isEqualToString:@"ok"]) {
                     NSArray *array               = [Class_All objectForKey:@"data"];
                     [defaults setObject:array forKey:@"array_class"];
                     [defaults synchronize];
                     /**请求实验课表*/
                     [manager GET:UrlXP_String parameters:nil progress:nil
                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              NSDictionary *ClassXP_All = [NSDictionary dictionaryWithDictionary:responseObject];
                              NSString *Msg=[ClassXP_All objectForKey:@"msg"];
                              if ([Msg isEqualToString:@"ok"]) {
                                  NSArray *array               = [ClassXP_All objectForKey:@"data"];
                                  [defaults setObject:array forKey:@"array_xp"];
                                  [defaults synchronize];
                                  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                  UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                  ClassViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Class"];
                                  AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                  [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:NO];
                              }
                          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                              [MBProgressHUD showError:@"网络错误，实验课表查询失败"];
                          }];
                 }
                 else if([Msg isEqualToString:@"令牌错误"]){
                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                     [MBProgressHUD showError:@"登录过期,请重新登录"];
                 }
                 else{
                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                     [MBProgressHUD showError:@"查询失败"];
                 }
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 [MBProgressHUD showError:@"网络错误，平时课表查询失败"];
             }];
    }
    else{
        UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ClassViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Class"];
        AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:NO];
    }
    
    
    
} //实验课表

- (IBAction)HomeWork:(id)sender { //作业界面
    UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ClassViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"HomeWork"];
    AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:YES];
} //网上作业

- (IBAction)Power:(id)sender {
    UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ClassViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Power"];
    AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:YES];
} //电费查询

- (IBAction)SchoolSay:(id)sender {
    /**设置不缓存*/
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0
                                                            diskCapacity:0
                                                                diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    [MBProgressHUD showMessage:@"加载中" toView:self.view];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    /**拼接地址*/
    NSString *Url_String=@"http://app.wxz.name/api/Say";
    /**设置9秒超时*/
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 4.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    /**请求平时课表*/
    [manager GET:Url_String parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *Say_All = [NSDictionary dictionaryWithDictionary:responseObject];
             if ([[Say_All objectForKey:@"msg"]isEqualToString:@"ok"]) {
                 NSDictionary *Say_Data=[Say_All objectForKey:@"data"];
                 NSArray *Say_content=[Say_Data objectForKey:@"posts"];//加载该页数据
                 if (Say_content!=NULL) {
                     [defaults setObject:Say_content forKey:@"Say"];
                     [defaults synchronize];
                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                     SayViewController *Say      = [[SayViewController alloc] init];
                     AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                     [tempAppDelegate.mainNavigationController pushViewController:Say animated:YES];
                     
                 }
                 else{
                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                     [MBProgressHUD showError:@"网络错误"];
                 }
             }
             else{
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 [MBProgressHUD showError:[Say_All objectForKey:@"msg"]];
             }             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [MBProgressHUD showError:@"网络错误"];
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         }];
    
    
    
    
    
    
} //校园说说

- (IBAction)SchoolHand:(id)sender {
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0
                                                            diskCapacity:0
                                                                diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    [MBProgressHUD showMessage:@"加载中" toView:self.view];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    /**拼接地址*/
    NSString *Url_String=@"http://app.wxz.name/api/Hand";
    /**设置9秒超时*/
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 4.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    /**请求平时课表*/
    [manager GET:Url_String parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *dic1 = [NSDictionary dictionaryWithObject:responseObject forKey:@""];
             NSArray *Hand           = [dic1 objectForKey:@""];
             [defaults setObject:Hand forKey:@"Hand"];
             [defaults synchronize];
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             HandTableViewController *hand=[[HandTableViewController alloc]init];
             AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
             [tempAppDelegate.mainNavigationController pushViewController:hand animated:YES];
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [MBProgressHUD showError:@"网络错误"];
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         }];
} //二手市场

- (IBAction)Score:(id)sender {
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSData* ScoreData           = [defaults objectForKey:@"Score"];
    NSDictionary *User_Data=[defaults objectForKey:@"User"];
    User *user=[User yy_modelWithJSON:User_Data];
    if(ScoreData==NULL){
        /**拼接地址*/
        [MBProgressHUD showMessage:@"查询中" toView:self.view];
        NSString *SHA_String=[user.data.studentKH stringByAppendingString:user.remember_code_app];
        SHA_String=[SHA_String stringByAppendingString:@"f$Z@%"];
        SHA_String=[Math sha1:SHA_String];
        NSString *Url_String=@"http://app.wxz.name/api/Score";
        NSLog(@"成绩查询地址:%@",Url_String);
        /**设置9秒超时*/
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 9.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        /**请求*/
        [manager GET:Url_String parameters:nil progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSDictionary *Score_All = [NSDictionary dictionaryWithDictionary:responseObject];
                 NSData *Score_Data =    [NSJSONSerialization dataWithJSONObject:Score_All options:NSJSONWritingPrettyPrinted error:nil];
                 
                 NSString *Msg=[Score_All objectForKey:@"msg"];
                 if([Msg isEqualToString:@"ok"]){
                     [defaults setObject:Score_Data forKey:@"data_score"];
                     [defaults synchronize];
                     RootViewController *Score      = [[RootViewController alloc] init];
                     AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                     [tempAppDelegate.mainNavigationController pushViewController:Score animated:YES];
                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 }
                 else if([Msg isEqualToString:@"令牌错误"]){
                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                     [MBProgressHUD showError:@"登录过期,请重新登录"];
                 }
                 else{
                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                     [MBProgressHUD showError:@"请检查网络或者重新登录"];
                 }
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 [MBProgressHUD showError:@"请检查网络或者重新登录"];
             }];
    }
    
} //成绩查询

- (IBAction)Library:(id)sender {
    UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ClassViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Library"];
    AppDelegate *tempAppDelegate              = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:YES];
    
} //图书馆

- (IBAction)Exam:(id)sender {
    [MBProgressHUD showMessage:@"查询中" toView:self.view];
    /**拼接地址*/
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *User_Data=[defaults objectForKey:@"User"];
    User *user=[User yy_modelWithJSON:User_Data];
    NSString *ss=[user.data.studentKH stringByAppendingString:@"apiforapp!"];
    ss=[ss MD5];
    NSString *Url_String=@"http://app.wxz.name/api/Exam";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    /**设置4秒超时*/
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 4.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    /**请求*/
    [manager GET:Url_String parameters:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *Exam_All = [NSDictionary dictionaryWithDictionary:responseObject];
             NSDictionary *Exam_Data=[Exam_All objectForKey:@"data"];//All字典 -> Data字典
             NSData *Exam_data =    [NSJSONSerialization dataWithJSONObject:Exam_All options:NSJSONWritingPrettyPrinted error:nil];
             NSString *message=[Exam_All objectForKey:@"message"];
             NSString *status=[Exam_All objectForKey:@"status"];
             if([status isEqualToString:@"success"]){
                 NSDictionary *Class_Data=[Exam_All objectForKey:@"res"];
                 NSMutableArray *array             = [Class_Data objectForKey:@"exam"];
                 NSMutableArray *arraycx             = [Class_Data objectForKey:@"cxexam"];
                 [defaults setObject:Exam_data forKey:@"Exam"];
                 [defaults synchronize];
                 NSInteger *exam_on                        = [defaults integerForKey:@"exam_on"];
                 if(array.count!=0){
                     [self EnterExam];
                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 }
                 else{
                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                     [MBProgressHUD showError:@"计划表上暂无考试"];
                 }
             }
             else{
                 [self EnterExam];
                 [MBProgressHUD showError:@"超时,显示本地数据"];
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             if ([defaults objectForKey:@"Exam"]!=NULL) {
                 [self EnterExam];
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 [MBProgressHUD showError:@"超时,显示本地数据"];
             }
             else{
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 [MBProgressHUD showError:@"网络错误"];
             }
         }];
} //考试计划

- (IBAction)Day:(id)sender {  //校历
    UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainPageViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Day"];
    AppDelegate *tempAppDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:NO];
}  //校历

- (IBAction)Lost:(id)sender {
    UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainPageViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"Lost"];
    AppDelegate *tempAppDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:NO];
}  //失物招领

- (void) isAppFirstRun{
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary]
                                objectForKey:@"CFBundleShortVersionString"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastRunKey = [defaults objectForKey:@"last_run_version_key"];
    NSLog(@"当前版本%@",currentVersion);
    NSLog(@"上个版本%@",lastRunKey);
        if (lastRunKey==NULL) {
            NSString *appDomain       = [[NSBundle mainBundle] bundleIdentifier];
            [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
            [defaults setObject:currentVersion forKey:@"last_run_version_key"];
            NSLog(@"没有记录");
    
        }
        else if (![lastRunKey isEqualToString:currentVersion]) {
            NSString *appDomain       = [[NSBundle mainBundle] bundleIdentifier];
            [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
            [defaults setObject:currentVersion forKey:@"last_run_version_key"];
            NSLog(@"记录不匹配");
        }
    
}
#pragma mark -"其他方法"
-(void)jspath{
    
}
-(void)SetTimeLabel{
    NSDate *now                               = [NSDate date];
    NSCalendar *calendar                      = [NSCalendar currentCalendar];
    NSUInteger unitFlags                      = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent           = [calendar components:unitFlags fromDate:now];

        int y                                     = (short)[dateComponent year];//年
        int m                                    = [dateComponent month];//月
       int mou                                    = [dateComponent month];//月
    NSLog(@"%d月",m);
        int d                                      = (short)[dateComponent day];//日
       int day                                      = (short)[dateComponent day];//日
        if(m==1||m==2) {
            m+=12;
            y--;
        }
        int iWeek=(d+2*m+3*(m+1)/5+y+y/4-y/100+y/400)%7+1;
    NSString *Week;
    switch (iWeek) {
        case 1:
            Week=@"一";
            break;
        case 2:
            Week=@"二";
            break;
        case 3:
            Week=@"三";
            break;
        case 4:
            Week=@"四";
            break;
        case 5:
            Week=@"五";
            break;
        case 6:
            Week=@"六";
            break;
        case 7:
            Week=@"日";
            break;
        default:
            Week=@"";
            break;
    }
    _Time.text=[NSString stringWithFormat:@"%d月%d日 星期%@",mou,day,Week];
}

-(void)EnterExam{
    UIStoryboard *mainStoryBoard              = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainPageViewController *secondViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"ExamNew"];
    AppDelegate *tempAppDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.mainNavigationController pushViewController:secondViewController animated:NO];
}
@end
