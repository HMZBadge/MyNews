//
//  HMZChannel.m
//  My-News
//
//  Created by 赵志丹 on 15/11/23.
//  Copyright © 2015年 hetefe. All rights reserved.
//

#import "HMZChannel.h"

@implementation HMZChannel
- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        for (NSString *propertity in [self propertity]) {
            if ([dict.allKeys containsObject:propertity]) {
                [self setValue:dict[propertity] forKey:propertity];
            }
        }
    }
    return self;
}

//获取我们对象中需要的属性
- (NSArray *)propertity{
    return @[ @"tid" , @"tname" ];
}

//set方法 是赋值一次,可以多次使用, 若重写URLString的get方法则需要每次拼接
-(void)setTid:(NSString *)tid{
    _tid = tid.copy;
    _URLString = [NSString stringWithFormat:@"article/list/%@/0-20.html",_tid];
}

+ (instancetype)channelWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

+ (NSMutableArray *)channels{
    NSData *jsonData = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"topic_news.json" withExtension:nil]];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    
    NSArray *array= dict[@"tList"];
    NSMutableArray *arrayM=[NSMutableArray arrayWithCapacity:array.count];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self channelWithDict:dict]];
    }
    //对数组进行排序
    [arrayM sortUsingComparator:^NSComparisonResult(HMZChannel *obj1, HMZChannel *obj2) {
        return [obj1.tid compare:obj2.tid];
    }];
    
    return arrayM;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p> {tid: %@, tname: %@ }", self.class, self, self.tid, self.tname];
}
@end
