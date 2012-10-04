//
//  WDBBookListViewController.m
//  WebDB Example
//
//  Created by Douglas Edmonson on 10/03/2012.
//  Copyright (c) 2012 DJ Edmonson. All rights reserved.
//

#import "WDBBookListViewController.h"
#import "WDBAPIClient.h"
#import "WDBBookDetailViewController.h"

@interface WDBBookListViewController ()

@property (nonatomic, strong) NSArray *books;

@end

@implementation WDBBookListViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [SVProgressHUD showWithStatus:@"Loading Books" maskType:SVProgressHUDMaskTypeGradient];
    
    [[WDBAPIClient sharedInstance] getPath:@"book"
                                parameters:nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       [SVProgressHUD showSuccessWithStatus:@"Done!"];
                                       NSLog(@"%@",responseObject);
                                       self.books = responseObject[@"Results"];
                                       [self.tableView reloadData];
                                   }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       [SVProgressHUD showErrorWithStatus:@"Error :("];
                                       NSLog(@"%@",error);
                                   }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"Book Detail Push"]){
        ((WDBBookDetailViewController*)segue.destinationViewController).bookInfo =
            self.books[self.tableView.indexPathForSelectedRow.row];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.books.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Book Cell";
    __block UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *req = [NSString stringWithFormat:@"publisher/id/%@",[self.books[indexPath.row] objectForKey:@"pub_id" ]];
    
    [[WDBAPIClient sharedInstance] getPath:req
                                parameters:nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       [SVProgressHUD showSuccessWithStatus:@"Done"];
                                       
                                       id results = responseObject[@"Results"];
                                       id publisher = results[0];
                                       NSString *name = publisher[@"name"];
                                       
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           cell.detailTextLabel.text = name;
                                           [cell setNeedsDisplay];
                                       });
                                   }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       [SVProgressHUD showErrorWithStatus:@"Error :("];
                                       NSLog(@"%@",error);
                                   }];

    
    cell.textLabel.text = [self.books[indexPath.row] objectForKey:@"name"];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
