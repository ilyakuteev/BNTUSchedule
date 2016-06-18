//
//  IKTextFieldCell.h
//  BNTUSchedule
//
//  Created by Ilya Kuteev on 29.03.16.
//  Copyright © 2016 Илья Кутеев. All rights reserved.
//

@import UIKit;


@interface IKTextFieldCell : UITableViewCell
@property (nonatomic, weak, readonly) UILabel *titleLabel;
@property (nonatomic, weak, readonly) UITextField *textField;
@end
