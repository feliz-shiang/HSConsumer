//
//  MenuTabView.m
//  HSConsumer
//
//  Created by apple on 14-10-22.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#define kViewHeight 34 //默认菜单高度
#define kMinHeight 20 //菜单最小高度
#define kMaxHeight 100 //菜单最大高度
#define kUnderLineHeigth 3 //下划线高度
#define kSeparatorWidth 1.0f //分隔栏宽度
//#define kTabBarItems 4 //栏位数

#import "MenuTabView.h"

@interface MenuTabView()
{
    UIImageView *underLineView;
    CGSize titleW;
    NSArray *arrTitle;
}
@end

@implementation MenuTabView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init
{
    if (self = [super init])
    {
        [self setFrame:CGRectMake(0, 0, kScreenWidth, kViewHeight)];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setUserInteractionEnabled:YES];
    }
    return self;
}

//重写setFrame
- (void)setFrame:(CGRect)f
{
    CGRect newFrame = f;
    newFrame.size.width = kScreenWidth;
    if (f.size.height < kMinHeight)
    {
        newFrame.size.height = kMinHeight;
    }
    if (f.size.height > kMaxHeight)
    {
        newFrame.size.height = kMaxHeight;
    }
    [super setFrame:newFrame];
}

//重写getFrame
- (CGRect)frame
{
    return [super frame];
}

- (id)initMenuWithTitles:(NSArray *)titles
{
    if (self = [self init])
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setUserInteractionEnabled:YES];
        arrTitle = titles;
        int i = kMenuBtnStartTag;//tag不建议从0开始，因为其它view可能已占用
        for (NSString *title in titles)
        {
            [self creatButtonWithTitle:title andIndex:i++ isShowSeparator:NO];
        }
        self.selectedIndex = -1;
        [self changeViewController:[self viewWithTag:kMenuBtnStartTag]];
        [self updateMenu:0];
//        NSLog(@"self.subviews:%@", self.subviews);
    }
    return self;
}

//平均界面宽度且可选带分隔条
- (id)initMenuWithTitles:(NSArray *)titles withFrame:(CGRect)frame isShowSeparator:(BOOL)showSeparator
{
    if (self = [super initWithFrame:frame])
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setUserInteractionEnabled:YES];
        arrTitle = titles;

        int i = kMenuBtnStartTag;//tag不建议从0开始，因为其它view可能已占用
        for (NSString *title in titles)
        {
            [self creatButtonWithTitle:title andIndex:i++ isShowSeparator:showSeparator];
        }
        self.selectedIndex = -1;
        [self changeViewController:[self viewWithTag:kMenuBtnStartTag]];
        [self updateMenu:0];
    }
    return self;
}

- (void)setDefaultItem:(NSUInteger)index
{
    if (index > arrTitle.count - 1) return;
    [self changeViewController:[self viewWithTag:kMenuBtnStartTag + index]];
    [self updateMenu:index];

}

- (void)setNewTitle:(NSString *)title withIndex:(NSUInteger)index
{
    if (index >= arrTitle.count) return;
    UIButton *cButton = (UIButton *)[self viewWithTag:index + kMenuBtnStartTag];
    dispatch_async(dispatch_get_main_queue(), ^{
        [cButton setTitle:title forState:UIControlStateNormal];
//        UIControlStateDisabled
    });
}

- (UIButton *)getItemButton:(NSUInteger)index
{
    if (index >= arrTitle.count) return nil;
    UIButton *cButton = (UIButton *)[self viewWithTag:index + kMenuBtnStartTag];
    return cButton;
}

//创建菜单按钮
- (void)creatButtonWithTitle:(NSString *)title andIndex:(int)tag isShowSeparator:(BOOL)showSeparator
{
    
    CGFloat buttonW = self.frame.size.width / arrTitle.count;
    
    if (showSeparator)//留分隔栏位置，每个
    {
        buttonW = (self.frame.size.width - (arrTitle.count - 1) * kSeparatorWidth) / arrTitle.count;
    }
    
    CGFloat buttonH = self.frame.size.height;
    
    UIButton *cButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cButton.tag = tag;
    int index = tag - kMenuBtnStartTag;
    cButton.frame = CGRectMake(buttonW *index, 0, buttonW, buttonH);
    [cButton setTitle:title forState:UIControlStateNormal];
    [cButton addTarget:self action:@selector(changeViewController:) forControlEvents:UIControlEventTouchDown];
    cButton.titleLabel.textAlignment = NSTextAlignmentCenter;
//    cButton.font = [UIFont systemFontOfSize:15];
    [cButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    
    [cButton setTitleColor:kNavigationBarColor forState:UIControlStateDisabled];
    [cButton setTitleColor:kCellItemTitleColor forState:UIControlStateNormal];
    
    if (showSeparator && index > 0)
    {
        CGFloat vSeparatorH = cButton.frame.size.height * 0.5;
        UIView *vSeparator = [[UIView alloc] initWithFrame:CGRectMake(cButton.frame.origin.x - kSeparatorWidth,
                                                                     cButton.frame.origin.y + (cButton.frame.size.height - vSeparatorH) / 2.0f,
                                                                     kSeparatorWidth,
                                                                     vSeparatorH)];
        [vSeparator setBackgroundColor:kCorlorFromRGBA(230, 230, 230, 1)];
        [self addSubview:vSeparator];
    }
    [self addSubview:cButton];

    //对首选项初始化
    if (index == 0)
    {
        titleW = [cButton.titleLabel.text sizeWithFont:cButton.font];
        titleW.width = 0.7 * buttonW;
        CGRect underLineViewFrame = CGRectMake(cButton.frame.origin.x + (CGRectGetWidth(cButton.frame) - titleW.width) * 0.5,
                                               CGRectGetMaxY(cButton.frame) - kUnderLineHeigth,
//                                               CGRectGetMaxY(self.frame),
                                               titleW.width,
                                               kUnderLineHeigth);
        if (!underLineView)
        {
            underLineView = [[UIImageView alloc] initWithFrame:underLineViewFrame];
            [underLineView setBackgroundColor:kNavigationBarColor];
            [self addSubview:underLineView];
        }
        //添加边框
        underLineViewFrame.origin.x = self.bounds.origin.x;
        underLineViewFrame.origin.y = CGRectGetMaxY(cButton.frame) - 0.7,
        underLineViewFrame.size.height = 0.7;
        underLineViewFrame.size.width = self.bounds.size.width;
        
        UIImageView *ivBottomLine = [[UIImageView alloc] initWithFrame:underLineViewFrame];
        [ivBottomLine setBackgroundColor:kCorlorFromRGBA(180, 180, 180, 1)];
        [self insertSubview:ivBottomLine belowSubview:underLineView];

    }
}

//切换按钮
- (void)changeViewController:(UIView *)btn
{
    NSInteger index = btn.tag - kMenuBtnStartTag;
    
    if (self.selectedIndex != index)
    {
        if ([self.delegate respondsToSelector:@selector(changeViewController:)])
        {
            [self.delegate changeViewController:index];
        }
//        [self updateMenu:index];
    }
    else if (self.selectedIndex == index &&[self.delegate respondsToSelector:@selector(menuTabViewDidSelectIndex:)]) {
        [self.delegate menuTabViewDidSelectIndex:index]; // add by songjk
    }
}

//更新状态
- (void)updateMenu:(NSInteger)index
{
    if (index < 0 || index >= arrTitle.count) return;
    UIButton *cButton = (UIButton *)[self viewWithTag:index + kMenuBtnStartTag];
    UIButton *preTabbtn = (UIButton *)[self viewWithTag:self.selectedIndex + kMenuBtnStartTag];
    cButton.enabled = NO;
    [cButton setTitleColor:kNavigationBarColor forState:UIControlStateDisabled];
    // add by songjk
    if ([self.delegate respondsToSelector:@selector(menuTabViewDidSelectIndex:)])
    {
        cButton.enabled = YES;
        [cButton setTitleColor:kNavigationBarColor forState:UIControlStateSelected];
        cButton.selected= YES;
        preTabbtn.selected = NO;
    }
    
    preTabbtn.enabled = YES;
    CGRect underLineViewFrame = CGRectMake(cButton.frame.origin.x + (CGRectGetWidth(cButton.frame) - titleW.width) * 0.5,
                                           CGRectGetMaxY(cButton.frame) - kUnderLineHeigth,
//                                           CGRectGetMaxY(cButton.frame) - kUnderLineHeigth * 0.5,
//                                            CGRectGetMaxY(cButton.frame),
                                           titleW.width,
                                           kUnderLineHeigth);
    [UIView animateWithDuration:0.1
                     animations:^{
                         underLineView.frame = underLineViewFrame;
                     }
     ];
    self.selectedIndex = index;
}

@end
