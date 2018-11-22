//
//  ZZViewController.m
//  ZZPlayer
//
//  Created by zhouXiaoR on 11/22/2018.
//  Copyright (c) 2018 zhouXiaoR. All rights reserved.
//

#import "ZZViewController.h"
#import "ZZPlayer/ZZPlayerLoadingView.h"

@interface ZZViewController ()
@property(nonatomic,weak)ZZPlayerLoadingView * playLoadingView;
@end

@implementation ZZViewController

- (void)viewDidLoad{
    [super viewDidLoad];

    ZZPlayerLoadingView * lv = [[ZZPlayerLoadingView alloc]initWithFrame:CGRectMake(10, 100, 40, 40)];
    lv.hiddenWhenStopped = YES;
    lv.duration = 0.5;
    lv.backgroundColor = [UIColor blackColor];
    [self.view addSubview:lv];
    [lv startAnimating];
    self.playLoadingView = lv;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.playLoadingView stopAnimating];
}

@end
