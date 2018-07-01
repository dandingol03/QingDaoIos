//
//  CCBaseTableViewCell.m
//  CCTableDataSourceDemo
//
//  Created by eHome on 17/2/15.
//  Copyright © 2017年 brefChan. All rights reserved.
//

#import "CCBaseTableViewCell.h"
#import "UIView+CCUtil.h"

@implementation CCBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)cellHeightForData:(id)data
{
    return [self cell:nil bindData:data];
}



+ (CGFloat)cell:(CCBaseTableViewCell *)cell bindData:(id)data
{
    if (cell && [data isKindOfClass:[NSString class]]) {
        cell.textLabel.text = data;
    }
    
    return 44.0f;
}

- (void)bindData:(id)data
{
    [[self class] cell:self bindData:data];
}

- (void)cellWillDisplayByData:(id)data
{

}

- (void)cellDidEndDisplayByData:(id)data
{
    
}


//-(HangQingGetSymbolDeptListInfo *)getSymbolInfoWithKey:(NSString *)key name:(NSString *)name{
//    NSArray *array = [AppDelegate shareDelegate].dataStore.symbolArray;
//    for (int i = 0; i < array.count; i++) {
//        HangQingGetSymbolDeptListInfo *info = [array objectAtIndex:i];
//        if ([key hasNonWhitespaceText]) {
//            if ([info.key isEqualToString:key]) {
//                return info;
//                break;
//            }
//        }
//        if ([name hasNonWhitespaceText]) {
//            if ([info.name isEqualToString:name]) {
//                return info;
//                break;
//            }
//        }
//    }
//    return nil;
//}

//+ (CGFloat)dynamicCellHeightForStaticCell:(CCBaseTableViewCell *)cell data:(id)data cellClass:(Class)cellClass tableViewWidth:(CGFloat)width fromXib:(BOOL)isFromXib
//{
//    if (!cell) {
//        if (isFromXib) {
//            cell = [cellClass viewFromXib];
//        }else
//        {
//            cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(cellClass)];
//        }
//    }
//    
//    [cell bindData:data];
//    
//    cell.bounds = CGRectMake(0.f, 0.f, width, CGRectGetHeight(cell.bounds));
//    
//    [cell setNeedsLayout];
//    [cell layoutIfNeeded];
//    
//    [cell.contentView setNeedsLayout];
//    [cell.contentView layoutIfNeeded];
//    
//    for (UIView *subView in cell.contentView.subviews) {
//        if ([subView isKindOfClass:[UILabel class]]) {
//            UILabel *subLabel = (UILabel *)subView;
//            subLabel.preferredMaxLayoutWidth = CGRectGetWidth(subLabel.bounds);
//        }
//    }
//    
//    
//    
//    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    
//    height += 1;
//    
//    return height;
//}




@end
