//
//  OfficeListCellView.m
//  Templet
//
//

#import "BaoxiaoOfficeCellView.h"
#import "BaoxiaoOffice.h"

#define ScreenWidth  CGRectGetWidth([UIScreen mainScreen].bounds)

@interface BaoxiaoOfficeCellView()
@property (weak, nonatomic) IBOutlet UITextField *reimbName;
@property (weak, nonatomic) IBOutlet UITextField *number;
@property (weak, nonatomic) IBOutlet UITextField *amount;

@property (strong, nonatomic) NSMutableArray* officeList;
@property (assign, nonatomic) NSInteger position;
@property (weak,nonatomic) UIView *mParent;
@property (strong,nonatomic) NSLayoutConstraint * topC;

@end

@implementation BaoxiaoOfficeCellView


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
    self.topC=[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:parent attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.position*60];
    [parent addConstraint:self.topC];
    
    //height约束
    [parent addConstraint: [NSLayoutConstraint constraintWithItem:self
                                                        attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:60]];

    if(position==0){
        self.frame = CGRectMake(0,0,SCREEN_WIDTH-40, 60);
    }else{
        self.frame = CGRectMake(10,self.position*60,SCREEN_WIDTH-40, 60);
    }
    
    //添加监听
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(updateFrameDelete:) name:@"BaoxiaoOfficeDelete" object:nil];
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
    [center addObserver:self selector:@selector(updateFrameDelete:) name:@"BaoxiaoOfficeDelete" object:nil];
}

-(void)setDefaultText:(BaoxiaoOffice*) info{
    self.reimbName.text =info.reimbName;
    self.number.text = info.number;
    self.amount.text = info.amount;
}


-(void)updateFrameDelete:(NSNotification *)info
{
    NSInteger position = [info.object integerValue];
    if(position<self.position){
        self.position = self.position-1;
        //添加新的top约束
        if(self.topC!=nil)
            [self.mParent removeConstraint:self.topC];
        self.topC=[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.mParent attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.position*60];
        [self.mParent addConstraint:self.topC];
        self.frame = CGRectMake(10,self.position*60,SCREEN_WIDTH-40, 60);
    }
    NSLog(@"%f",self.frame.origin.y);
}

- (IBAction)showMoney:(UITextField*)sender {
    BaoxiaoOffice* info = [self.officeList objectAtIndex:self.position];
    
    switch (sender.tag) {
        case 2:{
            info.reimbName = self.reimbName.text;
        }
            break;
        case 3:{
            info.number = self.number.text;
            [_delegate onNotifyChange];
            
        }
            break;
        case 4:{
            info.amount = self.amount.text;
            [_delegate onNotifyChange];
        }
            break;
      
        default:
            break;
    }

}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BaoxiaoOfficeDelete" object:nil];
}


- (IBAction)deleteAction:(id)sender {
    [self.officeList removeObjectAtIndex:self.position];
    NSNumber* position = [NSNumber numberWithInteger:self.position];
    [self removeFromSuperview];
    [_delegate deleteOfficeListCell:self.position];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BaoxiaoOfficeDelete" object:position];
}


@end
