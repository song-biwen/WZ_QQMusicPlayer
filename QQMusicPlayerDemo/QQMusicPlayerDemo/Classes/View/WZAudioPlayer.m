//
//  WZAudioPlayer.m
//  QQMusicPlayerDemo
//
//  Created by songbiwen on 2017/1/4.
//  Copyright © 2017年 songbiwen. All rights reserved.
//

#import "WZAudioPlayer.h"
#import "UIButton+WZAdd.h"
#import "WZMusicModel.h"
#import <AVFoundation/AVFoundation.h>

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define CommonButtonW 64
#define CommonButtonH 64
#define DefaultMargin 20


@interface WZAudioPlayer ()
@property (nonatomic, assign) BOOL isPlaying;//正在播放

@property (nonatomic, weak) UIImageView *avatorImageView;
@property (nonatomic, weak) UIButton *playButton;
@property (nonatomic, weak) UIImageView *arrowImageView;

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@end

@implementation WZAudioPlayer

+ (instancetype)audioPlayer {
    return [[WZAudioPlayer alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];

}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"lyric_tipview_backimg"].CGImage);
        [self setupUI];
    }
    return self;
}


- (void)setMusicList:(NSArray *)musicList {
    _musicList = musicList;
    self.selectedIndex = 0;
    [self changeSingerAvatorImage];
    [self playButtonAction:self.playButton];
}

- (void)setupUI {
    
    //添加箭头
    CGFloat arrowImageH = 100;
    CGFloat arrowImageW = 100;
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - arrowImageW) * 0.5, 0, arrowImageW, arrowImageH)];
    arrowImageView.image = [UIImage imageNamed:@"arrow"];
    [self addSubview:arrowImageView];
    self.arrowImageView = arrowImageView;
    
    self.arrowImageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    
    //添加图片
    CGFloat avatorBgImageH = 200;
    CGFloat avatorBgImageW = 200;
    UIImageView *avatorBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - avatorBgImageW)  * 0.5, 100, avatorBgImageW, avatorBgImageH)];
    avatorBgImageView.image = [UIImage imageNamed:@"avator_bg_image"];
    [self addSubview:avatorBgImageView];
    
    //添加头像
    CGFloat avatorImageW = avatorBgImageW - 20;
    CGFloat avatorImageH = avatorBgImageH - 20;
    UIImageView *avatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake((avatorBgImageW - avatorImageW) * 0.5, (avatorBgImageH - avatorImageH) * 0.5, avatorImageW, avatorImageH)];
    avatorImageView.layer.cornerRadius = avatorImageW * 0.5;
    avatorImageView.layer.masksToBounds = YES;
    avatorImageView.image = [UIImage imageNamed:@"蔡健雅"];
    [avatorBgImageView addSubview:avatorImageView];
    self.avatorImageView = avatorImageView;
    
    
    //计算上一曲 播放 下一曲按钮之间的间距
    CGFloat buttonMargin = (ScreenWidth - CommonButtonW * 3) * 1.0 / 4;
    //添加播放按钮
    CGFloat playButtonX = (ScreenWidth - CommonButtonW) * 0.5;
    CGFloat playButtonY = ScreenHeight - CommonButtonH - DefaultMargin;
    UIButton *playButton = [UIButton buttonWithFrame:CGRectMake(playButtonX, playButtonY, CommonButtonW, CommonButtonH) normalImageName:@"player_btn_play_normal" selectedImageName:nil highlightedImageName:@"player_btn_play_highlight" target:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:playButton];
    self.playButton = playButton;
    
    
    //添加上一曲切换按钮
    CGFloat lastButtonX = buttonMargin;
    CGFloat lastButtonY = playButtonY;
    UIButton *lastButton = [UIButton buttonWithFrame:CGRectMake(lastButtonX, lastButtonY, CommonButtonW, CommonButtonH) normalImageName:@"player_btn_pre_normal" selectedImageName:nil highlightedImageName:@"player_btn_pre_highlight" target:self action:@selector(lastButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:lastButton];
    
    
    //添加下一曲切换按钮
    CGFloat nextButtonX = ScreenWidth - buttonMargin - CommonButtonW;
    CGFloat nextButtonY = playButtonY;
    UIButton *nextButton = [UIButton buttonWithFrame:CGRectMake(nextButtonX, nextButtonY, CommonButtonW, CommonButtonH) normalImageName:@"player_btn_next_normal" selectedImageName:nil highlightedImageName:@"player_btn_next_highlight" target:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nextButton];
    
}

//播放暂停按钮
- (void)playButtonAction:(UIButton *)button {
    NSLog(@"%s",__func__);
    
    self.isPlaying = !self.isPlaying;
    //开启关闭定时器
    self.displayLink.paused = !self.isPlaying;
    //箭头旋转
    [UIView animateWithDuration:0.25 animations:^{
        self.arrowImageView.transform = CGAffineTransformRotate(self.arrowImageView.transform, self.isPlaying ? M_PI_4 : -M_PI_4);
    }];
    
    if (self.isPlaying) {
        //播放
        [self.playButton setImage:[UIImage imageNamed:@"player_btn_pause_normal"] forState:UIControlStateNormal];
        [self.playButton setImage:[UIImage imageNamed:@"player_btn_pause_highlight"] forState:UIControlStateHighlighted];
        [self.audioPlayer play];
    }else {
        
        //暂停
        [self.playButton setImage:[UIImage imageNamed:@"player_btn_play_normal"] forState:UIControlStateNormal];
        [self.playButton setImage:[UIImage imageNamed:@"player_btn_play_highlight"] forState:UIControlStateHighlighted];
        [self.audioPlayer pause];
    }
}

//上一曲切换按钮
- (void)lastButtonAction:(UIButton *)button {
    NSLog(@"%s",__func__);
    
    self.selectedIndex --;
    if (self.selectedIndex < 0) {
        self.selectedIndex = self.musicList.count - 1;
    }
    
    [self changeSingerAvatorImage];
    self.audioPlayer = nil;
    if (self.isPlaying) {
        [self.audioPlayer play];
    }
}

//下一曲切换按钮
- (void)nextButtonAction:(UIButton *)button {
    NSLog(@"%s",__func__);
    
    self.selectedIndex ++;
    if (self.selectedIndex > self.musicList.count - 1) {
        self.selectedIndex = 0;
    }
    
    [self changeSingerAvatorImage];
    self.audioPlayer = nil;
    if (self.isPlaying) {
        [self.audioPlayer play];
    }
}

//改变头像
- (void)changeSingerAvatorImage {
    WZMusicModel *musicModel = self.musicList[self.selectedIndex];
    self.avatorImageView.image = [UIImage imageNamed:musicModel.singerName];
}


//定时器
- (CADisplayLink *)displayLink {
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(avatorImageViewRotate)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return _displayLink;
}

//头像转动，1s转60次
- (void)avatorImageViewRotate {
    self.avatorImageView.transform = CGAffineTransformRotate(self.avatorImageView.transform, M_PI * 2 / 60 / 5);
}


- (AVAudioPlayer *)audioPlayer {
    if (!_audioPlayer) {
        WZMusicModel *musicModel = self.musicList[self.selectedIndex];
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:musicModel.songName ofType:@"mp3"]];
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        [_audioPlayer prepareToPlay];
    }
    return _audioPlayer;
}

- (void)dealloc {
    [self.displayLink invalidate];
    self.displayLink = nil;
}
@end
