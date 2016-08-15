//
//  AddressViewController.h
//  addressBook
//
//  Created by HJ on 16/3/2.
//  Copyright © 2016年 HJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectBlock)(NSMutableArray *selectArray);

@interface AddressViewController : UIViewController
@property (strong, nonatomic) NSMutableArray *contactArray;
/**
 *  索引数组
 */
@property(nonatomic,strong)NSMutableArray *indexArray;
/**
 *  所有联系人的综合模型数组集合
 */
@property (strong, nonatomic) NSMutableArray *sectionArray;
/**
 *  选中的模型数组
 */
@property (strong, nonatomic) NSMutableArray *selectArray;

- (void)finishSelect:(selectBlock)select;
@end
