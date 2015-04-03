//
//  MKWaterFlowController.m
//  瀑布流
//
//  Created by wangqinggong on 15/4/2.
//  Copyright (c) 2015年 Michael King. All rights reserved.
//

#import "MKClothesController.h"
#import "MKWaterFlowViewCell.h"
#import "MKWaterFlowView.h"

// 定义颜色
#define MKColor(r,g,b) [UIColor colorWithRed:(r) green:(g) blue:(b) alpha:1]
#define MKRandomColor MKColor(arc4random_uniform(255)/255.0, arc4random_uniform(255)/255.0, arc4random_uniform(255)/255.0)
;
@interface MKClothesController () <MKWaterFlowViewDelegate,MKWaterFlowViewDataSource>

@property (nonatomic,strong) MKWaterFlowView * waterFlow;

@end

@implementation MKClothesController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // 创建MKWaterFlowView
    MKWaterFlowView * waterFlow = [[MKWaterFlowView alloc] init];
    waterFlow.frame = self.view.bounds;
    waterFlow.delegate = self;
    waterFlow.dataSource = self;
    self.waterFlow = waterFlow;
    [self.view addSubview:waterFlow];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 数据源方法
// cell的个数
- (NSUInteger)numberOfCellsInWaterFlow:(MKWaterFlowView *)waterFlow
{
    return 90;
}

// index位置cell的样式
- (MKWaterFlowViewCell *)waterFlow:(MKWaterFlowView *)waterFlow cellAtIndex:(NSUInteger)index
{
    static NSString * ID = @"cell";
    
    MKWaterFlowViewCell * cell = [waterFlow dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MKWaterFlowViewCell alloc] init];
        cell.reuseIdentifer = ID;
        cell.backgroundColor = MKRandomColor;
    }
    return cell;
}

#pragma mark - 代理方法
// cell的高度
- (CGFloat)waterFlow:(MKWaterFlowView *)waterFlow heightAtIndex:(NSUInteger)index
{
    return 50 + arc4random_uniform(100);
}
// cell的点击事件
- (void)waterFlow:(MKWaterFlowView *)waterFlow didSelectCellAtIndexIndex:(NSUInteger)index
{
    NSLog(@"点击了第%zd个cell",index);
}
// 间距的设置
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
@end
