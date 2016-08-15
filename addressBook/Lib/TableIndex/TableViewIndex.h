//
//  TableViewIndex.h
//  通讯录
//
//  Created by HJ on 15/12/8.
//  Copyright © 2015年 HJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TableViewIndex;

@protocol TableViewIndexDataSource <NSObject>

- (TableViewIndex *)sectionIndexView:(TableViewIndex *)indexView itemViewForSection:(NSInteger)section;
- (NSInteger)numberOfItemViewForSectionIndexView:(TableViewIndex *)indexView;
@optional
- (NSString *)sectionIndexView:(TableViewIndex *)indexView
               titleForSection:(NSInteger)section;

@end

@protocol TableViewIndexDelegate <NSObject>

- (void)sectionIndexView:(TableViewIndex *)indexView
        didSelectSection:(NSInteger)section;

@end

@interface TableViewIndex : UIView

@property (weak, nonatomic) id<TableViewIndexDataSource> dataSource;
@property (weak, nonatomic) id<TableViewIndexDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *indexArray;

@end
