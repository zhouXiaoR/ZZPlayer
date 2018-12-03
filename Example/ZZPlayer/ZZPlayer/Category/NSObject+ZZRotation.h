//
//  NSObject+ZZRotation.h
//  ZZPlayer_Example
//
//  Created by 周晓瑞 on 2018/12/3.
//  Copyright © 2018 zhouXiaoR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ZZRotation)

+ (void)forceUpdateDeviceRotaion:(UIInterfaceOrientation)orientation;

@end

NS_ASSUME_NONNULL_END
