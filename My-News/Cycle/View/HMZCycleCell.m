//
//  HMZCycleCell.m
//  My-News
//
//  Created by 赵志丹 on 15/11/26.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "HMZCycleCell.h"
#import "UIImageView+AFNetworking.h"

@interface HMZCycleCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation HMZCycleCell

- (void)setCycle:(HMZCycle *)cycle{
    _cycle = cycle;
    self.titleLabel.text = cycle.title;
    [self.iconView setImageWithURL:[NSURL URLWithString:cycle.imgsrc]];
}
@end
