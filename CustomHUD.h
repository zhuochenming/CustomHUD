//
//  CustomHUD.h
//  CustomHUD
//
//  Created by zhuochenming on 16/3/17.
//  Copyright © 2016年 zhuochenming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomHUD : UIView

#pragma mark - 展示
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

+ (void)dismissWithCompletion:(void (^)(void))completion;

@end
