//
//  WDBAddPubOrAuthViewController.h
//  WebDB Example
//
//  Created by Douglas Edmonson on 10/03/2012.
//  Copyright (c) 2012 DJ Edmonson. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WDBResourceToAddUnknown = 0,
    WDBResourceToAddPublisher = 1,
    WDBResourceToAddAuthor = 2
} WDBResourceToAdd;

@interface WDBAddPubOrAuthViewController : UIViewController

@property (nonatomic, assign) WDBResourceToAdd resouceType;

-(void)configure;

@end
