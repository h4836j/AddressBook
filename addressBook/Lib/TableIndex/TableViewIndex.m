//
//  TableViewIndex.m
//  通讯录
//
//  Created by HJ on 15/12/8.
//  Copyright © 2015年 HJ. All rights reserved.
//

#import "TableViewIndex.h"

@interface TableViewIndex ()
@property (nonatomic, strong) NSMutableArray *itemViewList;
@end

@implementation TableViewIndex

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
    }
    return self;
}

- (void)setIndexArray:(NSMutableArray *)indexArray
{
    _indexArray = indexArray;
    if (indexArray.count < 1) return;
    CGFloat btnX = 0;
    CGFloat btnH = 10;
    CGFloat btnW = self.frame.size.width;
    CGFloat gap = 2;
    for (int i = 0; i < indexArray.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        CGFloat btnY = gap + (gap + btnH) * i;
        button.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [button setTitle:indexArray[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClink:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [self addSubview:button];
        
    }
}

- (void)buttonClink:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(sectionIndexView:didSelectSection:)]) {
        [self.delegate sectionIndexView:self didSelectSection:button.tag];
    }
}

@end
