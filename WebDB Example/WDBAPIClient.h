//
//  WDBAPIClient.h
//  WebDB Example
//
//  Created by Douglas Edmonson on 10/03/2012.
//  Copyright (c) 2012 DJ Edmonson. All rights reserved.
//

#import "AFHTTPClient.h"

@interface WDBAPIClient : AFHTTPClient

+(id)sharedInstance;

@end
