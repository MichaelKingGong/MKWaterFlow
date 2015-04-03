//
//  MKWaterFlowView.m
//  瀑布流
//
//  Created by wangqinggong on 15/4/2.
//  Copyright (c) 2015年 Michael King. All rights reserved.
//

#import "MKWaterFlowView.h"

#define MKWaterFlowDefaultCellHeight 44
#define MKWaterFlowDefaultMargin 8
#define MKWaterFlowDefaultCountOfColumn 3


@interface MKWaterFlowView ()
/**
 *  存放所有cell的frame
 */
@property (nonatomic,strong) NSMutableArray * cellFrames;

/**
 *  已经显示的cell
 */
@property (nonatomic,strong) NSMutableDictionary * displayingCell;

/**
 *  可重用的cell
 */
@property (nonatomic,strong) NSMutableSet * reusableCell;

@end

@implementation MKWaterFlowView

#pragma mark - lazy load
- (NSMutableArray *)cellFrames
{
    if (_cellFrames == nil)
    {
        _cellFrames = [[NSMutableArray alloc] init];
    }
    return _cellFrames;
}

- (NSMutableDictionary *)displayingCell
{
    if (_displayingCell == nil)
    {
        _displayingCell = [NSMutableDictionary dictionary];
    }
    return _displayingCell;
}

- (NSMutableSet *)reusableCell
{
    if (_reusableCell == nil)
    {
        _reusableCell = [NSMutableSet set];
    }
    return _reusableCell;
}

#pragma mark - public interface



- (CGFloat)cellWidth
{
    // 总列数
    NSUInteger numberOfColumns = [self countOfColumn];
    CGFloat leftM = [self marginInWaterFlowWitharginType:MKWaterFlowMarginTypeLeft];
    CGFloat rigthM = [self marginInWaterFlowWitharginType:MKWaterFlowMarginTypeRight];
    CGFloat columnM = [self marginInWaterFlowWitharginType:MKWaterFlowMarginTypeColumn];
    return (self.bounds.size.width - leftM - rigthM - (numberOfColumns - 1) * columnM) / numberOfColumns;
}

// 刷新数据方法
- (void)reloadData{
    
    // 移除正在显示的cell
    [self.displayingCell.allValues makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 清除之前的数据
    [self.cellFrames removeAllObjects];
    [self.displayingCell removeAllObjects];
    [self.reusableCell removeAllObjects];
    
    // 得到cell的个数
    NSUInteger countOfCell = [self.dataSource numberOfCellsInWaterFlow:self];
    
    CGFloat topM = [self marginInWaterFlowWitharginType:MKWaterFlowMarginTypeTop];
    
    // 使用C语言的数组存放每列的最大y值
    CGFloat maxYOfEachColumn[[self countOfColumn]];
    for (int i = 0;i < [self countOfColumn];i++)
    {
        maxYOfEachColumn[i] = topM;
    }
    
    // 计算每个cell的frame
    CGFloat cellH = 0;
    // (屏幕的宽度- 左右间距 - countOfCell * 列之间的间距) / countOfCell
    
    CGFloat bottomM = [self marginInWaterFlowWitharginType:MKWaterFlowMarginTypeBottom];
    CGFloat leftM = [self marginInWaterFlowWitharginType:MKWaterFlowMarginTypeLeft];
    CGFloat rigthM = [self marginInWaterFlowWitharginType:MKWaterFlowMarginTypeRight];

    CGFloat columnM = [self marginInWaterFlowWitharginType:MKWaterFlowMarginTypeColumn];
    CGFloat rowM = [self marginInWaterFlowWitharginType:MKWaterFlowMarginTypeRow];
    
    // cell的宽度
    CGFloat cellW = (self.frame.size.width - rigthM - leftM - ([self countOfColumn] - 1) * columnM) / [self countOfColumn];
    
    for (int i = 0; i < countOfCell; i++) {
       // MKWaterFlowViewCell * cell = [self.dataSource waterFlow:self cellAtIndex:i];
        
        // 计算cell的frame
         // cell的高度
        cellH = [self cellHeightAtIndex:i];
        
        NSUInteger minYOfIndex = 0;
        CGFloat minY = maxYOfEachColumn[minYOfIndex];
        for (int j = 1; j < [self countOfColumn]; j++) {
            
            if (minY > maxYOfEachColumn[j]) {
                minY = maxYOfEachColumn[j];
                minYOfIndex = j;
            }
        }
        CGFloat cellX = leftM + (cellW + columnM) * minYOfIndex;
        CGFloat cellY = minY;
        CGRect cellFrame = CGRectMake(cellX, cellY, cellW, cellH);
        [self.cellFrames addObject:[NSValue valueWithCGRect:cellFrame]];
        
        // 更新数组
        maxYOfEachColumn[minYOfIndex] = CGRectGetMaxY(cellFrame) + rowM;
        // 显示cell
        // MKWaterFlowViewCell * cell = [self.dataSource waterFlow:self cellAtIndex:i];
       // cell.frame = [self.cellFrames[i] CGRectValue];
      // [self addSubview:cell];
    }
    
    // 设置contentSize
    CGFloat maxY = maxYOfEachColumn[0];
    for (int j = 1; j < [self countOfColumn]; j++) {
        
        if (maxY < maxYOfEachColumn[j]) {
            maxY = maxYOfEachColumn[j];
        }
    }
    self.contentSize = CGSizeMake(0, maxY);
   
}

// 在缓冲池中取出可以重用的cell
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
     __block MKWaterFlowViewCell * reusableCell = nil;
    [self.reusableCell enumerateObjectsUsingBlock:^(MKWaterFlowViewCell * cellFromSet, BOOL *stop) {
        if ([cellFromSet.reuseIdentifer isEqualToString:identifier])
        {
            reusableCell = cellFromSet;
            *stop = YES;
        }
    }];
    
    // 从缓冲池中移除
    if (reusableCell) {
        [self.reusableCell removeObject:reusableCell];
    }
    
    return reusableCell;
}

#pragma mark - private interface

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [self reloadData];
}

// scrollView滚动时就会调用这个方法
- (void)layoutSubviews
{
   
    [super layoutSubviews];
    
    // NSLog(@"%zd",self.subviews.count);

    for (int i = 0; i < [self.dataSource numberOfCellsInWaterFlow:self]; i++) {
        // 优先从字典中取出cell
        MKWaterFlowViewCell * cell = self.displayingCell[@(i)];
        if ([self isAtScreenWithIndex:i]) { // 在屏幕上
            if (cell == nil){
              // 从数据源索取
              cell = [self.dataSource waterFlow:self cellAtIndex:i];
              cell.frame = [self.cellFrames[i] CGRectValue];
              [self addSubview:cell];
                
             // 将cell添加到字典
                self.displayingCell[@(i)] = cell;
            }
           
        }else // 不在屏幕上
        {
            if (cell){
            // 从self中移除
            [cell removeFromSuperview];
            // 从字典中移除
            [self.displayingCell removeObjectForKey:@(i)];
            
            // 添加到缓冲池
            [self.reusableCell addObject:cell];
            }
        }
    }
}

- (BOOL)isAtScreenWithIndex:(NSUInteger)index
{
    
    return CGRectGetMaxY([self.cellFrames[index] CGRectValue]) > self.contentOffset.y && CGRectGetMinY([self.cellFrames[index] CGRectValue]) < self.contentOffset.y + self.frame.size.height;
    
}

// cell的高度
- (CGFloat)cellHeightAtIndex:(NSUInteger)index
{
    if ([self.delegate respondsToSelector:@selector(waterFlow:heightAtIndex:)]) {
        return [self.delegate waterFlow:self heightAtIndex:index];
    }
    return MKWaterFlowDefaultCellHeight;
}
// 间距
- (CGFloat)marginInWaterFlowWitharginType:(MKWaterFlowMarginType)type
{
    if ([self.delegate respondsToSelector:@selector(waterFlow:marginWithType:)]) {
        return [self.delegate waterFlow:self marginWithType:type];
    }
    return MKWaterFlowDefaultMargin;
}

// 返回列数
- (NSUInteger)countOfColumn
{
    if ([self.dataSource respondsToSelector:@selector(columnCountInWaterFlow:)]) {
        return [self.dataSource columnCountInWaterFlow:self];
    }
    return MKWaterFlowDefaultCountOfColumn;
}

// 监听点击事件
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![self.delegate respondsToSelector:@selector(waterFlow:didSelectCellAtIndexIndex:)]) return;
    
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    __block NSNumber  * selectedIndex = nil;
    // 判断point在哪个cell上
    [self.displayingCell enumerateKeysAndObjectsUsingBlock:^(id key, MKWaterFlowViewCell * cell, BOOL *stop){
        if (CGRectContainsPoint(cell.frame, point))
        {
            *stop = YES;
            selectedIndex = key;
        }

    }];
    
    if(selectedIndex){
        [self.delegate waterFlow:self didSelectCellAtIndexIndex:selectedIndex.unsignedIntegerValue];
    }
    
}
@end
