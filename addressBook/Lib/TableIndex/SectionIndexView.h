//
//  SectionIndexView.h
//  TableViewIndex
//
//  Created by HJ on 15/12/8.
//  Copyright © 2015年 Dean. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SectionIndexView;
typedef void(^clinkBlock)();
@interface SectionIndexItemView : UIView
/** 索引view中item所在的位置 */
@property (nonatomic, assign) NSInteger section;
/** 索引view里面的标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/** 索引view中的按钮 */
@property (strong, nonatomic) UIButton *titleButton;
/** 背景视图 */
@property (strong, nonatomic) UIImageView *backgroundImgView;

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated;//方便在子类里重写该方法
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

- (void)buttonClink:(clinkBlock)clink;

@end

@protocol SectionIndexViewDataSource <NSObject>
/** 返回某个索引位置的视图 */
- (SectionIndexItemView *)sectionIndexView:(SectionIndexView *)sectionIndexView itemViewForSection:(NSInteger)section;
/** 一共有多少个索引字母 */
- (NSInteger)numberOfItemViewForSectionIndexView:(SectionIndexView *)sectionIndexView;@optional
@optional
/** 提供方法用来自定义弹窗显示索引字母的view */
- (UIView *)sectionIndexView:(SectionIndexView *)sectionIndexView calloutViewForSection:(NSInteger)section;
/** 提供方法用来自定义索引文字 */
- (NSString *)sectionIndexView:(SectionIndexView *)sectionIndexView titleForSection:(NSInteger)section;

@end

@protocol SectionIndexViewDelegate <NSObject>
- (void)sectionIndexView:(SectionIndexView *)sectionIndexView didSelectSection:(NSInteger)section;

@end

typedef enum {
    SectionIndexCalloutDirectionLeft,
    SectionIndexCalloutDirectionRight
}SectionIndexCalloutDirection;

@interface SectionIndexView : UIView
@property (weak, nonatomic) id<SectionIndexViewDataSource> dataSource;
@property (weak, nonatomic) id<SectionIndexViewDelegate> delegate;

/** 选中提示图显示的方向，相对于DSectionIndexView的对象而言 */
@property (nonatomic, assign) SectionIndexCalloutDirection calloutDirection;

/** 是否显示选中提示图，默认是YES */
@property (nonatomic, assign, getter=isShowCallout) BOOL showCallout;
/** 弹窗视图的Y轴位置，默认跟当前字母同步 */
@property (assign, nonatomic) CGFloat calloutCenterYPosition;
/** 索引距离顶部的距离 默认为10.0f */
@property (assign, nonatomic) CGFloat indexTopMargin;
/** 索引距离底部的距离 默认为10.0f */
@property (assign, nonatomic) CGFloat indexBottonMargin;
/** itemView的高度，默认是根据itemView的数目均分SectionIndexView的对象的高度 */
@property (nonatomic, assign) CGFloat fixedItemHeight;

/** 选中提示图与DSectionIndexView的对象边缘的距离 默认为18*/
@property (nonatomic, assign) CGFloat calloutMargin;
/** 背景视图 */
@property (strong, nonatomic) UIView *backgroundView;
/** 背景视图与view左侧和右侧的距离 默认为3.0f */
@property (assign, nonatomic) CGFloat backViewLeftMargin;
/** 弹窗视图 */
@property (strong, nonatomic) UIView *calloutView;
/** 弹窗视图的背景图片 */
@property (strong, nonatomic) UIImageView *calloutBackImg;


- (void)reloadItemViews;

@end















