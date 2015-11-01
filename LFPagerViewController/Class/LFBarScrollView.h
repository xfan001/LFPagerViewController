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

/**
 *  标题字体大小
 */
@property (nonatomic, strong) UIFont *titleFont;

/**
 *  标题正常状态下的颜色
 */
@property (nonatomic, strong) UIColor *titleNormalColor;

/**
 *  标题被选中时的颜色
 */
@property (nonatomic, strong) UIColor *titleSelectedColor;

/**
 *  顶部bar的背景颜色
 */
@property (nonatomic, strong) UIColor *barBackgroundColor;

/**
 *  滑块颜色
 */
@property (nonatomic, strong) UIColor *slideColor;

/**
 *  滑块高度
 */
@property (nonatomic) CGFloat slideHeight;


- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titleArray andSelected:(NSInteger)selected;

- (void)setWidthArray:(NSArray *)widthArray;

- (void)setSelectedIndex:(NSInteger)selectedIndex;

/*渐变转换*/
- (void)transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex withPercent:(double)p;

@end
