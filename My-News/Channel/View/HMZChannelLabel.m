//
//  HMZChannelLabel.m
//  My-News
//
//  Created by 赵志丹 on 15/11/23.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "HMZChannelLabel.h"

@implementation HMZChannelLabel
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor blackColor];
        self.font = [UIFont systemFontOfSize:20];
    }
    return self;
}
@end
