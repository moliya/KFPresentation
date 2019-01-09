//
//  KFPresentation.h
//  KFPresentationDemo
//
//  Created by carefree on 2018/11/6.
//  Copyright © 2018 carefree. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KFPresentation : UIPresentationController

@property (nonatomic, assign) CGRect            frame;
// 点击遮罩层是否消失
@property (nonatomic, assign) BOOL              dismissInBlurView;
// 点击遮罩层是否收起键盘
@property (nonatomic, assign) BOOL              keyboardHiddenInBlurView;
// 点击遮罩层事件回调（该回调会忽略dismissInBlurView和keyboardHiddenInBlurView的设置）
@property (nonatomic, copy, nullable) void(^blurViewClickedHandler)(void);
// 遮罩层颜色
@property (nonatomic, strong) UIColor           *backgroundColor;
// 遮罩层透明度
@property (nonatomic, assign) CGFloat           backgroundAlpha;
// 自定义遮罩层
@property (nonatomic, strong, nullable) UIView  *customBackgroundView;
@property (nonatomic, assign) BOOL              blurBackground;
// 遮罩样式
@property (nonatomic, assign) UIBlurEffectStyle blurStyle;
// 圆角度数
@property (nonatomic, assign) CGFloat           cornerRadius;

@end


// Category
typedef void(^KFPresentationCustomConfigure)(KFPresentation *presentation);

@interface UIViewController (KFPresentation)<UIViewControllerTransitioningDelegate>

// 设置view的frame
- (void)kf_setContentFrame:(CGRect)frame;
// 自定义Presentation的相关属性，如背景色、透明度、圆角等
- (void)kf_setCustomConfigure:(nullable KFPresentationCustomConfigure)configure;

@end


NS_ASSUME_NONNULL_END
