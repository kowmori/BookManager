//
//  BMAccountSettingViewController.m
//  BookManager
//
//  Created by 森島航 on 2014/05/04.
//  Copyright (c) 2014年 wataru.morishima. All rights reserved.
//

#import "BMAccountSettingViewController.h"
#import "BMAccountCreateViewController.h"
#import "BMTableViewController.h"
#import "BMAppDelegate.h"
#import <AFNetworking/AFNetworking.h>

@interface BMAccountSettingViewController ()

@end

@implementation BMAccountSettingViewController

- (void)viewDidLoad
{
    _mailText.delegate = self;
    _passText.delegate = self;
    _passConfText.delegate = self;
    _mailText.returnKeyType = UIReturnKeyDone;
    _passText.returnKeyType = UIReturnKeyDone;
    _passConfText.returnKeyType = UIReturnKeyDone;
    _passText.secureTextEntry = YES;
    _passConfText.secureTextEntry = YES;
    _scrollView.delegate = self;
    
    // キーボードが表示されたときのNotificationをうけとる
    [self registerForKeyboardNotifications];
    
    // ナビゲーションバーを生成
    UINavigationBar* navBarTop = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    // ナビゲーションアイテムを生成
    UINavigationItem* title = [[UINavigationItem alloc] initWithTitle:@"アカウント設定"];
    // 戻るボタンを生成
    UIBarButtonItem* btnItemBack = [[UIBarButtonItem alloc] initWithTitle:@"閉じる" style:UIBarButtonItemStyleBordered target:self action:@selector(closeButton:)];
    // 保存ボタンを生成
    UIBarButtonItem* btnItemSave;
    if (self.delegate) {
        btnItemSave = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(saveButton:)];
        // アカウント情報取得
        [self getAccount];
    } else {
        if ([_status isEqualToString:@"OK"]) {
            btnItemSave = [[UIBarButtonItem alloc] initWithTitle:@"ログイン" style:UIBarButtonItemStyleBordered target:self action:@selector(saveButton:)];
        } else {
            btnItemSave = [[UIBarButtonItem alloc] initWithTitle:@"登録" style:UIBarButtonItemStyleBordered target:self action:@selector(saveButton:)];
        }
    }

    // ナビゲーションアイテムの右側に戻るボタンを設置
    title.leftBarButtonItem = btnItemBack;
    title.rightBarButtonItem = btnItemSave;
    // ナビゲーションバーにナビゲーションアイテムを設置
    [navBarTop pushNavigationItem:title animated:YES];
    // ビューにナビゲーションアイテムを設置
    [self.view addSubview:navBarTop];
    
    [super viewDidLoad];
}

- (void)saveButton:(id)sender {
    // BMAccountCreateViewControllerを呼び出す
    //[self setAccount];
    [self dismissViewControllerAnimated:YES completion:nil];
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // UITabBarControllerをRootViewControllerに設定する
    //BMTableViewController *firstTab = [[BMTableViewController alloc] init];
    //BMAccountCreateViewController *secondTab = [[BMAccountCreateViewController alloc] init];
    //UITabBarController *tabBarCon = [[UITabBarController alloc] init];
    //UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:firstTab];
    //[tabBarCon addChildViewController:nav];
    //[tabBarCon addChildViewController:secondTab];
    
    //タブのタイトル指定
    //[firstTab setTitle:@"書籍一覧"];
    //[secondTab setTitle:@"設定"];
    //タブのタイトル位置設定
    //[[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -17)];
    
    // タブバー設定
    //UIImage *image2 = [UIImage imageNamed:@"TabBar.png"];
    //[[UITabBar appearance] setBackgroundImage:image2];
    
    //self.window.rootViewController = tabBarCon;
    
    // キーウィンドウを作成して描画
    //[self.window makeKeyAndVisible];
}

- (void)closeButton:(id)sender {
    //アラートビューの生成と設定
    //UIAlertView *alert = [[UIAlertView alloc]
    //                      initWithTitle:@"BookManager OFF"
    //                      message:@"画面を閉じます"
    //                      delegate:self
    //                      cancelButtonTitle:@"OK！" otherButtonTitles:nil];
    //[alert show];
    // BMAccountCreateViewControllerを呼び出す
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    // メンバ変数activeFieldに選択されたテキストフィールドを代入
    _activeField = textField;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)targetTextField {
    
    // textFieldを最初にイベントを受け取る対象から外すことでキーボードを閉じる
    [targetTextField resignFirstResponder];
    
    return YES;
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary *dic = [aNotification userInfo];
    //アニメーション終了時のキーボードのCGRect
    CGRect keyboardRect = [[dic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    float screenHeight = screenBounds.size.height;
    
    CGPoint scrollPoint = CGPointZero;
    if((_activeField.frame.origin.y + _activeField.frame.size.height)>(screenHeight - keyboardRect.size.height - 10)){
    	// テキストフィールドがキーボードで隠れるようなら
        // 選択中のテキストフィールドの直ぐ下にキーボードの上端が付くように、スクロールビューの位置を設定する
        scrollPoint = CGPointMake(0, -(screenHeight - _activeField.frame.origin.y - _activeField.frame.size.height - keyboardRect.size.height - 10));
    }
    [_scrollView setContentOffset:scrollPoint animated:YES];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [_scrollView setContentOffset:CGPointZero animated:YES];
}

-(void)getAccount
{
    // JSONデータ取得
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user_id": @"1"};
    [manager POST:@"http://localhost/api/account/get"
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSDictionary *dict = [[NSDictionary alloc]init];
              NSDictionary *dict2 = [[NSDictionary alloc]init];
              dict = [responseObject objectAtIndex:0];
              dict2 = [dict objectForKey:@"User"];
              _mailText = [dict2 objectForKey:@"mail_address"];
              _passText = [dict2 objectForKey:@"password"];
              _passConfText = [dict2 objectForKey:@"password"];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

-(void)setAccount
{
    // JSONデータ取得
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"user_id": @"1",
                             @"mail_address": _mailText.text,
                             @"password": _passText.text};
    [manager POST:@"http://localhost/api/account/regist"
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"Json: %@", responseObject);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
    
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // UITabBarControllerをRootViewControllerに設定する
    //BMTableViewController *firstTab = [[BMTableViewController alloc] init];
    //BMAccountCreateViewController *secondTab = [[BMAccountCreateViewController alloc] init];
    //UITabBarController *tabBarCon = [[UITabBarController alloc] init];
    //    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:firstTab];
    //[tabBarCon addChildViewController:nav];
    //[tabBarCon addChildViewController:secondTab];
    
    //タブのタイトル指定
    //[firstTab setTitle:@"書籍一覧"];
    //[secondTab setTitle:@"設定"];
    //タブのタイトル位置設定
    //[[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -17)];
    
    // タブバー設定
    //UIImage *image2 = [UIImage imageNamed:@"TabBar.png"];
    //[[UITabBar appearance] setBackgroundImage:image2];
    
    //self.window.rootViewController = tabBarCon;
    
    // キーウィンドウを作成して描画
    //[self.window makeKeyAndVisible];
}

@end
