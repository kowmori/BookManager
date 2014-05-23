//
//  BMDatePickerViewController.m
//  BookManager
//
//  Created by 森島航 on 2014/05/04.
//  Copyright (c) 2014年 wataru.morishima. All rights reserved.
//

#import "BMDatePickerViewController.h"

@interface BMDatePickerViewController ()

@end

@implementation BMDatePickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    _datePicker.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)commitButton:(id)sender {
    [self.delegate didCommitButtonClicked:self selectedDate:self.datePicker.date];
}

- (IBAction)cancelButton:(id)sender {
    [self.delegate didCancelButtonClicked:self];
}

@end
