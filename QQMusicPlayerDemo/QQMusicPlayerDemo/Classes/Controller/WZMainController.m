//
//  WZMainController.m
//  QQMusicPlayerDemo
//
//  Created by songbiwen on 2016/12/23.
//  Copyright © 2016年 songbiwen. All rights reserved.
//

#import "WZMainController.h"
#import "UIButton+WZAdd.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define CommonButtonW 64
#define CommonButtonH 64
#define DefaultMargin 20

@interface WZMainController ()

@end

@implementation WZMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.view.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"lyric_tipview_backimg"].CGImage);
    
    [self setupUI];
}


- (void)setupUI {
    
    //计算上一曲 播放 下一曲按钮之间的间距
    CGFloat buttonMargin = (ScreenWidth - CommonButtonW * 3) * 1.0 / 4;
    
    //添加播放按钮
    CGFloat playButtonX = (ScreenWidth - CommonButtonW) * 0.5;
    CGFloat playButtonY = ScreenHeight - CommonButtonH - DefaultMargin;
    UIButton *playButton = [UIButton buttonWithFrame:CGRectMake(playButtonX, playButtonY, CommonButtonW, CommonButtonH) normalImageName:@"player_btn_pause_highlight" selectedImageName:@"player_btn_play_highlight" highlightedImageName:nil target:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playButton];
    
    
    //添加上一曲切换按钮
    CGFloat lastButtonX = buttonMargin;
    CGFloat lastButtonY = playButtonY;
    UIButton *lastButton = [UIButton buttonWithFrame:CGRectMake(lastButtonX, lastButtonY, CommonButtonW, CommonButtonH) normalImageName:@"player_btn_pre_normal" selectedImageName:nil highlightedImageName:@"player_btn_pre_highlight" target:self action:@selector(lastButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lastButton];
    
    
    //添加下一曲切换按钮
    CGFloat nextButtonX = ScreenWidth - buttonMargin - CommonButtonW;
    CGFloat nextButtonY = playButtonY;
    UIButton *nextButton = [UIButton buttonWithFrame:CGRectMake(nextButtonX, nextButtonY, CommonButtonW, CommonButtonH) normalImageName:@"player_btn_next_normal" selectedImageName:nil highlightedImageName:@"player_btn_next_highlight" target:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
}

//播放暂停按钮
- (void)playButtonAction:(UIButton *)button {
    NSLog(@"%s",__func__);
}

//上一曲切换按钮
- (void)lastButtonAction:(UIButton *)button {
    NSLog(@"%s",__func__);
}

//下一曲切换按钮
- (void)nextButtonAction:(UIButton *)button {
    NSLog(@"%s",__func__);
}
@end
