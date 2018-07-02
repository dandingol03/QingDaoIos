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

@end

@implementation OfficeListCellView

-(void)passViewOfficeList:(NSMutableArray *)officeList position:(NSInteger)position
{
    self.officeList = officeList;
    self.position = position;
    if(position==0){
        self.frame = CGRectMake(0,0,SCREEN_WIDTH-40, 200);
    }else{
        self.frame = CGRectMake(10,self.position*210,SCREEN_WIDTH-40, 200);
    }
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(updateFrameDelete:) name:@"officeListDelete" object:nil];
}

-(void)setDefaultText:(OfficeInfo*)officeInfo{
    self.nameField.text =officeInfo.name;
    self.standField.text = officeInfo.stand;
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
            officeInfo.stand = self.standField.text;
        }
            break;
        case 3:{
            float univalent = [self.univalentField.text floatValue];
            float number = [self.numberField.text floatValue];
            self.moneyLabel.text = [NSString stringWithFormat:@"%0.2f",univalent*number];
            officeInfo.univalent = self.univalentField.text;
            officeInfo.money = self.moneyLabel.text;
        }
            break;
        case 4:{
            float univalent = [self.univalentField.text floatValue];
            float number = [self.numberField.text floatValue];
            self.moneyLabel.text = [NSString stringWithFormat:@"%0.2f",univalent*number];
            officeInfo.number = self.numberField.text;
            officeInfo.money = self.moneyLabel.text;
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
