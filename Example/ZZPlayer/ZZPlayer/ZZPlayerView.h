//
//  ZZPlayerView.h
//  Pods-ZZPlayer_Example
//
//  Created by 周晓瑞 on 2018/11/14.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "ZZVideoModel.h"



typedef enum : NSUInteger {
    ZZPlayerPlayStatusFailed = 1, // 播放失败
    ZZPlayerPlayStatusBuffering = 2, // 缓冲中
    ZZPlayerPlayStatusPlaying = 3, // 播放中
    ZZPlayerPlayStatusStopped = 4, // 异常打断的播放
    ZZPlayerPlayStatusFinished = 5, // 完成播放
    ZZPlayerPlayStatusPaused = 6, // 正常的暂停播放
} ZZPlayerPlayStatus;


NS_ASSUME_NONNULL_BEGIN

@interface ZZPlayerView : UIView

- (void)zzPlayWithVideoModel:(ZZVideoModel *)model;

@property(nonatomic,assign,readonly)ZZPlayerPlayStatus playStatus;

- (void)zzPause;

@end

NS_ASSUME_NONNULL_END
