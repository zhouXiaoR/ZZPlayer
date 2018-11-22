//
//  ZZPlayerLoadingView.h
//  Pods-ZZPlayer_Example
//
//  Created by 周晓瑞 on 2018/11/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZPlayerLoadingView : UIView

@property(nonatomic,assign)BOOL hiddenWhenStopped;

@property (nonatomic, readonly) BOOL isAnimating;

@property (nonatomic, strong) CAMediaTimingFunction *timingFunction;

@property (nonatomic, readwrite) NSTimeInterval duration;

- (void)startAnimating;

- (void)stopAnimating;

@end

NS_ASSUME_NONNULL_END
