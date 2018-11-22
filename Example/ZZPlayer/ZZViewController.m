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

@interface ZZViewController ()
@property(nonatomic,weak)ZZPlayerLoadingView * playLoadingView;
@property(nonatomic,weak)ZZBrightnessView *brigV;
@end

@implementation ZZViewController

- (void)viewDidLoad{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

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

@end
