 //
//  SAAutocompleteTextField.m
//  School Assistant
//
//  Created by Илья Кутеев on 12.07.15.
//  Copyright (c) 2015 Илья Кутеев. All rights reserved.
//

#import "IKAutocompleteCell.h"

static CGFloat const SASuggestionsTableViewHeight = 44 * 3;

@interface IKAutocompleteCell () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, getter=isShown) BOOL shown;
@end


@implementation IKAutocompleteCell

#pragma mark - Initialization

-(instancetype)init
{
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self commonInit];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self commonInit];
}

-(void)commonInit
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView insertSubview:tableView atIndex:0];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:0 metrics:nil views:@{@"tableView" : tableView}]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableView]-0-|" options:0 metrics:nil views:@{@"tableView" : tableView}]];
    [self.contentView layoutIfNeeded];
    
    self.tableView = tableView;
}

#pragma mark - Getters&Setters

-(void)setTextField:(UITextField *)textField
{
    if (!_textField && textField) {
        [textField addTarget:self action:@selector(editingDidBegin) forControlEvents:UIControlEventEditingDidBegin];
        [textField addTarget:self action:@selector(editingChanged) forControlEvents:UIControlEventEditingChanged];
        [textField addTarget:self action:@selector(editingDidEnd) forControlEvents:UIControlEventEditingDidEnd];
    } else if (_textField && !textField) {
        [_textField removeTarget:self action:@selector(editingDidBegin) forControlEvents:UIControlEventEditingDidBegin];
        [_textField removeTarget:self action:@selector(editingChanged) forControlEvents:UIControlEventEditingChanged];
        [_textField removeTarget:self action:@selector(editingDidEnd) forControlEvents:UIControlEventEditingDidEnd];
    }
    _textField = textField;
}

-(void)setShown:(BOOL)shown
{
    if (shown == _shown) return;
    _shown = shown;
    self.prefferedHeight = _shown ? SASuggestionsTableViewHeight : 0;
    [self.delegate autocompleteCellDidChangeHeight:self];
}

#pragma mark - Target Actions

-(void)editingDidBegin
{
    self.shown = YES;
}

-(void)editingChanged
{
    [self.tableView reloadData];
    if (!self.shown && [self filteredSuggestions].count) {
        self.shown = YES;
    } else if (self.shown && ![self filteredSuggestions].count) {
        self.shown = NO;
    }
}

-(void)editingDidEnd
{
    self.shown = NO;
}

#pragma mark - UITableViewDataSource&Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self filteredSuggestions].count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor colorWithWhite:61.f/255.f alpha:1.0];
    }
    cell.textLabel.text = [self filteredSuggestions][indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.textField.text = cell.textLabel.text;
    [self.textField sendActionsForControlEvents:UIControlEventEditingChanged];
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self.textField];
    self.shown = NO;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSMutableArray *suggestions = self.suggestions.mutableCopy;
        [suggestions removeObject:cell.textLabel.text];
        self.suggestions = suggestions.copy;
        
        if ([self.delegate respondsToSelector:@selector(autocompleteCell:didDeleteWord:)]) {
            [self.delegate autocompleteCell:self didDeleteWord:cell.textLabel.text];
        }
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark -

-(NSArray<NSString *> *)filteredSuggestions
{
    NSArray *filteredSuggestions;
    if (self.textField.text.length) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[cd] %@", self.textField.text];
        filteredSuggestions = [NSArray arrayWithArray:[self.suggestions filteredArrayUsingPredicate:predicate]];
    } else {
        filteredSuggestions = self.suggestions;
    }
    return [filteredSuggestions sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 localizedStandardCompare:obj2];
    }];
}

@end
