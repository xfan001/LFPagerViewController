//
//  LFBarScrollView.h
//  LFPagerViewController
//
//  Created by 黎帆 on 15/10/23.
//  Copyright © 2015年 lifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LFBarScrollViewDelegate <NSObject>

- (void)didClickBarAtIndex:(NSInteger)index;

@end

@interface LFBarScrollView : UIScrollView

@property (nonatomic, weak) id<LFBarScrollViewDelegate> barDelegate;

@property (nonatomic, strong) UIFont *titleFont;

@property (nonatomic, strong) UIColor *titleNormalColor;

@property (nonatomic, strong) UIColor *titleSelectedColor;

@property (nonatomic, strong) UIColor *barBackgroundColor;

@property (nonatomic, strong) UIColor *slideColor;

@property (nonatomic) CGFloat slideHeight;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titleArray widthArray:(NSArray *)widthArray andSelected:(NSInteger)selected;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titleArray andSelected:(NSInteger)selected;

- (void)setWidthArray:(NSArray *)widthArray;

- (void)setSelectedIndex:(NSInteger)selectedIndex;

//- (void)transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex withPercent:(double)p;

@end
