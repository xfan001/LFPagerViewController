//
//  ViewController.m
//  LFPagerViewController
//
//  Created by 黎帆 on 15/10/23.
//  Copyright © 2015年 lifan. All rights reserved.
//

#import "ViewController.h"
#define mainScreenWidth ([UIScreen mainScreen].bounds.size.width)

@interface ViewController () <LFPagerViewControllerDataSource>

@end

@implementation ViewController

- (instancetype)init{
    if (self  =[super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    self.datasource = self;
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.barView setWidthArray:@[[NSNumber numberWithFloat:mainScreenWidth/2], [NSNumber numberWithFloat:mainScreenWidth/2]]];
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

- (NSInteger)numberOfViewControllers
{
    return 2;
}

@end
