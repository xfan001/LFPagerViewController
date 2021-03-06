//
//  LFBarScrollView.h
//  LFPagerViewController
//
//  Copyright © 2015年 lifan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LFBarSlideLength) {
    LFBarSlideLengthFull,
    LFBarSlideLengthFit
};


@protocol LFBarScrollViewDelegate <NSObject>

- (void)didClickBarAtIndex:(NSInteger)index;

@end


@interface LFBarScrollView : UIScrollView

@property (nonatomic, weak) id<LFBarScrollViewDelegate> barDelegate;

/**
 *  自定义外观属性
 */
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleNormalColor;
@property (nonatomic, strong) UIColor *titleSelectedColor;
@property (nonatomic, strong) UIColor *slideColor;
@property (nonatomic) CGFloat slideHeight;
@property (nonatomic) LFBarSlideLength slideLength;

//必需设置
- (void)setTitles:(NSArray *)titles;

- (void)setWidthArray:(NSArray *)widthArray;

- (void)setSelectedIndex:(NSInteger)selectedIndex;

/*渐变转换*/
//- (void)titleColorTransitionByPercent:(double)offsetRatio;

//- (void)slideTransitionByPercent:(double)offsetRatio;

//- (void)scrollToVisible;

@end
