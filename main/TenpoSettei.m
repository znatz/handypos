//
//  TenpoSettei.m
//  HandyPOS
//
//  Created by POSCO on 12/12/27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TenpoSettei.h"
#import "DataMente.h"
#import "DataModels.h"
#import "ShopSettings.h"
#import "Tenpo.h"

@interface TenpoSettei ()
@property ShopSettings * shopsettings;
@property NSMutableArray * allTenpo;
@property int currentTenpo;
- (NSString *) paddingReceiptNo : (NSString *) r ;
@end

@implementation TenpoSettei{
}

//@synthesize lblTenpoID;
@synthesize lblTenpo;
@synthesize lblRejiNo;
@synthesize lblReceiptNo;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    /* Solve overlapping navigation bar in iOS 7 */
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [super viewDidLoad];
    self.title=@"店舗設定";
    
    self.allTenpo = [DataModels getAllTanpo];
    self.currentTenpo = 1;
    
    /* Setup ShopSettings */
    [DataMente createShopSettingsTable];
    self.shopsettings = [DataMente getShopSettings];
    if (!self.shopsettings) {
        self.shopsettings = [[ShopSettings alloc] initWithTempo:@"01" reji:@"01" receipt:@"01"];
        [DataMente insertShopSettings:self.shopsettings];
    } ;
  
    
    //背景用の設定
    self.navigationController.navigationBar.tintColor=[UIColor brownColor];
    UIImage *imgback=[UIImage imageNamed:@"back.bmp"];
    self.view.backgroundColor=[UIColor colorWithPatternImage:imgback];
}

//ロード時に各要素の格納
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIBarButtonItem *Change; 
    Change = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(Change_Save)];
    self.navigationItem.rightBarButtonItem=Change;//右側にボタン設置
    

//    lblTenpoID.text = self.shopsettings.tempo;
    lblRejiNo.text  = self.shopsettings.reji;
    
    
    NSString * name = [DataModels getTanpoNameByID:self.shopsettings.tempo];
    if(name){
        lblTenpo.text= name;
    }
    
    
    lblReceiptNo.text= [self paddingReceiptNo:self.shopsettings.receipt];
}

//店舗No
-(IBAction)btnTenpoID:(id)sender{
    
    Tenpo * selectedTenpo = self.allTenpo[self.currentTenpo];
    self.shopsettings.tempo = selectedTenpo.ID;
    lblTenpo.text = selectedTenpo.tenpo;
//    lblTenpoID.text = self.shopsettings.tempo;
    
    if (self.currentTenpo > 0) {
        self.currentTenpo --;
    }
    

}
-(IBAction)btnTenpoID2:(id)sender{
     Tenpo * selectedTenpo = self.allTenpo[self.currentTenpo];
    self.shopsettings.tempo = selectedTenpo.ID;
    lblTenpo.text = selectedTenpo.tenpo;
//    lblTenpoID.text = self.shopsettings.tempo;
    
    if (self.currentTenpo < self.allTenpo.count - 1) {
        self.currentTenpo ++;
    }
   
}

//レジNo
-(IBAction)btnRejiNo:(id)sender{   
    int r = [self.shopsettings.reji intValue];
    if (r > 1) {
        r -- ;
        self.shopsettings.reji = [NSString stringWithFormat:@"%02d", r];
    }
    lblRejiNo.text = self.shopsettings.reji;
}

-(IBAction)btnRejiNo2:(id)sender{
    
    int r = [self.shopsettings.reji intValue];
    if (r < 99) {
        r ++ ;
        self.shopsettings.reji = [NSString stringWithFormat:@"%02d", r];
    }
    lblRejiNo.text = self.shopsettings.reji;
}



//レシートNo
-(IBAction)btnReceiptNo:(id)sender{
    int rt = [self.shopsettings.receipt intValue];
    if (rt > 1) {
        rt -- ;
        self.shopsettings.receipt = [NSString stringWithFormat:@"%d", rt];
    }
    lblReceiptNo.text = [self paddingReceiptNo:self.shopsettings.receipt];
}
-(IBAction)btnReceiptNo2:(id)sender{
    int rt = [self.shopsettings.receipt intValue];
    if (rt < 999999 ) {
        rt ++ ;
        self.shopsettings.receipt = [NSString stringWithFormat:@"%d", rt];
    }
    lblReceiptNo.text = [self paddingReceiptNo:self.shopsettings.receipt];
}

//変更の保存
-(void)Change_Save{    
    //各要素の保存
    [DataMente updateShopSettings:self.shopsettings];
    [self.navigationController popViewControllerAnimated:YES];//保存後ホームに戻る
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSString *) paddingReceiptNo : (NSString *) r {

    NSString * padded = [NSString stringWithString:r];
    int l = [padded length];

    for(int i=0; i<6-l; i++){
        padded=[NSString stringWithFormat:@"0%@",padded];
    }
    return padded;
}

@end
