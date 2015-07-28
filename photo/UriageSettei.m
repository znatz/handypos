//
//  UriageSettei.m
//  HandyPOS
//
//  Created by POSCO on 12/12/27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UriageSettei.h"
#import "DataMente.h"
#import "ReceiptSettings.h"

@interface UriageSettei ()
@property ReceiptSettings * receiptsettings;
@end

@implementation UriageSettei{
}

@synthesize lblZeiritu;
@synthesize lblReceipt;
@synthesize lblStamp;
@synthesize lblRecNo;
@synthesize btnZeiritu;
@synthesize btnZeiritu2;
@synthesize btnReceipt;
@synthesize btnReceipt2;
@synthesize btnStamp;
@synthesize btnStamp2;
@synthesize btnRecNo;
@synthesize btnRecNo2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title=@"売上設定";
    
    /* Setup ReceiptSettings */
    [DataMente createReceiptSettingsTable];
    self.receiptsettings = [DataMente getReceiptSettings];
    if (!self.receiptsettings) {
        self.receiptsettings = [[ReceiptSettings alloc] initWithTax:5 haveReceipt:1 haveStamp:0 haveComment:0];
        [DataMente insertReceiptSettings:self.receiptsettings];
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
    
    
    
    lblZeiritu.text=[NSString stringWithFormat:@"%d ％",self.receiptsettings.tax];
    
    if(self.receiptsettings.haveReceipt == 0)lblReceipt.text=@"無し";
        else lblReceipt.text=@"有り";
    
    if(self.receiptsettings.haveStamp   == 0)lblStamp.text=@"無し";
        else lblStamp.text=@"有り";
    
    if(self.receiptsettings.haveComment == 0)lblRecNo.text=@"無し";
        else lblRecNo.text=@"有り";
    
}

//税率変更
-(IBAction)btnZeiritu:(id)sender{
    if(self.receiptsettings.tax >0){
        self.receiptsettings.tax -- ;
        lblZeiritu.text=[NSString stringWithFormat:@"%d ％",self.receiptsettings.tax];
    }
}
-(IBAction)btnZeiritu2:(id)sender{
    if(self.receiptsettings.tax <99){
        self.receiptsettings.tax ++;
        lblZeiritu.text=[NSString stringWithFormat:@"%d ％",self.receiptsettings.tax];
    }
}

//レシート
-(IBAction)btnReceipt:(id)sender{
    if(self.receiptsettings.haveReceipt == 1){
        self.receiptsettings.haveReceipt = 0;
        lblReceipt.text=@"無し";
    }
}
-(IBAction)btnReceipt2:(id)sender{
    if(self.receiptsettings.haveReceipt == 0){
        self.receiptsettings.haveReceipt = 1;
        lblReceipt.text=@"有り";
    }
}

//スタンプ
-(IBAction)btnStamp:(id)sender{
    if(self.receiptsettings.haveStamp == 1){
        self.receiptsettings.haveStamp = 0;
        lblStamp.text=@"無し";
    }
}
-(IBAction)btnStamp2:(id)sender{
    if(self.receiptsettings.haveStamp == 0){
        self.receiptsettings.haveStamp = 1;
        lblStamp.text=@"有り";
    }
}

//レシートNo印字
-(IBAction)btnRecNo:(id)sender{
    if(self.receiptsettings.haveComment == 1){
        self.receiptsettings.haveComment = 0;
        lblRecNo.text=@"無し";
    }
}
-(IBAction)btnRecNo2:(id)sender{
    if(self.receiptsettings.haveComment == 0){
        self.receiptsettings.haveComment = 1;
        lblRecNo.text=@"有り";
    }
    
}
//変更の保存
-(void)Change_Save{    

    [DataMente updateReceiptSettings:self.receiptsettings];
    
    [self.navigationController popViewControllerAnimated:YES];//保存後ホームに戻る
}

- (void)viewDidUnload{
    [super viewDidUnload];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
