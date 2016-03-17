//
//  CustomHUD.h
//  GGBannerViewDemo
//
//  Created by zhuochenming on 16/3/17.
//  Copyright © 2016年 zhuochenming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomHUD : UIView

#pragma mark - 展示
+ (void)show;

+ (void)showWithStatus:(NSString *)status;

//#pragma mark - 进度
//+ (void)showProgress:(CGFloat)progress;
//
//+ (void)showProgress:(CGFloat)progress status:(NSString *)status;

#pragma mark - 成功
+ (void)showSuccess;

+ (void)showSuccessWithStatus:(NSString *)status;

#pragma mark - 错误
+ (void)showError;

+ (void)showErrorWithStatus:(NSString *)status;

#pragma mark - 移除
+ (void)dismiss;

+ (void)dismissWithCompletion:(void (^)(void))completion;

@end
