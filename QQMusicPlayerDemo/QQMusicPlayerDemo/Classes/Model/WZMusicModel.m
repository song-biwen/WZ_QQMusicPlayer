//
//  WZMusicModel.m
//  QQMusicPlayerDemo
//
//  Created by songbiwen on 2017/1/4.
//  Copyright © 2017年 songbiwen. All rights reserved.
//

#import "WZMusicModel.h"

@implementation WZMusicModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self == [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
@end
