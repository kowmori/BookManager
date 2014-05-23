//
//  BMTableViewController.h
//  BookManager
//
//  Created by 森島航 on 2014/05/02.
//  Copyright (c) 2014年 wataru.morishima. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BMTableViewControllerDelegate;

@interface BMTableViewController : UIViewController< UITabBarDelegate,UITableViewDelegate, UITableViewDataSource >

@property (weak, nonatomic) IBOutlet UITableView *tableView;

-(void)rightTapped:(id)sender;

@end