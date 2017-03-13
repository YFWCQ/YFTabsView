//
//  YFTabsView.h
//  YFTabsView
//
//  Created by FYWCQ on 17/3/7.
//  Copyright © 2017年 YFWCQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kYFTabsIndicateNone = 0,
    kYFTabsIndicateDot = 1,
    kYFTabsIndicateLine = 2,
} YFTabsIndicStyle;


@interface YFTabsView : UIView

@property(nonatomic, assign)YFTabsIndicStyle scroStyle;

/**
 *  向 外部 传出去 点击的 信息（点击了第几个button），index 从 1 开始
 */
@property(nonatomic, copy)void(^clickIndex)(NSUInteger index);

/**
 * 根据 Title 去加载Button
 */
- (void)loadButtonToLastWithTitle:(NSString *)title;
- (void)loadButtonWithTitles:(NSArray *)titles;

/**
 * 不可滑动，只在 frame.size 里面布局
 */
- (void)loadButtonWithoutScrolWithTitles:(NSArray *)titles buttonsGap:(CGFloat)gap;

/**
 * 初始化 加载完Button 之后，去做 相应的设置
 */
- (void)loadButtonEnd;

/**
 *  尽可能 使  相应的分类 标签 显示 到最中间，index 从1 开始
 */
- (void)scrollToCategoryWithIndex:(NSUInteger)index;

/**
 *  列表 scrollVIew 滑动时  调用
 */
- (void)mainScrollViewDidSroll:(UIScrollView *)scrollView;

/**
 *index 从 1 开始，通过 代码 让 该 button 执行 点击方法
 */
- (void)clickButtonOfIndex:(NSUInteger)index;

/**
 *  根据 index（从1 开始）删除对应的Button
 */
- (void)deleteButtonOfIndex:(NSUInteger)index;
- (void)clickCategoryButtonAction:(UIButton *)button;

/**
 * 设置提示View Size通过Frame
 */
-(void)setFrameScroIndicViewSizeToFrame:(CGRect)frame;


@end
