//
//  CustomHUD.h
//  CustomHUD
//
//  Created by zhuochenming on 16/3/17.
//  Copyright © 2016年 zhuochenming. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HUDTintColor [UIColor colorWithRed:71 / 255.0 green:192 / 255.0 blue:182 / 255.0 alpha:1]

@interface CustomHUD : UIView

#pragma mark - 纯文本
+ (void)showWithStatus:(NSString *)status;

#pragma mark - 进度
+ (void)showProgress;

+ (void)showProgressWithStatus:(NSString *)status;

#pragma mark - 成功
+ (void)showSuccess;

+ (void)showSuccessWithStatus:(NSString *)status;

#pragma mark - 错误
+ (void)showError;

+ (void)showErrorWithStatus:(NSString *)status;

#pragma mark - 移除
+ (void)dismiss;

+ (void)dismissAfterTime:(CGFloat)timeout;

+ (void)dismissWithCompletion:(void (^)(void))completion;

@end
