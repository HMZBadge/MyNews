//
//  NSString+Tools.h
//  UI07MicroBlog
//
//  Created by 赵志丹 on 15/10/8.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import <UIKit/UIKit.h>

// 使用分类，可以把常用的方法，不好记的方法都抽取出来，进行归纳总结
// 随着学习的深入，我们每个人都会建立一大套属于自己的分类库！
@interface NSString (Tools)

/**
 *  计算当前字符串显示所需的实际frame，返回值的x = 0, y = 0
 */
- (CGRect)textRectWithSize:(CGSize)size attributes:(NSDictionary *)attributes;
@end
