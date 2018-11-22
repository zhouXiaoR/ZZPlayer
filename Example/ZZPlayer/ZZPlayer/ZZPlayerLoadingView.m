//
//  ZZPlayerLoadingView.m
//  Pods-ZZPlayer_Example
//
//  Created by 周晓瑞 on 2018/11/14.
//

#import "ZZPlayerLoadingView.h"

static NSString *kRotationAnimationKey = @"zzloading.rotation";

@interface ZZPlayerLoadingView()

@property (nonatomic, readwrite) BOOL isAnimating;
@property(nonatomic,weak)UIImageView *animationImgView;

@end


@implementation ZZPlayerLoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initialize];
}

- (void)initialize {
    self.duration = 1.5f;
    _timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetAnimations) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.animationImgView.frame = self.bounds;
}

- (void)resetAnimations {
    if (self.isAnimating) {
        [self stopAnimating];
        [self startAnimating];
    }
}

- (void)setAnimating:(BOOL)animate {
    (animate ? [self startAnimating] : [self stopAnimating]);
}


- (void)startAnimating {
    if (self.isAnimating)
        return;

    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation";
    animation.duration = self.duration / 0.375f;
    animation.fromValue = @(0.f);
    animation.toValue = @(2 * M_PI);
    animation.repeatCount = INFINITY;
    animation.removedOnCompletion = NO;
    [self.animationImgView.layer addAnimation:animation forKey:kRotationAnimationKey];

    self.isAnimating = true;

    if (self.hiddenWhenStopped) {
        self.hidden = NO;
    }
}

- (void)stopAnimating {
    if (!self.isAnimating)
        return;

    [self.animationImgView.layer removeAnimationForKey:kRotationAnimationKey];
    self.isAnimating = false;

    if (self.hiddenWhenStopped) {
        self.hidden = YES;
    }
}

#pragma mark - Properties

- (BOOL)isAnimating {
    return _isAnimating;
}

-(void)setHiddenWhenStopped:(BOOL)hiddenWhenStopped {
    _hiddenWhenStopped = hiddenWhenStopped;
    self.hidden = !self.isAnimating && hiddenWhenStopped;
}

- (UIImageView *)animationImgView{
    if (_animationImgView == nil) {
        UIImageView * animationImgView = [[UIImageView alloc]init];
        animationImgView.image = [UIImage imageNamed:@"ic_videodetails_loading"];
        [self addSubview:animationImgView];
        _animationImgView = animationImgView;
    }
    return _animationImgView;
}


@end
