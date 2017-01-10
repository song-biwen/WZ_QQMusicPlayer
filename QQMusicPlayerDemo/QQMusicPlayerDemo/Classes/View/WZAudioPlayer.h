//
//  WZAudioPlayer.h
//  QQMusicPlayerDemo
//
//  Created by songbiwen on 2017/1/4.
//  Copyright © 2017年 songbiwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WZAudioPlayer;
@protocol WZAudioPlayerDelegate <NSObject>
//点击头像
- (void)audioPlayer:(WZAudioPlayer *)player didClickedAvatorImageView:(UIImageView *)avatorImageView;
@end

@interface WZAudioPlayer : UIView

+ (instancetype)WZAudioPlayer;
@property (nonatomic, strong) NSArray *musicList;
@property (nonatomic, assign) id<WZAudioPlayerDelegate> delegate;

@end
