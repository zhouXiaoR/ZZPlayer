//
//  ZZBrightnessView.m
//  ZZPlayer_Example
//
//  Created by 周晓瑞 on 2018/11/22.
//  Copyright © 2018 zhouXiaoR. All rights reserved.
//

#import "ZZBrightnessView.h"
#import "UIView+ZZFrame.h"

@interface ZZBrightnessView ()<UICollectionViewDataSource>

@property(nonatomic,weak)UIView * contentView;
@property(nonatomic,weak)UILabel * lightLab;
@property(nonatomic,weak)UIImageView * sunImgView;
@property(nonatomic,weak)UICollectionView *lightProgressCollectionView;
@property(nonatomic,strong)UICollectionViewFlowLayout * lightLayout;

@end

@implementation ZZBrightnessView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self setUp];
    }
    return self;
}

- (void)setUp{
    [self contentView];
    [self lightLab];
    [self sunImgView];
    [self lightProgressCollectionView];
}

- (void)layoutSubviews{
    [super layoutSubviews];

    self.contentView.frame = self.bounds;
    self.lightLab.frame = CGRectMake(0, 10, self.width, 30);
    self.sunImgView.bounds = CGRectMake(0, 0, 79, 76);
    self.sunImgView.center =
    CGPointMake(self.contentView.width * 0.5, self.contentView.height * 0.5);
    self.lightProgressCollectionView.frame = CGRectMake(15, 130, self.width - 30, 10);
}

#pragma mark - Public

- (void)setBrightnessValue:(CGFloat)brightnessValue{
    _brightnessValue = brightnessValue;

    [self reloadBrightnessProgress];
}


- (void)reloadBrightnessProgress{

}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

#pragma mark - getter

- (UIView *)contentView{
    if (_contentView == nil) {
        UIView * contentView = [[UIView alloc]init];
        contentView.backgroundColor = [UIColor whiteColor];
        contentView.layer.cornerRadius  = 10.0f;
        contentView.layer.masksToBounds = YES;
        [self addSubview:contentView];
        _contentView = contentView;
    }
    return _contentView;
}

- (UILabel *)lightLab{
    if (_lightLab == nil) {
        UILabel *lightLab = [[UILabel alloc] init];
        lightLab.font = [UIFont boldSystemFontOfSize:16.0];
        lightLab.textColor = [UIColor colorWithRed:0.25f green:0.22f blue:0.21f alpha:1.0f];
        lightLab.textAlignment = NSTextAlignmentCenter;
        lightLab.text = @"亮度";
        [self.contentView addSubview:lightLab];
        _lightLab = lightLab;
    }
    return _lightLab;
}

- (UIImageView *)sunImgView{
    if (_sunImgView == nil) {
        UIImageView * sun = [[UIImageView alloc] init];
        sun.image = [UIImage imageNamed:@"play_new_brightness_day"];
        [self addSubview:sun];
        _sunImgView = sun;
    }
    return _sunImgView;
}

- (UICollectionView *)lightProgressCollectionView{
    if (_lightProgressCollectionView == nil) {
        UICollectionView * cov = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.lightLayout];
        cov.backgroundColor = [UIColor colorWithRed:65.0/255.0 green:67.0/255.0 blue:70.0/255.0 alpha:1.0];
        cov.dataSource = self;
        [self.contentView addSubview:cov];
        _lightProgressCollectionView = cov;
    }
    return _lightProgressCollectionView;
}

@end
