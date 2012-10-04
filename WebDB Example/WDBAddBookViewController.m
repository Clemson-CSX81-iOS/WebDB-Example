//
//  WDBAddBookViewController.m
//  WebDB Example
//
//  Created by Douglas Edmonson on 10/04/2012.
//  Copyright (c) 2012 DJ Edmonson. All rights reserved.
//

#import "WDBAddBookViewController.h"
#import "WDBAPIClient.h"
#import "WDBSelectionViewController.h"

@interface WDBAddBookViewController () <UITextFieldDelegate>

@property (nonatomic, strong) NSMutableDictionary *data;

@property (nonatomic,   weak) IBOutlet UIButton *pubButton;
@property (nonatomic,   weak) IBOutlet UIButton *authButton;
@property (nonatomic,   weak) IBOutlet UITextField *nameField;

@end

@implementation WDBAddBookViewController

- (void)awakeFromNib{
    self.data = [NSMutableDictionary dictionaryWithCapacity:3];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"Choose Publisher"]) {
        ((WDBSelectionViewController*)segue.destinationViewController).pubOrAuth = @"publisher";
    }
    else if([segue.identifier isEqualToString:@"Choose Authors"]){
        ((WDBSelectionViewController*)segue.destinationViewController).pubOrAuth = @"author";
    }
}


- (void)selectDone:(UIStoryboardSegue *)segue{
    WDBSelectionViewController *vc = segue.sourceViewController;
    
    if ([vc.pubOrAuth isEqualToString:@"publisher"]) {
        self.data[@"pub_id"] = @([vc.pubRes intValue]);
        self.pubButton.titleLabel.text = [NSString stringWithFormat:@"%@",self.data[@"pub_id"]];
    }
    else if([vc.pubOrAuth isEqualToString:@"author"]){
        self.data[@"auths"] = vc.authRes;
        self.authButton.titleLabel.text = [NSString stringWithFormat:@"%@",self.data[@"auths"]];
    }
}

- (void)submit:(id)sender{
    NSLog(@"%@",self.data);
    
    
    //Send to server
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    self.data[@"name"] = textField.text;
    
    return YES;
}

@end
