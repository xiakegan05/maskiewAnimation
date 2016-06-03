//
//  UIImageView+GKLBannerAnimation.m
//  GKLMaskViewAnimation
//
//  Created by forms on 16/6/3.
//  Copyright © 2016年 forms. All rights reserved.
//

#import "UIImageView+GKLBannerAnimation.h"
#import <objc/runtime.h>

const void * kCompleteBlockKey = &kCompleteBlockKey;
const void * kBannerImagesKey = &kBannerImagesKey;
const void * kPageControlKey = &kPageControlKey;
const void * kTempImageKey = &kTempImageKey;
const void * kStopKey = &kStopKey;

@implementation UIImageView (GKLBannerAnimation)

- (BOOL)stop
{
    return [objc_getAssociatedObject(self, kStopKey) boolValue];
}

- (NSTimeInterval)fadeDuration
{
    if (self.bannerImages.count < 2) { return 0; }
    return (self.verticalCount * self.horizontalCount + 3) * self.intervalDuration;
}

- (void)setFadeDuration: (NSTimeInterval)fadeDuration
{
    if (self.bannerImages.count > 1) {
        fadeDuration = MIN(2.5, MAX(1.5, fadeDuration));
        self.fadeAnimationDuration = fadeDuration / (self.bannerImages.count + 3) / LXDMULTIPLED;
        self.intervalDuration = self.fadeAnimationDuration * LXDMULTIPLED;
    }
}

- (NSArray *)bannerImages
{
    return objc_getAssociatedObject(self, kBannerImagesKey);
}

- (void)setStop: (BOOL)stop
{
    objc_setAssociatedObject(self, kStopKey, @(stop), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setBannerImages: (NSArray *)bannerImages
{
    objc_setAssociatedObject(self, kBannerImagesKey, bannerImages, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)fadeBanner
{
    NSParameterAssert(self.superview);
    self.image = [UIImage imageNamed: self.bannerImages.firstObject];
    if (self.bannerImages.count < 2) {
        return;
    }
    
    // 此处创建了一张底部试图
    UIImageView * tempBanner = [self associateTempBannerWithImage: [UIImage imageNamed: self.bannerImages[1]]];
    self.stop = NO;
    
    __block  NSInteger idx = 0;
    __weak typeof(self) weakSelf = self;
    [self associatePageControlWithCurrentIdx: 0];
    
    void (^complete)() = ^{
        //完成后实现更新图片
        sleep(2);
        
        NSInteger updateIndex = [weakSelf updateImageWithCurrentIndex: ++idx tempBanner: tempBanner];
        idx = updateIndex;
        [weakSelf associatePageControlWithCurrentIdx: idx];
        
    };
    
    
    objc_setAssociatedObject(self, kCompleteBlockKey, complete, OBJC_ASSOCIATION_COPY_NONATOMIC);
    　// 执行褪色动画
    [self animateFadeWithComplete: ^{
        if (!self.stop) {
            
            complete();
        }
    }];
}

-(void)swipefadeBanner{
    
    void (^complete)() = objc_getAssociatedObject(self, kCompleteBlockKey);
    
    [self animateFadeWithComplete: ^{
        
        complete();
        
    }];
    
}
// 显示当前下标圆点
- (void)associatePageControlWithCurrentIdx: (NSInteger)idx
{
    UIPageControl * pageControl = objc_getAssociatedObject(self, kPageControlKey);
    if (!pageControl) {
        pageControl = [[UIPageControl alloc] initWithFrame: CGRectMake(self.frame.origin.x, CGRectGetHeight(self.frame) - 37 + self.frame.origin.y, CGRectGetWidth(self.frame), 37)];
        [self.superview addSubview: pageControl];
        
        pageControl.numberOfPages = self.bannerImages.count;
        objc_setAssociatedObject(self, kPageControlKey, pageControl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    pageControl.currentPage = idx;
}
// 插入一张图片到底部
- (UIImageView *)associateTempBannerWithImage: (UIImage *)image
{
    UIImageView * tempBanner = objc_getAssociatedObject(self, kTempImageKey);
    if (!tempBanner) {
        tempBanner = [[UIImageView alloc] initWithFrame: self.frame];
        objc_setAssociatedObject(self, kTempImageKey, tempBanner, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self.superview insertSubview: tempBanner belowSubview: self];
    }
    tempBanner.image = image;
    return tempBanner;
}

// 让本试图图片变成＋＋idx，填充底部图片，并且返回当前下标
- (NSInteger)updateImageWithCurrentIndex: (NSInteger)idx tempBanner: (UIImageView *)tempBanner
{
    if (idx >= self.bannerImages.count) { idx = 0; }
    self.image = [UIImage imageNamed: self.bannerImages[idx]];
    [self reverseWithoutAnimate];
    NSInteger nextIdx = idx + 1;
    if (nextIdx >= self.bannerImages.count) { nextIdx = 0; }
    tempBanner.image = [UIImage imageNamed: self.bannerImages[nextIdx]];
    [self animateFadeWithComplete: ^{
        if (!self.stop) {
            void (^complete)() = objc_getAssociatedObject(self, kCompleteBlockKey);
            complete();
        } else {
            [objc_getAssociatedObject(self, kTempImageKey) removeFromSuperview];
            [objc_getAssociatedObject(self, kPageControlKey) removeFromSuperview];
            objc_setAssociatedObject(self, kTempImageKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            objc_setAssociatedObject(self, kPageControlKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }];
    return idx;
}

- (void)fadeBannerWithImages: (NSArray *)images
{
    self.bannerImages = images;
    [self fadeBanner];
    
}

- (void)stopBanner
{
    self.stop = YES;
}


@end
