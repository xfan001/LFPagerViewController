//
//  LFBarScrollView.m
//  LFPagerViewController
//
//  Created by 黎帆 on 15/10/23.
//  Copyright © 2015年 lifan. All rights reserved.
//


#import "LFBarScrollView.h"

#define self_width self.frame.size.width
#define self_height self.frame.size.height


@interface LFBarScrollView ()

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *widthArray;
@property (nonatomic, strong) NSArray *labelArray;

@property (nonatomic, strong) UIView *slideView;

@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation LFBarScrollView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titleArray andSelected:(NSInteger)selected
{
    if (self = [super initWithFrame:frame]) {
        
        _titleArray = titleArray;
        _selectedIndex = selected;
        
        _titleFont = [UIFont systemFontOfSize:14];
        _barBackgroundColor = [UIColor whiteColor];
        _titleNormalColor = [UIColor blackColor];
        _titleSelectedColor = [UIColor redColor];
        _slideColor = [UIColor redColor];
        _slideHeight = 2;
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bounces = NO;
    
        NSMutableArray *mutableArray = [NSMutableArray new];
        for (int i=0; i<self.titleArray.count; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.text = self.titleArray[i];
            label.tag = i;
            label.userInteractionEnabled = YES;
            [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabel:)]];
            [self addSubview:label];
            
            [mutableArray addObject:label];
        }
        _labelArray = mutableArray;
        
        self.slideView = [[UIView alloc] init];
        [self addSubview:self.slideView];
        
        [self relodViews];
    }
    return self;
}

- (void)relodViews
{
    self.backgroundColor = self.barBackgroundColor;
    
    BOOL isWidthSet;
    if (!self.widthArray || (self.widthArray.count != self.titleArray.count)) {
        isWidthSet = NO;
    }else{
        isWidthSet = YES;
    }
    
    CGFloat x = 0;
    for (int i=0; i<self.titleArray.count; i++){
        UILabel *label = [self.labelArray objectAtIndex:i];
        CGFloat width;
        if (isWidthSet) {
            width = [self.widthArray[i] doubleValue];
        }else{
            width = [self.titleArray[i] sizeWithAttributes:@{NSFontAttributeName : self.titleFont}].width + 30;
        }
        label.frame = CGRectMake(x, 0, width, self.bounds.size.height);
        x += width;
        
        label.textAlignment = NSTextAlignmentCenter;
        label.font = self.titleFont;
        label.textColor = self.titleNormalColor;
        label.backgroundColor = self.backgroundColor;
    }
    
    self.contentSize = CGSizeMake(x, self.bounds.size.height);
    
    CGRect slideFrame = self.slideView.frame;
    slideFrame.size.height = self.slideHeight;
    self.slideView.frame = slideFrame;
    self.slideView.backgroundColor = self.slideColor;
    self.slideView.layer.cornerRadius = 1.0f;
    [self setSelectedIndex:_selectedIndex];
}


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

- (void)transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex withPercent:(double)p
{
    UILabel *fromLabel = self.labelArray[fromIndex];
    UILabel *toLabel = self.labelArray[toIndex];
    fromLabel.textColor = [LFBarScrollView getColorOfPercent:p between:self.titleNormalColor and:self.titleSelectedColor];
    toLabel.textColor = [LFBarScrollView getColorOfPercent:1-p between:self.titleNormalColor and:self.titleSelectedColor];
    
    CGFloat startX1 = CGRectGetMinX(fromLabel.frame);
    CGFloat startX2 = CGRectGetMinX(toLabel.frame);
    CGFloat endX1 = CGRectGetMaxX(fromLabel.frame);
    CGFloat endX2 = CGRectGetMaxX(toLabel.frame);
    
    CGFloat start = startX1 + (startX2 - startX1) * p;
    CGFloat end = endX1 + (endX2 - endX1) * p;
    
    self.slideView.frame = CGRectMake(start, self.slideView.frame.origin.y, end-start, self.slideView.frame.size.height);
}

#pragma mark - private functions

+ (UIColor *)getColorOfPercent:(CGFloat)percent between:(UIColor *)color1 and:(UIColor *)color2{
    CGFloat red1, green1, blue1, alpha1;
    [color1 getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
    
    CGFloat red2, green2, blue2, alpha2;
    [color2 getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];
    
    CGFloat p1 = percent;
    CGFloat p2 = 1.0 - percent;
    UIColor *mid = [UIColor colorWithRed:red1*p1+red2*p2 green:green1*p1+green2*p2 blue:blue1*p1+blue2*p2 alpha:1.0f];
    return mid;
}

#pragma mark - getter and setter

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    UILabel *originLabel = self.labelArray[_selectedIndex];
    originLabel.textColor = self.titleNormalColor;
    
    UILabel *label = self.labelArray[selectedIndex];
    label.textColor = self.titleSelectedColor;
    
    _selectedIndex = selectedIndex;
    
    CGRect frame = label.frame;
    CGFloat textWidth = [self.titleArray[_selectedIndex] sizeWithAttributes:@{NSFontAttributeName : self.titleFont}].width + 2;
    self.slideView.frame = CGRectMake(CGRectGetMidX(frame)-textWidth/2, CGRectGetHeight(self.frame)-self.slideHeight, textWidth, self.slideHeight);
    
    //滚动到中间位置
    CGPoint offset = self.contentOffset;
    CGFloat maxOffset = self.contentSize.width - self_width;
    CGFloat minOffset = 0;
    offset.x = frame.origin.x + frame.size.width/2 - self_width/2;
    offset.x = offset.x > minOffset ? offset.x : minOffset;
    offset.x = offset.x < maxOffset ? offset.x : maxOffset;
    self.contentOffset = offset;
}

- (void)setWidthArray:(NSArray *)widthArray
{
    if ([_widthArray isEqualToArray:widthArray]) {
        return;
    }
    _widthArray = widthArray;
    [self relodViews];
}

- (void)setTitleFont:(UIFont *)titleFont
{
    if ([_titleFont isEqual:titleFont]) {
        return;
    }
    _titleFont = titleFont;
    [self relodViews];
}

- (void)setTitleNormalColor:(UIColor *)titleNormalColor
{
    if ([_titleNormalColor isEqual:titleNormalColor]) {
        return;
    }
    _titleNormalColor = titleNormalColor;
    [self relodViews];
}

- (void)setTitleSelectedColor:(UIColor *)titleSelectedColor
{
    if ([_titleSelectedColor isEqual:titleSelectedColor]) {
        return;
    }
    _titleSelectedColor = titleSelectedColor;
    [self relodViews];
}

- (void)setBarBackgroundColor:(UIColor *)barBackgroundColor
{
    if ([_barBackgroundColor isEqual:barBackgroundColor]) {
        return;
    }
    _barBackgroundColor = barBackgroundColor;
    [self relodViews];
}

- (void)setSlideColor:(UIColor *)slideColor
{
    if ([_slideColor isEqual:slideColor]) {
        return;
    }
    _slideColor = slideColor;
    [self relodViews];
}

- (void)setSlideHeight:(CGFloat)slideHeight
{
    if (_slideHeight == slideHeight) {
        return;
    }
    _slideHeight = slideHeight;
    [self relodViews];
}

@end