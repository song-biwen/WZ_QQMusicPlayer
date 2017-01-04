//
//  WZMusicModel.h
//  QQMusicPlayerDemo
//
//  Created by songbiwen on 2017/1/4.
//  Copyright © 2017年 songbiwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZMusicModel : NSObject
- (instancetype)initWithDict:(NSDictionary *)dict;

@property (nonatomic, copy) NSString *singerName;
@property (nonatomic, copy) NSString *songName;
@end
