//
//  ContactTableViewCell.h
//  通讯录
//
//  Created by HJ on 15/12/5.
//  Copyright © 2015年 HJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContactTableViewCell;
@class AddressModel;

typedef void(^editBlock)(ContactTableViewCell *cell);

@protocol ContactTableViewCellDelegate <NSObject>

@optional
/**
 *  点击了cell后面的按钮时调用的方法
 */
- (void)contactTableViewCell:(ContactTableViewCell *)tableViewCell didClinkedEditButton:(UIButton *)button;
- (void)contactTableViewCell:(ContactTableViewCell *)tableViewCell didClinkedEditButton:(UIButton *)button contactInfo:(NSString *)info;

@end

@interface ContactTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) id<ContactTableViewCellDelegate> delegate;
/** 通讯录联系人模型 */
@property (strong, nonatomic) AddressModel *address;
+ (instancetype)contactCellWithTableView:(UITableView *)tableView;
- (void)editButtonClink:(editBlock)edit;
@end
