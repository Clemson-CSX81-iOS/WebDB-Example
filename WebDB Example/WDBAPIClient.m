//
//  WDBAPIClient.m
//  WebDB Example
//
//  Created by Douglas Edmonson on 10/03/2012.
//  Copyright (c) 2012 DJ Edmonson. All rights reserved.
//

#import "WDBAPIClient.h"

@implementation WDBAPIClient

+ (id)sharedInstance {
    static WDBAPIClient *__sharedInstance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[WDBAPIClient alloc] initWithBaseURL:
                            [NSURL URLWithString:@"http://pba.cs.clemson.edu/~dedmons/api/index.php/class_api/"]];
    });
    
    return __sharedInstance;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        //custom settings
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    }
    return self;
}

@end
