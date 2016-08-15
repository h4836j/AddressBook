//
//  AddressBookCell.m
//  通讯录
//
//  Created by HJ on 15/12/7.
//  Copyright © 2015年 HJ. All rights reserved.
//

#import "AddressBookCell.h"
#import "AddressModel.h"
//#import "UIView+Layout.h"

@interface AddressBookCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
- (IBAction)choose:(UIButton *)sender;


@end

@implementation AddressBookCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    AddressBookCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AddressBookCell" owner:nil options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAddress:(AddressModel *)address
{
    _address = address;
    self.nameLabel.text = address.name;
    self.phoneLabel.text = address.mobileNumber;
}

- (IBAction)choose:(UIButton *)sender {
    self.selectBtn.selected = !self.selectBtn.isSelected;
    if ([self.delegate respondsToSelector:@selector(addressCell:dicClinkedButton:)]) {
        [self.delegate addressCell:self dicClinkedButton:sender];
    }
}
@end
