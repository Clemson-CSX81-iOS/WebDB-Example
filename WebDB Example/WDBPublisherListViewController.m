//
//  WDBPublisherListViewController.m
//  WebDB Example
//
//  Created by Douglas Edmonson on 10/03/2012.
//  Copyright (c) 2012 DJ Edmonson. All rights reserved.
//

#import "WDBPublisherListViewController.h"
#import "WDBAPIClient.h"
#import "WDBAddPubOrAuthViewController.h"

@interface WDBPublisherListViewController ()

@property (nonatomic, strong) NSArray *publishers;

@end

@implementation WDBPublisherListViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [SVProgressHUD showWithStatus:@"Loading Publishers" maskType:SVProgressHUDMaskTypeGradient];
    
    [[WDBAPIClient sharedInstance] getPath:@"publisher"
                                parameters:nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       [SVProgressHUD showSuccessWithStatus:@"Done!"];
                                       NSLog(@"%@",responseObject);
                                       self.publishers = responseObject[@"Results"];
                                       [self.tableView reloadData];
                                   }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       [SVProgressHUD showErrorWithStatus:@"Error :("];
                                       NSLog(@"%@",error);
                                   }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"Add Publisher"]) {
        ((WDBAddPubOrAuthViewController*)segue.destinationViewController).resouceType = WDBResourceToAddPublisher;
        [((WDBAddPubOrAuthViewController*)segue.destinationViewController) configure];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.publishers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Publisher Cell";
    __block UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *req = [NSString stringWithFormat:@"book/pub_id/%@",[self.publishers[indexPath.row] objectForKey:@"id" ]];
    
    [[WDBAPIClient sharedInstance] getPath:req
                                parameters:nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       [SVProgressHUD showSuccessWithStatus:@"Done"];
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",responseObject[@"Total"]];
                                           [cell setNeedsDisplay];
                                       });
                                   }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       [SVProgressHUD showErrorWithStatus:@"Error :("];
                                       NSLog(@"%@",error);
                                   }];
    
    cell.textLabel.text = [self.publishers[indexPath.row] objectForKey:@"name"];
    cell.detailTextLabel.text = @"...";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"Delete");
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
