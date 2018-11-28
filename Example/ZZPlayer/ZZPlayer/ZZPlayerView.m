//
//  ZZPlayerView.m
//  Pods-ZZPlayer_Example
//
//  Created by 周晓瑞 on 2018/11/14.
//

#import "ZZPlayerView.h"
#import <AVFoundation/AVFoundation.h>

@interface ZZPlayerView ()
@property(nonatomic,weak)AVPlayerLayer * playerLayer;
@property(nonatomic,strong)ZZPlayer * playerManager;
@end

@implementation ZZPlayerView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
    [self playerLayer];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
}

#pragma mark - Public

- (void)playVideo:(ZZVideoModel *)model{
    [self.playerManager playWithURL:model.videoURL];
    self.playerLayer.player = self.playerManager.player;
}


#pragma mark - getter

- (AVPlayerLayer *)playerLayer{
    if (_playerLayer == nil) {
        AVPlayerLayer * pl = [[AVPlayerLayer alloc]init];
        pl.videoGravity = AVLayerVideoGravityResizeAspect;
        [self.layer addSublayer:pl];
        _playerLayer = pl;
    }
    return _playerLayer;
}

- (ZZPlayer *)playerManager{
    return [ZZPlayer shareInstance];
}

@end
