//
//  ViewController.m
//  GKLMaskViewAnimation
//
//  Created by forms on 16/6/3.
//  Copyright © 2016年 forms. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+GKLBannerAnimation.h"
@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self bannerFadeAnimate];
    // Do any additional setup after loading the view, typically from a nib.
}

/*!
 *  @brief 广告页轮播效果
 */
- (void)bannerFadeAnimate
{
    NSMutableArray * images = @[].mutableCopy;
    for (NSInteger idx = 1; idx < 5; idx++) {
        [images addObject: [NSString stringWithFormat: @"banner%lu", idx]];
    }
    [_bannerImageview fadeBannerWithImages: images];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
