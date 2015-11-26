//
//  HMZChannel.h
//  My-News
//
//  Created by 赵志丹 on 15/11/23.
//  Copyright © 2015年 hetefe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMZChannel : NSObject

@property (nonatomic,copy) NSString *tid;
@property (nonatomic,copy) NSString *tname;
@property (nonatomic,copy) NSString *URLString;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)channelWithDict:(NSDictionary *)dict;

+ (NSMutableArray *)channels;

@end
