//
//  TodoListTableViewCell.m
//  Templet
//
//  Created by 丁一明 on 2018/6/18.
//  Copyright © 2018年 丁一明. All rights reserved.
//

#import "TodoListTableViewCell.h"

@interface TodoListTableViewCell()
@property (strong, nonatomic) IBOutlet UIView *cellView;
@property (strong, nonatomic) IBOutlet UILabel *feeLabel;
@property (strong, nonatomic) IBOutlet UILabel *departmentLabel;
@property (strong, nonatomic) IBOutlet UILabel *applyPersonLabel;
@property (strong, nonatomic) IBOutlet UILabel *applyTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation TodoListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [super awakeFromNib];
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, 180);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *selectedColor = [UIColor colorWithWhite:1 alpha:0.1];
    CGContextSetFillColorWithColor(context, [selectedColor CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.selectedBackgroundView = [[UIImageView alloc] initWithImage:image];
    
    self.cellView.layer.cornerRadius = 8;
    self.cellView.layer.masksToBounds = YES;
    
}

+ (CGFloat)cellHeightForData:(id)data
{
    return 180;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
