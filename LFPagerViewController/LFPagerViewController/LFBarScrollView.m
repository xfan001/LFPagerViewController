//
//  LFBarScrollView.m
//  LFPagerViewController
//
//  Copyright © 2015年 lifan. All rights reserved.
//


#import "LFBarScrollView.h"

#define self_width self.frame.size.width
#define self_height self.frame.size.height


@interface LFBarScrollView ()

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *widthArray;

@property (nonatomic, strong) NSArray *labelArray;

@property (nonatomic, strong) UIView *slideView;

@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation LFBarScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _titleFont = [UIFont systemFontOfSize:14];
        _titleNormalColor = [UIColor blackColor];
        _titleSelectedColor = [UIColor redColor];
        _slideColor = [UIColor redColor];
        _slideHeight = 2;
        
        self.slideView = [[UIView alloc] init];
        [self addSubview:self.slideView];
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bounces = NO;
    }
    return self;
}

- (void)reloadViews
{
    CGFloat x = 0;
    for (int i=0; i<self.labelArray.count; i++){
        UILabel *label = [self.labelArray objectAtIndex:i];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.font = self.titleFont;
        label.textColor = self.titleNormalColor;
        label.highlightedTextColor = self.titleSelectedColor;
        
        CGFloat width;
        if (self.widthArray && i < self.widthArray.count) {
            width = [self.widthArray[i] doubleValue];
        }else{
            width = [label.text sizeWithAttributes:@{NSFontAttributeName:self.titleFont}].width + 20;
        }
        label.frame = CGRectMake(x, 0, width, self.bounds.size.height);
        x += width;
    }
    self.contentSize = CGSizeMake(x, self.bounds.size.height);
    
    self.slideView.backgroundColor = self.slideColor;
    [self bringSubviewToFront:self.slideView];
    
    [self setSelectedIndex:_selectedIndex];
}

#pragma mark - API

/**
 *  标题颜色随着位移比例渐变
 *
 *  @param offsetRatio 位移比例, 比如1.2,则前一个index是1,下一个index是2, 相对比例为0.2
 */
- (void)titleColorTransitionByPercent:(double)offsetRatio
{
    NSInteger nextIndex = ceil(offsetRatio);
    NSInteger previousIndex = floor(offsetRatio);
    UILabel *nextLabel = self.labelArray[nextIndex];
    UILabel *previousLabel = self.labelArray[previousIndex];
    
    previousLabel.textColor = [self getColorOfPercent:1-(offsetRatio-previousIndex) between:self.titleNormalColor and:self.titleSelectedColor];
    nextLabel.textColor = [self getColorOfPercent:1-(nextIndex-offsetRatio) between:self.titleNormalColor and:self.titleSelectedColor];
}

/**
 *  滑块位置随着位移比例渐变
 *
 *  @param offsetRatio 同上
 */
- (void)slideTransitionByPercent:(double)offsetRatio
{
    NSInteger nextIndex = ceil(offsetRatio);
    NSInteger previousIndex = floor(offsetRatio);
    UILabel *nextLabel = self.labelArray[nextIndex];
    UILabel *previousLabel = self.labelArray[previousIndex];
    
    CGFloat pStart = CGRectGetMinX(previousLabel.frame);
    CGFloat pEnd = CGRectGetMaxX(previousLabel.frame);
    CGFloat nStart = CGRectGetMinX(nextLabel.frame);
    CGFloat nEnd = CGRectGetMaxX(nextLabel.frame);
    
    CGFloat start = pStart + (offsetRatio-previousIndex) * (pEnd-pStart);
    CGFloat end = nEnd - (nextIndex-offsetRatio) * (nEnd-nStart);
    self.slideView.frame = CGRectMake(start, self.slideView.frame.origin.y, end-start, self.slideView.frame.size.height);
}

/**
 *  使选中的label滑到中间
 */
- (void)scrollToVisible
{
    CGRect frame = [(UILabel *)[self.labelArray objectAtIndex:_selectedIndex] frame];
    
    CGPoint offset = self.contentOffset;
    CGFloat maxOffset = self.contentSize.width - self_width;
    CGFloat minOffset = 0;
    offset.x = frame.origin.x + frame.size.width/2 - self_width/2;
    offset.x = offset.x > minOffset ? offset.x : minOffset;
    offset.x = offset.x < maxOffset ? offset.x : maxOffset;
    self.contentOffset = offset;
}



#pragma mark - private functions

- (UIColor *)getColorOfPercent:(CGFloat)percent between:(UIColor *)color1 and:(UIColor *)color2{
    CGFloat red1, green1, blue1, alpha1;
    [color1 getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
    
    CGFloat red2, green2, blue2, alpha2;
    [color2 getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];
    
    CGFloat p1 = 1.0 - percent;
    CGFloat p2 = percent;
    UIColor *mid = [UIColor colorWithRed:red1*p1+red2*p2 green:green1*p1+green2*p2 blue:blue1*p1+blue2*p2 alpha:1.0f];
    return mid;
}

#pragma mark - selectors

- (void)tapLabel:(id)sender
{
    UILabel *label = (UILabel *)[sender view];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.selectedIndex = label.tag;
    }];
    if ([self.barDelegate respondsToSelector:@selector(didClickBarAtIndex:)]) {
        [self.barDelegate didClickBarAtIndex:label.tag];
    }
}

#pragma mark - getter and setter

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    
    for (int i=0; i<self.labelArray.count; i++) {
        [(UILabel *)self.labelArray[i] setHighlighted:(_selectedIndex==i)];
    }
    
    UILabel *label = self.labelArray[_selectedIndex];
    CGRect labelFrame = [label frame];
    CGFloat width;
    if (self.slideLength == LFBarSlideLengthFull) {
        width = CGRectGetWidth(labelFrame);
    }else{
        width = [label.text sizeWithAttributes:@{NSFontAttributeName : self.titleFont}].width;
    }
    self.slideView.frame = CGRectMake(CGRectGetMidX(labelFrame)-width/2, CGRectGetHeight(self.bounds)-self.slideHeight, width, self.slideHeight);
    
    [self scrollToVisible];
}



- (void)setTitles:(NSArray *)titles
{
    if ([_titles isEqualToArray:titles]) {
        return;
    }
    _titles = titles;
    
    for (UILabel *view in _labelArray) {
        [view removeFromSuperview];
    }
    
    NSMutableArray *labels = [NSMutableArray arrayWithCapacity:titles.count];
    for (int i=0; i<titles.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.text = titles[i];
        
        label.tag = i;
        label.userInteractionEnabled = YES;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabel:)]];
        [self addSubview:label];
        [labels addObject:label];
    }
    _labelArray = labels;

    [self reloadViews];
}

- (void)setWidthArray:(NSArray *)widthArray
{
    if ([_widthArray isEqualToArray:widthArray]) {
        return;
    }
    _widthArray = widthArray;
    [self reloadViews];
}

- (void)setTitleFont:(UIFont *)titleFont
{
    if ([_titleFont isEqual:titleFont]) {
        return;
    }
    _titleFont = titleFont;
    [self reloadViews];
}

- (void)setTitleNormalColor:(UIColor *)titleNormalColor
{
    if ([_titleNormalColor isEqual:titleNormalColor]) {
        return;
    }
    _titleNormalColor = titleNormalColor;
    [self reloadViews];
}

- (void)setTitleSelectedColor:(UIColor *)titleSelectedColor
{
    if ([_titleSelectedColor isEqual:titleSelectedColor]) {
        return;
    }
    _titleSelectedColor = titleSelectedColor;
    [self reloadViews];
}

- (void)setSlideColor:(UIColor *)slideColor
{
    if ([_slideColor isEqual:slideColor]) {
        return;
    }
    _slideColor = slideColor;
    [self reloadViews];
}

- (void)setSlideHeight:(CGFloat)slideHeight
{
    if (_slideHeight == slideHeight) {
        return;
    }
    _slideHeight = slideHeight;
    [self reloadViews];
}

- (void)setSlideLength:(LFBarSlideLength)slideLength
{
    if (_slideLength == slideLength) {
        return;
    }
    _slideLength = slideLength;
    [self reloadViews];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self reloadViews];
}

@end
