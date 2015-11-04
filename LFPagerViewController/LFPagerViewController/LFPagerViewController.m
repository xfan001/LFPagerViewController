//
//  LFPagerViewController.m
//  LFPagerViewController
//
//  Copyright © 2015年 lifan. All rights reserved.
//

#import "LFPagerViewController.h"
#import <objc/runtime.h>

#define self_width self.view.frame.size.width
#define self_height self.view.frame.size.height
#define UNIQUE_INDEX_KEY "LFPagerViewController_Unique_Runtime_Key"

@interface LFPagerViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate, LFBarScrollViewDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;

@end

@implementation LFPagerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
     
    NSMutableArray *titleArray = [[NSMutableArray alloc] init];
    for (int i=0; i<[self.datasource numberOfViewControllers];i++) {
        [titleArray addObject:[self.datasource titleAtIndex:i]];
    }
    self.barView = [[LFBarScrollView alloc] initWithFrame:CGRectMake(0, 0, self_width, [self barViewHeight]) titles:titleArray];
    self.barView.barDelegate = self;
    [self.view addSubview:self.barView];
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    for (UIView *view in [[[self pageViewController] view] subviews]) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView *)view setDelegate:self];
        }
    }
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //set frame
    self.barView.frame = CGRectMake(0, 0, self_width, [self barViewHeight]);
    self.pageViewController.view.frame = CGRectMake(0, CGRectGetMaxY(self.barView.frame), self_width, self_height-CGRectGetHeight(self.barView.frame));
    
    //设置默认的index
    [self.barView setSelectedIndex:_selectedIndex];
    [self.pageViewController setViewControllers:[NSArray arrayWithObject:[self viewControllerOfIndex:_selectedIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

#pragma mark - Page View Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger pageIndex = [objc_getAssociatedObject(viewController, UNIQUE_INDEX_KEY) integerValue];
    return pageIndex > 0 ? [self viewControllerOfIndex:pageIndex-1] : nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger pageIndex = [objc_getAssociatedObject(viewController, UNIQUE_INDEX_KEY) integerValue];
    return pageIndex < [self.datasource numberOfViewControllers]-1 ? [self viewControllerOfIndex:pageIndex+1]: nil;
}

#pragma mark - Page View Delegate

- (void)pageViewController:(UIPageViewController * _Nonnull)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> * _Nonnull)pendingViewControllers
{
    
}

- (void)pageViewController:(UIPageViewController * _Nonnull)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> * _Nonnull)previousViewControllers transitionCompleted:(BOOL)completed
{

}

#pragma mark - UIscrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger page = [objc_getAssociatedObject([self.pageViewController.viewControllers firstObject], UNIQUE_INDEX_KEY) integerValue];
    if (_selectedIndex != page) {
        _selectedIndex = page;
        [UIView animateWithDuration:0.2 animations:^{
            [self.barView setSelectedIndex:_selectedIndex];
        }];
    }
}

#pragma mark - private methods

- (void)didClickBarAtIndex:(NSInteger)index
{
    [self.pageViewController setViewControllers:[NSArray arrayWithObject:[self viewControllerOfIndex:index]]
                                      direction:(index > [self selectedIndex]) ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse
                                       animated:YES
                                     completion:nil];
}


- (UIViewController *)viewControllerOfIndex:(NSInteger)index
{
    UIViewController *vc = [self.datasource viewControllerAtIndex:index];
    objc_setAssociatedObject(vc, UNIQUE_INDEX_KEY, [NSNumber numberWithInteger:index], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return vc;
}

- (CGFloat)barViewHeight
{
    if (self.datasource && [self.datasource respondsToSelector:@selector(barHeight)]) {
        return [self.delegate barHeight];
    }
    return 36.0f;
}

#pragma mark - getter and setter


@end
