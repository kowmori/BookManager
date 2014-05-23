//
//  BMDatePickerViewController.h
//  BookManager
//
//  Created by 森島航 on 2014/05/04.
//  Copyright (c) 2014年 wataru.morishima. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BMDatePickerViewControllerDelegate;

@interface BMDatePickerViewController : UIViewController

@property (weak, nonatomic) id<BMDatePickerViewControllerDelegate> delegate;

- (IBAction)commitButton:(id)sender;
- (IBAction)cancelButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end


@protocol BMDatePickerViewControllerDelegate <NSObject>

- (void)didCommitButtonClicked:(BMDatePickerViewController *)controller selectedDate:(NSDate *)selectedDate;
- (void)didCancelButtonClicked:(BMDatePickerViewController *)controller;

@end