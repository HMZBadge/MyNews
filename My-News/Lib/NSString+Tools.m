//
//  NSString+Tools.m
//  UI07MicroBlog
//
//  Created by 赵志丹 on 15/10/8.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "NSString+Tools.h"

@implementation NSString (Tools)
// self 就是调用当前成员方法的NSString对象
- (CGRect)textRectWithSize:(CGSize)size attributes:(NSDictionary *)attributes
{
    return  [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
}
@end
