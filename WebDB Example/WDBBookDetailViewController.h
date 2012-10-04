//
//  WDBBookDetailViewController.h
//  WebDB Example
//
//  Created by Douglas Edmonson on 10/03/2012.
//  Copyright (c) 2012 DJ Edmonson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDBBookDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSDictionary *bookInfo;

@end
