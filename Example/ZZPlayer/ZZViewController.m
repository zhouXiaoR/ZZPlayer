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
#import "ZZPlayer/Category/UIView+ZZFrame.h"
#import <MediaPlayer/MediaPlayer.h>

#import "ZZPlayer/ZZPlayerView.h"

@interface ZZViewController ()
@property(nonatomic,weak)ZZPlayerLoadingView * playLoadingView;
@property(nonatomic,weak)ZZBrightnessView *brigV;
@property(nonatomic,strong)MPVolumeView *volumeView;
@property(nonatomic,strong)UISlider * volumeSlider;

@property(nonatomic,strong)ZZVideoModel * vmodel;
@property(nonatomic,weak)ZZPlayerView * playerView;

// 时间比
@property (weak, nonatomic) IBOutlet UIButton *timeLabBtn;

// 播放暂停按钮
@property (weak, nonatomic) IBOutlet UIButton *playPauseBtn;

// 进度滑块
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;

// 亮度滑块
@property (weak, nonatomic) IBOutlet UISlider *brightnessSlider;

// 声音滑块
@property (weak, nonatomic) IBOutlet UISlider *volumnsSlide;

// 缓冲进度
@property (weak, nonatomic) IBOutlet UIProgressView *bufferingProgressView;

// 播放速度
@property (weak, nonatomic) IBOutlet UISegmentedControl *rateSegment;

@end

@implementation ZZViewController

- (IBAction)playOrPause:(id)sender {
    UIButton * s = sender;
    s.selected = !s.selected;

    if (s.selected) {
        if (![[self.playPauseBtn titleForState:UIControlStateNormal] isEqualToString:@"播放"]) {
            [self.playPauseBtn setTitle:@"播放" forState:UIControlStateNormal];
        }
        [self.playerView playVideo:self.vmodel];
    }else{
        [self.playerView.playerManager zzPause];
    }
}

- (IBAction)fastBack:(id)sender {
     UISlider * s = sender;
    [self.playerView.playerManager seekTimeProgress:s.value];
}

- (IBAction)brightnessSlide:(id)sender {
    UISlider * s = sender;
    self.playerView.playerManager.brightness = s.value;
}

- (IBAction)volumnSlide:(UISlider *)sender {
    self.playerView.playerManager.volume = sender.value * 10;
}

- (IBAction)segmentClick:(UISegmentedControl *)sender {
    NSInteger index = sender.selectedSegmentIndex;
    CGFloat rate = (1 + index) * 0.5;
    self.playerView.playerManager.rate = rate;
}

- (void)bindData{
    self.brightnessSlider.value = [UIScreen mainScreen].brightness;
    self.volumnsSlide.value = self.playerView.playerManager.volume;
    [self.timeLabBtn setTitle:@"00:00/00:00" forState:UIControlStateNormal];
    self.rateSegment.selectedSegmentIndex = 1;

    __weak typeof(self) weakSelf = self;
    [self.playerView.playerManager setPlayingProgressComplete:^(CGFloat progress) {
        NSLog(@"当前的播放进度----%.2f",progress);
        NSString * cd = [self  getMMSSFromSS:weakSelf.playerView.playerManager.currentDuration];
         NSString * tol = [self  getMMSSFromSS:weakSelf.playerView.playerManager.totalDuration];
        NSString * timeLabText = [NSString stringWithFormat:@"%@/%@",cd,tol];
        [weakSelf.timeLabBtn setTitle:timeLabText forState:UIControlStateNormal];
        [weakSelf.progressSlider setValue:progress animated:YES];
        weakSelf.progressSlider.value = progress;
    }];

    [self.playerView.playerManager setPlayStateChangeCompelete:^(ZZPlayerState state) {
        NSLog(@"当前的播放状态----%lu",(unsigned long)state);
    }];

    [self.playerView.playerManager setPlayBufferingProgressComplete:^(CGFloat bufferProgress) {
        NSLog(@"当前的缓冲进度----%.2f",bufferProgress);
        [weakSelf.bufferingProgressView setProgress:bufferProgress animated:YES];
    }];

    [self.playerView.playerManager setPlayFinishedComplete:^(id obj) {
        NSLog(@"播放完成了---重置按钮");
        weakSelf.playPauseBtn.selected = NO;
        [weakSelf.playPauseBtn setTitle:@"重播" forState:UIControlStateNormal];
    }];
}

- (IBAction)fullScreenClick:(id)sender {
    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationLandscapeRight) forKey:@"orientation"];
   [UIViewController attemptRotationToDeviceOrientation];
}

- (void)viewDidLoad{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    ZZPlayerView * pv = [[ZZPlayerView alloc]initWithFrame:
                         CGRectMake(0, 64, self.view.width, self.view.height - 300 - 64)];
    pv.backgroundColor = [UIColor greenColor];
    [self.view addSubview:pv];
    self.playerView = pv;
// https://media.w3.org/2010/05/sintel/trailer.mp4
    ZZVideoModel * vm = [[ZZVideoModel alloc]init];
    NSString * path = [[NSBundle mainBundle] pathForResource:@"story.mp4" ofType:nil];
    vm.videoURL = [NSURL fileURLWithPath:path];
    vm.videoURL = [NSURL URLWithString:@"http://v4.qutoutiao.net/toutiao_video_zdgq_online/d0287ebf4ae741dfb403ef1f0217fc86/hd.mp4"];

    // http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4 动画片1分钟
    // http://v4.qutoutiao.net/toutiao_video_zdgq_online/87c3a57b674941c3935515611392c9a2/hd.mp4
    // http://v4.qutoutiao.net/toutiao_video_zdgq_online/9c1303634abb4321b5df4db3cb6c148c/hd.mp4
//天路 http://v4.qutoutiao.net/toutiao_video_zdgq_online/d0287ebf4ae741dfb403ef1f0217fc86/hd.mp4
    self.vmodel = vm;

    [self bindData];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    ZZVideoModel * vm = [[ZZVideoModel alloc]init];
    vm.videoURL = [NSURL URLWithString:@"http://v4.qutoutiao.net/toutiao_video_zdgq_online/87c3a57b674941c3935515611392c9a2/hd.mp4"];
    [self.playerView playVideo:vm];
}

#pragma mark - 旋转支持

- (BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

- (BOOL)prefersStatusBarHidden {
    BOOL sbh = [UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height;
    [self.navigationController setNavigationBarHidden:sbh animated:YES];
    return sbh;
}

#pragma mark - Private

- (NSString *)getMMSSFromSS:(NSInteger)totalTime{
    NSInteger seconds = totalTime;
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];

    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    if (str_hour.integerValue <= 0) {
        format_time =
        [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    }

    return format_time;
}



#pragma mark - 测试代码
#pragma mark - 测试代码

- (void)demo{
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
