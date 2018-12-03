//
//  ZZPlayerControlView.h
//  Pods-ZZPlayer_Example
//
//  Created by 周晓瑞 on 2018/11/14.
//

#import <UIKit/UIKit.h>


typedef void(^ZZPControlBackBlock)(id obj);

NS_ASSUME_NONNULL_BEGIN

@interface ZZPlayerControlView : UIView

@property(nonatomic,copy)ZZPControlBackBlock backBlock;

@property(nonatomic,assign)BOOL fullScreen;

@end

NS_ASSUME_NONNULL_END
