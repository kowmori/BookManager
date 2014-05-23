//
//  BMAccountSettingViewController.h
//  BookManager
//
//  Created by 森島航 on 2014/05/04.
//  Copyright (c) 2014年 wataru.morishima. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BMAccountSettingViewControllerDelegate;

@interface BMAccountSettingViewController : UIViewController<UIScrollViewDelegate,UITextFieldDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (weak, nonatomic) id<BMAccountSettingViewControllerDelegate> delegate;

- (void)saveButton:(id)sender;
- (void)closeButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *mailText;
@property (weak, nonatomic) IBOutlet UITextField *passText;
@property (weak, nonatomic) IBOutlet UITextField *passConfText;

@property (weak, nonatomic) UITextField *activeField;
@property (strong, nonatomic) NSString *status;

@end

@protocol BMAccountSettingViewControllerDelegate <NSObject>

@end