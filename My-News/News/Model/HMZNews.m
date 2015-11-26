//
//  HMZNews.m
//  My-News
//
//  Created by 赵志丹 on 15/11/26.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "HMZNews.h"

@implementation HMZNews
- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)newsWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

+ (void)newsListWithURLString:(NSString *)URLString finishBlock:(FinishBlock)finishBlock{
    
    NSArray *array=[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"aa.plist" ofType:nil]];
    NSMutableArray *arrayM=[NSMutableArray arrayWithCapacity:array.count];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self newsWithDict:dict]];
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p> { title: %@, digest: %@ }", self.class, self, self.title, self.digest];
}
@end
