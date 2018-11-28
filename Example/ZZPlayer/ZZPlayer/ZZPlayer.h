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
     ZZPlayerStateUnknown = 0, // 未知状态，默认状态
     ZZPlayerStateBuffering = 1, // 缓冲中
     ZZPlayerStatePlaying = 2, // 播放中
     ZZPlayerStateFinished = 3, // 播放完成
     ZZPlayerStatePaused = 4,  // 暂停
     ZZPlayerStateFailed = 5, // 失败
};

typedef void(^ZZPlayerMPlayStateChangeComplete)(ZZPlayerState state);
typedef void(^ZZPlayerMPlayingProgressComplete)(CGFloat progress);
typedef void(^ZZPlayerMPlayBufferingProgressComplete)(CGFloat bufferProgress);
typedef void(^ZZPlayerMPlayFinishedComplete)(id obj);

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
  播放状态回调
 */
@property(nonatomic,copy)ZZPlayerMPlayStateChangeComplete playStateChangeCompelete;

/**
  播放进度回调
 */
@property(nonatomic,copy)ZZPlayerMPlayingProgressComplete playingProgressComplete;

/**
  缓冲进度回调
 */
@property(nonatomic,copy)ZZPlayerMPlayBufferingProgressComplete playBufferingProgressComplete;

/**
 播放完成
 */
@property(nonatomic,copy)ZZPlayerMPlayFinishedComplete  playFinishedComplete;

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

/**
 继续
 */
- (void)zzResume;

/**
 停止，清空player
 */
- (void)zzStop;

/**
 暂停
 */
- (void)zzPause;

@end

