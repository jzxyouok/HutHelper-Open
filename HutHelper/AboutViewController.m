//
//  AboutViewController.m
//  HutHelper
//
//  Created by nine on 2016/10/11.
//  Copyright © 2016年 nine. All rights reserved.
//

#import "AboutViewController.h"
#import "JSONKit.h"
#import "AppDelegate.h"
#import "LeftSortsViewController.h"
@interface AboutViewController ()
@property (weak, nonatomic) IBOutlet UILabel *version;

@end

@implementation AboutViewController





- (void)viewDidLoad {
    [super viewDidLoad];
       self.navigationItem.title = @"关于";
    UIColor *greyColor        = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    self.view.backgroundColor = greyColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    // Do any additional setup after loading the view from its nib.
    NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
   _version.text=app_Version;
}
- (IBAction)Appscore:(id)sender {
    NSString *str = @"https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1164848835&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8";
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
