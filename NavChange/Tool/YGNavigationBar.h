//
//  YGNavigationBar.h
//  MXBarManagerDemo
//
//  Created by super on 2017/10/14.
//  Copyright © 2017年 desn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YGNavigationBar : NSObject

+ (YGNavigationBar *)sharedManager;

-(YGNavigationBar *(^)(UIViewController *viewController))managerViewController;

-(YGNavigationBar *(^)(UIColor *color))addBarColor;

-(YGNavigationBar *(^)(UIImage *image))addBackgroundImage;

-(YGNavigationBar *(^)(float value))addBeginAlphaOffset;

-(YGNavigationBar *(^)(float value))addFinishAlphaOffset;

-(YGNavigationBar *(^)(float value))addmMinAlphaValue;

-(YGNavigationBar *(^)(float value))addMaxAlphaValue;

- (void)changeAlphaWithCurrentOffset:(CGFloat)currentOffset;
@end
