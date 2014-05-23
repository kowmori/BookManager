//
//  BMAddViewController.m
//  BookManager
//
//  Created by 森島航 on 2014/05/04.
//  Copyright (c) 2014年 wataru.morishima. All rights reserved.
//

#import "BMAppDelegate.h"
#import "BMAddViewController.h"
#import "BMTableViewController.h"
#import "BMDatePickerViewController.h" 
#import <AFNetworking/AFNetworking.h>

@interface BMAddViewController ()<BMDatePickerViewControllerDelegate>

@property BOOL isDispDatePicker;
@property BMDatePickerViewController* datePickerViewController;

@end

@implementation BMAddViewController

- (void)viewDidLoad
{
    _bookText.delegate = self;
    _priceText.delegate = self;
    _dateText.delegate = self;
    _isDispDatePicker = NO;
    _bookText.returnKeyType = UIReturnKeyDone;
    _priceText.returnKeyType = UIReturnKeyDone;
    _dateText.returnKeyType = UIReturnKeyDone;
    _scrollView.delegate = self;
    _photoImageView.image = [UIImage imageNamed:@"noImage.png"];
    // キーボードが表示されたときのNotificationをうけとる
    [self registerForKeyboardNotifications];
    
    // ナビゲーションバーを生成
    UINavigationBar* navBarTop = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    // ナビゲーションアイテムを生成
    UINavigationItem* title = [[UINavigationItem alloc] initWithTitle:@"書籍追加"];
    // 戻るボタンを生成
    UIBarButtonItem* btnItemBack = [[UIBarButtonItem alloc] initWithTitle:@"戻る" style:UIBarButtonItemStyleBordered target:self action:@selector(closeButton:)];
    // 保存ボタンを生成
    UIBarButtonItem* btnItemSave = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(saveButton:)];
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
    if ([self.delegate respondsToSelector:@selector(addViewControllerDidFinish:)]) {
        // 配列の取得
        NSMutableArray *bookInfo = [[NSMutableArray alloc]init];
        [bookInfo addObject:_photoImageView.image];
        [bookInfo addObject:_bookText.text];
        [bookInfo addObject:_priceText.text];
        [bookInfo addObject:_dateText.text];
        [self registJSON:bookInfo];
        [self.delegate addViewControllerDidFinish:self];
    }
}

- (void)closeButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(addViewControllerDidCancel:)]) {
        [self.delegate addViewControllerDidCancel:self];
    }
}

- (IBAction)imageSelectButton:(id)sender {
    UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
    // UIImagePickerControllerSourceTypeSavedPhotosAlbum だと直接写真選択画面
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // 選択したメディアの編集を可能にするかどうか
    imagePickerVC.allowsEditing = YES;
    
    imagePickerVC.delegate = self;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [_photoImageView setImage:info[UIImagePickerControllerOriginalImage]];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    // メンバ変数activeFieldに選択されたテキストフィールドを代入
    _activeField = textField;

    BOOL ret = YES;
    
	// 対象外のTextFieldが編集状態になり、その時DatePickerが出てきたら隠す
    if ((_activeField == _bookText) || (_activeField == _priceText)) {
        if (_isDispDatePicker) {
            [self hideModal:_datePickerViewController.view];
            _datePickerViewController.delegate = nil;
        }
    } else if (_activeField == _dateText) {
		// もし他のTextField編集中でキーボードが出ていたらそれを直す
        [_bookText resignFirstResponder];
        [_priceText resignFirstResponder];
        
		// datepickerがまだ出ていなければ出す
        if (!_isDispDatePicker) {
            //BMDatePickerViewController *datePickerViewController;
            _datePickerViewController = [[BMDatePickerViewController alloc]initWithNibName:@"BMDatePickerViewController" bundle:nil];
            _datePickerViewController.delegate = self;
            [self showModal:_datePickerViewController.view];
            _isDispDatePicker = YES;
            CGRect screenBounds = [[UIScreen mainScreen] bounds];
            float screenHeight = screenBounds.size.height;
            CGPoint scrollPoint = CGPointMake(0, -(screenHeight - _activeField.frame.origin.y - _activeField.frame.size.height - 210));
            [_scrollView setContentOffset:scrollPoint animated:YES];
        }
        
        // NOを返すとソフトウェアキーボードを出さない
        ret = NO;
    }
    
    return ret;
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

// datePicker実装
- (void) showModal:(UIView *) modalView
{
    UIWindow *mainWindow = (((BMAppDelegate *) [UIApplication sharedApplication].delegate).window);
    CGPoint middleCenter = modalView.center;
    CGSize offSize = [UIScreen mainScreen].bounds.size;
    CGPoint offScreenCenter = CGPointMake(offSize.width * 0.5f, offSize.height * 1.5f);
    modalView.center = offScreenCenter;
    
    [mainWindow addSubview:modalView];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    modalView.center = middleCenter;
    [UIView commitAnimations];
}

- (void) hideModal:(UIView*) modalView
{
    CGSize offSize = [UIScreen mainScreen].bounds.size;
    CGPoint offScreenCenter = CGPointMake(offSize.width * 0.5f, offSize.height * 1.5f);
    [UIView beginAnimations:nil context:(__bridge_retained void *)(modalView)];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(hideModalEnded:finished:context:)];
    modalView.center = offScreenCenter;
    [UIView commitAnimations];
}

- (void) hideModalEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    UIView *modalView = (__bridge_transfer UIView *)context;
    [modalView removeFromSuperview];
    _isDispDatePicker = NO;
}

-(void)didCommitButtonClicked:(BMDatePickerViewController *)controller selectedDate:(NSDate *)selectedDate
{
    [self hideModal:controller.view];
    controller.delegate = nil;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    _dateText.text = [formatter stringFromDate:selectedDate];
    [_scrollView setContentOffset:CGPointZero animated:YES];
}

-(void)didCancelButtonClicked:(BMDatePickerViewController *)controller
{
    [self hideModal:controller.view];
    controller.delegate = nil;
    [_scrollView setContentOffset:CGPointZero animated:YES];
}

-(void)registJSON:(NSMutableArray *)bookInfo
{
    NSData* data = [[NSData alloc] initWithData:UIImagePNGRepresentation([bookInfo objectAtIndex:0])];
    NSString *imageText= [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
    if ([imageText isEqual:nil]) {
        imageText = @"NULL";
    }else{
        imageText = @"NULL";
    }
    // JSONデータ登録
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //NSLog(@"image:%@",imageText);
    //NSLog(@"name:%@",[bookInfo objectAtIndex:1]);
    //NSLog(@"price:%@",[bookInfo objectAtIndex:2]);
    //NSLog(@"date:%@",[bookInfo objectAtIndex:3]);
    NSDictionary *params = @{@"user_id":  @"1",
                             @"image_url": imageText,
                             @"name": [bookInfo objectAtIndex:1],
                             @"price": [bookInfo objectAtIndex:2],
                             @"purchase_date": [bookInfo objectAtIndex:3]};
    NSDictionary *params2 = @{@"Book": params};
    [manager POST:@"http://localhost/api/book/regist"
       parameters:params2
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"Json: %@", responseObject);
              //_bookId = [responseObject objectForKey:@"id"];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

@end