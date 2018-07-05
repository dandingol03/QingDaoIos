//
//  OfficeListCellView.m
//  Templet
//
//  Created by 丁一明 on 2018/6/26.
//  Copyright © 2018年 丁一明. All rights reserved.
//

#import "OfficeListCellView.h"
#import "OfficeInfo.h"

#define ScreenWidth  CGRectGetWidth([UIScreen mainScreen].bounds)


@interface OfficeListCellView()
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *standField;
@property (strong, nonatomic) IBOutlet UITextField *univalentField;
@property (strong, nonatomic) IBOutlet UITextField *numberField;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;
@property (strong, nonatomic) IBOutlet UITextField *remarksField;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;


@property (strong, nonatomic) NSMutableArray* officeList;
@property (assign, nonatomic) NSInteger position;
@property (weak,nonatomic) UIView *mParent;
@property (strong,nonatomic) NSLayoutConstraint * topC;

@end

@implementation OfficeListCellView


-(void)passViewOfficeList:(NSMutableArray *)officeList position:(NSInteger)position parent:(id)parent
{
    self.officeList = officeList;
    self.position = position;
    self.mParent=parent;
    //设置约束
    self.translatesAutoresizingMaskIntoConstraints=NO;
    //leading约束
    [parent addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:parent attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    //trailing约束
    [parent addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:parent attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
    //top约束
    if(self.topC!=nil)
        [parent removeConstraint:self.topC];
    self.topC=[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:parent attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.position*210];
    [parent addConstraint:self.topC];
    
    //height约束
    [parent addConstraint: [NSLayoutConstraint constraintWithItem:self
                                                        attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:210]];

    if(position==0){
        self.frame = CGRectMake(0,0,SCREEN_WIDTH-40, 200);
    }else{
        self.frame = CGRectMake(10,self.position*210,SCREEN_WIDTH-40, 200);
    }
    
    //添加监听
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(updateFrameDelete:) name:@"officeListDelete" object:nil];
}


-(void)passViewOfficeList:(NSMutableArray *)officeList position:(NSInteger)position
{
    self.officeList = officeList;
    self.position = position;

    if(position==0){
        self.frame = CGRectMake(0,0,SCREEN_WIDTH-40, 200);
    }else{
        self.frame = CGRectMake(10,self.position*210,SCREEN_WIDTH-40, 200);
    }
    
    //添加监听
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(updateFrameDelete:) name:@"officeListDelete" object:nil];
}

-(void)setDefaultText:(OfficeInfo*)officeInfo{
    self.nameField.text =officeInfo.name;
    self.standField.text = officeInfo.standard;
    self.univalentField.text = officeInfo.univalent;
    self.numberField.text = officeInfo.number;
    self.moneyLabel.text = officeInfo.money;
    self.moneyLabel.text = officeInfo.money;
    self.remarksField.text = officeInfo.remarks;
}


-(void)updateFrameDelete:(NSNotification *)info
{
    NSInteger position = [info.object integerValue];
    if(position<self.position){
        self.position = self.position-1;
        //添加新的top约束
        if(self.topC!=nil)
            [self.mParent removeConstraint:self.topC];
        self.topC=[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.mParent attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.position*210];
        [self.mParent addConstraint:self.topC];
        self.frame = CGRectMake(10,self.position*210,SCREEN_WIDTH-40, 200);
    }
    NSLog(@"%f",self.frame.origin.y);
    NSLog(@"%f",self.deleteButton.frame.origin.y);
}

- (IBAction)showMoney:(UITextField*)sender {
    OfficeInfo* officeInfo = [self.officeList objectAtIndex:self.position];
    
    switch (sender.tag) {
        case 1:{
            officeInfo.name = self.nameField.text;
        }
            break;
        case 2:{
            officeInfo.standard = self.standField.text;
        }
            break;
        case 3:{
            float univalent = [self.univalentField.text floatValue];
            float number = [self.numberField.text floatValue];
            self.moneyLabel.text = [NSString stringWithFormat:@"%0.2f",univalent*number];
            officeInfo.univalent = self.univalentField.text;
            officeInfo.money = self.moneyLabel.text;
            [_delegate onNotifyMoneyChange];
        }
            break;
        case 4:{
            float univalent = [self.univalentField.text floatValue];
            float number = [self.numberField.text floatValue];
            self.moneyLabel.text = [NSString stringWithFormat:@"%0.2f",univalent*number];
            officeInfo.number = self.numberField.text;
            officeInfo.money = self.moneyLabel.text;
            [_delegate onNotifyMoneyChange];
        }
            break;
        case 5:{
            officeInfo.remarks = self.remarksField.text;
        }
            break;
      
        default:
            break;
    }

}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"officeListDelete" object:nil];
}


- (IBAction)deleteAction:(id)sender {
    [self.officeList removeObjectAtIndex:self.position];
    NSNumber* position = [NSNumber numberWithInteger:self.position];
    [self removeFromSuperview];
    [_delegate deleteOfficeListCell:self.position];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"officeListDelete" object:position];
}


@end
