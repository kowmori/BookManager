//
//  BMAccountCreateViewController.m
//  BookManager
//
//  Created by 森島航 on 2014/05/04.
//  Copyright (c) 2014年 wataru.morishima. All rights reserved.
//

#import "BMAccountCreateViewController.h"
#import "BMAccountSettingViewController.h"
#import "BMTableViewController.h"

@interface BMAccountCreateViewController ()<BMAccountSettingViewControllerDelegate>

@end

@implementation BMAccountCreateViewController

- (void)viewDidLoad
{
    // ナビゲーションバーを生成
    UINavigationBar* navBarTop = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    // ナビゲーションアイテムを生成
    UINavigationItem* title = [[UINavigationItem alloc] initWithTitle:@"設定"];
    // ナビゲーションバーにナビゲーションアイテムを設置
    [navBarTop pushNavigationItem:title animated:YES];
    // ビューにナビゲーションアイテムを設置
    [self.view addSubview:navBarTop];
    [super viewDidLoad];
}


- (IBAction)settingButton:(id)sender {
    BMAccountSettingViewController *accountSettingViewController;
    accountSettingViewController = [[BMAccountSettingViewController alloc]initWithNibName:@"BMAccountSettingViewController" bundle:nil];
    accountSettingViewController.delegate = self;
    [self presentViewController:accountSettingViewController animated:YES completion:nil];
}
@end
