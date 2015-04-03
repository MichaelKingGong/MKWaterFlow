## MKWaterFlow
这是一个很实用的瀑布流控件。

它也提供了很多接口，使得自定义程度更高，更方便。可以自定义列数，自定义间距，自定义cell的个数等很多可定制化东西。

它的是实现是通过模仿UITableView的底层来做。

使用此框架，不仅可以是实现想要的瀑布流效果，还可以加深对苹果自带的UITableView的理解，包括如何循环利用cell，如何计算cell的位置等。
##如何使用

* 将MKWaterFlow文件夹下的所有文件拖入到您的项目

* 导入主头文件  `#import "MKWaterFlow.h"`
* 创建控件，遵守协议，设置代理，再实现必要的方法即可


##使用细节

###遵守协议

```objc

@interface MKClothesController () <MKWaterFlowViewDelegate,MKWaterFlowViewDataSource>

```
###创建控件，设置代理

```objc

    MKWaterFlowView * waterFlow = [[MKWaterFlowView alloc] init];
    waterFlow.frame = self.view.bounds;
    waterFlow.delegate = self;
    waterFlow.dataSource = self;
    self.waterFlow = waterFlow;
    [self.view addSubview:waterFlow];

```
###实现必要的方法
```objc
cell的个数

   - (NSUInteger)numberOfCellsInWaterFlow:(MKWaterFlowView *)waterFlow
{
    return 10;
}

index处cell的样式
- (MKWaterFlowViewCell *)waterFlow:(MKWaterFlowView *)waterFlow cellAtIndex:(NSUInteger)index
{
    static NSString * ID = @"cell";
    
    MKWaterFlowViewCell * cell = [waterFlow dequeueReusableCellWithIdentifier    :ID];
    if (cell == nil) {
        cell = [[MKWaterFlowViewCell alloc] init];
        cell.reuseIdentifer = ID;
        cell.backgroundColor = MKRandomColor;
    }
    return cell;
}

```

###根据需要，实现可选方法
```objc
cell的高度
   - (CGFloat)waterFlow:(MKWaterFlowView *)waterFlow heightAtIndex:(NSUInteger)index
{
    return 50 + arc4random_uniform(100);
}

瀑布流的列数
- (NSUInteger)columnCountInWaterFlow:(MKWaterFlowView *)waterFlow
{
    return 2;
}

 间距的设置
- (CGFloat)waterFlow:(MKWaterFlowView *)waterFlow marginWithType:(MKWaterFlowMarginType)type
{
    switch (type) {
        case MKWaterFlowMarginTypeTop:
        case MKWaterFlowMarginTypeBottom:
        case MKWaterFlowMarginTypeLeft:
        case MKWaterFlowMarginTypeRight:
            return 10;
        case MKWaterFlowMarginTypeRow : return 10;
        default: return 10;
    }
}

 监听ell的点击事件
- (void)waterFlow:(MKWaterFlowView *)waterFlow didSelectCellAtIndexIndex:(NSUInteger)index
{
    NSLog(@"点击了第%zd个cell",index);
}
```

