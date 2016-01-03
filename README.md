# LFPagerViewController

利用UIPageViewController实现左右滑动子视图

![image](http://ww4.sinaimg.cn/large/907e8112jw1ezmjoap8l4g208s0gcdia.gif)

#使用方法

直接继承LFPagerViewController并override以下几个方法:
* - (NSInteger)numberOfViewControllers;
* - (NSString *)titleAtIndex:(NSInteger)index;
* - (UIViewController *)viewControllerAtIndex:(NSInteger)index;
* - (CGFloat)barHeight;

#自定义BarView外观
```
    self.barView.titleFont = [UIFont systemFontOfSize:15]; //标题字体大小
    self.barView.titleNormalColor = [UIColor lightGrayColor];  //标题正常颜色
    self.barView.titleSelectedColor = [UIColor orangeColor];  //标题选中时的颜色
    self.barView.slideColor = [UIColor redColor];  //下方滑块颜色
    self.barView.slideHeight = 4;  //下方滑块高度
    [self.barView setSlideLength:LFBarSlideLengthFit]; //滑块排列样式
    NSMutableArray *widthArray = [NSMutableArray new];  //设置标题宽度
    for (int i=0; i<[self numberOfViewControllers]; i++) {
        [widthArray addObject:@(mainScreenWidth/3)];
    }
    [self.barView setWidthArray:widthArray];
```
