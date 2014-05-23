//
//  BMAddViewController.h
//  BookManager
//
//  Created by 森島航 on 2014/05/04.
//  Copyright (c) 2014年 wataru.morishima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMDatePickerViewController.h"

@protocol BMAddViewControllerDelegate;

@interface BMAddViewController : UIViewController<UIScrollViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) id<BMAddViewControllerDelegate> delegate;

-(void)closeButton:(id)sender;
-(void)saveButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)imageSelectButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UITextField *bookText;
@property (weak, nonatomic) IBOutlet UITextField *priceText;
@property (weak, nonatomic) IBOutlet UITextField *dateText;

@property (weak, nonatomic) UITextField *activeField;

@end

@protocol BMAddViewControllerDelegate <NSObject>

-(void)addViewControllerDidFinish:(BMAddViewController *)controller;

-(void)addViewControllerDidCancel:(BMAddViewController *)controller;

@end