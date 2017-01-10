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
#import "WZSecondController.h"
#import "WZAnimationControllerForDismissed.h"
#import "WZAnimationControllerForPresented.h"

@interface WZMainController ()
<WZAudioPlayerDelegate,UIViewControllerTransitioningDelegate>

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

#pragma makr - UIViewControllerTransitioningDelegate
//转场出现的对象
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    WZAnimationControllerForPresented *presentedObject = [[WZAnimationControllerForPresented alloc] init];
    return presentedObject;
}


//转场消失的对象
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    WZAnimationControllerForDismissed *dismissedObject = [[WZAnimationControllerForDismissed alloc] init];
    return dismissedObject;
}

#pragma mark - WZAudioPlayerDelegate
- (void)audioPlayer:(WZAudioPlayer *)player didClickedAvatorImageView:(UIImageView *)avatorImageView {
    WZSecondController *secondVc = [[WZSecondController alloc] init];
    secondVc.avatorImage = avatorImageView.image;
    
    
    //自定义转场效果
    secondVc.modalPresentationStyle = UIModalPresentationCustom;
    //设置转场代理
    secondVc.transitioningDelegate = self;
    [self presentViewController:secondVc animated:YES completion:nil];
}

- (WZAudioPlayer *)audioPlayer {
    if (!_audioPlayer) {
        _audioPlayer = [WZAudioPlayer WZAudioPlayer];
        _audioPlayer.delegate = self;
        [self.view addSubview:_audioPlayer];
    }
    return _audioPlayer;
}
@end
