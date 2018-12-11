//
//  ZZPlayerControlView.m
//  Pods-ZZPlayer_Example
//
//  Created by 周晓瑞 on 2018/11/14.
//

#import "ZZPlayerControlView.h"
#import "Category/UIView+ZZFrame.h"

@interface ZZPlayerControlView ()
@property(nonatomic,weak)UIButton * backButton;

@property(nonatomic,weak)UIView *playerControlTopView;
@property(nonatomic,weak)UIView *playerControlBottomView;
@property(nonatomic,weak)UIView * betLineView;


@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic,assign) ZZControlViewPanDirection panDirection;
@property (nonatomic,assign) ZZControlViewPanLocationType panLocationType;
@property (nonatomic,assign) ZZControlViewMoveDirection panMovingDirection;

// 上次拖动的点
@property(nonatomic,assign)CGPoint previousPanPoint;

@end

@implementation ZZPlayerControlView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
    [self playerControlTopView];
    [self playerControlBottomView];
    [self backButton];
    [self betLineView];


    [self addGestureRecognizer:self.singleTap];
    [self addGestureRecognizer:self.doubleTap];
    [self addGestureRecognizer:self.panGesture];
    [self.singleTap requireGestureRecognizerToFail:self.doubleTap];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.fullScreen) {
        self.backButton.frame = CGRectMake(15, 15, 80, 40);
    }

    self.playerControlTopView.frame = CGRectMake(0, 0, self.width, 60);
    self.playerControlBottomView.frame = CGRectMake(0, self.height - 60, self.width, 60);
    self.betLineView.bounds = CGRectMake(0, 0, 2, self.height);
    self.betLineView.center = CGPointMake(self.width * 0.5, self.height * 0.5);
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

#pragma mark - Private


#pragma mark - Events

- (void)handleSingleTap:(UITapGestureRecognizer *)tap {

    NSLog(@"单击了屏幕");

    if (self.singleTapGesture){
        self.singleTapGesture(self);
    }
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
    NSLog(@"双击了屏幕");

    if (self.doubleTapGeture){
        self.doubleTapGeture(self);
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)pan {
    CGPoint translate = [pan translationInView:pan.view];
    CGPoint velocity = [pan velocityInView:pan.view];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            self.panMovingDirection = ZZControlViewMoveDirectionUnkown;
            CGFloat x = fabs(velocity.x);
            CGFloat y = fabs(velocity.y);
            if (x > y) {
                self.panDirection = ZZControlViewPanDirectionHorizontal;
                NSLog(@"手势开始-水平方向移动");
            } else {
                self.panDirection = ZZControlViewPanDirectionVertical;
                NSLog(@"手势开始-竖直方向移动");


                //位置在这里确定
                CGFloat halfScreenWidth = self.width * 0.5;
                if (translate.x < halfScreenWidth) {
                    self.panLocationType = ZZControlViewPanLocationLeftType;
                    NSLog(@"竖直左面-调节音量");
                }else{
                    self.panLocationType = ZZControlViewPanLocationRightType;
                    NSLog(@"竖直右面-调节亮度");
                }
            }
            if (self.beganPanGesture){
                self.beganPanGesture(self, self.panDirection, self.panLocationType);
            }
        }
            break;
        case UIGestureRecognizerStateChanged: {
            switch (self.panDirection) {
                case ZZControlViewPanDirectionHorizontal: {
                    if (translate.x > self.previousPanPoint.x) {
                        self.panMovingDirection = ZZControlViewMoveDirectionRight;
                        NSLog(@"水平移动-向右");
                    } else if(translate.x < self.previousPanPoint.x){
                        self.panMovingDirection = ZZControlViewMoveDirectionLeft;
                        NSLog(@"水平移动-向左");
                    }
                }
                    break;
                case ZZControlViewPanDirectionVertical: {
                    if (translate.y > self.previousPanPoint.y) {
                        self.panMovingDirection = ZZControlViewMoveDirectionBottom;
                        NSLog(@"竖直移动-向下");
                    } else if(translate.y < self.previousPanPoint.y) {
                        self.panMovingDirection = ZZControlViewMoveDirectionTop;
                        NSLog(@"竖直移动-向上");
                    }
                }
                    break;
                case ZZControlViewPanDirectionUnknown:
                    break;
            }
            if (self.changedMovingPanGesture) {
                self.changedMovingPanGesture(self, self.panDirection, self.panLocationType, velocity);
            }
        }
            break;
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            if (self.endedPanGuesture) {
                self.endedPanGuesture(self, self.panDirection, self.panLocationType);
            }
        }
            break;
        default:
            break;
    }

    self.previousPanPoint = translate;
    [pan setTranslation:CGPointZero inView:pan.view];
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

- (UIView *)playerControlTopView{
    if (_playerControlTopView == nil) {
        UIView * pcv = [[UIView alloc]init];
        pcv.backgroundColor=[UIColor darkGrayColor];
        [self addSubview:pcv];
        _playerControlTopView = pcv;
    }
    return _playerControlTopView;
}

- (UIView *)playerControlBottomView{
    if (_playerControlBottomView == nil) {
        UIView * pcv = [[UIView alloc]init];
        pcv.backgroundColor=[UIColor darkGrayColor];
        [self addSubview:pcv];
        _playerControlBottomView = pcv;
    }
    return _playerControlBottomView;
}

- (UIView *)betLineView{
    if (_betLineView == nil) {
        UIView * blv = [[UIView alloc]init];
        blv.backgroundColor = [UIColor redColor];
        [self addSubview:blv];
        _betLineView = blv;
    }
    return _betLineView;
}


- (UITapGestureRecognizer *)singleTap {
    if (!_singleTap){
        _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    }
    return _singleTap;
}

- (UITapGestureRecognizer *)doubleTap {
    if (!_doubleTap) {
        _doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        _doubleTap.numberOfTapsRequired = 2;
    }
    return _doubleTap;
}

- (UIPanGestureRecognizer *)panGesture {
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    }
    return _panGesture;
}


@end
