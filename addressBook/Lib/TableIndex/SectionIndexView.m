//
//  SectionIndexView.m
//  TableViewIndex
//
//  Created by HJ on 15/12/8.
//  Copyright © 2015年 Dean. All rights reserved.
//

#import "SectionIndexView.h"
#import <QuartzCore/QuartzCore.h>

@interface SectionIndexItemView ()<UIGestureRecognizerDelegate>
/**
 *  内容视图
 */
@property (strong, nonatomic) UIView *contentView;




@end

@implementation SectionIndexItemView
{
    clinkBlock clinked;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder]) {
        
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.contentView = [[UIView alloc] init];
    [self addSubview:self.contentView];
    
    self.backgroundImgView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.backgroundImgView];
    
    UIButton *titleBtn = [[UIButton alloc] init];
    titleBtn.backgroundColor = [UIColor redColor];
    self.titleButton = titleBtn;
    [self.contentView addSubview:titleBtn];
    titleBtn.userInteractionEnabled = NO;
    
//    [titleBtn addTarget:self action:@selector(buttonClink) forControlEvents:UIControlEventTouchDown];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
//    tap.delegate = self;
//    [titleBtn addGestureRecognizer:tap];
}

- (void)buttonClink
{
    NSLog(@"----------");
    if (clinked) {
        clinked();
    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"indexItemClink" object:self];
    
}

- (void)buttonClink:(clinkBlock)clink
{
    clinked = clink;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
    self.backgroundImgView.frame = self.bounds;
    self.titleButton.frame = CGRectMake(5, 5, self.contentView.bounds.size.width - 10, self.contentView.bounds.size.width - 10);
    

}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    self.titleButton.selected = YES;
    [self.backgroundImgView setHighlighted:highlighted];
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [self setHighlighted:selected animated:animated];
}
@end

@interface SectionIndexView ()
/** 索引示图高度 */
@property (assign, nonatomic) CGFloat itemViewHeight;
/** 当前选中的索引视图 */
@property (assign, nonatomic) NSInteger highlightedItemIndex;
/** 索引视图模型数组 */
@property (strong, nonatomic) NSMutableArray *itemViewList;
/** 是否设置过索引 */
@property (assign, nonatomic, getter=isSetIndex) BOOL setIndex;
@end

@implementation SectionIndexView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundView = [[UIView alloc] init];
        self.backgroundView.backgroundColor = [UIColor grayColor];
        self.backgroundView.frame = CGRectMake(0, 0, 20, 300);
        self.backgroundView.clipsToBounds = YES;
        self.backgroundView.layer.cornerRadius = 12.f;
        [self addSubview:self.backgroundView];
        
        self.showCallout = YES;
        self.calloutDirection = SectionIndexCalloutDirectionLeft;
        self.indexBottonMargin = 10.f;
        self.indexTopMargin = 10.f;
        self.backViewLeftMargin = 3.f;
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(indexItemClinked:) name:@"indexItemClink" object:nil];
    }
    return self;
}

- (NSMutableArray *)itemViewList
{
    if (_itemViewList == nil) {
        _itemViewList = [[NSMutableArray alloc] init];
    }
    return _itemViewList;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundView.frame = CGRectMake(self.backViewLeftMargin, 0, CGRectGetWidth(self.frame) - self.backViewLeftMargin*2, CGRectGetHeight(self.frame));
    if (!self.isSetIndex) {
        [self layoutItemViews];
    }
}

- (void)reloadItemViews
{
    if (!(self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfItemViewForSectionIndexView:)] && [self.dataSource respondsToSelector:@selector(sectionIndexView:itemViewForSection:)])) return;
    [self.itemViewList removeAllObjects];
    NSInteger numberOfItems = [self.dataSource numberOfItemViewForSectionIndexView:self];
    
    for (int i = 0; i < numberOfItems; i++) {
        SectionIndexItemView *itemView = [self.dataSource sectionIndexView:self itemViewForSection:i];
        itemView.section = i;
        [self.itemViewList addObject:itemView];
        [self addSubview:itemView];
    }
}

- (void)layoutItemViews
{
    if (self.isSetIndex) return;
    if (!self.itemViewList.count) return;
    
    if (self.fixedItemHeight > 0) {
        self.itemViewHeight = self.fixedItemHeight;
    }else if (self.itemViewList.count) {
        self.itemViewHeight = (CGRectGetHeight(self.bounds) - self.indexTopMargin - self.indexBottonMargin)/(CGFloat)(self.itemViewList.count);
    }
    CGFloat offsetY = self.indexTopMargin;
    for (UIView *itemView in self.itemViewList) {
        itemView.frame = CGRectMake(0, offsetY, CGRectGetWidth(self.bounds), self.itemViewHeight);
//        NSLog(@"%@",NSStringFromCGRect(itemView.frame));
        offsetY += self.itemViewHeight;
    }
    if (offsetY < self.bounds.size.height * 0.5) {
        self.setIndex = NO;
    }else{
        self.setIndex = YES;
    }
}

//#pragma mark - 通知方法
//- (void)indexItemClinked:(NSNotification *)notification
//{
//    SectionIndexItemView *itemView = notification.object;
//    
//    [self selectItemViewForSection:itemView.section];
//    self.highlightedItemIndex = itemView.section;
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self unhighlightAllItems];
//        self.highlightedItemIndex = -1;
//    });
//}


#pragma mark methods of touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    // 判断选择的哪个索引字母
    for (SectionIndexItemView *itemView in self.itemViewList) {
        if (CGRectContainsPoint(itemView.frame, touchPoint)) {
            NSLog(@"========");
            [self selectItemViewForSection:itemView.section];
            self.highlightedItemIndex = itemView.section;
            return;
        }else{
//            itemView.titleButton.selected = NO;
        }
    }
    // 手指不在索引字母中，不就行任何操作
    self.highlightedItemIndex = -1;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    for (SectionIndexItemView *itemView in self.itemViewList) {
        if (CGRectContainsPoint(itemView.frame, touchPoint)) {
            if (itemView.section != self.highlightedItemIndex) {
//                itemView.titleButton.selected = YES;
                [self selectItemViewForSection:itemView.section];
                self.highlightedItemIndex  = itemView.section;
                return;
                
            }else{
//                itemView.titleButton.selected = NO;
            }
        }else{
//            itemView.titleButton.selected = NO;
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self unhighlightAllItems];
    self.highlightedItemIndex = -1;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesCancelled:touches withEvent:event];
}

#pragma mark - 设置选择字母后的事件

/**
 *  选中了某一个index索引字母
 */
- (void)selectItemViewForSection:(NSInteger)section
{
     [self highlightItemForSection:section];
    
    SectionIndexItemView *seletedItemView = self.itemViewList[section];
    CGFloat centerY = seletedItemView.center.y;
    CGFloat calloutHeight = CGRectGetHeight(self.calloutView.frame);
    CGFloat count = self.itemViewList.count;
    
    if (_delegate && [_delegate respondsToSelector:@selector(sectionIndexView:didSelectSection:)]) {
        [_delegate sectionIndexView:self didSelectSection:section];
    }
    
    if (!self.isShowCallout) return;
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(sectionIndexView:calloutViewForSection:)]) { // 自己实现了代理方法设置弹窗
        self.calloutView = [self.dataSource sectionIndexView:self calloutViewForSection:section];
        [self addSubview:self.calloutView];
        // 设置弹窗的Y轴位置
        if (self.calloutCenterYPosition) { // 用户自己设置了位置
            centerY = self.calloutCenterYPosition;
        } else if (centerY - calloutHeight * 0.5 < 0) { // 第一个弹窗顶部可能超过索引视图
            centerY = CGRectGetHeight(self.calloutView.frame)/2;
        } else if (centerY + calloutHeight * 0.5 > self.itemViewHeight * count) {// 最后一个弹窗底部可能超过索引视图
            centerY = self.itemViewHeight * count - calloutHeight * 0.5;
        }
        
    }else { // 默认弹窗
        self.calloutView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 88, 51)];
        if (self.calloutBackImg) {
            [self.calloutView addSubview:self.calloutBackImg];
        }
        // 弹窗中文字提示label
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (CGRectGetHeight(self.calloutView.frame) - 30)/2, 30, 30)];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.textColor = [UIColor redColor];
        tipLabel.font = [UIFont boldSystemFontOfSize:36];
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(sectionIndexView:titleForSection:)]) {
            tipLabel.text = [self.dataSource sectionIndexView:self titleForSection:section];
        }
        tipLabel.textAlignment = NSTextAlignmentCenter;
        [self.calloutView addSubview:tipLabel];
        [self addSubview:self.calloutView];
        
        self.calloutMargin = -18.f;
    }
    
    switch (self.calloutDirection) {
        case SectionIndexCalloutDirectionRight:
            _calloutView.center = CGPointMake(CGRectGetWidth(seletedItemView.frame) + CGRectGetWidth(self.calloutView.frame)/2 + self.calloutMargin, centerY);
            break;
        case SectionIndexCalloutDirectionLeft:
            _calloutView.center = CGPointMake(- (CGRectGetWidth(self.calloutView.frame)/2 + self.calloutMargin), centerY);
            break;
        default:
            break;
    }
    
    
    
}

// 将该字母设置为高亮状态
- (void)highlightItemForSection:(NSInteger)section
{
    [self unhighlightAllItems];
    SectionIndexItemView *itemView = self.itemViewList[section];
    [itemView setHighlighted:YES animated:YES];
    itemView.backgroundColor = [UIColor blueColor];
}

// 取消高亮状态，隐藏弹窗字母提示
- (void)unhighlightAllItems
{
    if (self.isShowCallout) {
        [self.calloutView removeFromSuperview];
        if (self.calloutView) {
            self.calloutView = nil;
        }
    }
    for (SectionIndexItemView *itemView  in self.itemViewList) {
//        [itemView setHighlighted:NO animated:NO];
        itemView.backgroundColor = [UIColor clearColor];
        itemView.titleButton.selected = NO;
    }
}

@end
