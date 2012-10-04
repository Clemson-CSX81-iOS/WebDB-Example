//
//  WDBSelectionViewController.m
//  WebDB Example
//
//  Created by Douglas Edmonson on 10/04/2012.
//  Copyright (c) 2012 DJ Edmonson. All rights reserved.
//

#import "WDBSelectionViewController.h"
#import "WDBAPIClient.h"

@interface WDBSelectionViewController ()

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSMutableSet *selected;

@end

@implementation WDBSelectionViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.selected = [NSMutableSet setWithCapacity:4];
    
    NSLog(@"%@",self.pubOrAuth);
    
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeGradient];
    
    [[WDBAPIClient sharedInstance] getPath:self.pubOrAuth
                                parameters:nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       [SVProgressHUD dismiss];
                                       
                                       self.data = responseObject[@"Results"];
                                       
                                       [self.tableView reloadData];
                                   }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       [SVProgressHUD showErrorWithStatus:@"Error :("];
                                       NSLog(@"%@",error);
                                   }];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([self.pubOrAuth isEqualToString:@"publisher"]){
        self.pubRes = [[self.selected allObjects] lastObject];
    }
    else if ([self.pubOrAuth isEqualToString:@"author"]){
        self.authRes = [self.selected allObjects];
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
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Selection Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [self.data[indexPath.row] objectForKey:@"name"];
    
    if ([self.selected containsObject:@(indexPath.row)]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.pubOrAuth isEqualToString:@"publisher"]){
        [self.selected removeAllObjects];
        [self.selected addObject:@(indexPath.row)];
    }
    else if ([self.pubOrAuth isEqualToString:@"author"]){
        if ([self.selected containsObject:@(indexPath.row)]) {
            [self.selected removeObject:@(indexPath.row)];
        }
        else {
            [self.selected addObject:@(indexPath.row)];
        }
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.tableView reloadData];
}

@end
