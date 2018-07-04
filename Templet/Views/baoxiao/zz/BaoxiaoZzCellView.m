//
//  BaoxiaoZzCellView.m
//  Templet
//
//

#import "BaoxiaoZzCellView.h"
#import "BaoxiaoZz.h"
#define ScreenWidth  CGRectGetWidth([UIScreen mainScreen].bounds)

@interface BaoxiaoZzCellView()

@property (strong, nonatomic) NSMutableArray* zzList;
@property (assign, nonatomic) NSInteger position;
@property (weak,nonatomic) UIView *mParent;
@property (strong,nonatomic) NSLayoutConstraint * topC;
@property (weak, nonatomic) IBOutlet UITextField *amount;
@property (weak, nonatomic) IBOutlet UITextField *bankNum;
@property (weak, nonatomic) IBOutlet UITextField *bankName;

@end

@implementation BaoxiaoZzCellView


-(void)passViewOfficeList:(NSMutableArray *)zzList position:(NSInteger)position parent:(id)parent
{
    self.zzList = zzList;
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
    self.topC=[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:parent attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.position*100];
    [parent addConstraint:self.topC];
    
    //height约束
    [parent addConstraint: [NSLayoutConstraint constraintWithItem:self
                                                        attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:100]];
    
    if(position==0){
        self.frame = CGRectMake(0,0,SCREEN_WIDTH-40, 100);
    }else{
        self.frame = CGRectMake(10,self.position*100,SCREEN_WIDTH-40, 100);
    }
    
    //添加监听
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(updateFrameDelete:) name:@"BaoxiaoOfficeDelete" object:nil];
}


-(void)passViewOfficeList:(NSMutableArray *)zzList position:(NSInteger)position
{
    self.zzList = zzList;
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

-(void)setDefaultText:(BaoxiaoZz*) zzInfo{
    self.amount.text =zzInfo.amount;
    self.bankNum.text = zzInfo.bankNum;
    self.bankName.text = zzInfo.bankName;
}


-(void)updateFrameDelete:(NSNotification *)info
{
    NSInteger position = [info.object integerValue];
    if(position<self.position){
        self.position = self.position-1;
        //添加新的top约束
        if(self.topC!=nil)
            [self.mParent removeConstraint:self.topC];
        self.topC=[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.mParent attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.position*100];
        [self.mParent addConstraint:self.topC];
        self.frame = CGRectMake(10,self.position*100,SCREEN_WIDTH-40, 100);
    }
    NSLog(@"%f",self.frame.origin.y);
}


- (IBAction)showMoney:(UITextField*)sender {
    
    BaoxiaoZz* info = [self.zzList objectAtIndex:self.position];

    switch (sender.tag) {
        case 1:{
            info.amount = self.amount.text;
        }
            break;
        case 2:{
            info.bankNum = self.bankNum.text;
        }
            break;
        case 3:{
            info.bankName = self.bankName.text;
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
    [self.zzList removeObjectAtIndex:self.position];
    NSNumber* position = [NSNumber numberWithInteger:self.position];
    [self removeFromSuperview];
    [_delegate deleteZzItem:self.position];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BaoxiaoOfficeDelete" object:position];
}


@end
