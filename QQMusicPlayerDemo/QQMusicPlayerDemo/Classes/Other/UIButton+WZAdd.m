//
//  UIButton+WZAdd.m
//  QQMusicPlayerDemo
//
//  Created by songbiwen on 2016/12/23.
//  Copyright © 2016年 songbiwen. All rights reserved.
//

#import "UIButton+WZAdd.h"

@implementation UIButton (WZAdd)
+ (instancetype)buttonWithFrame:(CGRect)frame normalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName highlightedImageName:(NSString *)highlightedImageName target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setImage:normalImageName.length > 0 ? [UIImage imageNamed:normalImageName] : nil forState:UIControlStateNormal];
    [button setImage:selectedImageName.length > 0 ? [UIImage imageNamed:selectedImageName] : nil forState:UIControlStateSelected];
    [button setImage:highlightedImageName.length > 0 ? [UIImage imageNamed:highlightedImageName] : nil forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:controlEvents];
    return button;
}
@end
