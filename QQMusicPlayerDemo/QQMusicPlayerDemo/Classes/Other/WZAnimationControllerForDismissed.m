//
//  WZAnimationControllerForDismissed.m
//  QQMusicPlayerDemo
//
//  Created by songbiwen on 2017/1/10.
//  Copyright © 2017年 songbiwen. All rights reserved.
//

#import "WZAnimationControllerForDismissed.h"

@implementation WZAnimationControllerForDismissed
#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    //旋转消失
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        if (fromView.transform.b < 0) {
            fromView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        }else {
            fromView.transform = CGAffineTransformMakeRotation(M_PI_2);
        }
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
    }];
}

@end
