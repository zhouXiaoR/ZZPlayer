//
//  NSObject+ZZRotation.m
//  ZZPlayer_Example
//
//  Created by 周晓瑞 on 2018/12/3.
//  Copyright © 2018 zhouXiaoR. All rights reserved.
//

#import "NSObject+ZZRotation.h"

@implementation NSObject (ZZRotation)

+ (void)forceUpdateDeviceRotaion:(UIInterfaceOrientation)orientation{
    [[UIDevice currentDevice] setValue:@(orientation) forKey:@"orientation"];
    [UIViewController attemptRotationToDeviceOrientation];
}

@end
