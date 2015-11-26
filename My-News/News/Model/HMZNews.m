//
//  HMZNews.m
//  My-News
//
//  Created by 赵志丹 on 15/11/26.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "HMZNews.h"
#import "HMZNetworkTool.h"
#import <objc/runtime.h>
@implementation HMZNews

/**
 利用运行时,动态获取我们的类的属性
 这个地方我只需要获取我们类的公共属性(私有属性到时候说)
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
    
    free(propertyArray);
    
    return properties.copy;
}


- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        //利用KVC进行赋值
        for (NSString *propertyName in [self properties]) {
            //先判断,是否有值,如果有值,才能设置,否则会奔溃
            if (dict[propertyName]!=nil) {
                [self setValue:dict[propertyName] forKey:propertyName];
            }
        }
    }
    return self;
}

+ (instancetype)newsWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

+ (void)newsListWithURLString:(NSString *)URLString finishBlock:(FinishBlock)finishBlock{
    //1.拿着我们的URLString,通过我们的NetWorkTool,去请求数据
    [[HMZNetworkTool shareNetworkTool] GET:URLString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (responseObject) {
            NSDictionary *dictData = responseObject;
            NSEnumerator *enumerator = dictData.objectEnumerator;
            NSArray *array = enumerator.nextObject;//取出字典中的下一个数据,由于只有一个,就是他了
            NSMutableArray *arrayM=[NSMutableArray arrayWithCapacity:array.count];
            [array enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
                [arrayM addObject:[self newsWithDict:dict]];
            }];
            
            if (finishBlock){
                finishBlock(arrayM.copy);
            }
        }else{
            NSLog(@"网络连接失败,请重新连接");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p> { title: %@, digest: %@ }", self.class, self, self.title, self.digest];
}
@end
