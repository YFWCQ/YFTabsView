//
//  YFTabsView.m
//  YFTabsView
//
//  Created by FYWCQ on 17/3/7.
//  Copyright © 2017年 YFWCQ. All rights reserved.
//

#import "YFTabsView.h"

#define RGB_YF(r,g,b) [UIColor colorWithRed:(r)/255. green:(g)/255. blue:(b)/255. alpha:1.0]


@interface YFTabsView ()

/**
 *   提示 View
 */
@property(nonatomic,strong)UIView *scroIndicView;

/**
 * 滑动提示
 */
@property(nonatomic,strong)UIColor *scroStyleColor;



@property(nonatomic,strong)UIScrollView *scrollView;

@property(nonatomic,strong)NSMutableArray *categoryButtonsArray;

@property(nonatomic,strong)UIColor *titleNomalColor;
@property(nonatomic,strong)UIColor *titleSelectColor;
@property(nonatomic,strong)UIFont *titleFont;

/**
 * 记录 选中Button
 */
@property(nonatomic,strong)UIButton *selectButton;

@end

@implementation YFTabsView
{
    //水平的X 坐标
    CGFloat _horX;
    // button 水平方向 的间距
    CGFloat _horSpacingOfButtons;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self initSettingData];
        // buttons 水平间距
        _horSpacingOfButtons = 20.f;
        
        // 初始化
        _categoryButtonsArray = [[NSMutableArray alloc] init];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _scrollView.backgroundColor = [UIColor clearColor];
        //  去掉 水平滑动条
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        [self addSubview:_scrollView];
        
        if (self.scroStyle == kYFTabsIndicateLine)
        {
            _scroIndicView = [[UIView alloc] initWithFrame:CGRectMake(10, self.frame.size.height - 1, 5, 1)];
            
            _scroIndicView.backgroundColor = self.scroStyleColor;
            
            
        }else if (self.scroStyle == kYFTabsIndicateDot)
        {
            _scroIndicView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 5, 5)];
            
            _scroIndicView.backgroundColor = self.scroStyleColor;
            // 圆角
            _scroIndicView.layer.cornerRadius = 2.5f;
            _scroIndicView.layer.masksToBounds = YES;
        }
        
        [_scrollView addSubview:_scroIndicView];
    }
    return self;
}

-(void)setButtonDefaultSetting:(UIButton *)button
{
    //Font
    [button.titleLabel setFont:_titleFont];
    // titleColor
    [button setTitleColor:_titleNomalColor forState:UIControlStateNormal];
    
    //选中状态的 字体颜色
    [button setTitleColor:_titleSelectColor forState:UIControlStateSelected];
    
    
    [button addTarget:self action:@selector(clickCategoryButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_scrollView addSubview:button];
    
    //  数组记录 Button
    [_categoryButtonsArray addObject:button];
    
    
}

-(void)initSettingData
{
    _titleNomalColor = RGB_YF(153., 153., 153.);
    _titleSelectColor = RGB_YF(51., 153., 51.);
    _titleFont = [UIFont systemFontOfSize:17.];
    self.scroStyle = kYFTabsIndicateLine;
    self.scroStyleColor = RGB_YF(51., 153., 51.);
}

// 不可滑动，只在 frame.size 里面布局
- (void)loadButtonWithoutScrolWithTitles:(NSArray *)titles buttonsGap:(CGFloat)gap
{
    // button 的宽度
    CGFloat buttonWidth = (self.frame.size.width - gap * (titles.count - 1)) / (CGFloat)titles.count;
    for (NSInteger i = 0; i < titles.count; i ++)
    {
        NSString *title = titles[i];

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

        [button setFrame:CGRectMake((buttonWidth + gap) * i, 0, buttonWidth, self.frame.size.height)];

        [button setTitle:title forState:UIControlStateNormal];
        
        [self setButtonDefaultSetting:button];
        
        [self.scrollView addSubview:button];

    }
    [self loadButtonEnd];
}

- (void)loadButtonWithTitles:(NSArray *)titles
{
    for (NSString *title in titles)
    {
        [self loadButtonToLastWithTitle:title];
    }
    [self loadButtonEnd];
}

- (void)loadButtonToLastWithTitle:(NSString *)title
{
    [self loadButtonWithTitle:title];
    [self loadButtonEnd];
}
- (void)loadButtonWithTitle:(NSString *)title
{
    //第一参数 Size :表示最大的控件的大小，限制Frame的大小
    // 第三个 参数attributes，填 字体 属性：大小，不同字体
    
    CGRect rect=  [title boundingRectWithSize:CGSizeMake(1000, self.frame.size.height) options:0 attributes:@{NSFontAttributeName:_titleFont} context:NULL];
    // button 的宽度
    CGFloat buttonWidth = ceil(rect.size.width);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (_horX == 0.)
    {
        _horX += 15;
    }
    else
    {
        _horX += _horSpacingOfButtons;
    }
    // Frame
    [button setFrame:CGRectMake(_horX, 0, buttonWidth, self.frame.size.height)];
    //title
    [button setTitle:title forState:UIControlStateNormal];
    
    [self setButtonDefaultSetting:button];
    // 记录 水平方向 最后 的坐标
    _horX += buttonWidth;
}

-(void)loadButtonEnd
{
    // scrollView  的显示范围
    [_scrollView setContentSize:CGSizeMake(_horX + 15, _scrollView.frame.size.height)];
    //默认 选中第一个
    self.selectButton = _categoryButtonsArray[0];
}



-(void)mainScrollViewDidSroll:(UIScrollView *)scrollView
{
    
    if (scrollView.contentOffset.x < 0 || scrollView.contentOffset.x > scrollView.contentSize.width - scrollView.frame.size.width)
    {
        // 滑动 超出显示范围，不处理
        return;
    }
    NSLog(@"滑动偏移量%f",scrollView.contentOffset.x);
    
    
    NSUInteger index = (NSUInteger)scrollView.contentOffset.x / (NSUInteger)scrollView.frame.size.width;
    
    CGFloat contentOffsetWidth = scrollView.contentOffset.x - scrollView.frame.size.width * index;
    
    CGFloat scale = contentOffsetWidth / scrollView.frame.size.width;
    
    NSLog(@"contentOffsetWidth====:%f",contentOffsetWidth);
    
    NSLog(@"比例====:%f",scale);
    //scale * Button的间距 == 是 圆点View 在左边最近一个Button中心点偏移的距离，

    if (_categoryButtonsArray.count  > index +1)
    {
        //圆点 左边Button
        UIButton *leftButton = _categoryButtonsArray[index];
        // 圆点 右边Button
        UIButton *rightButton = _categoryButtonsArray[index + 1];
        //  两个Button 中心点 间的距离
        CGFloat horSpacing = rightButton.center.x - leftButton.center.x;
        //  中心点 偏移的距离
        CGFloat offsetOfCirlleDotView = horSpacing *scale;
        
        // 先设置 大小
        if (self.scroStyle == kYFTabsIndicateLine)
        {
            CGFloat widthExtra = scale * (rightButton.frame.size.width -leftButton.frame.size.width);
            [self setFrameScroIndicViewSizeToFrame:CGRectMake(_scroIndicView.frame.origin.x, _scroIndicView.frame.origin.y, leftButton.frame.size.width + widthExtra, 1)];
        }
        
        //  设置 圆点 的位置
        _scroIndicView.center = CGPointMake(leftButton.center.x + offsetOfCirlleDotView, _scroIndicView.center.y);
    }
}
#pragma mark  Actions
-(void)openEditCategoriesViewAction:(UIButton *)button
{
    NSLog(@"打开分类View");
}

-(void)clickCategoryButtonAction:(UIButton *)button
{
    // 设置 选中状态
    self.selectButton = button;
    
    // 根据 数组里 存 的对象 查找它的 下标
    NSUInteger indexOfButton = [_categoryButtonsArray indexOfObject:button];
    
    NSLog(@"点击了第%lu个button",(unsigned long)(indexOfButton + 1));
    
    if (self.clickIndex)
    {
        self.clickIndex(indexOfButton + 1);
    }
}

-(void)scrollToCategoryWithIndex:(NSUInteger)index
{
    
    // 数组 没有越界
    if (_categoryButtonsArray.count > index - 1)
    {
        UIButton *button  = [_categoryButtonsArray objectAtIndex:index - 1];
        
        //  设置 选中Button
        self.selectButton = button;
        
        // 滑动到一个 范围，这个范围是 在scrollView的显示范围之内的，如果超出了会自动显示被截取的范围
        [_scrollView scrollRectToVisible:CGRectMake(button.center.x  - _scrollView.frame.size.width / 2., 0, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:YES];
    }
    else
    {
        NSLog(@"%s in %@,数组越界index=:%lu",__FUNCTION__,[self class],index - 1);
    }
}

-(void)clickButtonOfIndex:(NSUInteger)index
{
    NSUInteger arrayIndex = index - 1;
    
    if (_categoryButtonsArray.count > arrayIndex)
    {
        UIButton *button = _categoryButtonsArray[arrayIndex];
        //  button   执行 点击方法
        [button sendActionsForControlEvents:UIControlEventTouchUpInside];
        //  直接 调用 注册 的方法，button 作为 参数 传过去
        //        [self clickCategoryButtonAction:button];
    }
    else
    {
        
        NSLog(@"数组越界，index：%ld,file:%s,行号：%d",(unsigned long)arrayIndex,__FILE__,__LINE__);
    }
}

#pragma mark  删除 Button
-(void)deleteButtonOfIndex:(NSUInteger)index
{
    NSUInteger arrayIndex = index - 1;
    
    if (_categoryButtonsArray.count > arrayIndex)
    {
        UIButton *button = _categoryButtonsArray[arrayIndex];
        // 删除Button后 产生 的 空白 区域
        CGFloat reducedHorSpacing = button.frame.size.width + _horSpacingOfButtons;
        // 记录横坐标
        _horX -= reducedHorSpacing;
        
        for (NSInteger i = arrayIndex + 1; i  < _categoryButtonsArray.count; i ++)
        {
            UIButton *afterButton = _categoryButtonsArray[i];
            //            CGRectOffset 设置 某个Frame的偏移量
            afterButton.frame = CGRectOffset(afterButton.frame,   -reducedHorSpacing, 0);
        }
        //scrollView  的显示范围
        _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width - reducedHorSpacing, _scrollView.contentSize.height);
        // 从父View 移除 Button
        [button removeFromSuperview];
        // 同步数据
        // 从 数组里 删除 button
        [_categoryButtonsArray removeObjectAtIndex:arrayIndex];
    }
    else
    {
        NSLog(@"数组越界，index：%ld,类名：%@，行号：%d",(unsigned long)arrayIndex,[self class],__LINE__);
    }
    
}

#pragma mark Setter

-(void)setSelectButton:(UIButton *)selectButton
{
    // 不是 同一个  Button 时 去赋值
    if ([_selectButton isEqual:selectButton] == NO)
    {
        if (_selectButton)
        {
            // 上一次 选中Button 设为 正常状态
            _selectButton.selected = NO;
        }
        // 记录这一次 点击的button
        _selectButton = selectButton;
        
        [_selectButton setSelected:YES];
    }
    if (self.scroStyle == kYFTabsIndicateDot)
    {
        _scroIndicView.center = CGPointMake(_selectButton.center.x  , _selectButton.center.y + 13.);
    }else
    {
        [self setFrameScroIndicViewSizeToFrame:CGRectMake(_scroIndicView.frame.origin.x, _scroIndicView.frame.origin.y, selectButton.frame.size.width, _scroIndicView.frame.size.height)];
        _scroIndicView.center = CGPointMake(_selectButton.center.x  , _scroIndicView.center.y);
    }
    
}

-(void)setFrameScroIndicViewSizeToFrame:(CGRect)frame
{
    _scroIndicView.frame = frame;
}




@end
