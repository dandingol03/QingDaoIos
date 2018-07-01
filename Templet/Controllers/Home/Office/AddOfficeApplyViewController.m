//
//  AddOfficeApplyViewController.m
//  Templet
//

#import "AddOfficeApplyViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "OfficeInfo.h"
#import "ApplyInfo.h"
#import "PictureViewController.h"



#define ScreenWidth  CGRectGetWidth([UIScreen mainScreen].bounds)

@interface AddOfficeApplyViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) IBOutlet UILabel *expenditureLabel;//支出事项
@property (strong, nonatomic) IBOutlet UILabel *departmentLabel;//当前单位
@property (strong, nonatomic) IBOutlet UIImageView *imageView1;//照片
@property (strong, nonatomic) IBOutlet UITextField *budgetAmountField;//预算金额

@property (strong, nonatomic) IBOutlet UIImageView *isLoanImag_y;//需要借款
@property (strong, nonatomic) IBOutlet UIButton *yesBtn;
@property (strong, nonatomic) IBOutlet UIImageView *isLoanImag_n;//不需要借款
@property (strong, nonatomic) IBOutlet UIButton *noBtn;

@property (strong, nonatomic) IBOutlet UITextField *cashContentField;//用款内容
@property (strong, nonatomic) IBOutlet UIView *remarkField;//备注

@property (nonatomic, assign) BOOL isLoan;//是否借款 0是，1否

@property (nonatomic ,strong) NSDictionary * expenditureItemMap;//支出事项弹框
@property (nonatomic ,strong) NSArray * expenditureItemArray;
@property (nonatomic ,strong) NSDictionary *  departmentMap;//当前单位弹框
@property (nonatomic ,strong) NSArray * departmentArray;
@property (nonatomic ,strong) NSDictionary * pickTypeMap;//照片图库选择弹框
@property (nonatomic ,strong) NSArray * pickTypeArray;

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign)NSInteger addPhotoButtonId;


//officeList
@property (nonatomic, strong) NSMutableArray * officeListArray;

@property (nonatomic, strong) IBOutlet UIView *view3;
@property (nonatomic, strong) IBOutlet UIView *viewCell;
@property (nonatomic ,assign) NSInteger viewCellTag;

@property (strong, nonatomic) IBOutlet UIView *view4;
@property (strong, nonatomic) IBOutlet UIView *view5;
@property (strong, nonatomic) IBOutlet UIView *view6;

@end

@implementation AddOfficeApplyViewController

UIImagePickerController* picker;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, 1000);
    self.navigationItem.title = @"多种申请";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                      NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"fooder-bg11"] forBarMetrics:UIBarMetricsDefault];
    [self getApplyInfo];

    OfficeInfo* officeInfo = [[OfficeInfo alloc] init];
    self.officeListArray = [NSMutableArray arrayWithObject:officeInfo];
    self.viewCellTag = 0;
    OfficeListCellView *officeListCellView = [OfficeListCellView viewFromXib];
    officeListCellView.delegate = self;
    [officeListCellView passViewOfficeList:self.officeListArray position:self.viewCellTag];
    [self.viewCell addSubview:officeListCellView];
    self.scrollView.frame = CGRectMake(0, 0, ScreenWidth, SCREEN_HEIGHT);
    self.view.frame = CGRectMake(0, 0, ScreenWidth, SCREEN_HEIGHT);
    
}

-(void)getApplyInfo{
    AppDelegate* appDelegate = [AppDelegate shareDelegate];
    ApplyInitInfo* applyInitInfo = appDelegate.applyInfo;
    
    NSArray* expenditureItemList = applyInitInfo.zhichuList;//支出事项
    NSMutableArray* expkey = [NSMutableArray array];
    NSMutableArray* expValue = [NSMutableArray array];
    for(NSDictionary *obj in expenditureItemList){
        expkey = [expkey arrayByAddingObject:[obj objectForKey:@"value"]];
        expValue = [expValue arrayByAddingObject:[obj objectForKey:@"key"]];
    }
    _expenditureItemMap = [NSDictionary dictionaryWithObjects:expValue forKeys:expkey];
    _expenditureItemArray = expValue;
    
    NSArray* depList = applyInitInfo.depList;//当前部门
    NSDictionary* dep = [depList objectAtIndex:0];
    self.departmentLabel.text = [dep objectForKey:@"deptName"];
    
    self.pickTypeMap = @{@"01":@"拍照",@"02":@"从相册选取",};//拍照选项
    self.pickTypeArray = [self.pickTypeMap allValues];
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
}


- (IBAction)actionSheetButton:(UIButton *)sender {
    switch (sender.tag) {
        case 1:{
            [ActionSheetStringPicker showPickerWithTitle:@"选择支出事项" rows:self.expenditureItemArray initialSelection:self.selectedIndex target:self successAction:@selector(expenditureItemWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
        }
            break;
        default:
            break;
    }
}

- (void)expenditureItemWasSelected:(NSNumber *)selectedIndex element:(id)element {
    self.selectedIndex = [selectedIndex intValue];
    //may have originated from textField or barButtonItem, use an IBOutlet instead of element
    self.expenditureLabel.text = (self.expenditureItemArray)[(NSUInteger) self.selectedIndex];
}

- (IBAction)isLoanAction:(UIButton*)sender {
    switch (sender.tag) {
        case 1:{
            self.isLoan = YES;
            self.isLoanImag_y.image = [UIImage imageNamed:@"checkbox_s"];
            self.isLoanImag_n.image = [UIImage imageNamed:@"checkbox_n"];
        }
            break;
            
        case 2:{
            self.isLoan = NO;
            self.isLoanImag_y.image = [UIImage imageNamed:@"checkbox_n"];
            self.isLoanImag_n.image = [UIImage imageNamed:@"checkbox_s"];
        }
            break;
            
        default:
            break;
    }
    
}

- (IBAction)addOfficeListAction:(id)sender {
    OfficeInfo* officeInfo = [[OfficeInfo alloc] init];
    [self.officeListArray addObject:officeInfo];
    self.viewCellTag = self.viewCellTag+1;
    if(self.viewCellTag == 0){
        CGFloat view3X = self.view3.frame.origin.x;
        CGFloat view3Y = self.view3.frame.origin.y;
        self.view3.frame = CGRectMake(view3X, view3Y, ScreenWidth-20, self.view3.frame.size.height+210);
        self.view4.frame = CGRectMake(view3X, view3Y+self.view3.frame.size.height+20, ScreenWidth-20, 200);
        self.view5.frame = CGRectMake(view3X, self.view4.frame.origin.y+200, ScreenWidth-20, 60);
        self.contentView.frame = CGRectMake(0,0,ScreenWidth, self.contentView.frame.size.height+210);
        self.scrollView.contentSize = CGSizeMake(ScreenWidth, self.scrollView.contentSize.height+210);

        self.viewCell = [[UIView alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth-40, 200)];
        self.viewCell.tag = self.viewCellTag;
        OfficeListCellView *officeListCellView = [OfficeListCellView viewFromXib];
        officeListCellView.delegate = self;
        [officeListCellView passViewOfficeList:self.officeListArray position:self.viewCellTag];
        [self.viewCell addSubview:officeListCellView];
        [self.view3 addSubview:self.viewCell];
    }else{
        CGFloat view3X = self.view3.frame.origin.x;
        CGFloat view3Y = self.view3.frame.origin.y;
        self.view3.frame = CGRectMake(view3X, view3Y, ScreenWidth-20, self.view3.frame.size.height+210);
        self.view4.frame = CGRectMake(view3X, view3Y+self.view3.frame.size.height+20, ScreenWidth-20, 200);
        self.view5.frame = CGRectMake(view3X, self.view4.frame.origin.y+200, ScreenWidth-20, 60);
        self.contentView.frame = CGRectMake(0,0,ScreenWidth, self.contentView.frame.size.height+210);
        self.scrollView.contentSize = CGSizeMake(ScreenWidth, self.scrollView.contentSize.height+210);
        

        OfficeListCellView *officeListCellView = [OfficeListCellView viewFromXib];
        officeListCellView.delegate = self;
        [officeListCellView passViewOfficeList:self.officeListArray position:self.viewCellTag];
        
        [self.view3 addSubview:officeListCellView];
    }
    
}

//OfficeListCellView delegate 方法
-(void)deleteOfficeListCell:(NSInteger)position
{
    if(position==0){
        [self.viewCell removeFromSuperview];
        CGFloat view3X = self.view3.frame.origin.x;
        CGFloat view3Y = self.view3.frame.origin.y;
        self.view3.frame = CGRectMake(view3X, view3Y, ScreenWidth-20, self.view3.frame.size.height-200);
        self.view4.frame = CGRectMake(view3X, view3Y+self.view3.frame.size.height+10, ScreenWidth-20, 200);
        self.view5.frame = CGRectMake(view3X, self.view4.frame.origin.y+200, ScreenWidth-20, 60);
        
        self.contentView.frame = CGRectMake(0,0,ScreenWidth, self.contentView.frame.size.height-200);
        self.scrollView.contentSize = CGSizeMake(ScreenWidth, self.scrollView.contentSize.height-200);
        self.viewCellTag = self.viewCellTag-1;
    }else{
        CGFloat view3X = self.view3.frame.origin.x;
        CGFloat view3Y = self.view3.frame.origin.y;
        self.view3.frame = CGRectMake(view3X, view3Y, ScreenWidth-20, self.view3.frame.size.height-210);
        self.view4.frame = CGRectMake(view3X, view3Y+self.view3.frame.size.height+20, ScreenWidth-20, 200);
        self.view5.frame = CGRectMake(view3X, self.view4.frame.origin.y+200, ScreenWidth-20, 60);
        
        self.contentView.frame = CGRectMake(0,0,ScreenWidth, self.contentView.frame.size.height-210);
        self.scrollView.contentSize = CGSizeMake(ScreenWidth, self.scrollView.contentSize.height-210);
        self.viewCellTag = self.viewCellTag-1;
    }
}


- (IBAction)addPhotoAction:(UIButton *)sender {
    self.addPhotoButtonId = sender.tag;
    [ActionSheetStringPicker showPickerWithTitle:@"选择" rows:self.pickTypeArray initialSelection:self.selectedIndex target:self successAction:@selector(pickTypeWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
}

- (void)pickTypeWasSelected:(NSNumber *)selectedIndex element:(id)element {
    self.selectedIndex = [selectedIndex intValue];
    //may have originated from textField or barButtonItem, use an IBOutlet instead of element
    NSString *pickTypeStr = (self.pickTypeArray)[(NSUInteger) self.selectedIndex];
    if([pickTypeStr isEqualToString:@"拍照"]){
        // 如果拍摄的摄像头可用
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypeCamera])
        {
            // 将sourceType设为UIImagePickerControllerSourceTypeCamera代表拍照或拍视频
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            // 设置拍摄照片
            picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            // 设置使用手机的后置摄像头（默认使用后置摄像头）
            picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            // 设置使用手机的前置摄像头。
            //        picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            // 设置拍摄的照片允许编辑
            picker.allowsEditing = YES;
        }
        else
        {
            NSLog(@"模拟器无法打开摄像头");
        }
        // 显示picker视图控制器
        [self presentViewController:picker animated: YES completion:nil];
    }else if([pickTypeStr isEqualToString:@"从相册选取"]){
        // 设置选择载相册的图片或视频
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = NO;
        [self presentViewController:picker animated: YES completion:nil];
    }
}

// 当得到照片或者视频后，调用该方法
-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"成功：%@", info);
    // 获取用户拍摄的是照片还是视频
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    // 判断获取类型：图片，并且是刚拍摄的照片
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]
        && picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImage *theImage = nil;
        // 判断，图片是否允许修改
        if ([picker allowsEditing])
        {
            // 获取用户编辑之后的图像
            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
        }
        else
        {
            // 获取原始的照片
            theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        // 保存图片到相册中
        UIImageWriteToSavedPhotosAlbum(theImage, self,nil, nil);
    }
    // 判断获取类型：视频，并且是刚拍摄的视频
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        //获取视频文件的url
        NSURL* mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
        //创建ALAssetsLibrary对象并将视频保存到媒体库
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        // 将视频保存到相册中
        [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:mediaURL
                                          completionBlock:^(NSURL *assetURL, NSError *error)
         {
             // 如果没有错误，显示保存成功。
             if (!error)
             {
                 NSLog(@"视频保存成功！");
             }
             else
             {
                 NSLog(@"保存视频出现错误：%@", error);
             }
         }];
    }
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    switch(self.addPhotoButtonId){
        case 1:{
            self.imageView1.image = image;
        }
            break;

            break;
        default:
            break;
    }
    // 隐藏UIImagePickerController
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
// 当用户取消时，调用该方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"用户取消的拍摄！");
    // 隐藏UIImagePickerController
    [picker dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
