//
//  ViewController.m
//  LFPagerViewController
//
//  Created by 黎帆 on 15/10/23.
//  Copyright © 2015年 lifan. All rights reserved.
//

#import "ViewController.h"
#define mainScreenWidth ([UIScreen mainScreen].bounds.size.width)

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    /*
    self.barView.titleFont = [UIFont systemFontOfSize:15];
    self.barView.titleNormalColor = [UIColor lightGrayColor];
    self.barView.titleSelectedColor = [UIColor orangeColor];
    self.barView.slideColor = [UIColor redColor];
    self.barView.slideHeight = 4;
    [self.barView setSlideLength:LFBarSlideLengthFit];
    NSMutableArray *widthArray = [NSMutableArray new];
    for (int i=0; i<[self numberOfViewControllers]; i++) {
        [widthArray addObject:@(mainScreenWidth/3)];
    }
    [self.barView setWidthArray:widthArray];
    [self setSelectedIndex:1];
     */
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}


- (NSInteger)numberOfViewControllers
{
    return 20;
}

- (CGFloat)barHeight
{
    return 36;
}

- (NSString *)titleAtIndex:(NSInteger)index
{
    return [NSString stringWithFormat:@"测试%ld", (long)index];
}

- (UIViewController *)viewControllerAtIndex:(NSInteger)index
{
    UIViewController *vc = [[UIViewController alloc] init];
    NSArray *colors = @[[UIColor blueColor], [UIColor grayColor], [UIColor greenColor], [UIColor purpleColor], [UIColor orangeColor], [UIColor whiteColor], [UIColor redColor]];
    vc.view.backgroundColor = [colors objectAtIndex:index%colors.count];
    return vc;
}


@end
