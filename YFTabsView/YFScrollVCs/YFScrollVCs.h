//
//  YFScrollVCs.h
//  YFTabsView
//
//  Created by FYWCQ on 17/3/7.
//  Copyright © 2017年 YFWCQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFScrollVCs : UIView


#pragma ViewController 设置
// 加载视图控制器
-(void)loadVC:(UIViewController *)VC;
/**
 *  得到 当前的 显示的 ViewController
 */
-(UIViewController *)currentVC;
/**
 * Block 关键字 Copy，三部分：(返回值)（函数名）（参数）
 */
@property(nonatomic,copy)void(^endScrollToVC)(UIViewController *VC);


#pragma View 设置
// 加载View
-(void)loadView:(UIView *)view;
/**
 *  得到 当前的 显示的 View
 */
-(UIView *)currentView;
/**
 * Block 关键字 Copy，三部分：(返回值)（函数名）（参数）
 */
@property(nonatomic,copy)void(^endScrollToView)(UIView *view);




/**
 * 滑到 第几个 View，index 从1 开始
 */
@property(nonatomic,copy)void(^scrollToIndex)(NSUInteger index);
/**
 *  滑动信息 传 出去
 */
@property(nonatomic,copy)void(^scrollViewDidScroll)(UIScrollView *scrollView);

/**
 *  根据 Index ，滑到相应的View，index 从 1开始
 */
-(void)scrollToViewWithIndex:(NSUInteger)index;

/**
 *  删除 对应index的 View（index 从 1 开始）
 */
-(void)deleteViewOfIndex:(NSUInteger)index;



@end
