//
//  UIView+ZZFrame.h
//  ZZPlayer_Example
//
//  Created by 周晓瑞 on 2018/11/22.
//  Copyright © 2018 zhouXiaoR. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ZZFrame)
@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat right;

@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize  size;
@end

NS_ASSUME_NONNULL_END
