//
//  ZZPlayControlVC.m
//  ZZPlayer_Example
//
//  Created by 周晓瑞 on 2018/12/7.
//  Copyright © 2018 zhouXiaoR. All rights reserved.
//

#import "ZZPlayControlVC.h"
#import "ZZPlayer/ZZPlayerControlView.h"

@interface ZZPlayControlVC ()
@property(nonatomic,weak) ZZPlayerControlView * playerControlView;
@end

@implementation ZZPlayControlVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.playerControlView.frame = CGRectMake(30, 100, self.view.bounds.size.width - 60, 300);
}

- (ZZPlayerControlView *)playerControlView{
    if (_playerControlView == nil) {
        ZZPlayerControlView * pcv = [[ZZPlayerControlView alloc]init];
        pcv.backgroundColor = [UIColor lightGrayColor];
        pcv.fullScreen = NO;
        [self.view addSubview:pcv];
        [pcv setBackBlock:^(id obj) {

        }];
        _playerControlView = pcv;
    }
    return _playerControlView;
}


@end
