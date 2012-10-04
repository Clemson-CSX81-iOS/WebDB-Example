//
//  WDBSelectionViewController.h
//  WebDB Example
//
//  Created by Douglas Edmonson on 10/04/2012.
//  Copyright (c) 2012 DJ Edmonson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDBSelectionViewController : UITableViewController

@property (nonatomic, strong) NSArray *authRes;
@property (nonatomic, strong) NSString *pubRes;

@property (nonatomic, strong) NSString *pubOrAuth;

@end
