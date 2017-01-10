//
//  WZSecondController.m
//  QQMusicPlayerDemo
//
//  Created by songbiwen on 2017/1/10.
//  Copyright © 2017年 songbiwen. All rights reserved.
//

#import "WZSecondController.h"

@interface WZSecondController ()
@property (nonatomic, strong) UIImageView *avatorImageView;
@end

@implementation WZSecondController

//视图在
- (void)loadView {
    [super loadView];
    //设置view旋转的支点(支点必须在frame前面设置)
    self.view.layer.anchorPoint = CGPointMake(0.5, 2.0);
    //设置view的尺寸
    self.view.frame = [UIScreen mainScreen].bounds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //给视图添加拖动手势
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerAction:)];
    [self.view addGestureRecognizer:panGesture];
}

//拖动事件
- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)panGesture {
    
    //拖动手势在X方向的偏移量
    CGFloat offsetX = [panGesture translationInView:panGesture.view].x;
    //计算x，相对于屏幕宽度的比例
    CGFloat scale = offsetX / self.view.bounds.size.width;
    
//    NSLog(@"%f",scale);
    if (panGesture.state == UIGestureRecognizerStateEnded || panGesture.state == UIGestureRecognizerStateCancelled) {
        //手势取消或者结束
        if (ABS(scale) > 0.25) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else {
            self.view.transform = CGAffineTransformIdentity;//恢复到默认状态
        }
    }else {
        
        //设置屏幕旋转最大45度
        self.view.transform = CGAffineTransformMakeRotation(M_PI_4 * scale);

    }
}

- (void)setAvatorImage:(UIImage *)avatorImage {
    _avatorImage = avatorImage;
    self.avatorImageView.image = _avatorImage;
}

- (UIImageView *)avatorImageView {
    if (!_avatorImageView) {
        _avatorImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_avatorImageView];
    }
    return _avatorImageView;
}
@end
