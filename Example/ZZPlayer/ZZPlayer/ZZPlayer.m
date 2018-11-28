//
//  ZZPlayer.m
//  ZZPlayer_Example
//
//  Created by 周晓瑞 on 2018/11/27.
//  Copyright © 2018 zhouXiaoR. All rights reserved.
//

#import "ZZPlayer.h"

static void *kPlayManagerObserveContext = &kPlayManagerObserveContext;

@interface ZZPlayer ()

/**
 用户主动暂停
 */
@property(nonatomic,assign)BOOL isUserManualSuspend;

@property(nonatomic,assign)CGFloat totalDuration;
@property(nonatomic,assign)CGFloat currentDuration;

//监听播放起状态的监听者
@property (nonatomic,strong) id playTimeObserver;

@property(nonatomic,assign)CGFloat bufferingProgress;

@property(nonatomic,strong)AVPlayer * player;
@property(nonatomic,assign)ZZPlayerState playerState;
@property(nonatomic,strong)NSURL * currentURL;

@end

@implementation ZZPlayer

 static ZZPlayer * __player;
+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __player = [[self alloc]init];
    });
    return __player;
}

- (instancetype)init{
    if (self = [super init]) {
        [self zzInitialize];
    }
    return self;
}

- (void)zzInitialize{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
     [UIApplication sharedApplication].idleTimerDisabled=YES;

     // 打断播放
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zzPlayInterrupt) name:AVPlayerItemPlaybackStalledNotification object:nil];

    // 播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zzPlayToEnded) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)zzPlayInterrupt{
    self.playerState = ZZPlayerStatePaused;
}

- (void)zzPlayToEnded{
    self.playerState = ZZPlayerStateFinished;
}

- (void)appDidEnterBackground{
    [self passivePause];
}

- (void)appWillEnterForeground{

}

#pragma mark - Public

- (void)playWithURL:(NSURL *)URL{
    if (!URL || ![URL isKindOfClass:[NSURL class]] || URL.absoluteString.length <= 0) return;

    if ([URL.absoluteString isEqualToString:self.currentURL.absoluteString]) {
        if (self.playerState == ZZPlayerStateBuffering) return;
        if (self.playerState == ZZPlayerStatePlaying) return;
        if (self.playerState == ZZPlayerStatePaused) {
            [self zzResume];
            return;
        }
    }

    self.currentURL = URL;

    if (self.player.currentItem) {
        [self removePlayerItemObserve:self.player.currentItem];
    }

    AVPlayerItem  *playerItem = [AVPlayerItem playerItemWithURL:URL];
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
    [self addPlayerItemObserve:playerItem];

    [self resetCurrentItemPlayState];

    [self zzResume];
}

- (void)resetCurrentItemPlayState{
    self.playerState = ZZPlayerStateUnknown;
    self.totalDuration = 0;
    self.currentDuration = 0;
    self.bufferingProgress = 0;
    self.playTimeObserver = nil;
    self.isUserManualSuspend = NO;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{

    if (context != kPlayManagerObserveContext) return;

    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] integerValue];
        if (status == AVPlayerItemStatusReadyToPlay) {
            CGFloat time = CMTimeGetSeconds(self.player.currentItem.duration);
            self.totalDuration = MAX(time, 0);
            if (!self.isUserManualSuspend) {
                [self zzResume];
            }
        }else if (status == AVPlayerItemStatusFailed){
            self.playerState = ZZPlayerStateFailed;
        }else {
            self.playerState = ZZPlayerStateUnknown;
        }
    }

    if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        BOOL isPlay = [change[NSKeyValueChangeNewKey] boolValue];
        if (isPlay) {
            if (!self.isUserManualSuspend) {
                [self zzResume];
            }
        }else{
            self.playerState = ZZPlayerStateBuffering;
        }
    }

    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        // 计算缓冲进度
        NSTimeInterval timeInterval = [self availableBufferingDuration];
        self.bufferingProgress = timeInterval * 1.0 / self.totalDuration;
        if (self.playBufferingProgressComplete) {
            if (!isinf(self.bufferingProgress)) {
                self.playBufferingProgressComplete(self.bufferingProgress);
            }
        }
    }
}


- (NSTimeInterval)availableBufferingDuration {
    NSArray *loadedTimeRanges = [self.player.currentItem loadedTimeRanges];
    CMTimeRange timeRange     = [loadedTimeRanges.firstObject CMTimeRangeValue];
    float startSeconds        = CMTimeGetSeconds(timeRange.start);
    float durationSeconds     = CMTimeGetSeconds(timeRange.duration);

    //计算缓冲总进度
    NSTimeInterval result     = startSeconds + durationSeconds;
    return result;
}

#pragma mark - Private

- (void)removePlayerItemObserve:(AVPlayerItem *)item{
    [item removeObserver:self forKeyPath:@"status"];
    [item removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [item removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [item cancelPendingSeeks];
    [item.asset cancelLoading];
    [self.player pause];
    [self.player removeTimeObserver:self.playTimeObserver];
}

- (void)addPlayerItemObserve:(AVPlayerItem *)item{
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:kPlayManagerObserveContext];
    [item addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:kPlayManagerObserveContext];
    [item addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:kPlayManagerObserveContext];

    __weak typeof(self) weakSelf = self;
   self.playTimeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, NSEC_PER_SEC) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        AVPlayerItem * item = weakSelf.player.currentItem;
        weakSelf.currentDuration = item.currentTime.value / item.currentTime.timescale;
       if (weakSelf.playingProgressComplete) {
           CGFloat bf = weakSelf.currentDuration * 1.0 / self.totalDuration;
           if (isnan(bf)) {
               bf = 0.0f;
           }
           weakSelf.playingProgressComplete(bf);
       }
    }];
}

- (void)zzResume{
    [self.player play];
    if (self.player && self.player.currentItem.playbackLikelyToKeepUp) {
        self.playerState = ZZPlayerStatePlaying;
        self.isUserManualSuspend = NO;
    }
}

- (void)passivePause{
    [self.player pause];
    if (self.player) {
        self.playerState = ZZPlayerStatePaused;
    }
}

- (void)zzStop{
    [self.player pause];
    [self removePlayerItemObserve:self.player.currentItem];
    self.player = nil;
    self.playerState = ZZPlayerStateUnknown;
    self.isUserManualSuspend = NO;
}

- (void)zzPause{
    [self.player pause];
    if (self.player) {
        self.isUserManualSuspend = YES;
        self.playerState = ZZPlayerStatePaused;
    }
}

- (void)seekTimeProgress:(CGFloat)progress{
    if (self.totalDuration <= 0) {
        NSLog(@"还未加载完成，别急着快进快退");
        return;
    }

    CGFloat totalTime = self.totalDuration;
    CGFloat currentTime = totalTime * progress;
    CMTime time = CMTimeMakeWithSeconds(currentTime, NSEC_PER_SEC);
    [self.player seekToTime:time completionHandler:^(BOOL finished) {
        NSLog(@"快进快退完成");
    }];
}

- (void)setPlayerState:(ZZPlayerState)playerState{
    if (_playerState == playerState) return;

    _playerState = playerState;

    if (self.playStateChangeCompelete) {
        self.playStateChangeCompelete(playerState);
    }

    if (playerState == ZZPlayerStateFinished) {
        if (self.playFinishedComplete) {
            self.playFinishedComplete(nil);
        }
    }
}

- (void)setVolume:(CGFloat)volume{
    if (volume > 0 && self.player.muted) {
        self.player.muted = NO;
    }
    self.player.volume = volume;
}

- (CGFloat)volume{
    return self.player.volume;
}

- (void)setBrightness:(CGFloat)brightness{
    [[UIScreen mainScreen] setBrightness:brightness];
}

- (void)setRate:(CGFloat)rate{
    if (rate != self.player.rate) {
        self.player.rate = rate;
    }
}

- (void)setMute:(BOOL)mute{
    self.player.muted = mute;
}

- (BOOL)mute{
    return self.player.muted;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removePlayerItemObserve:self.player.currentItem];
}

@end
