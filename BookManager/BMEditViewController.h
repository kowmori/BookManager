//
//  BMEditViewController.h
//  BookManager
//
//  Created by 森島航 on 2014/05/04.
//  Copyright (c) 2014年 wataru.morishima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMDatePickerViewController.h"
#import "BMTableViewController.h"

@protocol BMEditViewControllerDelegate;

@interface BMEditViewController : UIViewController<UIScrollViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) id<BMEditViewControllerDelegate> delegate;

- (void)rightTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)imageSelectButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UITextField *bookText;
@property (weak, nonatomic) IBOutlet UITextField *priceText;
@property (weak, nonatomic) IBOutlet UITextField *dateText;

@property (weak, nonatomic) UITextField *activeField;

@property (weak, nonatomic) NSMutableArray *bookInfo;

@end

@protocol BMEditViewControllerDelegate <NSObject>

-(void)editViewControllerDidFinish:(BMEditViewController *)controller;

@end
