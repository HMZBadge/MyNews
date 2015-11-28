//
//  HMZCycle.m
//  My-News
//
//  Created by 赵志丹 on 15/11/26.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "HMZCycle.h"
#import <objc/runtime.h>
#import "HMZNetworkTool.h"

@implementation HMZCycle

/**
 利用运行时,动态获取我们的类的属性
 这个地方我只需要获取我们类的公共属性(私有属性到时候说)
 
 MJExtension  字典里面   利用运行时+ KVC来进行字典转模型
 JSONModal 耦合性太强了,不建议
 */
- (NSArray *)properties{
    NSMutableArray *properties = [NSMutableArray array];
    
    //我们的一个属性的个数
    unsigned int count = 0;//属性的个数
    //propertyArray 相当于是一个数组
    objc_property_t *propertyArray = class_copyPropertyList([self class], &count);
    
    for (int i=0; i<count; i++) {
        //获取到类的每一个属性
        objc_property_t property = propertyArray[i];
        //进一步获取我们属性的名称
        const char *cPropertyName = property_getName(property);
        //把C语言中的属性名称转成我们OC的字符串
        NSString *propertyName = [[NSString alloc] initWithCString:cPropertyName encoding:NSUTF8StringEncoding];
        [properties addObject:propertyName];
    }
    return properties.copy;
}

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        for (NSString *property in [self properties]) {
            if (dict[property]){
                [self setValue:dict[property] forKey:property];
            }
        }
    }
    return self;
}

+ (instancetype)cycleWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

+ (void)cycleWithFinishBlock:(FinishBlock)finishBlock{
    [[HMZNetworkTool shareNetworkTool] GET:@"ad/headline/0-4.html" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (responseObject) {
            NSDictionary *dictData = responseObject;
            NSArray *array = dictData[@"headline_ad"];
            NSMutableArray *arrayM=[NSMutableArray arrayWithCapacity:array.count];
            for (NSDictionary *dict in array) {
                [arrayM addObject:[self cycleWithDict:dict]];
            }
            if (finishBlock) {
                finishBlock(arrayM.copy);
            }
        }else{
            NSLog(@"网络连接失败--请重新连接--cycle");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p> {title: %@, imagesrc: %@ }", self.class, self, self.title, self.imgsrc];
}
@end
