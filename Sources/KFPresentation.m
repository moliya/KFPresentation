//
//  KFPresentation.m
//  KFPresentationDemo
//
//  Created by carefree on 2018/11/6.
//  Copyright © 2018 carefree. All rights reserved.
//

#import "KFPresentation.h"
#import <objc/runtime.h>

@interface KFPresentation()

@property (nonatomic,strong) UIView             *bgView;
@property (nonatomic,strong) UIVisualEffectView *blurView;

@end

@implementation KFPresentation

#pragma mark - Override
// 初始化
- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController {
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    if (!self) {
        return nil;
    }
    
    _frame = CGRectZero;
    _dismissInBlurView = YES;
    _backgroundColor = [UIColor clearColor];
    _backgroundAlpha = 0.5;
    _blurBackground = YES;
    _blurStyle = UIBlurEffectStyleDark;
    _cornerRadius = 0;
    
    return self;
}

//在呈现过渡即将开始的时候被调用的
- (void)presentationTransitionWillBegin {
    if (self.customBackgroundView) {
        self.bgView = self.customBackgroundView;
        self.bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self.bgView addGestureRecognizer:tap];
    } else {
        self.bgView.backgroundColor = self.backgroundColor;
    }
    if (self.blurBackground) {
        [self.bgView insertSubview:self.blurView atIndex:0];
        self.blurView.effect = [UIBlurEffect effectWithStyle:self.blurStyle];
    }
    self.bgView.alpha = 0;
    
    [self.containerView addSubview:self.bgView];
    
    //渐变动画
    [self.presentingViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.bgView.alpha = self.backgroundAlpha;
    } completion:nil];
}

//在呈现过渡结束时被调用的
//如果呈现没有完成，那就移除背景 View
- (void)presentationTransitionDidEnd:(BOOL)completed {
    if (!completed) {
        [self.bgView removeFromSuperview];
    }
}

//在退出过渡即将开始的时候被调用的
- (void)dismissalTransitionWillBegin {
    [self.presentingViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.bgView.alpha = 0;
    } completion:nil];
}

//在退出的过渡结束时被调用的
- (void)dismissalTransitionDidEnd:(BOOL)completed {
    if (completed) {
        [self.bgView removeFromSuperview];
    }
}

//如果你不希望被呈现的 View 占据了整个屏幕，可以调整它的frame
- (CGRect)frameOfPresentedViewInContainerView {
    CGRect frame = [super frameOfPresentedViewInContainerView];
    if (!CGRectIsEmpty(self.frame)) {
        frame = self.frame;
    }
    
    return frame;
}

- (UIView *)presentedView {
    UIView *view = self.presentedViewController.view;
    if (self.cornerRadius > 0) {
        //设置圆角
        view.layer.cornerRadius = self.cornerRadius;
    }
    
    return view;
}

#pragma mark - Lazyloading
- (UIView *)bgView {
    if (_bgView) {
        return _bgView;
    }
    
    _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _bgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [_bgView addGestureRecognizer:tap];
    
    return _bgView;
}

- (UIVisualEffectView *)blurView {
    if (_blurView) {
        return _blurView;
    }
    
    _blurView = [[UIVisualEffectView alloc] init];
    _blurView.frame = self.containerView.bounds;
    
    return _blurView;
}

#pragma mark - Private
- (void)dismiss {
    if (self.blurViewClickedHandler) {
        self.blurViewClickedHandler();
        return;
    }
    if (self.dismissInBlurView) {
        [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    } else if (self.keyboardHiddenInBlurView) {
        [self.presentedViewController.view endEditing:YES];
    }
}

@end


@implementation UIViewController (KFPresentation)

#pragma mark - Public
- (void)kf_setContentFrame:(CGRect)frame {
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = self;
    
    objc_setAssociatedObject(self, @selector(kf_contentFrame), [NSValue valueWithCGRect:frame], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)kf_setCustomConfigure:(KFPresentationCustomConfigure)configure {
    objc_setAssociatedObject(self, @selector(kf_customConfigure), configure, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - Getter
- (CGRect)kf_contentFrame {
    NSValue *value = objc_getAssociatedObject(self, @selector(kf_contentFrame));
    
    return value.CGRectValue;
}

- (KFPresentationCustomConfigure)kf_customConfigure {
    KFPresentationCustomConfigure configure = objc_getAssociatedObject(self, @selector(kf_customConfigure));
    
    return configure;
}

#pragma mark - UIViewControllerTransitioningDelegate
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    KFPresentation *presentation = [[KFPresentation alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    presentation.frame = [self kf_contentFrame];
    KFPresentationCustomConfigure configure = [self kf_customConfigure];
    if (configure) {
        configure(presentation);
    }
    
    return presentation;
}

@end
