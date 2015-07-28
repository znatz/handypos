//
//  SeisanViewController2.m
//  photo
//
//  Created by POSCO on 12/10/31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SeisanViewController2.h"
#import "SyoukeiViewController.h"
#import "DataModels.h"
#import "DataAzukari.h"
#import "DataMente.h"
#import "MainViewController.h"
#import "ShopSettings.h"
#import "ReceiptSettings.h"

//#import "MiniPrinterFunctions.h"
#import <Foundation/Foundation.h>
@interface SeisanViewController2 ()
@property ShopSettings * shopsettings;
@property ReceiptSettings * receiptsettings;
@end

@implementation SeisanViewController2{
    NSMutableArray *idArry;
    NSMutableArray *idArry2;
    NSMutableArray *titleArry;
    NSMutableArray *priceArry;
    NSMutableArray *kosuArry;
    NSMutableArray *kosuArry2;

    NSMutableArray *tantouArry;
    NSMutableArray *BumonArry;
    //預り金システム
    NSMutableArray *NoArry;
    NSMutableArray *AzuArry;
    
    NSString *Flag;
    NSString *Re_no;
    NSString *tantou_id;
    int goukei;
    int goukei2;
    int intfor1;
    int intAzuNo;
    int henpin_flag;
    int Printer_flg;
    int intLength;
    UIBarButtonItem *seisan; 
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
@synthesize btn1;
@synthesize btn2;
@synthesize btn3;
@synthesize btn4;
@synthesize btn5;
@synthesize btn6;
@synthesize btn500;
@synthesize btn1000;
@synthesize btn5000;
@synthesize btn10000;

- (void)viewDidLoad
{
    [super viewDidLoad];
    Flag=@"1";
    henpin_flag=0;
    self.title=@"お支払い";
    
    self.shopsettings = [DataMente getShopSettings];
    self.receiptsettings = [DataMente getReceiptSettings];

    
    //背景用の設定
    self.navigationController.navigationBar.tintColor=[UIColor brownColor];
    UIImage *imgback=[UIImage imageNamed:@"back.bmp"];
    self.view.backgroundColor=[UIColor colorWithPatternImage:imgback];
    //priceLabel.backgroundColor=[UIColor lightGrayColor];
    //oturiLabel.backgroundColor=[UIColor lightGrayColor];
    oturiLabel.text=@"";
    //[self.navigationItem setHidesBackButton:YES]; //戻るボタンを非表示   
    //NSLog(@"tantouid %@",tantou_id);
    

    
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
    
    tantouArry=[[NSMutableArray alloc]init];
    [DataAzukari selectTantou:tantouArry];
    tantou_id=[tantouArry objectAtIndex:0];
    NSLog(@"tantou:%@",tantou_id);
    
    //レシートナンバーの設定
    Re_no= self.shopsettings.receipt;
    
    escp = [[ESCPOSPrinter alloc] init];
    Printer_flg=1;
}

- (IBAction)connectCommand
{
	NSLog(@"Connect call\r\n");
    int errCode = 0; 
    
	if((errCode = [escp openPort:@"192.168.1.199" withPortParam:9100]) >= 0){
		NSLog(@"コネクション成功\r\n");
        Printer_flg=0;
	}
	else{
		NSLog(@"ERROR:プリンタとの接続失敗\r\n");
        UIAlertView *av =[[UIAlertView alloc]initWithTitle:@"ERROR" message:@"プリンタとの接続に失敗しました。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [av show];
        Printer_flg=1;
        NSLog(@"%d",errCode);
	}
}

- (IBAction) disconnectCommand{
    [escp closePort];
    NSLog(@"プリンタ切断\r\n");
}

//ロード時に各要素の格納
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    idArry=[[NSMutableArray alloc]init];
    titleArry=[[NSMutableArray alloc]init];//タイトル格納配列
    priceArry=[[NSMutableArray alloc]init];//値段格納
    kosuArry=[[NSMutableArray alloc]init];//個数格納
    NoArry=[[NSMutableArray alloc]init];
    AzuArry=[[NSMutableArray alloc]init];

    
    [DataModels selectID:idArry selectFlag:Flag];
    [DataModels selectTitle:titleArry selectFlag:Flag];//タイトルフィールド取り出し
    [DataModels selectPrice:priceArry selectFlag:Flag];//値段フィールド取り出し
    [DataModels selectKosu:kosuArry selectFlag:Flag];

    
    for(int i=0; i < titleArry.count; i++){
        NSString *price=[priceArry objectAtIndex:i];
        NSString *kosu=[kosuArry objectAtIndex:i];
        goukei=goukei+[price intValue]*[kosu intValue];
    } 
    NSString *strgoukei=[NSString stringWithFormat:@"%d",goukei];
    goukeiLabel.text=strgoukei;
    goukei2=goukei;
    
    [self Azu_Calculate];
    [DataAzukari selectNo:NoArry];
    [DataAzukari selectKingaku:AzuArry];
    intAzuNo=0;
    for(int i=0; i<6; i++){
        if(i < NoArry.count){
            if(i==0)[btn1 setTitle:[AzuArry objectAtIndex:i] forState:UIControlStateNormal];
            if(i==1)[btn2 setTitle:[AzuArry objectAtIndex:i] forState:UIControlStateNormal];
            if(i==2)[btn3 setTitle:[AzuArry objectAtIndex:i] forState:UIControlStateNormal];
            if(i==3)[btn4 setTitle:[AzuArry objectAtIndex:i] forState:UIControlStateNormal];
            if(i==4)[btn5 setTitle:[AzuArry objectAtIndex:i] forState:UIControlStateNormal];
            if(i==5)[btn6 setTitle:[AzuArry objectAtIndex:i] forState:UIControlStateNormal];
        }
        
    } 
}
//確定ボタン
-(IBAction)btnkettei:(id)sender{
    AudioServicesPlaySystemSound(soundID);
    //int oturi;
    
    //預り金が正しい,もしくは返品フラグがたっている場合
    if([priceLabel.text intValue]>=goukei || henpin_flag==1) {
        
        //if(henpin_flag==0){
        //    oturi=[priceLabel.text intValue]-goukei;
        //}
        //else{
        //     oturi=goukei;
        //}
        
        
        //NSString *stroturi=[NSString stringWithFormat:@"%d",oturi];
        //oturiLabel.text=stroturi;
        //[priceLabel endEditing:YES];
        
        seisan = [[UIBarButtonItem alloc]initWithTitle:@"精算" style:UIBarButtonItemStyleBordered target:self action:@selector(seisan_syori)];
        self.navigationItem.rightBarButtonItem=seisan;//右側にボタン設置
        
        //レシート処理
        if( self.receiptsettings.haveReceipt == 1){
            [self connectCommand];
        }
        else{
            Printer_flg=1;
        }
        [self receipt_print];
        
    }
    //else if(henpin_flag==1 || [priceLabel.text length]==0){
    //return;
    //}
    else{
        UIAlertView *av =[[UIAlertView alloc]initWithTitle:@"預り金" message:@"預り金が不足しています" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [av show];
    }
    
}
//アニメーションの停止
-(void)anime_stop{
    [UIView beginAnimations:nil context:NULL];
    [priceLabel setAlpha:1.0f];
    [UIView commitAnimations];
}
//取消ボタン
-(IBAction)clear:(id)sender{
    AudioServicesPlaySystemSound(soundID);
    priceLabel.text=@"";
    oturiLabel.text=@"";
    henpin_flag=0;
    self.navigationItem.rightBarButtonItem=nil;
}


//％引き処理
-(IBAction)percent_biki:(id)sender{
    if([priceLabel.text intValue]>0 && [priceLabel.text intValue]<100 && [oturiLabel.text length]==0){
        AudioServicesPlaySystemSound(soundID);
        goukei=goukei*(100-[priceLabel.text intValue])/100;
        //NSLog(@"%d",goukei);
        NSString *strgoukei=[NSString stringWithFormat:@"%d    円",goukei];
        //[nebikiField endEditing:YES];
        goukeiLabel.text=strgoukei;
        priceLabel.text=@"";
    }
}

//円引き処理
-(IBAction)en_biki:(id)sender{
    if([priceLabel.text intValue]>0 && [priceLabel.text intValue]<goukei && [oturiLabel.text length]==0){
        AudioServicesPlaySystemSound(soundID);
        goukei=goukei-[priceLabel.text intValue];
        //NSLog(@"%d",goukei);
        NSString *strgoukei=[NSString stringWithFormat:@"%d    円",goukei];
        goukeiLabel.text=strgoukei;
        priceLabel.text=@"";
        
    }
}
//値下げ取消処理
-(IBAction)Cancel:(id)sender{
    if([oturiLabel.text length]==0){
        AudioServicesPlaySystemSound(soundID);
        goukei=goukei2;
        priceLabel.text=@"";
        NSString *strgoukei=[NSString stringWithFormat:@"%d    円",goukei];
        goukeiLabel.text=strgoukei;
        
    }
}

//返品処理
-(IBAction)henpin:(id)sender{
    AudioServicesPlaySystemSound(soundID);
    goukei=goukei2;
    NSString *strgoukei=[NSString stringWithFormat:@"%d",goukei];
    goukeiLabel.text=strgoukei;
    
    priceLabel.text=@"0";
    oturiLabel.text=[NSString stringWithFormat:@"%d",goukei2];
    henpin_flag=1;
    
    //seisan = [[UIBarButtonItem alloc]initWithTitle:@"精算" style:UIBarButtonSystemItemAdd target:self action:@selector(seisan_syori)];
    //self.navigationItem.rightBarButtonItem=seisan;//右側にボタン設置
}


-(IBAction)push_1:(id)sender{
    AudioServicesPlaySystemSound(soundID);
    if ([oturiLabel.text length]==0)priceLabel.text=btn1.currentTitle;
    [self anime_stop];
}
-(IBAction)push_2:(id)sender{
    AudioServicesPlaySystemSound(soundID);
    if ([oturiLabel.text length]==0)priceLabel.text=btn2.currentTitle;
    [self anime_stop];
}
-(IBAction)push_3:(id)sender{
    AudioServicesPlaySystemSound(soundID);
    if ([oturiLabel.text length]==0)priceLabel.text=btn3.currentTitle;
    [self anime_stop];
}
-(IBAction)push_4:(id)sender{
    AudioServicesPlaySystemSound(soundID);
    if ([oturiLabel.text length]==0)priceLabel.text=btn4.currentTitle;
    [self anime_stop];
}
-(IBAction)push_5:(id)sender{
    AudioServicesPlaySystemSound(soundID);
    if ([oturiLabel.text length]==0)priceLabel.text=btn5.currentTitle;
    [self anime_stop];
}
-(IBAction)push_6:(id)sender{
    AudioServicesPlaySystemSound(soundID);
    if ([oturiLabel.text length]==0)priceLabel.text=btn6.currentTitle;
    [self anime_stop];
}
-(IBAction)push_500:(id)sender{
    AudioServicesPlaySystemSound(soundID);
    [self Button_Set:500];
}
-(IBAction)push_1000:(id)sender{
    AudioServicesPlaySystemSound(soundID);
    [self Button_Set:1000];
}
-(IBAction)push_5000:(id)sender{
    AudioServicesPlaySystemSound(soundID);
    [self Button_Set:5000];
}
-(IBAction)push_10000:(id)sender{
    AudioServicesPlaySystemSound(soundID);
    [self Button_Set:10000];
}

-(void)Button_Set:(int)kingaku{
    [btn1 setTitle:@"" forState:UIControlStateNormal];
    [btn2 setTitle:@"" forState:UIControlStateNormal];
    [btn3 setTitle:@"" forState:UIControlStateNormal];
    [btn4 setTitle:@"" forState:UIControlStateNormal];
    [btn5 setTitle:@"" forState:UIControlStateNormal];
    [btn6 setTitle:@"" forState:UIControlStateNormal];
    
    for(intfor1=0;intfor1<NoArry.count;intfor1++){
        if(kingaku<=[[AzuArry objectAtIndex:intfor1] intValue]){
            if(intfor1<NoArry.count)[btn1 setTitle:[AzuArry objectAtIndex:intfor1] forState:UIControlStateNormal];
            if(intfor1+1<NoArry.count)[btn2 setTitle:[AzuArry objectAtIndex:intfor1+1] forState:UIControlStateNormal];
            if(intfor1+2<NoArry.count)[btn3 setTitle:[AzuArry objectAtIndex:intfor1+2] forState:UIControlStateNormal];
            if(intfor1+3<NoArry.count)[btn4 setTitle:[AzuArry objectAtIndex:intfor1+3] forState:UIControlStateNormal];
            if(intfor1+4<NoArry.count)[btn5 setTitle:[AzuArry objectAtIndex:intfor1+4] forState:UIControlStateNormal];
            if(intfor1+5<NoArry.count)[btn6 setTitle:[AzuArry objectAtIndex:intfor1+5] forState:UIControlStateNormal];
            intAzuNo=intfor1;
            break;
        }
    } 
}
-(IBAction)push_Up:(id)sender{
    AudioServicesPlaySystemSound(soundID);
    intAzuNo=intAzuNo+6;
    
    if(intAzuNo>=NoArry.count)intAzuNo=NoArry.count-6;
    [self Button_Set2:intAzuNo];
}
-(IBAction)push_Down:(id)sender{
    AudioServicesPlaySystemSound(soundID);
    intAzuNo=intAzuNo-6;
    if(intAzuNo<=0)intAzuNo=0;
    [self Button_Set2:intAzuNo];
}
-(void)Button_Set2:(int)AzuNo{
    [btn1 setTitle:@"" forState:UIControlStateNormal];
    [btn2 setTitle:@"" forState:UIControlStateNormal];
    [btn3 setTitle:@"" forState:UIControlStateNormal];
    [btn4 setTitle:@"" forState:UIControlStateNormal];
    [btn5 setTitle:@"" forState:UIControlStateNormal];
    [btn6 setTitle:@"" forState:UIControlStateNormal];
    
    for(intfor1=0;intfor1<NoArry.count;intfor1++){
        if(AzuNo<[[NoArry objectAtIndex:intfor1] intValue]){
            if(intfor1<NoArry.count)[btn1 setTitle:[AzuArry objectAtIndex:intfor1] forState:UIControlStateNormal];
            if(intfor1+1<NoArry.count)[btn2 setTitle:[AzuArry objectAtIndex:intfor1+1] forState:UIControlStateNormal];
            if(intfor1+2<NoArry.count)[btn3 setTitle:[AzuArry objectAtIndex:intfor1+2] forState:UIControlStateNormal];
            if(intfor1+3<NoArry.count)[btn4 setTitle:[AzuArry objectAtIndex:intfor1+3] forState:UIControlStateNormal];
            if(intfor1+4<NoArry.count)[btn5 setTitle:[AzuArry objectAtIndex:intfor1+4] forState:UIControlStateNormal];
            if(intfor1+5<NoArry.count)[btn6 setTitle:[AzuArry objectAtIndex:intfor1+5] forState:UIControlStateNormal];
            //NSLog(@"%d %d %d %d %d %d",intfor1,intfor1+1,intfor1+2,intfor1+3,intfor1+4,intfor1+5);
            intAzuNo=intfor1;
            break;
        }
    } 
}
//精算が押されたら処理
-(void)seisan_syori{
    //ベスト表用の格納
    idArry2=[[NSMutableArray alloc]init];//id格納
    kosuArry2=[[NSMutableArray alloc]init];//個数格納
    [DataModels selectID:idArry2 selectFlag:@"0"];
    [DataModels selectKosu:kosuArry2 selectFlag:@"0"];
    
    //日付の取得
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    NSDate *now=[NSDate date];
    [formatter setDateFormat:@"yyyyMMddHHmm"];
    NSString *time=[formatter stringFromDate:now];
    
    
    //各要素の保存
    for(int i=0;i<titleArry.count;i++){
        NSString *idno=[idArry objectAtIndex:i];
        NSString *title=[titleArry objectAtIndex:i];
        NSString *price=[priceArry objectAtIndex:i];
        NSString *Kosu=[kosuArry objectAtIndex:i];
        
        BumonArry=[[NSMutableArray alloc]init];
        [DataModels selectBumon:BumonArry where_id:idno];
        NSString *Bumon=[BumonArry objectAtIndex:0];
        if(henpin_flag==0){
            [DataModels insertTime:time insertReno:Re_no insertID:idno insertTitle:title insertBumon:Bumon insertPrice:price insertKosu:Kosu];
            
            for(int j=0;j<idArry2.count;j++){
                if([idno intValue]==[[idArry2 objectAtIndex:j] intValue]){
                    //NSLog(@"%@ %@ %@",[idArry2 objectAtIndex:j],[kosuArry2 objectAtIndex:j],Kosu);
                    [DataModels selectID:[idArry2 objectAtIndex:j] updateKosu:[NSString stringWithFormat:@"%d",[[kosuArry2 objectAtIndex:j] intValue]+[Kosu intValue]] selectFlag:@"4"];
                }
            }
        }
        else {
            [DataModels insertTime:time insertReno:Re_no insertID:idno insertTitle:title insertBumon:Bumon insertPrice:[NSString stringWithFormat:@"%@",price] insertKosu:[NSString stringWithFormat:@"-%@",Kosu]];
        }
    }
    int nebiki=goukei2-goukei;
    
    //預り金・値引きデータ
    if(henpin_flag==0){
        [DataModels insertTime:time insertReno:Re_no insertTantou:tantou_id insertGoukei:[NSString stringWithFormat:@"%d",goukei2] insertNebiki:[NSString stringWithFormat:@"%d",nebiki] insertAzukari:priceLabel.text insertOturi:oturiLabel.text];
    }
    else{
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
    
    [DataModels drop_table:Flag];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2]animated:YES];//保存後ホームに戻る
}

//レシート印刷
-(void)receipt_print{
    int oturi;
    int len;
    int Goukei_Kosu=0;
    NSNumber *price1;//3桁区切り用
    NSString *price2;//3桁区切り用
    NSString *price3;//3桁
    if(henpin_flag==0){
        oturi=[priceLabel.text intValue]-goukei;
    }
    else{
        oturi=goukei;
    }
    
    
    NSString *stroturi=[NSString stringWithFormat:@"%d",oturi];
    oturiLabel.text=stroturi;
    [priceLabel endEditing:YES];
    //////////////////レシート処理///////////////////
    if(Printer_flg==0){
        char normalSize[3] = {0x1D,0x21,0x00};
        char dWidthSize[3] = {0x1D,0x21,0x10};
        char centerAlign[3] = {0x1B,0x61,0x01};
        //char rightAlign[3] = {0x1B,0x61,0x02};
        
        [escp setEncoding:NSShiftJISStringEncoding];
        [escp printData:dWidthSize withLength:sizeof(dWidthSize)];				   
        [escp printData:centerAlign withLength:sizeof(centerAlign)];				   
        
        if( self.receiptsettings.haveStamp == 1){
            NSString * imgfile1 = [[NSBundle mainBundle] pathForResource:@"logo.png" ofType:nil];
            [escp printBitmap:imgfile1 withAlignment:ALIGNMENT_LEFT withSize:BITMAP_NORMAL withBrightness:0];
            [escp lineFeed:1];
        }
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setPositiveFormat:@",###"];
        NSMutableString *printData = [NSMutableString string];
        
        if(henpin_flag==0)[escp printString:@" ＜＜領収証＞＞\r\n"];
        else [escp printString:@" ＜＜返　品＞＞\r\n"];
        
        [escp printData:normalSize withLength:sizeof(normalSize)];				   
        [escp printString:@"株式会社POSCO 宮崎本社\r\n"];			   
        [escp printString:@"              TEL (0985)-56-0369\r\n"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy/MM/dd(EEE) H:mm   "];  
        NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
        dateString=[NSString stringWithFormat:@"%@担当：%@\n",dateString,tantou_id];
        //[escp printData:normalSize withLength:sizeof(normalSize)];	
        [escp printString:dateString];
        [escp printText:@"品名               数量     金額\r\n" withAlignment:ALIGNMENT_LEFT withOption:(FNT_UNDERLINE) withSize:(TXT_1WIDTH)];
        
        //各要素の保存
        for(int i=0;i<titleArry.count;i++){
            //NSString *idno=[idArry objectAtIndex:i];
            NSString *title=[titleArry objectAtIndex:i];
            NSString *price=[priceArry objectAtIndex:i];
            NSString *Kosu=[kosuArry objectAtIndex:i];
            [escp printString:[NSString stringWithFormat:@"%@\r\n",title]];
            
            price1=[NSNumber numberWithInt:[price intValue]];
            price2=[formatter stringFromNumber:price1];
            price1=[NSNumber numberWithInt:[price intValue]*[Kosu intValue]];
            price3=[formatter stringFromNumber:price1];
            int len2=[price2 length];
            int len3=[price3 length];
            //空白の挿入
            for(int i=0; i<7-len2; i++)price2=[NSString stringWithFormat:@" %@",price2];
            for(int i=0; i<7-len3; i++)price3=[NSString stringWithFormat:@" %@",price3];
            if(i!=titleArry.count-1){
                [escp printString:[NSString stringWithFormat:@"        %@ × %3d   %@\r\n",price2,[Kosu intValue],price3]];
            }
            else{
                [escp printText:[NSString stringWithFormat:@"        %@ × %3d   %@\r\n",price2,[Kosu intValue],price3] withAlignment:ALIGNMENT_LEFT withOption:(FNT_UNDERLINE) withSize:(TXT_1WIDTH)];
            }
            Goukei_Kosu=Goukei_Kosu+[Kosu intValue];
        }
        //空白の挿入
        int nebiki=goukei-goukei2;
        if(nebiki<0){
            price1=[NSNumber numberWithInt:nebiki];
            price2=[formatter stringFromNumber:price1];
            //空白の挿入
            len=[price2 length];
            for(int i=0; i<8-len; i++)price2=[NSString stringWithFormat:@" %@",price2];
            [escp printString:[NSString stringWithFormat:@"値引き                  %@\r\n",price2]];
        }
        
        price1=[NSNumber numberWithInt:goukei2+nebiki];
        price2=[formatter stringFromNumber:price1];
        len=[price2 length];
        for(int i=0; i<7-len; i++)price2=[NSString stringWithFormat:@" %@",price2];
        [escp printString:[NSString stringWithFormat:@"税込計             %3d点 %@\r\n",Goukei_Kosu,price2]];
        
        price1=[NSNumber numberWithInt:goukei-(goukei/1.05)];
        price2=[formatter stringFromNumber:price1];
        //空白の挿入
        len=[price2 length];
        for(int i=0; i<7-len; i++)price2=[NSString stringWithFormat:@" %@",price2];
        [escp printString:[NSString stringWithFormat:@"（内消費税 5.0％       %@）\r\n",price2]];
        if(henpin_flag==0){
            price1=[NSNumber numberWithInt:[priceLabel.text intValue]];
            price2=[formatter stringFromNumber:price1];
            //空白の挿入
            len=[price2 length];
            for(int i=0; i<7-len; i++)price2=[NSString stringWithFormat:@" %@",price2];
            [escp printString:[NSString stringWithFormat:@"預り金                   %@\r\n",price2]];
            [printData appendString:@"\n"];
        }
        
        price1=[NSNumber numberWithInt:[stroturi intValue]];
        price2=[formatter stringFromNumber:price1];
        //空白の挿入
        len=[price2 length];
        for(int i=0; i<7-len; i++)price2=[NSString stringWithFormat:@" %@",price2];
        if(henpin_flag==0){
            [escp printString:[NSString stringWithFormat:@"お釣り                   %@\r\n",price2]];
        }
        else{
            [escp printString:[NSString stringWithFormat:@"返金額                   %@\r\n",price2]];
        }
        if( self.receiptsettings.haveComment == 1){
            [escp printString:[NSString stringWithFormat:@"レシートNo:%@\r\n",Re_no]];   
        }
        [printData appendString:@"\n"];
        
        if(henpin_flag==0){
            [escp printString:@"       　<<お願い>>\r\n"];
            [escp printString:@"返品の際は、必ずレシートをご持参\r\n"];
            [escp printString:@"下さいませ。\r\n"];
            
        }
        // 3Line Feed
        [escp lineFeed:3];
    }
    [self disconnectCommand];

}

////////自動預り金処理/////////////////
-(void)Azu_Calculate{
    long lngKin=goukei2;
    long lngFor1;
    if(lngKin<=15000)lngFor1=20000-lngKin;
    else if(lngKin<=30000)lngFor1=35000-lngKin;
    else if (lngKin<=60000) lngFor1=65000-lngKin;
    else if(lngKin<=100000) lngFor1=105000-lngKin;
    else lngFor1=205000-lngKin;
    int intAzuMai=0;
    int intTuriMai=0;
    int intCnt=0;
    bool blnTuri;
    
    [DataAzukari drop_table];
    for (long i=0; i<=lngFor1; i++){
        blnTuri=TRUE;
        long lngAzu=lngKin+i;
        long lngAzu2=lngAzu;
        long lngTuri=lngAzu-lngKin;
        //NSLog(@"%@",[NSString stringWithFormat:@"%ld %ld %ld",lngAzu,lngAzu2,lngTuri]);
        intAzuMai=0;
        intTuriMai=0;
        if(lngAzu>=10000){
            intAzuMai=lngAzu/10000;
            lngAzu=lngAzu % 10000;
        }
        if(lngTuri>=10000){
            intTuriMai=lngTuri/10000;
            lngTuri=lngTuri%10000;
            if(intAzuMai!=0 && intTuriMai!=0)continue;
        }
        intAzuMai=0;
        intTuriMai=0;
        if(lngAzu>=5000){
            intAzuMai=lngAzu/5000;
            lngAzu=lngAzu % 5000;
        }
        if(lngTuri>=5000){
            intTuriMai=lngTuri/5000;
            lngTuri=lngTuri%5000;
            if(intAzuMai!=0 && intTuriMai!=0)continue;
        }
        intAzuMai=0;
        intTuriMai=0;
        if(lngAzu>=1000){
            intAzuMai=lngAzu/1000;
            lngAzu=lngAzu % 1000;
        }
        if(lngTuri>=1000){
            intTuriMai=lngTuri/1000;
            lngTuri=lngTuri%1000;
            if(intAzuMai!=0 && intTuriMai!=0)continue;
        }
        intAzuMai=0;
        intTuriMai=0;
        if(lngAzu>=500){
            intAzuMai=lngAzu/500;
            lngAzu=lngAzu % 500;
        }
        if(lngTuri>=500){
            intTuriMai=lngTuri/500;
            lngTuri=lngTuri%500;
            if(intAzuMai!=0 && intTuriMai!=0)continue;
        }
        intAzuMai=0;
        intTuriMai=0;
        if(lngAzu>=100){
            intAzuMai=lngAzu/100;
            lngAzu=lngAzu % 100;
        }
        if(lngTuri>=100){
            intTuriMai=lngTuri/100;
            lngTuri=lngTuri%100;
            if(intAzuMai!=0 && intTuriMai!=0)continue;
        }
        intAzuMai=0;
        intTuriMai=0;
        if(lngAzu>=50){
            intAzuMai=lngAzu/50;
            lngAzu=lngAzu % 50;
        }
        if(lngTuri>=50){
            intTuriMai=lngTuri/50;
            lngTuri=lngTuri%50;
            if(intAzuMai!=0 && intTuriMai!=0)continue;
        }
        intAzuMai=0;
        intTuriMai=0;
        if(lngAzu>=10){
            intAzuMai=lngAzu/10;
            lngAzu=lngAzu % 10;
        }
        if(lngTuri>=10){
            intTuriMai=lngTuri/10;
            lngTuri=lngTuri%10;
            if(intAzuMai!=0 && intTuriMai!=0)continue;
        }
        intAzuMai=0;
        intTuriMai=0;
        if(lngAzu>=5){
            intAzuMai=lngAzu/5;
            lngAzu=lngAzu % 5;
        }
        if(lngTuri>=5){
            intTuriMai=lngTuri/5;
            lngTuri=lngTuri%5;
            if(intAzuMai!=0 && intTuriMai!=0)continue;
        }
        if(lngAzu!=0 && lngTuri!=0)continue;
        
        intCnt++;
        //NSLog(@"%ld %d %d",lngAzu2,intAzuMai,intTuriMai);
        [DataAzukari insert_No:[NSString stringWithFormat:@"%d",intCnt] insert_Kingaku:[NSString stringWithFormat:@"%ld",lngAzu2]];
        
    }
    
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
