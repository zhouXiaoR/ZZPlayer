//
//  ZZPlayerControlView.h
//  Pods-ZZPlayer_Example
//
//  Created by 周晓瑞 on 2018/11/14.
//

#import <UIKit/UIKit.h>


typedef void(^ZZPControlBackBlock)(id obj);

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ZZControlViewPanDirection) {
    ZZControlViewPanDirectionUnknown,
    ZZControlViewPanDirectionVertical,
    ZZControlViewPanDirectionHorizontal,
};

typedef NS_ENUM(NSUInteger, ZZControlViewPanLocationType) {
    ZZControlViewPanLocationUnknownType,
    ZZControlViewPanLocationLeftType,
    ZZControlViewPanLocationRightType,
};

typedef NS_ENUM(NSUInteger, ZZControlViewMoveDirection) {
    ZZControlViewMoveDirectionUnkown,
    ZZControlViewMoveDirectionTop, // 向上
    ZZControlViewMoveDirectionLeft, // 向左
    ZZControlViewMoveDirectionBottom, // 向下
    ZZControlViewMoveDirectionRight, // 向右
};

@interface ZZPlayerControlView : UIView

@property(nonatomic,copy)ZZPControlBackBlock backBlock;

@property(nonatomic,assign)BOOL fullScreen;


@property (nonatomic, copy) void(^singleTapped)(ZZPlayerControlView  *controlView);

@property (nonatomic, copy) void(^doubleTapped)(ZZPlayerControlView *controlView);

@property (nonatomic, copy) void(^beganPanGesture)(ZZPlayerControlView *controlView, ZZControlViewPanDirection direction, ZZControlViewPanLocationType location);
@property (nonatomic, copy) void(^changedMovingPanGesture)(ZZPlayerControlView *controlView, ZZControlViewPanDirection direction, ZZControlViewPanLocationType location, CGPoint velocity);
@property (nonatomic, copy) void(^endedPanGuesture)(ZZPlayerControlView *controlView, ZZControlViewPanDirection direction, ZZControlViewPanLocationType location);


@end

NS_ASSUME_NONNULL_END
