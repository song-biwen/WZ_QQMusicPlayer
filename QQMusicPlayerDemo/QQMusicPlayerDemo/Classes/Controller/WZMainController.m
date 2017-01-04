//
//  WZMainController.m
//  QQMusicPlayerDemo
//
//  Created by songbiwen on 2016/12/23.
//  Copyright © 2016年 songbiwen. All rights reserved.
//

#import "WZMainController.h"
#import "WZAudioPlayer.h"
#import "WZMusicModel.h"

@interface WZMainController ()
@property (nonatomic, strong) WZAudioPlayer *audioPlayer;
@end

/*
 @property (nonatomic, copy) NSString *singerName;
 @property (nonatomic, copy) NSString *songName;
 
 */
@implementation WZMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *dic = @{@"singerName":@"蔡健雅",@"songName":@"蔡健雅-红色高跟鞋 (《爱情左右》电影主题曲)"};
    WZMusicModel *musicMolde = [[WZMusicModel alloc] initWithDict:dic];
    
    NSDictionary *dic1 = @{@"singerName":@"陈粒",@"songName":@"陈粒-奇妙能力歌"};
    WZMusicModel *musicMolde1 = [[WZMusicModel alloc] initWithDict:dic1];
    
    NSDictionary *dic2 = @{@"singerName":@"陈翔",@"songName":@"陈翔-烟火 (《旋风少女》电视剧插曲)"};
    WZMusicModel *musicMolde2 = [[WZMusicModel alloc] initWithDict:dic2];
    
    NSDictionary *dic3 = @{@"singerName":@"陈小春",@"songName":@"陈小春-主题曲"};
    WZMusicModel *musicMolde3 = [[WZMusicModel alloc] initWithDict:dic3];
    self.audioPlayer.musicList = @[musicMolde,musicMolde1,musicMolde2,musicMolde3];
    
}


- (WZAudioPlayer *)audioPlayer {
    if (!_audioPlayer) {
        _audioPlayer = [WZAudioPlayer WZAudioPlayer];
        [self.view addSubview:_audioPlayer];
    }
    return _audioPlayer;
}
@end
