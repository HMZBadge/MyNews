//
//  HMZNetworkTool.h
//  My-News
//
//  Created by 赵志丹 on 15/11/26.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>

@interface HMZNetworkTool : AFHTTPSessionManager
+ (instancetype)shareNetworkTool;
@end
