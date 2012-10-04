//
//  WDBBookDetailViewController.m
//  WebDB Example
//
//  Created by Douglas Edmonson on 10/03/2012.
//  Copyright (c) 2012 DJ Edmonson. All rights reserved.
//

#import "WDBBookDetailViewController.h"
#import "WDBAPIClient.h"


@interface WDBBookDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *pubLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *authors;

@end

@implementation WDBBookDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.nameLable.text = self.bookInfo[@"name"];
    self.pubLabel.text = @"";
    
    NSString *req = [NSString stringWithFormat:@"publisher/id/%@",[self.bookInfo objectForKey:@"pub_id" ]];
    
    [[WDBAPIClient sharedInstance] getPath:req
                                parameters:nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       id results = responseObject[@"Results"];
                                       id publisher = results[0];
                                       NSString *name = publisher[@"name"];
                                       
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           self.pubLabel.text = name;
                                           
                                       });
                                   }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       [SVProgressHUD showErrorWithStatus:@"Error :("];
                                       NSLog(@"%@",error);
                                   }];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeGradient];
    
    NSString *req = [NSString stringWithFormat:@"author/book_id/%@",self.bookInfo[@"id"]];
    
    [[WDBAPIClient sharedInstance] getPath:req
                                parameters:nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       [SVProgressHUD showSuccessWithStatus:@"Done!"];
                                       NSLog(@"%@",responseObject);
                                       self.authors = responseObject[@"Results"];
                                       [self.tableView reloadData];
                                   }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       [SVProgressHUD showErrorWithStatus:@"Error :("];
                                       NSLog(@"%@",error);
                                   }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.authors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Author Detail Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [self.authors[indexPath.row] objectForKey:@"name"];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end

