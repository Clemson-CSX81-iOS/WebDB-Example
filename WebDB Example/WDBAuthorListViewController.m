//
//  WDBAuthorListViewController.m
//  WebDB Example
//
//  Created by Douglas Edmonson on 10/03/2012.
//  Copyright (c) 2012 DJ Edmonson. All rights reserved.
//

#import "WDBAuthorListViewController.h"
#import "WDBAPIClient.h"
#import "WDBAddPubOrAuthViewController.h"

@interface WDBAuthorListViewController ()

@property (nonatomic, strong) NSArray *authors;

@end

@implementation WDBAuthorListViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeGradient];
    
    [[WDBAPIClient sharedInstance] getPath:@"author"
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"Add Author"]) {
        ((WDBAddPubOrAuthViewController*)segue.destinationViewController).resouceType = WDBResourceToAddAuthor;
        [((WDBAddPubOrAuthViewController*)segue.destinationViewController) configure];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.authors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Author Cell";
    __block UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
//    NSString *req = [NSString stringWithFormat:@"book/auth_id/%@",[self.authors[indexPath.row] objectForKey:@"id" ]];
//    
//    [[WDBAPIClient sharedInstance] getPath:req
//                                parameters:nil
//                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                                       [SVProgressHUD showSuccessWithStatus:@"Done"];
//                                       dispatch_async(dispatch_get_main_queue(), ^{
//                                           cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",responseObject[@"Total"]];
//                                           [cell setNeedsDisplay];
//                                       });
//                                   }
//                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                                       [SVProgressHUD showErrorWithStatus:@"Error :("];
//                                       NSLog(@"%@",error);
//                                   }];
    
    cell.textLabel.text = [self.authors[indexPath.row] objectForKey:@"name"];
    cell.detailTextLabel.text = @"...";
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
