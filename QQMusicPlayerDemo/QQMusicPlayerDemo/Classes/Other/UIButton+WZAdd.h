//
//  UIButton+WZAdd.h
//  QQMusicPlayerDemo
//
//  Created by songbiwen on 2016/12/23.
//  Copyright © 2016年 songbiwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (WZAdd)
+ (instancetype)buttonWithFrame:(CGRect)frame normalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName highlightedImageName:(NSString *)highlightedImageName target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
@end

