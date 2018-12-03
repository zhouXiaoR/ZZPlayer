//
//  ZZPlayerView.m
//  Pods-ZZPlayer_Example
//
//  Created by 周晓瑞 on 2018/11/14.
//

#import "ZZPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import "Category/UIView+ZZFrame.h"
#import "Category/NSObject+ZZRotation.h"
#import "ZZPlayerControlView.h"

#define ZZMScreeenWidth  [UIScreen mainScreen].bounds.size.width
#define ZZMScreeenHeight  [UIScreen mainScreen].bounds.size.height

@interface ZZPlayerView ()
@property(nonatomic,weak)AVPlayerLayer * playerLayer;
@property(nonatomic,strong)ZZPlayer * playerManager;

/**
 是否是全屏,减少动画执行次数
 */
@property(nonatomic,assign)BOOL isFullScreen;

/**
 是否已经完成了竖屏
 */
@property(nonatomic,assign)BOOL isPortraitFinished;

@property(nonatomic,weak)ZZPlayerControlView * playerControlView;


@end

@implementation ZZPlayerView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUp];

        //获取设备旋转方向的通知,即使关闭了自动旋转,一样可以监测到设备的旋转方向
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];

        //旋转屏幕通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(deviceOrientationChangeNotification:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil
         ];

        self.isFullScreen = NO;
        self.isPortraitFinished = YES;
    }
    return self;
}

- (void)setUp{
    [self playerLayer];
    [self playerControlView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
    self.playerControlView.frame = self.bounds;
}

#pragma mark - Public

- (void)playVideo:(ZZVideoModel *)model{
    [self.playerManager playWithURL:model.videoURL];
    self.playerLayer.player = self.playerManager.player;
}

- (void)setIsFullScreen:(BOOL)isFullScreen{
    _isFullScreen = isFullScreen;

    self.playerControlView.fullScreen = isFullScreen;
}

#pragma mark - NSNotification

- (void)deviceOrientationChangeNotification:(NSNotification *)notify{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortrait:{
            NSLog(@"正常方向");
            if (self.isFullScreen) {
                CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
                self.isFullScreen = NO;
                [UIView animateWithDuration:duration animations:^{
                    CGFloat nowWidth = MIN(ZZMScreeenWidth, ZZMScreeenHeight);
                    self.frame = CGRectMake(0, 64, nowWidth,ZZMScreeenHeight - 300 - 64);
                    self.isPortraitFinished = NO;
                } completion:^(BOOL finished) {
                    self.isPortraitFinished = YES;

                    //竖屏完成之后判断现在的手机设备的方向,如果是横竖屏,那么需要再次进行动画操作.
                    [self portraitFinishaNextAction];
                }];
            }
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            NSLog(@"home在左");
            if (!self.isFullScreen) {
                CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
                self.isFullScreen = YES;
                [UIView animateWithDuration:duration animations:^{
                    if (self.isPortraitFinished) {
                        self.frame = CGRectMake(0, 0,ZZMScreeenWidth, ZZMScreeenHeight);
                    }
                }completion:^(BOOL finished) {

                }];
            }
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            NSLog(@"home在右");
            if (!self.isFullScreen) {
                CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
                self.isFullScreen = YES;
                [UIView animateWithDuration:duration animations:^{
                    if (self.isPortraitFinished) {
                        self.frame = CGRectMake(0, 0, ZZMScreeenWidth, ZZMScreeenHeight);
                    }
                } completion:^(BOOL finished) {
                }];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - Private

-(void)portraitFinishaNextAction{
    UIDeviceOrientation  orient = [UIDevice currentDevice].orientation;
    if (orient == UIDeviceOrientationLandscapeLeft || orient == UIDeviceOrientationLandscapeRight) {
        CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
        [UIView animateWithDuration:duration delay:duration options:UIViewAnimationOptionLayoutSubviews animations:^{

            if (self.isPortraitFinished) {
                self.frame = self.frame;
            }
        } completion:^(BOOL finished) {
            self.frame = CGRectMake(0, 0, ZZMScreeenWidth, ZZMScreeenHeight);
        }];
    }
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

- (ZZPlayerControlView *)playerControlView{
    if (_playerControlView == nil) {
        ZZPlayerControlView * pcv = [[ZZPlayerControlView alloc]init];
        pcv.fullScreen = NO;
        [self addSubview:pcv];
        [pcv setBackBlock:^(id obj) {
            [UIDevice forceUpdateDeviceRotaion:UIInterfaceOrientationPortrait];
        }];
        _playerControlView = pcv;
    }
    return _playerControlView;
}

@end
