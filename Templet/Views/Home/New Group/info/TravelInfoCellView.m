//
//  TravelInfoCellView.m
//  Templet
//
//

#import "TravelInfoCellView.h"
#import "TravelInfo.h"
#define ScreenWidth  CGRectGetWidth([UIScreen mainScreen].bounds)

@interface TravelInfoCellView()

@property (nonatomic, assign) NSString* type;//出差类别
@property (strong, nonatomic) IBOutlet UIImageView *isVolunteerImag_y;//自发
@property (strong, nonatomic) IBOutlet UIButton *volunteerBtn;
@property (strong, nonatomic) IBOutlet UIImageView *isCultivateImag_n;//培训
@property (strong, nonatomic) IBOutlet UIButton *cultivateBtn;
@property (strong, nonatomic) IBOutlet UIImageView *isMeetingImag_n;//开会
@property (strong, nonatomic) IBOutlet UIButton *meetingBtn;
@property (strong, nonatomic) IBOutlet UIImageView *isCountryImag_n;//培训
@property (strong, nonatomic) IBOutlet UIButton *countryBtn;

@property (weak, nonatomic) IBOutlet UITextField *b_number;
@property (weak, nonatomic) IBOutlet UITextField *w_number;

@property (weak, nonatomic) IBOutlet UITextField *content;

@property (weak, nonatomic) IBOutlet UILabel *go_time;
@property (weak, nonatomic) IBOutlet UILabel *back_time;



@property (nonatomic, assign) NSString *jt_tools;//出发工具

@property (strong, nonatomic) IBOutlet UIImageView *jt_car_imag_y;//汽车
@property (strong, nonatomic) IBOutlet UIButton *jtCarBtn;
@property (strong, nonatomic) IBOutlet UIImageView *jt_train_Imag_n;//火车
@property (strong, nonatomic) IBOutlet UIButton *jtTrainBtn;
@property (strong, nonatomic) IBOutlet UIImageView *jt_plane_Imag_n;//飞机
@property (strong, nonatomic) IBOutlet UIButton *jtPlaneBtn;

@property (nonatomic, assign) NSString *fh_tools;//返回工具
@property (strong, nonatomic) IBOutlet UIImageView *fh_car_imag_y;//汽车
@property (strong, nonatomic) IBOutlet UIButton *fhCarBtn;
@property (strong, nonatomic) IBOutlet UIImageView *fh_train_Imag_n;//火车
@property (strong, nonatomic) IBOutlet UIButton *fhTrainBtn;
@property (strong, nonatomic) IBOutlet UIImageView *fh_plane_Imag_n;//飞机
@property (strong, nonatomic) IBOutlet UIButton *fhPlaneBtn;

@property (nonatomic, assign) NSString *zs_jd;//食宿自理
@property (strong, nonatomic) IBOutlet UIImageView *zs_jd_imag_y;
@property (strong, nonatomic) IBOutlet UIButton *zsJdYesBtn;
@property (strong, nonatomic) IBOutlet UIImageView *zs_jd_Imag_n;
@property (strong, nonatomic) IBOutlet UIButton *zsJdNoBtn;

@property (nonatomic, assign) NSString *sendCar;//是否派车
@property (strong, nonatomic) IBOutlet UIImageView *send_car_imag;
@property (strong, nonatomic) IBOutlet UIButton *sendCarBtn;
@property (strong, nonatomic) IBOutlet UIImageView *go_alone_Imag;
@property (strong, nonatomic) IBOutlet UIButton *goAloneBtn;
@property (strong, nonatomic) IBOutlet UIImageView *rent_car_Imag;
@property (strong, nonatomic) IBOutlet UIButton *rentCarBtn;
@property (strong, nonatomic) IBOutlet UIImageView *pickup_else_Imag;
@property (strong, nonatomic) IBOutlet UIButton *pickupElseBtn;

@property (weak, nonatomic) IBOutlet UITextField *remarks;
@property (weak, nonatomic) IBOutlet UITextField *fare;
@property (weak, nonatomic) IBOutlet UITextField *ht_money;
@property (weak, nonatomic) IBOutlet UITextField *jt_money;
@property (weak, nonatomic) IBOutlet UITextField *zs_money;
@property (weak, nonatomic) IBOutlet UITextField *hs_money;
@property (weak, nonatomic) IBOutlet UITextField *qt_money;
@property (weak, nonatomic) IBOutlet UITextField *all_money;


@property (strong, nonatomic) NSMutableArray* travelList;
@property (assign, nonatomic) NSInteger position;
@property (weak,nonatomic) UIView *mParent;
@property (strong,nonatomic) NSLayoutConstraint * topC;

@end


@implementation TravelInfoCellView


-(void)passViewOfficeList:(NSMutableArray *)travels position:(NSInteger)position parent:(id)parent
{
    self.travelList = travels;
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
    self.topC=[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:parent attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.position*990];
    [parent addConstraint:self.topC];
    
    //height约束
    [parent addConstraint: [NSLayoutConstraint constraintWithItem:self
                                                        attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:990]];
    
    if(position==0){
        self.frame = CGRectMake(0,0,SCREEN_WIDTH-40, 990);
    }else{
        self.frame = CGRectMake(10,self.position*100,SCREEN_WIDTH-40, 990);
    }
    
    //添加监听
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(updateFrameDelete:) name:@"TravelItemDelete" object:nil];
}



-(void)setDefaultText:(TravelInfo*) travelInfo{
    self.type=travelInfo.type;
    self.go_time.text=travelInfo.go_time;
    self.back_time.text=travelInfo.back_time;
    self.jt_tools=travelInfo.jt_tools;
    self.fh_tools=travelInfo.fh_tools;
    self.content.text=travelInfo.content;
    self.b_number.text=[NSString stringWithFormat:@"%d",travelInfo.b_number];
    
    self.w_number.text=[NSString stringWithFormat:@"%d",travelInfo.w_number];
    self.zs_jd=travelInfo.zs_jd;
    self.sendCar=travelInfo.sendCar;
    self.remarks.text=travelInfo.remarks;
    self.fare.text=[NSString stringWithFormat:@"%.2f",travelInfo.fare];
    self.ht_money.text=[NSString stringWithFormat:@"%.2f",travelInfo.ht_money];
    self.jt_money.text=[NSString stringWithFormat:@"%.2f",travelInfo.jt_money];
    self.zs_money.text=[NSString stringWithFormat:@"%.2f",travelInfo.zs_money];
    self.hs_money.text=[NSString stringWithFormat:@"%.2f",travelInfo.hs_money];
    self.qt_money.text=[NSString stringWithFormat:@"%.2f",travelInfo.qt_money];
    self.all_money.text=[NSString stringWithFormat:@"%.2f",travelInfo.all_money];
    
}


-(void)updateFrameDelete:(NSNotification *)info
{
    NSInteger position = [info.object integerValue];
    if(position<self.position){
        self.position = self.position-1;
        //添加新的top约束
        if(self.topC!=nil)
            [self.mParent removeConstraint:self.topC];
        self.topC=[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.mParent attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.position*990];
        [self.mParent addConstraint:self.topC];
        self.frame = CGRectMake(10,self.position*100,SCREEN_WIDTH-40, 990);
    }
    NSLog(@"%f",self.frame.origin.y);
}

- (IBAction)onEditChange:(UITextField*)sender {
    TravelInfo* travelInfo = [self.travelList objectAtIndex:self.position];
    
    switch (sender.tag) {
        case 1:{
            travelInfo.b_number =@([self.b_number.text intValue]);
        }
            break;
        case 2:{
            travelInfo.w_number = @([self.w_number.text intValue]);
        }
            break;
        case 3:{
            travelInfo.content=self.content.text;
        }
            break;
        case 4:{
            travelInfo.remarks=self.remarks.text;
        }
        case 5:{
            travelInfo.fare =@([self.fare.text doubleValue]);
        }
            break;
        case 6:{
            travelInfo.ht_money=@([self.ht_money.text doubleValue]);
        }
            break;
        case 7:{
        travelInfo.jt_money=@([self.jt_money.text doubleValue]);
        }
            break;
        case 8:
        {
            travelInfo.zs_money=@([self.zs_money.text doubleValue]);
        }
            break;
        case 9:{
            travelInfo.hs_money=@([self.hs_money.text doubleValue]);
        }
            break;
        case 10:{
        travelInfo.qt_money=@([self.qt_money.text doubleValue]) ;
        }
        
        default:
            break;
    }
    
}



-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TravelItemDelete" object:nil];
}


- (IBAction)deleteAction:(id)sender {
    [self.travelList removeObjectAtIndex:self.position];
    NSNumber* position = [NSNumber numberWithInteger:self.position];
    [self removeFromSuperview];
    [_delegate deleteTravelItem:self.position];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TravelItemDelete" object:position];
}


@end
