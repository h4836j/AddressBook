//
//  AddressBookCell.h
//  通讯录
//
//  Created by HJ on 15/12/7.
//  Copyright © 2015年 HJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddressModel;
@class AddressBookCell;

@protocol AddressBookCellDelegate <NSObject>

@optional
- (void)addressCell:(AddressBookCell *)cell dicClinkedButton:(UIButton *)btn;


@end

@interface AddressBookCell : UITableViewCell

@property (strong, nonatomic) AddressModel *address;

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) id<AddressBookCellDelegate> delegate;
@end
