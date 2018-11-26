//
//  ZZViewController.m
//  ZZPlayer
//
//  Created by zhouXiaoR on 11/22/2018.
//  Copyright (c) 2018 zhouXiaoR. All rights reserved.
//

#import "ZZViewController.h"
#import "ZZPlayer/ZZPlayerLoadingView.h"
#import "ZZPlayer/ZZBrightnessView.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ZZViewController ()
@property(nonatomic,weak)ZZPlayerLoadingView * playLoadingView;
@property(nonatomic,weak)ZZBrightnessView *brigV;

@property(nonatomic,strong)MPVolumeView *volumeView;
@property(nonatomic,strong)UISlider * volumeSlider;

@end

@implementation ZZViewController

- (void)viewDidLoad{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor lightGrayColor];
    ZZBrightnessView * bv = [[ZZBrightnessView alloc]initWithFrame:CGRectMake(50, 100, 160, 160)];
    [self.view addSubview:bv];
    self.brigV = bv;

    UISlider * s = [[UISlider alloc]initWithFrame:CGRectMake(20, 350, 200, 40)];
    s.minimumValue = 0.0f;
    s.maximumValue = 1.0f;
    [s addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:s];

}


- (void)change:(UISlider *)s{
    self.brigV.brightnessValue = s.value;
}

- (void)loadingDemo{
    ZZPlayerLoadingView * lv = [[ZZPlayerLoadingView alloc]initWithFrame:CGRectMake(10, 100, 40, 40)];
    lv.hiddenWhenStopped = YES;
    lv.duration = 0.5;
    lv.backgroundColor = [UIColor blackColor];
    [self.view addSubview:lv];
    [lv startAnimating];
    self.playLoadingView = lv;

    // [self.playLoadingView stopAnimating];
}


- (void)setVolume:(float)value {
    UISlider *volumeSlider = [self volumeSlider];
    self.volumeView.showsVolumeSlider = YES; // 需要设置 showsVolumeSlider 为 YES
    // 下面两句代码是关键
    [volumeSlider setValue:value animated:NO];
    [volumeSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
    [self.volumeView sizeToFit];
}

- (MPVolumeView *)volumeView {
    if (!_volumeView) {
        _volumeView = [[MPVolumeView alloc] init];
        _volumeView.hidden = NO;
        [self.view addSubview:_volumeView];
    }
    return _volumeView;
}
/*
 * 遍历控件，拿到UISlider
 */
- (UISlider *)volumeSlider {
    UISlider* volumeSlider = nil;
    for (UIView *view in [self.volumeView subviews]) {
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeSlider = (UISlider *)view;
            break;
        }
    }
    return volumeSlider;
}

@end
