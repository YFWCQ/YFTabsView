//
//  YFScrollVCs.m
//  YFTabsView
//
//  Created by FYWCQ on 17/3/7.
//  Copyright © 2017年 YFWCQ. All rights reserved.
//

#import "YFScrollVCs.h"


@interface YFScrollVCs ()<UIScrollViewDelegate>

@end

@implementation YFScrollVCs
{
    UIScrollView *_scrollView;

// 记录 View 的可变 数组
    NSMutableArray *_arrayOfView;
// 试图控制器的数组
    NSMutableArray *_arrayOfVC;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self initData];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        //  只显示 self的背景色
        _scrollView.backgroundColor = [UIColor clearColor];
        //按页 翻滚
        _scrollView.pagingEnabled = YES;
        // 代理
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        [self addSubview:_scrollView];
    }
    return self;
}

-(void)initData
{
    // 初始化 数组
    _arrayOfView = [[NSMutableArray alloc] init];
    
    _arrayOfVC = [[NSMutableArray alloc] init];
    
}

-(void)loadVC:(UIViewController *)VC
{
    [_arrayOfVC addObject:VC];
    [self loadView:VC.view];
}

-(void)loadView:(UIView *)view
{
    view.frame = CGRectMake(_arrayOfView.count * _scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    
    //view  添加 到 ScrollView
    [_scrollView addSubview:view];
    // 数组记录 View
    [_arrayOfView addObject:view];
    //  设置 scrollView 显示范围
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * _arrayOfView.count, _scrollView.frame.size.height);
}
//删除 View
-(void)deleteViewOfIndex:(NSUInteger)index
{
    NSUInteger arrayIndex  = index - 1;
    
    if (_arrayOfView.count > arrayIndex)
    {
        UIView *view = _arrayOfView[arrayIndex];
        //父view移除 删除的View
        [view removeFromSuperview];
        
        for (NSInteger i = arrayIndex + 1; i < _arrayOfView.count; i ++)
        {
            UIView *afterView = _arrayOfView[i];
            
            afterView.frame = CGRectOffset(afterView.frame, -view.frame.size.width, 0);
        }
        // 数组 里移除 View
        [_arrayOfView removeObjectAtIndex:arrayIndex];
        // scrollView  的显示 范围
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * _arrayOfView.count, _scrollView.frame.size.height);
        // 刷新列表 和 相应的UI，如果 是当前显示的View的话
        [self endScroll];
    }
    else
    {
        NSLog(@"数组越界index：%ld,in %@,方法：%s，行号：%d",(unsigned long)arrayIndex,[self class],__FUNCTION__,__LINE__);
    }
}

-(UIView *)currentView
{
    NSInteger currentIndex = (NSInteger)_scrollView.contentOffset.x / (NSInteger)_scrollView.frame.size.width ;
    UIView *view = nil;
    
    if (_arrayOfView.count  > currentIndex)
    {
        view = [_arrayOfView objectAtIndex:currentIndex];
    }
    else
    {
        // 方法名  越界 Index 和 类名
        NSLog(@"%s,数组越界 index：%ld,in %@",__FUNCTION__,(long)currentIndex,[self class]);
    }
    return view;
}

-(UIViewController *)currentVC
{
    NSInteger currentIndex =   (NSInteger)_scrollView.contentOffset.x / (NSInteger)_scrollView.frame.size.width ;
    UIViewController *viewC = nil;
    
    if (_arrayOfVC.count  > currentIndex)
    {
        viewC = [_arrayOfVC objectAtIndex:currentIndex];
    }
    else
    {
        // 方法名  越界 Index 和 类名
        NSLog(@"%s,数组越界 index：%ld,in %@",__FUNCTION__,(long)currentIndex,[self class]);
    }
    return viewC;
}



#pragma mark UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.scrollViewDidScroll)
    {
        self.scrollViewDidScroll(scrollView);
    }
    //    NSLog(@"偏移量X==:%f",scrollView.contentOffset.x);
}


// 停止拖拽时调用，decelerate 表示 是否会 减速
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate == NO)
    {
        [self endScroll];
    }
}
// 停止 减速
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self endScroll];
}
//停止滚动
-(void)endScroll
{
    //    NSLog(@"停止滚动");
    //  得到 当前的View
    UIView *currentView = [self currentView];
    //判断 Block 有没有 实现过
    if (self.endScrollToView)
    {
        //调用Block 把 当前View传出去
        self.endScrollToView(currentView);
    }
    
    UIViewController *currentVC = [self currentVC];
    if (self.endScrollToVC)
    {
        self.endScrollToVC(currentVC);
    }
    // 滑动停止 把当前View是第几个 传出去
    NSInteger currentIndex =   (NSInteger)_scrollView.contentOffset.x / (NSInteger)_scrollView.frame.size.width ;
    
    if (self.scrollToIndex)
    {
        self.scrollToIndex(currentIndex + 1);
    }
}

-(void)scrollToViewWithIndex:(NSUInteger)index
{
    NSLog(@"%ld",index);
    CGFloat contentoffsetX = (index - 1) * _scrollView.frame.size.width;
    
    [_scrollView setContentOffset:CGPointMake(contentoffsetX, 0) ];
    
    [self endScroll];
    
    //  动画 方式
    //    [UIView animateWithDuration:.3 animations:^{
    //          [_scrollView setContentOffset:CGPointMake(contentoffsetX, 0) ];
    //    } completion:^(BOOL finished) {
    //        [self endScroll];
    //
    //    }];
}



@end
