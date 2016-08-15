//
//  ContactTableViewCell.m
//  通讯录
//
//  Created by HJ on 15/12/5.
//  Copyright © 2015年 HJ. All rights reserved.
//

#import "ContactTableViewCell.h"
#import "AddressModel.h"

@interface ContactTableViewCell ()<UITextFieldDelegate>
{
    editBlock edited;
}
- (IBAction)editBtn:(UIButton *)sender;

@end

@implementation ContactTableViewCell

+ (instancetype)contactCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactTableViewCell" owner:nil options:nil] firstObject];
    }
    cell.nameText.delegate = cell;
    return cell;
    
}

- (void)awakeFromNib {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textValueChange:) name:UITextFieldTextDidChangeNotification object:self.nameText];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)editBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(contactTableViewCell:didClinkedEditButton:)]) {
        [self.delegate contactTableViewCell:self didClinkedEditButton:nil];
    }
    if (edited) {
        edited(self);
    }
}

- (void)setAddress:(AddressModel *)address
{
    _address = address;
    if (address.name.length && address.mobileNumber.length) {
        NSString *name = [NSString stringWithFormat:@"%@  %@",address.name, address.mobileNumber];
        self.nameText.text = name;
    } else if (address.mobileNumber.length){
        NSString *name = [NSString stringWithFormat:@"%@",address.mobileNumber];
        self.nameText.text = name;
    }
    
}

- (void)textValueChange:(NSNotification *)notification
{
    UITextField *textField = notification.object;
    
    id ce = [textField superview];
    ContactTableViewCell *cell = (ContactTableViewCell *)[ce superview];
    AddressModel *model = cell.address;
    
    model.mobileNumber = textField.text;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    AddressModel *model = self.address;
    model.mobileNumber = textField.text;
}

- (void)editButtonClink:(editBlock)edit
{
    edited = edit;
}

@end
