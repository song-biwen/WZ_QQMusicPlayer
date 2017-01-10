//
//  WZAnimationControllerForPresented.m
//  QQMusicPlayerDemo
//
//  Created by songbiwen on 2017/1/10.
//  Copyright © 2017年 songbiwen. All rights reserved.
//

#import "WZAnimationControllerForPresented.h"

@implementation WZAnimationControllerForPresented

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    [containerView addSubview:toView];
    //添加转场动画
    toView.transform = CGAffineTransformMakeRotation(-M_PI_2);//逆时针旋转90度
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        toView.transform = CGAffineTransformIdentity;//回到默认状态
        
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:finished]; //转场动画结束之后必须标记结束，不然控制器不做任何相应
    }];
    
}
@end
