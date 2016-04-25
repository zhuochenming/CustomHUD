//
//  CustomHUD.m
//  CustomHUD
//
//  Created by zhuochenming on 16/3/17.
//  Copyright © 2016年 zhuochenming. All rights reserved.
//

#import "CustomHUD.h"

#define ConBacColor [UIColor colorWithRed:214 / 255.0 green:214 / 255.0 blue:214 / 255.0 alpha:1]

static CGFloat const HUDWidth = 150.0;
static CGFloat const HUDCircleWidth = 91.0;

@interface CustomHUD ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIView *drawView;

@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) CAShapeLayer *circleProgressLayer;

@end

@implementation CustomHUD

+ (CustomHUD *)sharedView {
    static CustomHUD *sharedView = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedView = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [sharedView configurationProgressHUDView];
    });
    
    return sharedView;
}

- (void)configurationProgressHUDView {
    _contentView = [[UIImageView alloc] init];
    _contentView.layer.cornerRadius = 5.0;
    
    _drawView = [[UIView alloc] init];
    [_contentView addSubview:_drawView];
    
    _statusLabel = [[UILabel alloc] init];
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    _statusLabel.textColor = [UIColor whiteColor];
    [_contentView addSubview:_statusLabel];
    
    [self addSubview:_contentView];
}

#pragma mark - 配置
- (CGFloat)haveNoLableSetup {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;

    _contentView.backgroundColor = ConBacColor;
    
    _drawView.frame = CGRectMake((HUDWidth - HUDCircleWidth) / 2.0, (HUDWidth - HUDCircleWidth) / 2.0, HUDCircleWidth, HUDCircleWidth);
    _contentView.frame = CGRectMake((width - HUDWidth) / 2.0, (height - HUDWidth) / 2.0, HUDWidth, HUDWidth);
    
    return (HUDCircleWidth / 2.0f);
}

- (CGFloat)haveLableSetupWithStatus:(NSString *)status {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;

    _contentView.backgroundColor = ConBacColor;
    _statusLabel.text = status;
    
    _drawView.frame = CGRectMake((HUDWidth - HUDCircleWidth) / 2.0, 10, HUDCircleWidth, HUDCircleWidth);
    _statusLabel.frame = CGRectMake(0, CGRectGetMaxY(_drawView.frame), HUDWidth, HUDWidth - CGRectGetMaxY(_drawView.frame));
    _contentView.frame = CGRectMake((width - HUDWidth) / 2.0, (height - HUDWidth) / 2.0, HUDWidth, HUDWidth);
    
    return (HUDCircleWidth / 2.0f);
}

#pragma mark - 展示
+ (void)showProgress {
    [[UIApplication sharedApplication].keyWindow addSubview:[self sharedView]];
    CGFloat radius = [[self sharedView] haveNoLableSetup];
    [[self sharedView] drawProgressCircleWithRadius:radius fillColor:ConBacColor];
}

+ (void)showProgressWithStatus:(NSString *)status {
    [[UIApplication sharedApplication].keyWindow addSubview:[self sharedView]];
    CGFloat radius = [[self sharedView] haveLableSetupWithStatus:status];
    [[self sharedView] drawProgressCircleWithRadius:radius fillColor:ConBacColor];
}

- (void)drawProgressCircleWithRadius:(CGFloat)radius fillColor:(UIColor *)color {
    CGPoint center = CGPointMake(radius, radius);
    
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:center radius:(radius - 5) startAngle:-45.0f * (M_PI / 180) endAngle:275.0f * (M_PI / 180) clockwise:YES];
    
    self.circleProgressLayer.path = circlePath.CGPath;
    self.circleProgressLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    self.circleProgressLayer.fillColor = color.CGColor;
    self.circleProgressLayer.lineWidth = 5;
    
    [self.drawView.layer addSublayer:self.circleProgressLayer];
    
    [self.circleProgressLayer removeAllAnimations];
    
    [self.drawView.layer removeAllAnimations];
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = @(M_PI * 2.0f * 3);
    rotationAnimation.duration = 3;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    
    [self.drawView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

#pragma mark - 成功
+ (void)showSuccess {
    [[UIApplication sharedApplication].keyWindow addSubview:[self sharedView]];
    CGFloat radius = [[self sharedView] haveNoLableSetup];
    [[self sharedView] drawSuccessWithRadius:radius color:ConBacColor];
}

+ (void)showSuccessWithStatus:(NSString *)status {
    [[UIApplication sharedApplication].keyWindow addSubview:[self sharedView]];
    CGFloat radius = [[self sharedView] haveLableSetupWithStatus:status];
    [[self sharedView] drawSuccessWithRadius:radius color:ConBacColor];
}

- (void)drawSuccessWithRadius:(CGFloat)radius color:(UIColor *)color {
    [self drawCircleWithRadius:radius color:color];
    
    CGFloat drawWith = CGRectGetWidth(self.drawView.bounds);
    CGFloat drawHeight = CGRectGetHeight(self.drawView.bounds);
    
    UIBezierPath *checkmarkPath = [UIBezierPath bezierPath];
    [checkmarkPath moveToPoint:CGPointMake(drawWith * 0.28f, drawHeight * 0.53f)];
    [checkmarkPath addLineToPoint:CGPointMake(drawWith * 0.42f, drawHeight * 0.66f)];
    [checkmarkPath addLineToPoint:CGPointMake(drawWith * 0.72f, drawHeight * 0.36f)];
    checkmarkPath.lineCapStyle = kCGLineCapSquare;
    
    CAShapeLayer *checkmarkLayer = [CAShapeLayer layer];
    checkmarkLayer.path = checkmarkPath.CGPath;
    checkmarkLayer.fillColor = nil;
    checkmarkLayer.strokeColor = [UIColor greenColor].CGColor;
    checkmarkLayer.lineWidth = 5;
    
    [self.drawView.layer addSublayer:self.circleProgressLayer];
    [self.drawView.layer addSublayer:checkmarkLayer];
    
    [self.circleProgressLayer removeAllAnimations];
    [checkmarkLayer removeAllAnimations];
    [self.drawView.layer removeAllAnimations];
    
    CABasicAnimation *circleAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    circleAnimation.duration = 3.0;
    circleAnimation.fromValue = @(0);
    circleAnimation.toValue = @(1);
    circleAnimation.fillMode = kCAFillModeBoth;
    circleAnimation.removedOnCompletion = NO;
    [self.circleProgressLayer addAnimation:circleAnimation forKey:@"appearance"];
    
    CABasicAnimation *checkmarkAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    checkmarkAnimation.duration = 1;
    checkmarkAnimation.removedOnCompletion = NO;
    checkmarkAnimation.fillMode = kCAFillModeBoth;
    checkmarkAnimation.fromValue = @(0);
    checkmarkAnimation.toValue = @(1);
    checkmarkAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [checkmarkLayer addAnimation:checkmarkAnimation forKey:@"strokeEnd"];
}

#pragma mark - 错误
+ (void)showError {
    [[UIApplication sharedApplication].keyWindow addSubview:[self sharedView]];
    CGFloat radius = [[self sharedView] haveNoLableSetup];
    [[self sharedView] drawErrorWithRadius:radius color:ConBacColor];
}

+ (void)showErrorWithStatus:(NSString *)status {
    [[UIApplication sharedApplication].keyWindow addSubview:[self sharedView]];
    CGFloat radius = [[self sharedView] haveLableSetupWithStatus:status];
    [[self sharedView] drawErrorWithRadius:radius color:ConBacColor];
}

- (void)drawErrorWithRadius:(CGFloat)radius color:(UIColor *)color {
    [self drawCircleWithRadius:radius color:color];
    
    UIBezierPath *crossPath = [UIBezierPath bezierPath];
    
    CGFloat drawWith = CGRectGetWidth(self.drawView.bounds);
    CGFloat drawHeight = CGRectGetHeight(self.drawView.bounds);
    
    [crossPath moveToPoint:CGPointMake(drawWith * 0.72f, drawHeight * 0.27f)];
    [crossPath addLineToPoint:CGPointMake(drawWith * 0.27f, drawHeight * 0.72f)];
    [crossPath moveToPoint:CGPointMake(drawWith * 0.27f, drawHeight * 0.27f)];
    [crossPath addLineToPoint:CGPointMake(drawWith * 0.72f, drawHeight * 0.72f)];
    crossPath.lineCapStyle = kCGLineCapSquare;
    
    CAShapeLayer *crossLayer = [CAShapeLayer layer];
    crossLayer.path = crossPath.CGPath;
    crossLayer.fillColor = nil;
    crossLayer.strokeColor = [UIColor redColor].CGColor;
    crossLayer.lineWidth = 5;
    
    self.circleProgressLayer.strokeColor = [UIColor redColor].CGColor;
    [self.drawView.layer addSublayer:self.circleProgressLayer];
    [self.drawView.layer addSublayer:crossLayer];
    
    [self.circleProgressLayer removeAllAnimations];
    [self.drawView.layer removeAllAnimations];
    [crossLayer removeAllAnimations];
    
    [self.contentView.layer setValue:@(0) forKeyPath:@"transform.scale"];
    [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.8 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        [self.contentView.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
        [self.contentView.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
    }];
}

#pragma mark - 移除
+ (void)dismiss {
    [[self sharedView] removeFromSuperview];
}

+ (void)dismissWithCompletion:(void (^)(void))completion {
    [[self sharedView] removeFromSuperview];
    completion();
}

- (CAShapeLayer *)circleProgressLayer {
    if (_circleProgressLayer == nil) {
        _circleProgressLayer = [CAShapeLayer layer];
    }
    return _circleProgressLayer;
}

#pragma mark - 绘制圆环
- (void)drawCircleWithRadius:(CGFloat)radius color:(UIColor *)color {
    CGPoint center = CGPointMake(radius, radius);
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:center radius:(radius - 5) startAngle:-90.0f * (M_PI / 180) endAngle:275.0f * (M_PI / 180) clockwise:YES];
    
    self.circleProgressLayer.path = circlePath.CGPath;
    self.circleProgressLayer.strokeColor = [UIColor greenColor].CGColor;
    self.circleProgressLayer.fillColor = color.CGColor;
    self.circleProgressLayer.lineWidth = 5;
}

@end
