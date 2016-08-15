//
//  AddressModel.m
//  AddressBook
//
//  Created by HJ on 15/12/4.
//  Copyright © 2015年 HJ. All rights reserved.
//

#import "AddressModel.h"
#import <AddressBook/AddressBook.h>
#import "ChineseString.h"

@implementation AddressModel

- (BOOL)isEqual:(AddressModel *)other
{
//    NSLog(@"name-%@---otherName--%@",self.name, other.name);
//    NSLog(@"mobileNumber-%@---otherMobileNumber--%@",self.mobileNumber, other.mobileNumber);
    return [self.name isEqualToString:other.name] && [self.mobileNumber isEqualToString:other.mobileNumber];
}

+ (NSArray *)getMyAddressBook
{
    // 如果没有授权成功,直接返回
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) return nil;
    
    // 1.创建通讯录实例
    ABAddressBookRef book = ABAddressBookCreateWithOptions(NULL, NULL);
    
    // 2.获得通讯录中的所有联系人
    
    // CFArrayRef, Core Foundation, C语言
    // NSArray *, Foundation, OC语言
    // 两个框架之间的数据类型要转换, 需要用到"桥接"技术
    NSArray *allPeopole = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(book);
    
    NSMutableArray *addressArr = [NSMutableArray array];
    // 3.遍历数组中的所有联系人
    for (int i = 0; i < allPeopole.count; i++) {
        // 获得i位置的1条联系人的信息
        ABRecordRef record = (__bridge ABRecordRef)(allPeopole[i]);
        // 姓
        NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(record, kABPersonLastNameProperty));
        // 名
        NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(record, kABPersonFirstNameProperty));
        AddressModel *address = [[AddressModel alloc] init];
        NSString *phoneNumber = @"";
        // 联系电话（是一个数组）
        ABMultiValueRef phone = ABRecordCopyValue(record, kABPersonPhoneProperty);
        NSArray *phoneArr = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(phone);
        // 遍历联系电话数组
        for (int i = 0; i < phoneArr.count; i++) {
            phoneNumber = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, i);
            if (phoneNumber.length > 4) { // 判断长度看是不是手机号码
                address.mobileNumber = phoneNumber;
                // 结束本次循环，继续下一次
                continue;
            }
        }
        // 拼接姓名，并且同时排除为空的情况
        if (address.mobileNumber.length > 4) {
            NSString *lastN = (lastName.length > 0) ? lastName : @"";
            NSString *firstN = (firstName.length > 0) ? firstName : @"";
            address.name = [NSString stringWithFormat:@"%@%@",lastN, firstN];
            [addressArr addObject:address];
        }
    }
    // 释放资源
    CFRelease(book);
    return addressArr;
    
    
    
//    AddressTableViewController *vc = [[AddressTableViewController alloc] init];
//    vc.sectionArray = self.sectionArray;
//    vc.indexArray = self.indexArray;
//    vc.selectArray = self.showArray;
//    vc.delegate = self;
//    [self.navigationController pushViewController:vc animated:YES];
//    return nil;
}

- (NSArray *)test2:(NSArray *)arr
{
    if (!arr.count) return nil;
    NSMutableArray *mutableAdress = [NSMutableArray array];
    for (id model in arr) {
        if ([model isKindOfClass:[AddressModel class]]) {
            AddressModel *address = (AddressModel *)model;
            NSString *phoneName = [NSString stringWithFormat:@"%@--%@",address.name, address.mobileNumber];
            [mutableAdress addObject:phoneName];
        }
    }
    // 使用联系人信息生成分组索引的顶部标题数组
    NSMutableArray *indexArray = [NSMutableArray array];
    indexArray = [ChineseString IndexArray:mutableAdress];
    // 使用联系人信息生成索引排序数组（二维数组）
    NSMutableArray *letterResultArr = [NSMutableArray array];
    letterResultArr = [ChineseString LetterSortArray:mutableAdress];
    // 排序后的二维联系人数组
    NSMutableArray *sectionArray = [NSMutableArray array];
    // 遍历所有分组（二维数组），取出每个分组下面的数组
    for (int i = 0; i < letterResultArr.count; i++) {
        NSArray *group = letterResultArr[i];
        // 各分组的联系人数组
        NSMutableArray *groupArray = [NSMutableArray arrayWithCapacity:1];
        // 遍历各分组中的数组，截取联系人信息，转成模型数据
        for (NSString *phoneName in group) {
            // 根据前面自己添加的特殊字符串拆分成数组
            NSArray *contace = [phoneName componentsSeparatedByString:@"--"];
            if (contace.count >1) {
                AddressModel *address = [[AddressModel alloc] init];
                address.name = contace[0];
                address.mobileNumber = contace[1];
                [groupArray addObject: address];
            }
        }
        [sectionArray addObject:groupArray];
    }
    
    return sectionArray;
}

+ (void)reorderAddressArr:(NSArray *)addresses orderBlock:(void(^)(NSMutableArray *indexArray, NSMutableArray *letterResultArr, NSMutableArray *sectionArray))orderBlock
{
    if (!addresses.count) {
        orderBlock(nil, nil, nil);
        return;
    }
    NSMutableArray *mutableAdress = [NSMutableArray array];
    for (id model in addresses) {
        if ([model isKindOfClass:[AddressModel class]]) {
            AddressModel *address = (AddressModel *)model;
            NSString *phoneName = [NSString stringWithFormat:@"%@--%@",address.name, address.mobileNumber];
            [mutableAdress addObject:phoneName];
        }
    }
    // 使用联系人信息生成分组索引的顶部标题数组
    NSMutableArray *indexArray = [NSMutableArray array];
    indexArray = [ChineseString IndexArray:mutableAdress];
    // 使用联系人信息生成索引排序数组（二维数组）
    NSMutableArray *letterResultArr = [NSMutableArray array];
    letterResultArr = [ChineseString LetterSortArray:mutableAdress];
    // 排序后的二维联系人数组
    NSMutableArray *sectionArray = [NSMutableArray array];
    // 遍历所有分组（二维数组），取出每个分组下面的数组
    for (int i = 0; i < letterResultArr.count; i++) {
        NSArray *group = letterResultArr[i];
        // 各分组的联系人数组
        NSMutableArray *groupArray = [NSMutableArray arrayWithCapacity:1];
        // 遍历各分组中的数组，截取联系人信息，转成模型数据
        for (NSString *phoneName in group) {
            // 根据前面自己添加的特殊字符串拆分成数组
            NSArray *contace = [phoneName componentsSeparatedByString:@"--"];
            if (contace.count >1) {
                AddressModel *address = [[AddressModel alloc] init];
                address.name = contace[0];
                address.mobileNumber = contace[1];
                [groupArray addObject: address];
            }
        }
        [sectionArray addObject:groupArray];
    }
    
    orderBlock(indexArray, letterResultArr, sectionArray);
}

+ (void)reorderAddressArr:(NSArray *)addresses order:(addressOrderBlock)orderBlock
{

}

@end
