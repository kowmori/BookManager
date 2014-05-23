//
//  BMTableViewController.m
//  BookManager
//
//  Created by 森島航 on 2014/05/02.
//  Copyright (c) 2014年 wataru.morishima. All rights reserved.
//

#import "BMTableViewController.h"
#import "BMAddViewController.h"
#import "BMEditViewController.h"
#import "BMAccountCreateViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface BMTableViewController () <BMAddViewControllerDelegate,BMEditViewControllerDelegate>

@property NSMutableArray *items;
@property NSString *dateText;
@property UIImage *tableImage;

@end

@implementation BMTableViewController

- (void)viewDidLoad
{
    _tableView.delegate = self;
    _tableView.rowHeight = 80.0;
    _tableView.allowsSelection = YES;
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    [self.view addSubview:_tableView];
    [self getJSON];
    UIBarButtonItem* bookAddButton = [[UIBarButtonItem alloc]
                               initWithTitle:@"追加"
                               style:UIBarButtonItemStyleBordered
                               target:self
                               action:@selector(rightTapped:)];
    self.navigationItem.rightBarButtonItems = @[bookAddButton];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // セクションは１つなので、１を返す
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // リストのアイテム数を返す
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // UITableViewCell生成
    UITableViewCell *cell = [[UITableViewCell alloc]
                             initWithStyle:UITableViewCellStyleSubtitle
                             reuseIdentifier:@"Cell"];
    // 配列からアイテムを取得してcellに設定
    NSMutableArray *bookInfo = [_items objectAtIndex:indexPath.row];
    CGSize thumb = CGSizeMake(80, 60);
    UIGraphicsBeginImageContextWithOptions(thumb, NO, 0.0);
    _tableImage = [bookInfo objectAtIndex:1];
    [_tableImage drawInRect:CGRectMake(0, 0, thumb.width, thumb.height)];
    _tableImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    cell.imageView.image = _tableImage;
    cell.textLabel.text = [bookInfo objectAtIndex:2];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@円 + 税        %@",[bookInfo objectAtIndex:3],[bookInfo objectAtIndex:4]];
    cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 「Delete」ボタンが押されたら配列からアイテムを削除する
        [_items removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)addViewControllerDidFinish:(BMAddViewController *)controller
{
    // 書籍一覧再取得
    _items = [[NSMutableArray alloc] init];
    [self getJSON];

    // BMAddViewControllerを閉じる
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    [_tableView reloadData];
}

- (void)addViewControllerDidCancel:(BMAddViewController *)controller
{
    // BMAddViewControllerを閉じる
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)editViewControllerDidFinish:(BMEditViewController *)controller
{
    // 書籍一覧再取得
    _items = [[NSMutableArray alloc] init];
    [self getJSON];
    
    // BMEditViewControllerを閉じる
    [self.navigationController popViewControllerAnimated:YES];
    
    [_tableView reloadData];
}

// Cell が選択された時
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath*) indexPath{
    NSMutableArray *bookInfo = [_items objectAtIndex:indexPath.row];
    // BMEditViewControllerを呼び出す
    BMEditViewController *editViewController;
    editViewController = [[BMEditViewController alloc]initWithNibName:@"BMEditViewController" bundle:nil];
    // delegateプロパティにself(TableViewController自身)を設定する
    editViewController.delegate = self;
    editViewController.bookInfo = bookInfo;
    [self.navigationController pushViewController:editViewController animated:YES];
}

- (void)rightTapped:(id)sender {
    // BMAddViewControllerを呼び出す
    BMAddViewController *addViewController;
    addViewController = [[BMAddViewController alloc]initWithNibName:@"BMAddViewController" bundle:nil]; 
    // delegateプロパティにself(TableViewController自身)を設定する
    addViewController.delegate = self;
    
    [self presentViewController:addViewController animated:YES completion:nil];
}

-(void)getJSON
{
    // JSONデータ取得
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"request": @"request"};
    [manager POST:@"http://localhost/api/book/get"
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              int i = 0;
              while (i < [responseObject count]) {
                  NSDictionary *dict = [[NSDictionary alloc]init];
                  NSDictionary *dict2 = [[NSDictionary alloc]init];
                  dict = [responseObject objectAtIndex:i];
                  dict2 = [dict objectForKey:@"Book"];
                  NSMutableArray *bookInfo = [[NSMutableArray alloc]init];
                  [bookInfo addObject:[dict2 objectForKey:@"id"]];
                  if ([dict2 objectForKey:@"image_url"] == [NSNull null]) {
                      _tableImage = [UIImage imageNamed:@"noImage.png"];
                  }else{
                      _tableImage = [bookInfo objectAtIndex:0];
                  }
                  [bookInfo addObject: _tableImage];
                  [bookInfo addObject:[dict2 objectForKey:@"name"]];
                  [bookInfo addObject:[dict2 objectForKey:@"price"]];
                  _dateText = [dict2 objectForKey:@"purchase_date"];
                  if (_dateText.length > 10) {
                      _dateText = [NSString stringWithFormat:@"%@/%@/%@",
                                   [_dateText substringWithRange:NSMakeRange(0,4)],
                                   [_dateText substringWithRange:NSMakeRange(5,2)],
                                   [_dateText substringWithRange:NSMakeRange(8,2)]];
                  }
                  [bookInfo addObject:_dateText];
                  if (!_items) {
                      _items = [[NSMutableArray alloc] init];
                  }
                  // アイテムを先頭に追加する
                  [_items insertObject:bookInfo atIndex:0];
                  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                  [_tableView insertRowsAtIndexPaths:@[indexPath]
                                    withRowAnimation:UITableViewRowAnimationAutomatic];
                  i++;
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

@end