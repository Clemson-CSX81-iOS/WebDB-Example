//
//  WDBAddPubOrAuthViewController.m
//  WebDB Example
//
//  Created by Douglas Edmonson on 10/03/2012.
//  Copyright (c) 2012 DJ Edmonson. All rights reserved.
//

#import "WDBAddPubOrAuthViewController.h"
#import "WDBAPIClient.h"

@interface WDBAddPubOrAuthViewController ()

@property (nonatomic, strong) NSString *resoucePath;
@property (nonatomic,   weak) IBOutlet UITextField *nameField;

- (IBAction)submit:(id)sender;

@end

@implementation WDBAddPubOrAuthViewController

- (void)configure{
    switch (self.resouceType) {
        case WDBResourceToAddPublisher:
            self.resoucePath = @"publisher";
            self.title = @"Add Publisher";
            break;
            
        case WDBResourceToAddAuthor:
            self.resoucePath = @"author";
            self.title = @"Add Author";
            break;
            
        default:
            self.title = @"Unknown Resouce";
            self.resoucePath = @"";
            break;
    }
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self configure];
}

- (void)submit:(id)sender{
    [SVProgressHUD showWithStatus:@"Adding..." maskType:SVProgressHUDMaskTypeGradient];
    
    [[WDBAPIClient sharedInstance] postPath:self.resoucePath
                                 parameters:@{@"name" : self.nameField.text}
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        [SVProgressHUD showSuccessWithStatus:@"Added!"];
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [self.navigationController popViewControllerAnimated:YES];
                                        });
                                    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        [SVProgressHUD showErrorWithStatus:@"Error!"];
                                        NSLog(@"%@",error);
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [self.navigationController popViewControllerAnimated:YES];
                                        });
                                    }];
}

@end
