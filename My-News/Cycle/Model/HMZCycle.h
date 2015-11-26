//
//  HMZCycle.h
//  My-News
//
//  Created by 赵志丹 on 15/11/26.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FinishBlock)(NSArray *cycleList);
@interface HMZCycle : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *imgsrc;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)cycleWithDict:(NSDictionary *)dict;

+ (void)cycleWithFinishBlock:(FinishBlock)finishBlock;

@end
