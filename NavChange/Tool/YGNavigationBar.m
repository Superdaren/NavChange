//
//  YGNavigationBar.m
//  MXBarManagerDemo
//
//  Created by super on 2017/10/14.
//  Copyright © 2017年 desn. All rights reserved.
//

#import "YGNavigationBar.h"

#define shareManager [YGNavigationBar sharedManager]

static const CGFloat kNavigationBarHeight  = 64.0f;
static const CGFloat kDefaultFullOffset    = 200.0f;
static const float   kMaxAlphaValue        = 0.995f;
static const float   kMinAlphaValue        = 0.0f;

@interface YGNavigationBar()

@property (nonatomic, strong) UIColor *barColor;

@property (nonatomic, assign) float beginAlphaOffset;   // 开始渐变的位移
@property (nonatomic, assign) float finishAlphaOffset;  // 结束渐变的位移
@property (nonatomic, assign) float minAlphaValue;
@property (nonatomic, assign) float maxAlphaValue;

@property (nonatomic, assign) BOOL setChange;

@property (nonatomic, assign) CGFloat alphaOffset;
@property (nonatomic, assign) CGFloat lastOffset;    // 上一次偏移量
@property (nonatomic, assign) CGFloat reverseOffset; // 开始反向的偏移量

@property (nonatomic, strong) UINavigationBar *selfNavigationBar;
@property (nonatomic, strong) UINavigationController *selfNavigationController;

@end

@implementation YGNavigationBar

+ (YGNavigationBar *)sharedManager
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
        [_sharedObject initBaseData];
        
    });
    return _sharedObject;
}

- (void)initBaseData {
    self.maxAlphaValue = kMaxAlphaValue;
    self.minAlphaValue = kMinAlphaValue;
    self.finishAlphaOffset = kDefaultFullOffset;
    self.beginAlphaOffset = -kNavigationBarHeight;
    self.lastOffset = self.beginAlphaOffset;
    self.reverseOffset = self.beginAlphaOffset;
}

-(YGNavigationBar *(^)(UIViewController *))managerViewController {
    return ^id(UIViewController *viewController){
        UINavigationBar *navigationBar = viewController.navigationController.navigationBar;
        shareManager.selfNavigationController = viewController.navigationController;
        shareManager.selfNavigationBar = navigationBar;
        [navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [navigationBar setShadowImage:[UIImage new]];
        return shareManager;
    };
}

- (YGNavigationBar *(^)(UIColor *color))addBarColor {
    return ^id(UIColor *color){
        self.barColor = color;
        return shareManager;
    };
}

- (YGNavigationBar *(^)(UIImage *image))addBackgroundImage {
    return ^id(UIImage *image){
        [shareManager.selfNavigationBar setBackgroundImage:image
                                                     forBarMetrics:UIBarMetricsDefault];
        return shareManager;
    };
}

- (YGNavigationBar *(^)(float value))addBeginAlphaOffset {
    return ^id(float value){
        self.beginAlphaOffset = value;
        return shareManager;
    };
}

- (YGNavigationBar *(^)(float value))addFinishAlphaOffset {
    return ^id(float value){
        self.finishAlphaOffset = value;
        return shareManager;
    };
}

- (YGNavigationBar *(^)(float value))addmMinAlphaValue {
    return ^id(float value){
        self.minAlphaValue = value;
        return shareManager;
    };
}

- (YGNavigationBar *(^)(float value))addMaxAlphaValue {
    return ^id(float value){
        self.maxAlphaValue = value;
        return shareManager;
    };
}


- (void)changeAlphaWithCurrentOffset:(CGFloat)currentOffset {
    float currentAlpha = [shareManager curretAlphaForOffset:currentOffset];
    
    [self setNavigationBarColorWithAlpha:currentAlpha];
}


#pragma mark - calculation
- (float)curretAlphaForOffset:(CGFloat)offset {
    if (offset < self.lastOffset) {
        self.alphaOffset =  0;
        self.reverseOffset = offset;
    } else {
        self.alphaOffset = offset - self.reverseOffset;
    }
    
    float currentAlpha = self.alphaOffset / (float)(shareManager.finishAlphaOffset - shareManager.beginAlphaOffset);
    currentAlpha = currentAlpha < shareManager.minAlphaValue ? shareManager.minAlphaValue : (currentAlpha > shareManager.maxAlphaValue ? shareManager.maxAlphaValue : currentAlpha);
    
    currentAlpha = 1 - currentAlpha;
    
    self.lastOffset = offset;
    return currentAlpha;
}

- (void)setTitleColorWithColor:(UIColor *)color {
    NSMutableDictionary *textAttr = [NSMutableDictionary dictionaryWithDictionary:shareManager.selfNavigationBar.titleTextAttributes];
    [textAttr setObject:color forKey:NSForegroundColorAttributeName];
    shareManager.selfNavigationBar.titleTextAttributes = textAttr;
}


- (void)setNavigationBarColorWithAlpha:(float)alpha {
    shareManager.addBackgroundImage([self imageWithColor:[shareManager.barColor colorWithAlphaComponent:alpha]]);
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage *imgae = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imgae;
}


@end
