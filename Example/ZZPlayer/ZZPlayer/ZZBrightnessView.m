//
//  ZZBrightVolumeView.m
//  ZZPlayer_Example
//
//  Created by 周晓瑞 on 2018/11/22.
//  Copyright © 2018 zhouXiaoR. All rights reserved.
//

#import "ZZBrightnessView.h"
#import "UIView+ZZFrame.h"

static NSString * const kBrightCellIdentifier = @"kBrightCellIdentifier";
static CGFloat const kBrightnessMaxProgressValue = 12.0f;
static CGFloat const kBrightnessSperateSpace = 1.5f;
static CGFloat const kBrightnessCovMargin = 15.0f;
static CGFloat const kBrightnessCovHeight = 5.0f;
static CGFloat const kBrightnessCovEdgeMargin = 1.0f;

static CGFloat const kBrightnessFadeAnimationDuration = 0.20f;
static CGFloat const kBrightnessDelayDismissAnimationDuration = 1.5f;


@interface ZZBrightnessView ()<UICollectionViewDataSource>{
    NSInteger _currentBrightnessValue;
}

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
        _currentBrightnessValue = [UIScreen mainScreen].brightness * kBrightnessMaxProgressValue;
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
    self.lightProgressCollectionView.frame = CGRectMake(kBrightnessCovMargin, 130, self.width - 2 * kBrightnessCovMargin, kBrightnessCovHeight);
}

#pragma mark - Public

- (void)setBrightnessValue:(CGFloat)brightnessValue{
    _brightnessValue = brightnessValue;

    [self reloadBrightnessProgress];

    [UIScreen mainScreen].brightness = brightnessValue;
}

#pragma mark - Private

- (void)reloadBrightnessProgress{
    _currentBrightnessValue = self.brightnessValue * kBrightnessMaxProgressValue;

    if (_currentBrightnessValue > kBrightnessMaxProgressValue) {
        _currentBrightnessValue = kBrightnessMaxProgressValue;
    }

    if (_currentBrightnessValue < 1) {
        _currentBrightnessValue = 1;
    }

    [self animationFadeShow];

    [self.lightProgressCollectionView reloadData];

    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(animationFadeHidden) withObject:nil afterDelay:kBrightnessDelayDismissAnimationDuration];
}

- (void)animationFadeHidden{
    [UIView animateWithDuration:kBrightnessFadeAnimationDuration animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

- (void)animationFadeShow{
    if (self.hidden) {
        self.hidden = NO;
        [UIView animateWithDuration:kBrightnessFadeAnimationDuration animations:^{
            self.alpha = 1.0f;
        }];
    }
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBrightCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = indexPath.item < _currentBrightnessValue ? [UIColor whiteColor] : [UIColor clearColor];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return kBrightnessMaxProgressValue;
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
        cov.showsVerticalScrollIndicator = NO;
        cov.showsHorizontalScrollIndicator = NO;
        cov.userInteractionEnabled = NO;
        cov.backgroundColor = [UIColor colorWithRed:65.0/255.0 green:67.0/255.0 blue:70.0/255.0 alpha:1.0];
        cov.dataSource = self;
        [cov registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kBrightCellIdentifier];
        [self.contentView addSubview:cov];
        _lightProgressCollectionView = cov;
    }
    return _lightProgressCollectionView;
}

- (UICollectionViewFlowLayout *)lightLayout{
    if (_lightLayout == nil) {
        _lightLayout = [[UICollectionViewFlowLayout alloc]init];
        _lightLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        CGFloat gh = kBrightnessCovHeight - 2 * kBrightnessCovEdgeMargin;
        _lightLayout.itemSize = CGSizeMake(self.itemWidth,gh);
        _lightLayout.minimumLineSpacing = kBrightnessSperateSpace;
        _lightLayout.minimumInteritemSpacing = 0;
        _lightLayout.sectionInset = UIEdgeInsetsMake(kBrightnessCovEdgeMargin,kBrightnessCovEdgeMargin,kBrightnessCovEdgeMargin,kBrightnessCovEdgeMargin);
    }
    return _lightLayout;
}

- (CGFloat)itemWidth{
    return  (self.width - 2 * kBrightnessCovMargin - 2 * kBrightnessCovEdgeMargin - (kBrightnessMaxProgressValue - 1) * kBrightnessSperateSpace) * 1.0 / kBrightnessMaxProgressValue;
}

@end
