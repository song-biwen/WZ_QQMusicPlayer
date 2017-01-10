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
#define TimeLabelWidth 60


@interface WZAudioPlayer ()
<AVAudioPlayerDelegate>
@property (nonatomic, assign) BOOL isPlaying;//正在播放

@property (nonatomic, weak) UIImageView *avatorImageView;
@property (nonatomic, weak) UIButton *playButton;
@property (nonatomic, weak) UIImageView *arrowImageView;

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (nonatomic, strong) UISlider *slider;

@property (nonatomic, weak) UILabel *currentTimeLabel;
@property (nonatomic, weak) UILabel *orignalTimeLabel;

@property (nonatomic, strong) NSTimer *timer;
@end

@implementation WZAudioPlayer

+ (instancetype)WZAudioPlayer {
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


#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (self.isPlaying) {
        [self playButtonAction:nil];
    }
    
    self.slider.value = 0;
    self.currentTimeLabel.text = [self stringFromTimeInterval:0];
}

- (void)setMusicList:(NSArray *)musicList {
    _musicList = musicList;
    self.selectedIndex = 0;
    [self changeSingerAvatorImage];
    [self playButtonAction:self.playButton];
}


- (void)tapGestureAction:(UITapGestureRecognizer *)tapGesture {
    
    NSLog(@"%s",__func__);
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioPlayer:didClickedAvatorImageView:)]) {
        [self.delegate audioPlayer:self didClickedAvatorImageView:self.avatorImageView];
    }
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
    
    
    //播放进度条
    CGFloat sliderH = 50;
    CGFloat sliderY = playButtonY - DefaultMargin - sliderH;
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(TimeLabelWidth,sliderY, ScreenWidth - TimeLabelWidth * 2, sliderH)];
    [slider addTarget:self action:@selector(touchUp)
          forControlEvents:UIControlEventValueChanged|UIControlEventTouchUpInside];
    //当滑块上的按钮的位置发生改变，或者被按下时，我们需要让歌曲先暂停。
    [slider addTarget:self action:@selector(touchDown)
          forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchCancel];
    //当滑块被松开，按到外面了，或者取消时，我们需要让歌曲的播放从当前的时间开始播放。
    [self addSubview:slider];
    self.slider = slider;
    
    //当前播放时长
    UILabel *currentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, sliderY, TimeLabelWidth, sliderH)];
    currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    currentTimeLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:currentTimeLabel];
    self.currentTimeLabel = currentTimeLabel;
    
    //总长度
    UILabel *originalTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(TimeLabelWidth + (ScreenWidth - TimeLabelWidth * 2), sliderY, TimeLabelWidth, sliderH)];
    originalTimeLabel.textAlignment = NSTextAlignmentCenter;
    originalTimeLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:originalTimeLabel];
    self.orignalTimeLabel = originalTimeLabel;
    
    //给视图添加点击事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    tapGesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapGesture];
}

-(void)touchUp{
    if ([self.audioPlayer isPlaying]){//判断歌曲是否正在播放，如果正在播放就让歌曲暂停，否则什么也不做。
        [self.audioPlayer pause];//在这里我们需要调用歌曲的暂停方法，实现歌曲的暂停。
        self.timer.fireDate = [NSDate distantFuture];
    }
}

-(void)touchDown{
    self.audioPlayer.currentTime = self.slider.value * self.audioPlayer.duration;//把歌曲当前播放的时间设置为进度条的值
    if (![self.audioPlayer isPlaying]) {
        [self.audioPlayer play];
        self.timer.fireDate = [NSDate distantPast];
    }
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
        self.timer.fireDate = [NSDate distantPast];
        
    }else {
        
        //暂停
        [self.playButton setImage:[UIImage imageNamed:@"player_btn_play_normal"] forState:UIControlStateNormal];
        [self.playButton setImage:[UIImage imageNamed:@"player_btn_play_highlight"] forState:UIControlStateHighlighted];
        [self.audioPlayer pause];
        self.timer.fireDate=[NSDate distantFuture];
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
        _audioPlayer.delegate = self;
        [_audioPlayer prepareToPlay];
        
        self.orignalTimeLabel.text = [self stringFromTimeInterval:_audioPlayer.duration];
        self.currentTimeLabel.text = [self stringFromTimeInterval:_audioPlayer.currentTime];
        self.slider.minimumValue = 0;
        self.slider.maximumValue = 1;
    }
    return _audioPlayer;
}

- (NSString *)stringFromTimeInterval:(NSTimeInterval)timeInterval {
    NSMutableString *mutableStr = [[NSMutableString alloc] init];
    int second = (int)timeInterval % 60;
    int min = (int)timeInterval/60;
    
    if (min < 10) {
        [mutableStr appendString:[NSString stringWithFormat:@"0%d",min]];
    }else {
        [mutableStr appendString:[NSString stringWithFormat:@"%d",min]];
    }
    
    [mutableStr appendString:@":"];
    
    if (second < 10) {
        [mutableStr appendString:[NSString stringWithFormat:@"0%d",second]];
    }else {
        [mutableStr appendString:[NSString stringWithFormat:@"%d",second]];
    }
    return [mutableStr copy];
}


- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)updateProgress {
    self.currentTimeLabel.text = [self stringFromTimeInterval:self.audioPlayer.currentTime];
    self.slider.value = self.audioPlayer.currentTime/self.audioPlayer.duration;
}

- (void)dealloc {
    [self.displayLink invalidate];
    self.displayLink = nil;
    
    [self.timer invalidate];
    self.timer = nil;
}
@end
