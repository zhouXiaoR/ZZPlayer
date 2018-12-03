//
//  ZZPlayerControlView.m
//  Pods-ZZPlayer_Example
//
//  Created by 周晓瑞 on 2018/11/14.
//

#import "ZZPlayerControlView.h"

@interface ZZPlayerControlView ()
@property(nonatomic,weak)UIButton * backButton;
@end

@implementation ZZPlayerControlView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
    [self backButton];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.fullScreen) {
        self.backButton.frame = CGRectMake(15, 15, 80, 40);
    }
}

- (void)playerBack:(UIButton *)sender{
    if (self.backBlock) {
        self.backBlock(sender);
    }
}

#pragma mark - Public

- (void)setFullScreen:(BOOL)fullScreen{
    _fullScreen = fullScreen;

    self.backButton.hidden = !fullScreen;
}

#pragma mark - getter

- (UIButton *)backButton{
    if (_backButton == nil) {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.backgroundColor = [UIColor redColor];
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(playerBack:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backButton];
        _backButton = backButton;
    }
    return _backButton;
}

@end
