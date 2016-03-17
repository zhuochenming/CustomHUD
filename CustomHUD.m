//
//  CustomHUD.m
//  GGBannerViewDemo
//
//  Created by zhuochenming on 16/3/17.
//  Copyright © 2016年 zhuochenming. All rights reserved.
//

#import "CustomHUD.h"

@interface CustomHUD ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIView *drawView;

@property (nonatomic, strong) UILabel *statusLabel;

//@property (nonatomic, strong) CAShapeLayer *checkmarkLayer;

@property (nonatomic, strong) CAShapeLayer *crossLayer;

@property (nonatomic, strong) CAShapeLayer *circleProgressLineLayer;

@property (nonatomic, strong) CAShapeLayer *circleBackgroundLineLayer;

@end

@implementation CustomHUD

+ (CustomHUD *)sharedView {
    static CustomHUD *sharedView = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedView = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [sharedView initProgressHUDView];
    });
    
    return sharedView;
}

- (void)initProgressHUDView {
    _contentView = [[UIImageView alloc] init];
    _contentView.layer.cornerRadius = 5.0;
    
    _drawView = [[UIView alloc] init];
    [self.contentView addSubview:_drawView];
    
    _statusLabel = [[UILabel alloc] init];
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    _statusLabel.textColor = [UIColor whiteColor];
    [_contentView addSubview:_statusLabel];
    
    [self addSubview:_contentView];
}

#pragma mark - 配置
- (UIColor *)viewVacGroundColor{
    return [UIColor colorWithRed:214 / 255.0 green:214 / 255.0 blue:214 / 255.0 alpha:1];
}

- (CGFloat)haveNoLableViewSetup {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat bacWidth = 150;
    CGFloat circleWidth = 114;
    
    UIColor *color = [self viewVacGroundColor];
    _contentView.backgroundColor = color;
    
    _drawView.frame = CGRectMake((bacWidth - circleWidth) / 2.0, (bacWidth - circleWidth) / 2.0, circleWidth, circleWidth);
    _contentView.frame = CGRectMake((width - bacWidth) / 2.0, (height - bacWidth) / 2.0, bacWidth, bacWidth);
    
    return (circleWidth / 2.0f);
}

- (CGFloat)haveLableViewSetupWithStatus:(NSString *)status {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat bacWidth = 160;
    CGFloat circleWidth = 114;
    
    UIColor *color = [self viewVacGroundColor];
    _contentView.backgroundColor = color;
    _statusLabel.text = status;
    
    _drawView.frame = CGRectMake((bacWidth - circleWidth) / 2.0, 10, circleWidth, circleWidth);
    _statusLabel.frame = CGRectMake(0, CGRectGetMaxY(_drawView.frame), bacWidth, bacWidth - CGRectGetMaxY(_drawView.frame));
    _contentView.frame = CGRectMake((width - bacWidth) / 2.0, (height - bacWidth) / 2.0, bacWidth, bacWidth);
    
    return (circleWidth / 2.0f);
}

#pragma mark - 展示
+ (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:[self sharedView]];
    CGFloat radius = [[self sharedView] haveNoLableViewSetup];
    UIColor *color = [[self sharedView] viewVacGroundColor];
    [[self sharedView] drawCircleWithRadius:radius fillColor:color];
}

+ (void)showWithStatus:(NSString *)status {
    [[UIApplication sharedApplication].keyWindow addSubview:[self sharedView]];
    CGFloat radius = [[self sharedView] haveLableViewSetupWithStatus:status];
    UIColor *color = [[self sharedView] viewVacGroundColor];
    [[self sharedView] drawCircleWithRadius:radius fillColor:color];
}

#pragma mark - 成功
+ (void)showSuccess {
    [[UIApplication sharedApplication].keyWindow addSubview:[self sharedView]];
    CGFloat radius = [[self sharedView] haveNoLableViewSetup];
    UIColor *color = [[self sharedView] viewVacGroundColor];
    [[self sharedView] drawSuccessWithRadius:radius color:color];
}

+ (void)showSuccessWithStatus:(NSString *)status {
    [[UIApplication sharedApplication].keyWindow addSubview:[self sharedView]];
    CGFloat radius = [[self sharedView] haveLableViewSetupWithStatus:status];
    UIColor *color = [[self sharedView] viewVacGroundColor];
    [[self sharedView] drawSuccessWithRadius:radius color:color];
}

#pragma mark - 错误
+ (void)showError {
    
    [[UIApplication sharedApplication].keyWindow addSubview:[self sharedView]];
    CGFloat radius = [[self sharedView] haveNoLableViewSetup];
    UIColor *color = [[self sharedView] viewVacGroundColor];
    [[self sharedView] drawErrorWithRadius:radius color:color];
    
//    CGRect rect = [self sharedView].contentView.frame;
//    [self sharedView].contentView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2.0, [UIScreen mainScreen].bounds.size.height / 2.0, 0, 0);
//
//    [UIView animateWithDuration:2 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:.3 options:0 animations:^{
//        [self sharedView].contentView.frame = rect;
//    } completion:^(BOOL finished) {
//        
//    }];
    
}

+ (void)showErrorWithStatus:(NSString *)status {
    [[UIApplication sharedApplication].keyWindow addSubview:[self sharedView]];
    CGFloat radius = [[self sharedView] haveLableViewSetupWithStatus:status];
    UIColor *color = [[self sharedView] viewVacGroundColor];
    [[self sharedView] drawErrorWithRadius:radius color:color];
}

#pragma mark - 移除
+ (void)dismiss {
    [[self sharedView] removeFromSuperview];
}

+ (void)dismissWithCompletion:(void (^)(void))completion {
    [[self sharedView] removeFromSuperview];
    completion();
}

#pragma mark - 绘制圆环
- (void)setupFullRoundCircleWithRadius:(CGFloat)radius color:(UIColor *)color {
    CGPoint center = CGPointMake(radius, radius);
    // Circle
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:center radius:(radius - 5) startAngle:-90.0f * (M_PI / 180) endAngle:275.0f * (M_PI / 180) clockwise:YES];
    
    self.circleProgressLineLayer = [CAShapeLayer layer];
    self.circleProgressLineLayer.path = circlePath.CGPath;
    self.circleProgressLineLayer.strokeColor = [UIColor greenColor].CGColor;
    self.circleProgressLineLayer.fillColor = color.CGColor;
    self.circleProgressLineLayer.lineWidth = 5;
}

#pragma mark - 绘制进度圈动画
- (void)drawCircleWithRadius:(CGFloat)radius fillColor:(UIColor *)color {
    CGPoint center = CGPointMake(radius, radius);
    
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:center radius:(radius - 5) startAngle:-45.0f * (M_PI / 180) endAngle:275.0f * (M_PI / 180) clockwise:YES];
    
    self.circleProgressLineLayer = [CAShapeLayer layer];
    self.circleProgressLineLayer.path = circlePath.CGPath;
    self.circleProgressLineLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    self.circleProgressLineLayer.fillColor = color.CGColor;
    self.circleProgressLineLayer.lineWidth = 5;
    
    [self.drawView.layer addSublayer:self.circleProgressLineLayer];
    
    [self.circleProgressLineLayer removeAllAnimations];
    [self.drawView.layer removeAllAnimations];
    [self animateCircleWithInfiniteLoop];
}

- (void)animateCircleWithInfiniteLoop {
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = @(M_PI * 2.0f * 3);
    rotationAnimation.duration = 3;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    
    [self.drawView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

#pragma mark - 绘制成功动画
- (void)drawSuccessWithRadius:(CGFloat)radius color:(UIColor *)color {
    [self setupFullRoundCircleWithRadius:radius color:color];
    
    UIBezierPath *checkmarkPath = [UIBezierPath bezierPath];
    [checkmarkPath moveToPoint:CGPointMake(CGRectGetWidth(self.drawView.bounds) * 0.28f, CGRectGetHeight(self.drawView.bounds) * 0.53f)];
    [checkmarkPath addLineToPoint:CGPointMake(CGRectGetWidth(self.drawView.bounds) * 0.42f, CGRectGetHeight(self.drawView.bounds) * 0.66f)];
    [checkmarkPath addLineToPoint:CGPointMake(CGRectGetWidth(self.drawView.bounds) * 0.72f, CGRectGetHeight(self.drawView.bounds) * 0.36f)];
    checkmarkPath.lineCapStyle = kCGLineCapSquare;
    
    CAShapeLayer *checkmarkLayer = [CAShapeLayer layer];
    checkmarkLayer.path = checkmarkPath.CGPath;
    checkmarkLayer.fillColor = nil;
    checkmarkLayer.strokeColor = [UIColor greenColor].CGColor;
    checkmarkLayer.lineWidth = 5;
    
    [self.drawView.layer addSublayer:self.circleProgressLineLayer];
    [self.drawView.layer addSublayer:checkmarkLayer];
    
    [self.circleProgressLineLayer removeAllAnimations];
    [self.drawView.layer removeAllAnimations];
    [checkmarkLayer removeAllAnimations];
    [self animateSuccessWithShareLayer:checkmarkLayer color:color];
}

- (void)animateFullCircleWithColor:(UIColor *)color {
    CABasicAnimation *circleAnimation;
//    if (self.superview) {
//        circleAnimation = [CABasicAnimation animationWithKeyPath:@"strokeColor"];
//        circleAnimation.duration = 3;
//        circleAnimation.toValue = (id)color.CGColor;
//        circleAnimation.fillMode = kCAFillModeBoth;
//        circleAnimation.removedOnCompletion = NO;
//    } else {
        circleAnimation = [CABasicAnimation animationWithKeyPath:@"alpha"];
        circleAnimation.duration = 3;
        circleAnimation.fromValue = @(0);
        circleAnimation.toValue = @(1);
        circleAnimation.fillMode = kCAFillModeBoth;
        circleAnimation.removedOnCompletion = NO;
//    }
    
    [self.circleProgressLineLayer addAnimation:circleAnimation forKey:@"appearance"];
}

- (void)animateSuccessWithShareLayer:(CAShapeLayer *)shapLayer color:(UIColor *)color {
    [self animateFullCircleWithColor:color];
    
    CABasicAnimation *checkmarkAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    checkmarkAnimation.duration = 1;
    checkmarkAnimation.removedOnCompletion = NO;
    checkmarkAnimation.fillMode = kCAFillModeBoth;
    checkmarkAnimation.fromValue = @(0);
    checkmarkAnimation.toValue = @(1);
    checkmarkAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [shapLayer addAnimation:checkmarkAnimation forKey:@"strokeEnd"];
}

#pragma mark - 绘制错误动画
- (void)drawErrorWithRadius:(CGFloat)radius color:(UIColor *)color {
    [self setupFullRoundCircleWithRadius:radius color:color];
    
    UIBezierPath *crossPath = [UIBezierPath bezierPath];
    [crossPath moveToPoint:CGPointMake(CGRectGetWidth(self.drawView.bounds) * 0.72f, CGRectGetHeight(self.drawView.bounds) * 0.27f)];
    [crossPath addLineToPoint:CGPointMake(CGRectGetWidth(self.drawView.bounds) * 0.27f, CGRectGetHeight(self.drawView.bounds) * 0.72f)];
    [crossPath moveToPoint:CGPointMake(CGRectGetWidth(self.drawView.bounds) * 0.27f, CGRectGetHeight(self.drawView.bounds) * 0.27f)];
    [crossPath addLineToPoint:CGPointMake(CGRectGetWidth(self.drawView.bounds) * 0.72f, CGRectGetHeight(self.drawView.bounds) * 0.72f)];
    crossPath.lineCapStyle = kCGLineCapSquare;
    
    self.crossLayer = [CAShapeLayer layer];
    self.crossLayer.path = crossPath.CGPath;
    self.crossLayer.fillColor = nil;
    self.crossLayer.strokeColor = [UIColor redColor].CGColor;
    self.crossLayer.lineWidth = 5;
    
    [self.drawView.layer addSublayer:self.circleProgressLineLayer];
    [self.drawView.layer addSublayer:self.crossLayer];
    
    [self.circleProgressLineLayer removeAllAnimations];
    [self.drawView.layer removeAllAnimations];
    [self.crossLayer removeAllAnimations];
    [self animateFullCircleWithColor:color];
}

@end
