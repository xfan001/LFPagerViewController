//
//  LFPagerViewController.h
//  LFPagerViewController
//
//  Copyright © 2015年 lifan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFBarScrollView.h"

@protocol LFPagerViewControllerDataSource <NSObject>

@required
- (NSInteger)numberOfViewControllers;

- (NSString *)titleAtIndex:(NSInteger)index;

- (UIViewController *)viewControllerAtIndex:(NSInteger)index;

@end


@protocol LFPagerViewControllerDelegate <NSObject>

@optional
- (CGFloat)barHeight;

@end

@interface LFPagerViewController : UIViewController

@property (nonatomic, strong) LFBarScrollView *barView;

@property (nonatomic, weak) id <LFPagerViewControllerDataSource> datasource;
@property (nonatomic, weak) id <LFPagerViewControllerDelegate> delegate;

@property (assign, nonatomic) NSInteger selectedIndex;

@end