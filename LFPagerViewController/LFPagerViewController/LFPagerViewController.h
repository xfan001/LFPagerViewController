//
//  LFPagerViewController.h
//  LFPagerViewController
//
//  Copyright © 2015年 lifan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFBarScrollView.h"


@interface LFPagerViewController : UIViewController

@property (nonatomic, strong) LFBarScrollView *barView;

@property (assign, nonatomic) NSInteger selectedIndex;

- (CGFloat)barHeight;
- (NSInteger)numberOfViewControllers;
- (NSString *)titleAtIndex:(NSInteger)index;
- (UIViewController *)viewControllerAtIndex:(NSInteger)index;

@end