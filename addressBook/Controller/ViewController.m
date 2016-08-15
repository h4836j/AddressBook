//
//  ViewController.m
//  addressBook
//
//  Created by HJ on 16/3/2.
//  Copyright © 2016年 HJ. All rights reserved.
//

#import "ViewController.h"
#import "AddressModel.h"
#import "AddressModel.h"
//#import "AddressTableViewController.h"
#import <AddressBook/AddressBook.h>
#import "ChineseString.h"
#import "ContactTableViewCell.h"
#import "AddressViewController.h"


@interface ViewController ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, ContactTableViewCellDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;

/** 遍历通讯录得到的联系人数组 */
@property (strong, nonatomic) NSMutableArray *addressArray;
/** 索引数组 */
@property(nonatomic,strong)NSMutableArray *indexArray;
/** 所有联系人的综合数组 */
@property(nonatomic,strong)NSMutableArray *letterResultArr;
/** 所有联系人的综合模型数组集合 */
@property (strong, nonatomic) NSMutableArray *sectionArray;
/** 需要显示的联系人 */
@property (strong, nonatomic) NSMutableArray *showArray;
/** 显示选择联系人的表示图 */
@property (strong, nonatomic) UITableView *tableView;
/** 从通讯录中导入 */
@property (strong, nonatomic) UIButton *addressBookBtn;
/** 手动导入 */
@property (strong, nonatomic) UIButton *manualBtn;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestAccessAddressBook];
    [self setUpSubviews];
    self.navigationItem.title = @"添加联系人";
    self.view.backgroundColor = [UIColor redColor];
}

- (void)setUpSubviews
{
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    scrollView.backgroundColor = [UIColor redColor];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    UIButton *manualBtn = [[UIButton alloc] init];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat manualW = width * 0.5;
    CGFloat manualX = width * 0.25;
    CGFloat manualH = 30;
    CGFloat manualY = 90;
    [manualBtn setTitle:@"手动导入" forState:UIControlStateNormal];
    [manualBtn setBackgroundColor:[UIColor blueColor]];
    manualBtn.frame = CGRectMake(manualX, manualY, manualW, manualH);
    [self.scrollView addSubview:manualBtn];
    self.manualBtn = manualBtn;
    [manualBtn addTarget:self action:@selector(manualBtnClink) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *addressBookBtn = [[UIButton alloc] init];
    CGFloat addressBookW = width * 0.5;
    CGFloat addressBookX = width * 0.25;
    CGFloat addressBookH = 30;
    CGFloat addressBookY = 30;
    addressBookBtn.frame = CGRectMake(addressBookX, addressBookY, addressBookW, addressBookH);
    [self.scrollView addSubview:addressBookBtn];
    self.addressBookBtn = addressBookBtn;
    [addressBookBtn setTitle:@"从通讯录中导入" forState:UIControlStateNormal];
    [addressBookBtn setBackgroundColor:[UIColor greenColor]];
    [addressBookBtn addTarget:self action:@selector(addressBookBtnClink) forControlEvents:UIControlEventTouchUpInside];
    
}

/**
 *  请求访问通讯录信息
 */
- (void)requestAccessAddressBook
{
    // 凡是函数名中包含了create\retain\copy\new等字眼,创建的数据类型,最终都需要release
    // 创建通讯录实例
    ABAddressBookRef book = ABAddressBookCreateWithOptions(NULL, NULL);
    // 请求访问通讯录的权限
    ABAddressBookRequestAccessWithCompletion(book, ^(bool granted, CFErrorRef error) { // 请求失败还是成功,都会调用这个block
        // granted : YES , 允许访问
        // granted : NO , 不允许访问
        if (granted) {
            NSLog(@"允许访问");
        } else {
            NSLog(@"不允许访问");
        }
    });
    // 释放资源  Core Foundation
    CFRelease(book);
}

#pragma mark - 懒加载
- (NSMutableArray *)addressArray
{
    if (_addressArray == nil) {
        _addressArray = [NSMutableArray arrayWithCapacity:2];
    }
    return _addressArray;
}
- (NSMutableArray *)sectionArray
{
    if (_sectionArray == nil) {
        _sectionArray = [[NSMutableArray alloc] init];
    }
    return _sectionArray;
}
- (NSMutableArray *)showArray
{
    if (_showArray == nil) {
        _showArray = [[NSMutableArray alloc] init];
    }
    return _showArray;
}
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        CGFloat tableX = 5;
        CGFloat tableY = CGRectGetMaxY(self.addressBookBtn.frame) + 20;
        CGFloat tableW = [UIScreen mainScreen].bounds.size.width - 10;
        CGFloat tableH = 0;
        if (self.showArray.count > 0) {
            tableH = 44 * self.showArray.count;
        }
        self.tableView.frame = CGRectMake(tableX, tableY, tableW, tableH);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        // tableView不可滚动
        self.tableView.scrollEnabled = NO;
        [self.scrollView addSubview:self.tableView];
        
    }
    return _tableView;
}

#pragma mark - 点击按钮的方法
- (void)manualBtnClink
{
    AddressModel *address =[[AddressModel alloc] init];
    [self.showArray addObject:address];
    [self manualBtnEnable];
    [self subViewFrameChange];
    [self.tableView reloadData];
}
- (void)addressBookBtnClink
{
    // 如果没有授权成功,直接返回
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized)
    {
        NSLog(@"没有获得访问通讯录的权限，请获取后再重试");
        return;
    }
    // 获得通讯录
    NSArray *addresses = [AddressModel getMyAddressBook];
    if (!addresses.count) {
        NSLog(@"您的手机没有联系人");
        return;
    }
    // 排序通讯录
    __weak typeof(self) weakSelf = self;
    [AddressModel reorderAddressArr:addresses orderBlock:^(NSMutableArray *indexArray, NSMutableArray *letterResultArr, NSMutableArray *sectionArray) {
        weakSelf.indexArray = indexArray;
        weakSelf.sectionArray = sectionArray;
        weakSelf.letterResultArr = letterResultArr;
    }];
    
    
    
    AddressViewController *vc = [[AddressViewController alloc] init];
    vc.sectionArray = self.sectionArray;
    vc.indexArray = self.indexArray;
    vc.selectArray = self.showArray;
    [vc finishSelect:^(NSMutableArray *selectArray) {
        self.showArray = selectArray;
        [self.tableView reloadData];
        [self subViewFrameChange];
        [self manualBtnEnable];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - tableView代理和数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return MAX(0, self.showArray.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactTableViewCell *cell = [ContactTableViewCell contactCellWithTableView:tableView];
    [cell editButtonClink:^(ContactTableViewCell *cell) {
        [cell removeFromSuperview];
        AddressModel *contact = cell.address;
        [self.showArray removeObject:contact];
        [self.tableView reloadData];
        [self subViewFrameChange];
        [self manualBtnEnable];
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.showArray.count) {
        AddressModel *address = self.showArray[indexPath.row];
        cell.address = address;
    }
    return cell;
}

#pragma mark - 其他方法
- (void)subViewFrameChange
{
    CGRect newFrame = self.tableView.frame;
    if (self.showArray.count > 0) {
        newFrame.size.height = 44 * self.showArray.count;
    }else{
        newFrame.size.height = 0;
    }
    self.tableView.frame = newFrame;
    CGFloat manualY = CGRectGetMaxY(self.tableView.frame) + 30;
    CGRect newManualFrame = self.manualBtn.frame;
    newManualFrame.origin.y = manualY;
    self.manualBtn.frame = newManualFrame;
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, (CGRectGetMaxY(self.manualBtn.frame) + 30));
}

- (void)manualBtnEnable
{
    if (self.showArray.count > 9) {
        self.manualBtn.enabled = NO;
    }else{
        self.manualBtn.enabled = YES;
    }
}


@end
