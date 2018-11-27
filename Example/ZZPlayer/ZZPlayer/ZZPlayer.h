//
//  ZZPlayer.h
//  ZZPlayer_Example
//
//  Created by 周晓瑞 on 2018/11/27.
//  Copyright © 2018 zhouXiaoR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef  NS_ENUM(NSUInteger,ZZPlayerState){
     ZZPlayerStateUnknown = 0, // 未知状态
     ZZPlayerStateBuffering = 1, // 缓冲中
     ZZPlayerStatePlaying = 2, // 播放中
     ZZPlayerStateStopped = 3, // 停止
     ZZPlayerStatePaused = 4,  // 暂停
     ZZPlayerStateFailed = 5, // 失败
};


@interface ZZPlayer : NSObject

+ (instancetype)shareInstance;

/**
 当前的播放状态
 */
@property(nonatomic,assign,readonly)ZZPlayerState playerState;

@property(nonatomic,strong,readonly)AVPlayer * player;

@property(nonatomic,assign,readonly)CGFloat totalDuration;
@property(nonatomic,assign,readonly)CGFloat currentDuration;
@property(nonatomic,assign,readonly)CGFloat bufferingProgress;
@property(nonatomic,assign)CGFloat volume;
@property(nonatomic,assign)CGFloat brightness;
@property(nonatomic,assign)CGFloat rate;
@property(nonatomic,assign)BOOL mute;

/**
 播放

 @param URL 视频URL
 */
- (void)playWithURL:(NSURL *)URL;

/**
 快进快退

 @param progress 进度  0.0 - 1.0
 */
- (void)seekTimeProgress:(CGFloat)progress;

- (void)zzResume;

- (void)zzStop;

- (void)zzPause;

@end

