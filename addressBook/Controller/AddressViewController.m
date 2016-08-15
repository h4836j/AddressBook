//
//  AddressViewController.m
//  addressBook
//
//  Created by HJ on 16/3/2.
//  Copyright © 2016年 HJ. All rights reserved.
//

#import "AddressViewController.h"
#import "AddressModel.h"
#import "ChineseString.h"
//#import "TableViewIndex.h"
#import "SectionIndexView.h"
#import "AddressBookCell.h"

#define kScreenWidth    [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight   [[UIScreen mainScreen] bounds].size.height
#define kSectionIndexWidth 30.f
@interface AddressViewController ()<UITableViewDelegate, UITableViewDataSource, SectionIndexViewDataSource, SectionIndexViewDelegate>
{
    selectBlock selected;
}

@property (strong, nonatomic) AddressModel *address;

@property (strong, nonatomic) UITableView *tableView;
@property (assign, nonatomic, getter=isSelect) bool select;
/** 此次选中的cell */
@property (strong, nonatomic) NSMutableArray *selectCell;

@property (strong, nonatomic) SectionIndexView *sectionIndexView;
@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"addressBook";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(deleteClick)];
    
    [self setUpTableView];
    [self setUpIndex];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.sectionIndexView reloadItemViews];
}
- (void)setUpTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    self.tableView = tableView;
    [self.view addSubview:tableView];
}

- (void)setUpIndex
{
    _sectionIndexView = [[SectionIndexView alloc] init];
    
    _sectionIndexView.backgroundColor = [UIColor clearColor];
    _sectionIndexView.dataSource = self;
    _sectionIndexView.delegate = self;
    _sectionIndexView.showCallout = YES;
    _sectionIndexView.calloutDirection = SectionIndexCalloutDirectionLeft;
    _sectionIndexView.calloutMargin = 100.f;
    [_sectionIndexView reloadItemViews];
    [self.view addSubview:self.sectionIndexView];
}

- (void)deleteClick
{
    if (selected) {
        selected(self.selectArray);
    }
    [self.navigationController popViewControllerAnimated:YES];
 
}

#pragma mark - 懒加载
- (NSMutableArray *)selectCell
{
    if (_selectCell == nil) {
        _selectCell = [[NSMutableArray alloc] init];
    }
    return _selectCell;
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *arr = self.sectionArray[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressBookCell *cell = [AddressBookCell cellWithTableView:tableView];
    NSMutableArray *arr = self.sectionArray[indexPath.section];
    AddressModel *address = arr[indexPath.row];
    
    cell.address = address;
    if ([self.selectArray containsObject:address]) {
        cell.selectBtn.selected = YES;
    }else{
        cell.selectBtn.selected = NO;
    }
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddressBookCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectBtn.selected = !cell.selectBtn.isSelected;
    AddressModel *selectModel = cell.address;
    if (cell.selectBtn.isSelected) {
        BOOL isSelect = NO;
        BOOL isMyFriend = NO;
        
        if (self.selectArray.count) {
            for (AddressModel *addres in self.selectArray) {
                if ([addres isEqual:selectModel]) {
                    NSLog(@"你已经添加过该联系人");
                    isSelect = YES;
                    cell.selected = NO;
                    cell.selectBtn.selected = NO;
                    break;
                    return;
                }
            }
        }
        if (self.selectArray.count > 9) {
            // 提示达到最大限制
            NSLog(@"已达到最大人数");
            cell.selected = NO;
            cell.selectBtn.selected = NO;
            
        }else if(isMyFriend == NO && isSelect == NO && self.selectArray.count < 10){
            [self.selectArray addObject:selectModel];
            [self.selectCell addObject:selectModel];
            cell.selected = YES;
            cell.selectBtn.selected = YES;
            
        }
        
    }else {
        [self.selectCell removeObject:selectModel];
        [self.selectArray removeObject:selectModel];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.indexArray[section];
}

- (void)finishSelect:(selectBlock)select
{
    selected = select;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGFloat kSectionIndexHeight = (self.indexArray.count) ? (self.indexArray.count * 40) : 20;
    kSectionIndexHeight = MIN(kSectionIndexHeight, ([UIScreen mainScreen].bounds.size.height - 64 -49));
    
    _sectionIndexView.frame = CGRectMake(CGRectGetWidth(self.tableView.frame) - kSectionIndexWidth, 64, kSectionIndexWidth, kSectionIndexHeight);
//    [_sectionIndexView setBackgroundViewFrame];
}


- (NSInteger)numberOfItemViewForSectionIndexView:(SectionIndexView *)sectionIndexView
{
    return self.indexArray.count;
}

- (SectionIndexItemView *)sectionIndexView:(SectionIndexView *)sectionIndexView itemViewForSection:(NSInteger)section
{
    SectionIndexItemView *itemView = [[SectionIndexItemView alloc] init];
    //    itemView.backgroundColor = [UIColor blueColor];
    [itemView.titleButton setTitle:self.indexArray[section] forState:UIControlStateNormal];
    [itemView.titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [itemView.titleButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    return itemView;
    
}
// 屏幕中间显示的label
- (UIView *)sectionIndexView:(SectionIndexView *)sectionIndexView calloutViewForSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    
    label.frame = CGRectMake(0, 0, 80, 80);
    
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = [UIColor redColor];
    label.font = [UIFont boldSystemFontOfSize:36];
    label.text = [self.indexArray objectAtIndex:section];
    label.textAlignment = NSTextAlignmentCenter;
    
    [label.layer setCornerRadius:label.frame.size.width/2];
    [label.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [label.layer setBorderWidth:3.0f];
    [label.layer setShadowColor:[UIColor blackColor].CGColor];
    [label.layer setShadowOpacity:0.8];
    [label.layer setShadowRadius:5.0];
    [label.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    return label;
}
// 标题
- (NSString *)sectionIndexView:(SectionIndexView *)sectionIndexView
               titleForSection:(NSInteger)section
{
    return [self.indexArray objectAtIndex:section];
}

// 点击字母滑动tableView
- (void)sectionIndexView:(SectionIndexView *)sectionIndexView didSelectSection:(NSInteger)section
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}




@end
