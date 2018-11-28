//
//  ZZPlayerView.h
//  Pods-ZZPlayer_Example
//
//  Created by 周晓瑞 on 2018/11/14.
//

#import <UIKit/UIKit.h>
#import "ZZPlayer.h"
#import "ZZVideoModel.h"



NS_ASSUME_NONNULL_BEGIN

@interface ZZPlayerView : UIView


@property(nonatomic,strong,readonly)ZZPlayer * playerManager;

- (void)playVideo:(ZZVideoModel *)model;

@property(nonatomic,assign,readonly)BOOL isFullScreen;


@end

NS_ASSUME_NONNULL_END
