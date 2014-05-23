//
//  BMAppDelegate.m
//  BookManager
//
//  Created by 森島航 on 2014/05/02.
//  Copyright (c) 2014年 wataru.morishima. All rights reserved.
//

#import "BMAppDelegate.h"
#import "BMTableViewController.h"
#import "BMAccountCreateViewController.h"
#import "BMAccountSettingViewController.h"

@implementation BMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // UIWindowのサイズをデバイスのディスプレイに合わせて定義する
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // BMAccountSettingViewControllerを呼び出す
    //BMAccountSettingViewController *accountSettingViewController;
    //accountSettingViewController = [[BMAccountSettingViewController alloc]initWithNibName:@"BMAccountSettingViewController" bundle:nil];
    
    // ナビゲーションバー設定
    UIImage *image = [UIImage imageNamed:@"NavBack.png"];
    [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    // UITabBarControllerをRootViewControllerに設定する
    BMTableViewController *firstTab = [[BMTableViewController alloc] init];
    BMAccountCreateViewController *secondTab = [[BMAccountCreateViewController alloc] init];
    UITabBarController *tabBarCon = [[UITabBarController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:firstTab];
    [tabBarCon addChildViewController:nav];
    [tabBarCon addChildViewController:secondTab];
    
    //タブのタイトル指定
    [firstTab setTitle:@"書籍一覧"];
    [secondTab setTitle:@"設定"];
    //タブのタイトル位置設定
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -17)];
    
    // タブバー設定
    UIImage *image2 = [UIImage imageNamed:@"TabBar.png"];
    [[UITabBar appearance] setBackgroundImage:image2];

    //self.window.rootViewController = accountSettingViewController;
    self.window.rootViewController = tabBarCon;
    
    // キーウィンドウを作成して描画
    [self.window makeKeyAndVisible];
    return YES;
}

@end
