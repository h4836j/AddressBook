//
//  AddressModel.h
//  AddressBook
//
//  Created by HJ on 15/12/4.
//  Copyright © 2015年 HJ. All rights reserved.
//

#import <Foundation/Foundation.h>
//typedef void(^reduceBlock)(PickerAttibuteTableViewCell *cell);
/**
 *  通讯录排序后的回掉Block
 *
 *  @param indexArray      索引数组
 *  @param letterResultArr 原始序列数组，二维数组
 *  @param sectionArray    拆解重新组织后的模型数组，二维数组
 */
typedef void(^addressOrderBlock)(NSArray *indexArray, NSArray *letterResultArr, NSArray *sectionArray);
typedef void(^valueBlock)(NSArray *indexArray, NSArray *letterResultArr, NSArray *sectionArray);

@interface AddressModel : NSObject
/** 姓名 */
@property (copy, nonatomic) NSString *name;
/** 手机号码 */
@property (copy, nonatomic) NSString *mobileNumber;
@property (copy, nonatomic) NSString *mainNumber;
@property (copy, nonatomic) NSString *iponeNumber;

/**
 *  获取手机通讯录
 */
+ (NSArray *)getMyAddressBook;

/**
 *  将传递过来的通讯录数组安装姓名重新排序
 *
 *  @param addresses  通讯录数组
 *  @param orderBlock 回掉的block，第一个参数为索引数组，第二个为返回的原始序列数组，第三个为拆解重新组织后的模型数组，后面两个均为二维数组
 */
+ (void)reorderAddressArr:(NSArray *)addresses orderBlock:(void(^)(NSMutableArray *indexArray, NSMutableArray *letterResultArr, NSMutableArray *sectionArray))orderBlock;

+ (void)reorderAddressArr:(NSArray *)addresses order:(addressOrderBlock)orderBlock;
@end
