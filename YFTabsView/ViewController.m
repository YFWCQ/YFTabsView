//
//  ViewController.m
//  YFTabsView
//
//  Created by FYWCQ on 17/3/7.
//  Copyright © 2017年 YFWCQ. All rights reserved.
//

#import "ViewController.h"

#import "YFTabsView.h"

#import "YFScrollVCs.h"

#import "YFSampleTViewController.h"
#import "YFSampleOViewController.h"

@interface ViewController ()

@property(nonatomic, strong)YFTabsView *tabsView;
@property(nonatomic, strong)YFScrollVCs *scrollVCs;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.tabsView];
    [self.view addSubview:self.scrollVCs];
    
    [self.scrollVCs loadVC:[[YFSampleOViewController alloc] init]];
    [self.scrollVCs loadVC:[[YFSampleTViewController alloc] init]];
}


- (YFTabsView *)tabsView
{
    if (_tabsView == nil)
    {
        __weak typeof(self)weakS = self;
        YFTabsView *tabsView = [[YFTabsView alloc] initWithFrame:CGRectMake(15, 64, self.view.frame.size.width - 30, 44)];
        [tabsView setClickIndex:^(NSUInteger index)
         {
            NSLog(@"点击了第%ld个分类",index);
            [weakS.scrollVCs scrollToViewWithIndex:index];
         }];
        [self.view addSubview:tabsView];
        [tabsView loadButtonWithoutScrolWithTitles:@[@"全部",@"已发送",@"草稿箱"] buttonsGap:30];
        
        _tabsView = tabsView;
    }
    return _tabsView;
}

- (YFScrollVCs *)scrollVCs
{
    if (_scrollVCs == nil)
    {
        YFScrollVCs *scrollVCs = [[YFScrollVCs alloc] initWithFrame:CGRectMake(0, 108,self.view.frame.size.width, self.view.frame.size.height - 108)];
        // 超出_mainScrollView 显示范围的 截取掉
        scrollVCs.clipsToBounds = YES;
        __weak typeof(self)weakS = self;
        [scrollVCs setEndScrollToVC:^(UIViewController * VC) {
            //        [weakS endScrollToVCFY:VC];
        }];
        [scrollVCs setScrollToIndex:^(NSUInteger index) {
            //            NSLog(@"列表滑到了第%ld个",index);
            // 分类 View 和 列表 显示的 信息 同步
            [weakS.tabsView scrollToCategoryWithIndex:index];
        }];
        
        [scrollVCs setScrollViewDidScroll:^(UIScrollView * scrollView) {
            // 分类View 接收 _mainScrollView 的滑动情况
            [weakS.tabsView mainScrollViewDidSroll:scrollView];
        }];
        _scrollVCs = scrollVCs;
    }
    return _scrollVCs;
}


@end
