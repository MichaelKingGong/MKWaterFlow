//
//  MKWaterFlowView.h
//  瀑布流
//
//  Created by wangqinggong on 15/4/2.
//  Copyright (c) 2015年 Michael King. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKWaterFlowViewCell.h"

@class MKWaterFlowView;

// 间距枚举的定义
typedef enum
{
    MKWaterFlowMarginTypeTop,
    MKWaterFlowMarginTypeBottom,
    MKWaterFlowMarginTypeLeft,
    MKWaterFlowMarginTypeRight,
    MKWaterFlowMarginTypeColumn,
    MKWaterFlowMarginTypeRow
} MKWaterFlowMarginType;

// 定义数据源协议
@protocol MKWaterFlowViewDataSource <NSObject>
@required
/**
 *  返回cell的个数
 */
- (NSUInteger)numberOfCellsInWaterFlow:(MKWaterFlowView *)waterFlow;
/**
 *  返回index位置对应的cell
 */
- (MKWaterFlowViewCell *)waterFlow:(MKWaterFlowView *)waterFlow cellAtIndex:(NSUInteger )index;
@optional
/**
 *  返回列数
 */
- (NSUInteger)columnCountInWaterFlow:(MKWaterFlowView *)waterFlow;

@end

// 定义代理协议
@protocol MKWaterFlowViewDelegate <UIScrollViewDelegate>
@optional
/**
 *  返回cell的高度
 */
- (CGFloat)waterFlow:(MKWaterFlowView *)waterFlow heightAtIndex:(NSUInteger)index;
/**
 *  监听cell的点击事件
 */
- (void)waterFlow:(MKWaterFlowView *)waterFlow didSelectCellAtIndexIndex:(NSUInteger)index;
/**
 *  设置各个间距
 */
- (CGFloat)waterFlow:(MKWaterFlowView *)waterFlow marginWithType:(MKWaterFlowMarginType)type;

@end

@interface MKWaterFlowView : UIScrollView

// 定义数据源
@property (nonatomic,weak) id <MKWaterFlowViewDataSource> dataSource;

// 定义代理属性
@property (nonatomic,weak) id <MKWaterFlowViewDelegate> delegate;
/**
 *  刷新数据，重新调用数据源方法
 */
- (void)reloadData;
/**
 *  去缓冲池中取可重用的cell
 */
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;
/**
 *  每一列的宽度
 */
- (CGFloat)cellWidth;

@end
