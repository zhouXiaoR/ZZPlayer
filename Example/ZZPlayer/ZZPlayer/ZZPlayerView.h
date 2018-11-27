//
//  ZZPlayerView.h
//  Pods-ZZPlayer_Example
//
//  Created by 周晓瑞 on 2018/11/14.
//

#import <UIKit/UIKit.h>
#import "ZZPlayer.h"
#import "ZZVideoModel.h"



NS_ASSUME_NONNULL_BEGIN

@interface ZZPlayerView : UIView

- (void)playVideo:(ZZVideoModel *)model;

@end

NS_ASSUME_NONNULL_END
