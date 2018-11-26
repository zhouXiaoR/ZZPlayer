//
//  ZZPlayerView.m
//  Pods-ZZPlayer_Example
//
//  Created by 周晓瑞 on 2018/11/14.
//

#import "ZZPlayerView.h"

@interface ZZPlayerView ()

@property(nonatomic,strong)AVPlayer * player;
@property(nonatomic,assign)ZZPlayerPlayStatus playStatus;
@property(nonatomic,strong)ZZVideoModel *currentVideoModel;
@property(nonatomic,weak)AVPlayerLayer *playerLayer;
@property(nonatomic,strong)AVPlayerItem *currentPlayerItem;

@end

@implementation ZZPlayerView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp{

}

- (void)layoutSubviews{
    [super layoutSubviews];

    self.playerLayer.frame = self.bounds;
}

#pragma mark - Public

- (void)zzPlayWithVideoModel:(ZZVideoModel *)model{
    self.currentVideoModel = model;
    self.player = [[AVPlayer alloc]initWithURL:model.videoURL];
    AVPlayerLayer * pl = [AVPlayerLayer playerLayerWithPlayer:self.player];
    pl.frame = self.bounds;
    [self.layer addSublayer:pl];

    [self.player play];
}

- (void)initAVPlayer{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(zzAppDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(zzAppWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];

    if (self.currentVideoModel) {
        self.currentPlayerItem = [AVPlayerItem playerItemWithURL:self.currentVideoModel.videoURL];
        self.player = [[AVPlayer alloc]initWithPlayerItem:self.currentPlayerItem];
        self.playerLayer.player = self.player;
    }
}

- (void)zzPlay{
    if(self.playStatus == ZZPlayerPlayStatusPlaying || self.playStatus == ZZPlayerPlayStatusBuffering) return;

    // 已经播放完成
    if (self.playStatus == ZZPlayerPlayStatusFinished) {
        NSLog(@"播放已经完成了，老铁");
        return;
    }

    if (!_player) {
        [self initAVPlayer];
    }

    if (self.playStatus == ZZPlayerPlayStatusStopped || self.playStatus == ZZPlayerPlayStatusPaused || self.playStatus == ZZPlayerPlayStatusFailed) {
        [self.player play];
    }
}

- (void)zzPause{
    if (self.playStatus == ZZPlayerPlayStatusPlaying) {
        [self.player pause];
    }
}

#pragma mark - getter

- (AVPlayerLayer *)playerLayer{
    if (_playerLayer == nil) {
        AVPlayerLayer * pl = [[AVPlayerLayer alloc]init];
        [self.layer addSublayer:pl];
        _playerLayer = pl;
    }
    return _playerLayer;
}


@end
