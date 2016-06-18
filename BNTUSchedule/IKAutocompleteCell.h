//
//  SAAutocompleteTextField.h
//  School Assistant
//
//  Created by Илья Кутеев on 12.07.15.
//  Copyright (c) 2015 Илья Кутеев. All rights reserved.
//

@import UIKit;
@class IKAutocompleteCell;


@protocol IKAutocompleteCellDelegate <NSObject>
@required
-(void)autocompleteCellDidChangeHeight:(IKAutocompleteCell *)cell;
@optional
-(void)autocompleteCell:(IKAutocompleteCell *)cell didDeleteWord:(NSString *)work;
@end


@interface IKAutocompleteCell : UITableViewCell
@property (nonatomic) CGFloat prefferedHeight;
@property (nonatomic, weak) id<IKAutocompleteCellDelegate> delegate;
@property (nonatomic, weak) UITextField *textField;
@property (nonatomic) NSArray *suggestions;
@end
