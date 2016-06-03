//
//  UIImageView+GKLBannerAnimation.h
//  GKLMaskViewAnimation
//
//  Created by forms on 16/6/3.
//  Copyright © 2016年 forms. All rights reserved.
//

#import "UIView+GKLFadeAnimation.h"
#define LXDFADEDURATION 2.
/*!
 *  @brief 图片轮播广告页碎片化动画
 */
@interface UIImageView (GKLBannerAnimation)

/*!
 *  @brief 设置后停止动画
 */
@property (nonatomic, assign) BOOL stop;
/*!
 *  @brief 每次切换图片的动画时长1.5~2.5
 */
@property (nonatomic, assign) NSTimeInterval fadeDuration;
/*!
 *  @brief 轮播图片数组
 */
@property (nonatomic, strong) NSArray * bannerImages;

- (void)fadeBanner;
- (void)fadeBannerWithImages: (NSArray *)images;
- (void)stopBanner;
-(void)swipefadeBanner;
@end
