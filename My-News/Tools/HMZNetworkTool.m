//
//  HMZNetworkTool.m
//  My-News
//
//  Created by 赵志丹 on 15/11/26.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "HMZNetworkTool.h"
#define BASEURL @"http://c.m.163.com/nc/"

@implementation HMZNetworkTool

static HMZNetworkTool *_instance;
+ (instancetype)shareNetworkTool{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance= [[self alloc] initWithBaseURL:[NSURL URLWithString:BASEURL]];
       
        _instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",nil];
    });
    return _instance;
}

@end
