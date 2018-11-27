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
    [[ZZPlayer shareInstance] playWithURL:model.videoURL];
    AVPlayer * p = [ZZPlayer shareInstance].player;
    self.playerLayer.player = p;
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


@end
