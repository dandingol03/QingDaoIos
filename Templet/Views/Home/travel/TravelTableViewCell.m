//
//  OfficeMainTableViewCell.m
//  Templet
//
//  Created by 丁一明 on 2018/6/12.
//  Copyright © 2018年 丁一明. All rights reserved.
//

#import "TravelTableViewCell.h"
#import "BusinessApplyInfo.h"
#import "OfficeListDetailViewController.h"

@interface TravelTableViewCell()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *feeLabel;
@property (strong, nonatomic) IBOutlet UILabel *applyTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *stateLabel;

@property (strong, nonatomic) IBOutlet UIView *cellView;
@property (strong, nonatomic) IBOutlet UILabel *expandTypeLabel;

@property (strong, nonatomic) NSString *expendId;
@end



@implementation TravelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, 109);
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

- (void)bindData:(BusinessApplyInfo *)data
{
    self.titleLabel.text = data.internalName;
    self.expandTypeLabel.text = data.expendType;
    self.applyTimeLabel.text = data.createTime;
    self.stateLabel.text = data.state;
    self.expendId = data.expendId;
    
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
