//
//  HMZNews.h
//  My-News
//
//  Created by 赵志丹 on 15/11/26.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef  void (^FinishBlock)(NSMutableArray *newsList);
@interface HMZNews : NSObject
// 标题
@property (nonatomic, copy) NSString *title;
// 摘要
@property (nonatomic, copy) NSString *digest;
// 图片
@property (nonatomic, copy) NSString *imgsrc;
// 跟贴数
@property (nonatomic, assign) int replyCount;
// 多张配图
@property (nonatomic, strong) NSArray *imgextra;
// 大图标记
@property (nonatomic, assign) BOOL imgType;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)newsWithDict:(NSDictionary *)dict;

+ (void)newsListWithURLString:(NSString *)URLString finishBlock:(FinishBlock) finishBlock;

@end

