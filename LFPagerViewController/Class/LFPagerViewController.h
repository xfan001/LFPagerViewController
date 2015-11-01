//
//  LFPagerViewController.h
//  LFPagerViewController
//
//  Created by 黎帆 on 15/10/24.
//  Copyright © 2015年 lifan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFBarScrollView.h"

@protocol LFPagerViewControllerDataSource <NSObject>

@required
- (NSInteger)numberOfViewControllers;

- (NSString *)titleAtIndex:(NSInteger)index;

- (UIViewController *)viewControllerAtIndex:(NSInteger)index;

@optional
- (CGFloat)barHeight;

@end

@interface LFPagerViewController : UIViewController

@property (nonatomic, strong) LFBarScrollView *barView;

@property (nonatomic, weak) id <LFPagerViewControllerDataSource> datasource;

@property (assign, nonatomic) NSInteger selectedIndex;

@end
