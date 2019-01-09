
//
//  KFSheetViewController.m
//  KFPresentationDemo
//
//  Created by carefree on 2019/1/9.
//  Copyright © 2019 carefree. All rights reserved.
//

#import "KFSheetViewController.h"
#import "KFPresentation.h"

@interface KFSheetViewController ()

@end

@implementation KFSheetViewController

#pragma mark - Lifecycle
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self customFrame];
    
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self customFrame];
    
    return self;
}

- (void)customFrame {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat height = 300;
    //设置显示frame
    [self kf_setContentFrame:(CGRect){0, screenHeight - height, screenWidth, height}];
    [self kf_setCustomConfigure:^(KFPresentation * _Nonnull presentation) {
        //相关配置
        presentation.backgroundColor = [UIColor lightGrayColor];
        presentation.backgroundAlpha = 0.3;
        presentation.dismissInBlurView = YES;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
