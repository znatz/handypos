//
//  SeisanViewController.m
//  photo
//
//  Created by POSCO on 12/07/23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SeisanViewController.h"
#import "SyoukeiViewController.h"
#import "Tanto.h"
#import "Goods.h"
#import "Bumon.h"
#import "DataModels.h"
#import "DataAzukari.h"
#import "DataMente.h"
#import "MainViewController.h"
#import "ShopSettings.h"
#import "ReceiptSettings.h"
#import "Syoukei.h"
#import "ConnectionManager.h"
#import "TransferData.h"
#import "Printer.h"


//#import "MiniPrinterFunctions.h"
#import <Foundation/Foundation.h>

@interface SeisanViewController ()
@property ShopSettings * shopsettings;
@property ReceiptSettings * receiptsettings;
@property NSMutableArray * allSyoukei;
@property Printer * printer;
@end

@implementation SeisanViewController{
    UIBarButtonItem *seisan;
    
    NSMutableArray *idArry2;
    NSMutableArray *kosuArry2;

    
    NSString *tantou_id;
    NSString *Re_no;
    
    
    /* All items price x kosu */
    int total;
    
    int goukei2;
    int henpin_flag;
    int Printer_flg;
    int intLength;
    //wav再生用
    NSString *path;
    NSURL *url;
    SystemSoundID soundID;
    
}

@synthesize goukeiLabel;
@synthesize oturiLabel;
@synthesize btnkettei;
@synthesize priceLabel;
@synthesize enbiki;
@synthesize percent;
//@synthesize tantou_id;




- (void)viewDidLoad
{
    /* Solve overlapping navigation bar in iOS 7 */
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [super viewDidLoad];
    self.allSyoukei = [DataModels getAllSyoukei];
    
    /* Printer Setup */
    NSUserDefaults * defaulSettings = [NSUserDefaults standardUserDefaults];
    NSString * printerURL = [defaulSettings valueForKey:@"PrinterURL"];
    printerURL = printerURL ? printerURL : @"192.168.1.231";
    self.printer = [[Printer alloc] initWithURL:printerURL];

    
//    Flag=@"1";
    henpin_flag=0;
    self.title=@"お支払い";
    
    self.shopsettings = [DataMente getShopSettings];
    self.receiptsettings = [DataMente getReceiptSettings];
    
    
    oturiLabel.text=@"";
    //背景用の設定
    self.navigationController.navigationBar.tintColor=[UIColor brownColor];
    UIImage *imgback=[UIImage imageNamed:@"back.bmp"];
    self.view.backgroundColor=[UIColor colorWithPatternImage:imgback];
    
    //音用の設定
    path=[[NSBundle mainBundle]pathForResource:@"butin" ofType:@"wav"];
    url=[NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url,&soundID);
    
    //アニメーション開始
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationRepeatCount:1000];
    [UIView setAnimationRepeatAutoreverses:YES];
    [priceLabel setAlpha:0.2f];
    [UIView commitAnimations];
    
    //担当コード取得  
    
    NSUserDefaults * globalVar = [NSUserDefaults standardUserDefaults];
    tantou_id = [globalVar objectForKey:@"tantoID"];
    NSLog(@"tantou:%@", tantou_id);

    
    //レシートナンバーの設定
    Re_no= self.shopsettings.receipt;
    //NSLog(@"%@",Re_no);
    
    Printer_flg=1;
}

//ロード時に各要素の格納
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    total = 0;
    for (int i=0; i< self.allSyoukei.count; i++) {
        Syoukei * s = self.allSyoukei[i];
        total += s.price * s.kosu;
    }
    goukeiLabel.text = [NSString stringWithFormat:@"%d", total];
    goukei2 = total; 
}

//確定ボタン submit button
-(IBAction)btnkettei:(id)sender{
    AudioServicesPlaySystemSound(soundID);
    
    //預り金が正しい,もしくは返品フラグがたっている場合
    if([priceLabel.text intValue]>= total || henpin_flag==1) {

        seisan = [[UIBarButtonItem alloc]initWithTitle:@"精算・印刷" style:UIBarButtonItemStyleBordered target:self action:@selector(seisan_syori)];
        
        self.navigationItem.rightBarButtonItem=seisan;//右側にボタン設置
   }
    else{
        UIAlertView *av =[[UIAlertView alloc]initWithTitle:@"預り金" message:@"預り金が不足しています" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [av show];
    }
    
    int oturi;
    if(henpin_flag==0){
        oturi=[priceLabel.text intValue]- total;
    }
    else{
        oturi= total;
    }
    
    oturiLabel.text = [NSString stringWithFormat:@"%d", oturi];

}



//アニメーション停止
-(void)anime_stop{
    [UIView beginAnimations:nil context:NULL];
    [priceLabel setAlpha:1.0f];
    [UIView commitAnimations];
}

-(IBAction)push_1:(id)sender{
    AudioServicesPlaySystemSound(soundID);
    [self anime_stop];
    if ([oturiLabel.text length]==0)priceLabel.text=[NSString stringWithFormat:@"%@1",priceLabel.text];
}
-(IBAction)push_2:(id)sender{
    AudioServicesPlaySystemSound(soundID);
    [self anime_stop];
    if ([oturiLabel.text length]==0)priceLabel.text=[NSString stringWithFormat:@"%@2",priceLabel.text];
}
-(IBAction)push_3:(id)sender{
    AudioServicesPlaySystemSound(soundID);
    [self anime_stop];
    if ([oturiLabel.text length]==0)priceLabel.text=[NSString stringWithFormat:@"%@3",priceLabel.text];
}
-(IBAction)push_4:(id)sender{
    AudioServicesPlaySystemSound(soundID);
    [self anime_stop];
    if ([oturiLabel.text length]==0)priceLabel.text=[NSString stringWithFormat:@"%@4",priceLabel.text];
}
-(IBAction)push_5:(id)sender{
    AudioServicesPlaySystemSound(soundID);
    [self anime_stop];
    if ([oturiLabel.text length]==0)priceLabel.text=[NSString stringWithFormat:@"%@5",priceLabel.text];
}
-(IBAction)push_6:(id)sender{
    AudioServicesPlaySystemSound(soundID);
    [self anime_stop];
    if ([oturiLabel.text length]==0)priceLabel.text=[NSString stringWithFormat:@"%@6",priceLabel.text];
}
-(IBAction)push_7:(id)sender{
    AudioServicesPlaySystemSound(soundID);
    [self anime_stop];
    if ([oturiLabel.text length]==0)priceLabel.text=[NSString stringWithFormat:@"%@7",priceLabel.text];
}
-(IBAction)push_8:(id)sender{
    AudioServicesPlaySystemSound(soundID);
    [self anime_stop];
    if ([oturiLabel.text length]==0)priceLabel.text=[NSString stringWithFormat:@"%@8",priceLabel.text];
}
-(IBAction)push_9:(id)sender{
    AudioServicesPlaySystemSound(soundID);
    [self anime_stop];
    if ([oturiLabel.text length]==0)priceLabel.text=[NSString stringWithFormat:@"%@9",priceLabel.text];
}
-(IBAction)push_0:(id)sender{
    AudioServicesPlaySystemSound(soundID);
    if ([priceLabel.text length]!=0 && [oturiLabel.text length]==0)
            priceLabel.text=[NSString stringWithFormat:@"%@0",priceLabel.text];
}
-(IBAction)push_00:(id)sender{
    AudioServicesPlaySystemSound(soundID);
    if ([priceLabel.text length]!=0 && [oturiLabel.text length]==0)
            priceLabel.text=[NSString stringWithFormat:@"%@00",priceLabel.text];
}
//取消ボタン
-(IBAction)clear:(id)sender{
    AudioServicesPlaySystemSound(soundID);
    priceLabel.text=@"";
    oturiLabel.text=@"";
    henpin_flag=0;
    self.navigationItem.rightBarButtonItem=nil;
}

//千券
-(IBAction)senken:(id)sender{
    if ([oturiLabel.text length]==0){
        AudioServicesPlaySystemSound(soundID);
        [self anime_stop];
        //if([priceLabel.text length]==1){
          //  priceLabel.text=[NSString stringWithFormat:@"%@000",priceLabel.text];
        //}
        if([priceLabel.text length]==1){
            priceLabel.text=[NSString stringWithFormat:@"1000"];
        }
        else{
            int intprice=[priceLabel.text intValue]+1000;
            priceLabel.text=[NSString stringWithFormat:@"%d",intprice];
        }
    }
}
//万券
-(IBAction)manken:(id)sender{
    if ([oturiLabel.text length]==0){
        AudioServicesPlaySystemSound(soundID);
        [self anime_stop];
        //if([priceLabel.text length]==1){
            //priceLabel.text=[NSString stringWithFormat:@"%@0000",priceLabel.text];
        //}
        if([priceLabel.text length]==0){
            priceLabel.text=[NSString stringWithFormat:@"10000"];
        }
        else{
            int intprice=[priceLabel.text intValue]+10000;
            priceLabel.text=[NSString stringWithFormat:@"%d",intprice];
        }
    }
}

//％引き処理
-(IBAction)percent_biki:(id)sender{
    if([priceLabel.text intValue]>0 && [priceLabel.text intValue]<100 && [oturiLabel.text length]==0){
        AudioServicesPlaySystemSound(soundID);
        total = total * (100- [priceLabel.text intValue])/100;

        goukeiLabel.text = [NSString stringWithFormat:@"%d",total];

        priceLabel.text=@"";
    }
}

//円引き処理
-(IBAction)en_biki:(id)sender{
    if([priceLabel.text intValue]>0 && [priceLabel.text intValue] < total && [oturiLabel.text length]==0){
        AudioServicesPlaySystemSound(soundID);
        total = total -[priceLabel.text intValue];
        //NSLog(@"%d",goukei);
        goukeiLabel.text = [NSString stringWithFormat:@"%d",total];
        priceLabel.text=@"";
        
    }
}

//値下げ取消処理
-(IBAction)Cancel:(id)sender{
    if([oturiLabel.text length]==0){
        AudioServicesPlaySystemSound(soundID);
        total = goukei2;
        priceLabel.text=@"";
        goukeiLabel.text= [NSString stringWithFormat:@"%d",total];
    
    }
}

//返品処理
-(IBAction)henpin:(id)sender{
    AudioServicesPlaySystemSound(soundID);
    total = goukei2;
    goukeiLabel.text = [NSString stringWithFormat:@"%d",total];
    
    priceLabel.text=@"0";
    oturiLabel.text=[NSString stringWithFormat:@"%d",goukei2];
    henpin_flag=1;
    
}

//精算が押されたら処理 Print Button
-(void)seisan_syori{
    AudioServicesPlaySystemSound(soundID);
    //ベスト表用の格納
    idArry2=[[NSMutableArray alloc]init];//id格納
    kosuArry2=[[NSMutableArray alloc]init];//個数格納
    [DataModels selectID:idArry2 selectFlag:@"0"];
    [DataModels selectKosu:kosuArry2 selectFlag:@"0"];
    
    //日付の取得
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
    NSDate *now=[NSDate date];
    [formatter setDateFormat:@"yyyy年MM月dd日(E) HH:mm"];
    NSString *time=[formatter stringFromDate:now];
    

    //各要素の保存
    for(int i=0;i<self.allSyoukei.count;i++){

        Syoukei * s = self.allSyoukei[i];
        
        
        //部門名の取得 Get bumon from BTSMAS which is table of available goods
        
        Goods * g = [DataModels getGoodsByID:s.ID];
        Bumon * b = (Bumon *)[DataModels getBumonByID:g.bumon];
        
        NSUserDefaults * defaultSettings = [NSUserDefaults standardUserDefaults];
        NSString * tableNO = [defaultSettings objectForKey:@"tableNO"];
        
        if(henpin_flag==0){
            
            [DataModels saveToSeisan:s withTime:time withReceiptNo:Re_no withBumon:b.bumon];

            /* Prepare data for sending !!!   --------------------------- */
            [DataModels createTransferData];
            TransferData * transfer = [[TransferData alloc] initWithTantoID : tantou_id
                                                                 goodsTitle : s.title
                                                                       kosu : [NSString stringWithFormat:@"%d", s.kosu]
                                                                       time : time
                                                                  receiptNo : Re_no
                                                                    tableNO : tableNO];
            [DataModels saveToTransfer:transfer];
            
            for(int j=0;j<idArry2.count;j++){
                // TODO Unknown
                if([s.ID intValue]==[[idArry2 objectAtIndex:j] intValue]){
                    [DataModels selectID:[idArry2 objectAtIndex:j] updateKosu:[NSString stringWithFormat:@"%d",[[kosuArry2 objectAtIndex:j] intValue]+s.kosu] selectFlag:@"4"];
                }
            }
        } else {
            /* Henpin */ 
            s.kosu = -s.kosu;
            [DataModels saveToSeisan:s withTime:time withReceiptNo:Re_no withBumon:b.bumon];
        }
    }
    int nebiki= goukei2 - total;
    
    //預り金・値引きデータ
    if(henpin_flag==0){
    // TODO
    [DataModels insertTime:time insertReno:Re_no insertTantou:tantou_id insertGoukei:[NSString stringWithFormat:@"%d",goukei2] insertNebiki:[NSString stringWithFormat:@"%d",nebiki] insertAzukari:priceLabel.text insertOturi:oturiLabel.text];
    }
    else{
        // TODO
        [DataModels insertTime:time insertReno:Re_no insertTantou:tantou_id insertGoukei:[NSString stringWithFormat:@"-%d",goukei2] insertNebiki:@"0" insertAzukari:@"0" insertOturi:oturiLabel.text];
    }
    
    //レシートNoの増加
    Re_no=[NSString stringWithFormat:@"%d",[Re_no intValue]+1];
    intLength=[Re_no length];
    for(int i=0; i<6-intLength; i++){
        Re_no=[NSString stringWithFormat:@"0%@",Re_no];
    }

    self.shopsettings.receipt = Re_no;
    [DataMente updateShopSettings:self.shopsettings];
    
    
    
    /* Print -------------------------------------------- */
    [self.printer printHeader];
    [self.printer printContentsWith:[DataModels getAllTransfer] syoukei:self.allSyoukei];
    [self.printer printFooter];
    [self.printer close];
    
    // TODO Cleanup before return to home!
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0]animated:YES];//保存後ホームに戻る
   
    /* Send To Kichen ----------------------------------- */
    [ConnectionManager uploadFile:@"BurData.sqlite"];
    [DataModels dropTransferData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
