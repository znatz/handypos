//
//  NikkeiViewController.m
//  photo
//
//  Created by POSCO on 12/08/02.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NikkeiViewController.h"
#import "DataModels.h"
#import "DataAzukari.h"
#import "DataAzukari.h"
#import "Settings.h"

//#import "MiniPrinterFunctions.h"
#import <Foundation/Foundation.h>

@interface NikkeiViewController ()
@property Settings * settings;

@end

@implementation NikkeiViewController{
    int uriage;
    int kosu_goukei;
    int henpin;
    int kosu_henpin;
    int Printer_flg;
    
    NSString *Flag;
    NSString *all_goukei;
    NSString *zei;
    NSString *kyaku_num;
    NSString *kyaku_tanka;
    NSString *kyaku_tennum;
    NSString *heikin_tanka;
    NSString *sashihiki;
    NSString *nebiki;
    NSString *henpin_goukei;
    NSString *aridaka;
    int table_count1;
    int table_count2;


    NSMutableArray *idArry;
    NSMutableArray *idArry2;//売上用
    NSMutableArray *idArry3;//返品用
    NSMutableArray *contentsArry;
    
    NSMutableArray *titleArry;
    NSMutableArray *titleArryHenpin;
    NSMutableArray *priceArry;
    NSMutableArray *priceArryHenpin;
    
    NSMutableArray *kosuArry;
    NSMutableArray *kosuArry2;//売上用
    NSMutableArray *kosuArry3;//返品用
    NSMutableArray *renoArry;
    NSMutableArray *nebikiArry;
    

    NSMutableArray *BuIDArry;
    NSMutableArray *BuIDArry2;
    NSMutableArray *BumonArry;
    //印刷用ボタン
    UIBarButtonItem *print; 

}
//プリンタとの接続
- (void)connectCommand
{
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
	}
}
//プリンタの切断
- (void) disconnectCommand{
    [escp closePort];
    NSLog(@"プリンタ切断\r\n");
}


@synthesize tableview=_tableview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"日計表";
    self.settings = [DataAzukari getSettings];
    
    
    //プリンタ用の設定
    escp = [[ESCPOSPrinter alloc] init];
    
    Flag=@"3";
    print = [[UIBarButtonItem alloc]initWithTitle:@"印刷" style:UIBarButtonItemStyleBordered target:self action:@selector(print_syori)];
    self.navigationItem.rightBarButtonItem=print;//右側にボタン設置
    [DataModels drop_table:Flag];

}

-(void)viewWillAppear:(BOOL)animated{
    //3桁区切りの設定
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@",###"];
    
    idArry=[[NSMutableArray alloc]init];
    titleArry=[[NSMutableArray alloc]init];
    priceArry=[[NSMutableArray alloc]init];
    kosuArry=[[NSMutableArray alloc]init];

    
    [DataModels selectID:idArry selectFlag:Flag];
    [DataModels selectTitle:titleArry selectFlag:Flag];
    [DataModels selectPrice:priceArry selectFlag:Flag];
    [DataModels selectKosu:kosuArry selectFlag:Flag];

    
    table_count1=0;
    
    NSString *idno;
    NSString *title;
    NSString *price;
    NSString *kosu;
    
    for(int i=0;i<idArry.count;i++){
        idno=[idArry objectAtIndex:i];
        title=[titleArry objectAtIndex:i];
        price=[priceArry objectAtIndex:i];
        kosu=[kosuArry objectAtIndex:i];
        
        if([kosu intValue]>0){
            kosu_goukei=kosu_goukei+[kosu intValue];//個数合計
            uriage=uriage+[price intValue]*[kosu intValue];//売上げ合計
        }
        if([kosu intValue]<0){
            kosu_henpin=kosu_henpin+[kosu intValue];//個数合計
            henpin=henpin+[price intValue]*[kosu intValue];//返品合計
        }
        //単品表示
        if([self.settings.nimode intValue]==0){
            NSString *kosu2=@"";//売上用
            NSString *kosu3=@"";//返品用
            //売上
            idArry2=[[NSMutableArray alloc]init];
            [DataModels selectID:idArry2 selectFlag:@"4"];
            kosuArry2=[[NSMutableArray alloc]init];
            [DataModels selectKosu:kosuArry2 selectFlag:@"4"];
            
            //返品
            idArry3=[[NSMutableArray alloc]init];
            [DataModels selectID:idArry3 selectFlag:@"5"];
            kosuArry3=[[NSMutableArray alloc]init];
            [DataModels selectKosu:kosuArry3 selectFlag:@"5"];
            
            for(int j=0; j<idArry2.count; j++){
                if([idno intValue]==[[idArry2 objectAtIndex:j] intValue] && [[kosuArry2 objectAtIndex:j] intValue]>0){
                    if([kosu intValue]>0){
                        kosu2=[kosuArry2 objectAtIndex:j];
                        break;
                    }
                }
            }
            for(int j=0; j<idArry3.count; j++){
                if([idno intValue]==[[idArry3 objectAtIndex:j] intValue] && [[kosuArry3 objectAtIndex:j] intValue]<0){
                    if([kosu intValue]<0){
                        kosu3=[kosuArry3 objectAtIndex:j];
                        break;
                    }
                }
            }
            
            if([kosu2 isEqual:@""] && [kosu3 isEqual:@""]){// && [kosu intValue]>0){
                [DataModels insertID:idno insertTitle:title insertPrice:price insertKosu:kosu selectFlag:Flag];
            }
            else if(![kosu2 isEqual:@""]){// && [kosu intValue]>0){
                kosu2=[NSString stringWithFormat:@"%d",[kosu2 intValue]+[kosu intValue]];
                [DataModels selectID:idno updateKosu:kosu2 selectFlag:Flag];
            }
            else if(![kosu3 isEqual:@""]){
                kosu3=[NSString stringWithFormat:@"%d",[kosu3 intValue]+[kosu intValue]];
                [DataModels selectID:idno updateKosu:kosu3 selectFlag:Flag];
            }
        }
    }
    //部門表示
    if([self.settings.nimode intValue]==1){
        NSString *price2;
        NSString *kosu2;
        idno=@"",title=@"",price=@"",kosu=@""; 
        BumonArry=[[NSMutableArray alloc]init];
        [DataModels selectBumon:BumonArry selectFlag:@"6"];
        BuIDArry=[[NSMutableArray alloc]init];
        [DataModels selectBumonID:BuIDArry selectFlag:@"8"];
        BuIDArry2=[[NSMutableArray alloc]init];
        [DataModels selectBumonID:BuIDArry2 selectFlag:@"4"];
        
        for(int i=0; i<BuIDArry.count; i++){
            for(int j=0; j<BuIDArry2.count; j++){
                if([[BuIDArry objectAtIndex:i] intValue]==[[BuIDArry2 objectAtIndex:j] intValue]){
                //NSLog(@"%@ %@ %@",[BuIDArry objectAtIndex:i],[BumonArry objectAtIndex:i],[BuIDArry2 objectAtIndex:j]);
                    idno=[BuIDArry objectAtIndex:i];
                    title=[BumonArry objectAtIndex:i];
                    if([[kosuArry objectAtIndex:j] intValue]>0){
                        price=[NSString stringWithFormat:@"%d",[price intValue]+[[priceArry objectAtIndex:j] intValue]*[[kosuArry objectAtIndex:j] intValue]];
                        kosu=[NSString stringWithFormat:@"%d",[kosu intValue]+[[kosuArry objectAtIndex:j] intValue]];
                    }
                    else if([[kosuArry objectAtIndex:j] intValue]<0){
                        price2=[NSString stringWithFormat:@"%d",[price2 intValue]+[[priceArry objectAtIndex:j] intValue]*[[kosuArry objectAtIndex:j] intValue]];
                        kosu2=[NSString stringWithFormat:@"%d",[kosu2 intValue]+[[kosuArry objectAtIndex:j] intValue]];
                        //NSLog(@"%@ %@ %@ %@",[BuIDArry objectAtIndex:i],[BuIDArry2 objectAtIndex:j],price2,kosu2);
                    }
                }
            }
            if([kosu intValue]>0){
                [DataModels insertID:idno insertTitle:title insertPrice:price insertKosu:kosu selectFlag:Flag];
                price=@"0"; kosu=@"0"; 
            }
            if([kosu2 intValue]<0){
                [DataModels insertID:idno insertTitle:title insertPrice:price2 insertKosu:kosu2 selectFlag:Flag];
                price2=@"0"; kosu2=@"0";
            }
        }
    }
    
    
    renoArry=[[NSMutableArray alloc]init];
    [DataModels selectReno:renoArry];
    nebikiArry=[[NSMutableArray alloc]init];
    [DataModels selectNebiki:nebikiArry];
    nebiki=@"0";
    int nebiki_goukei;
    for(int i=0; i<nebikiArry.count; i++){
        nebiki_goukei=[nebiki intValue]-[[nebikiArry objectAtIndex:i] intValue];
        nebiki=[NSString stringWithFormat:@"%@",[formatter stringFromNumber:[NSNumber numberWithInt:nebiki_goukei]]];
    }
    all_goukei=[NSString stringWithFormat:@"%@",[formatter stringFromNumber:[NSNumber numberWithInt:uriage]]];//税抜きの売上
    
    double kiriage=uriage-uriage/1.05;
    int kirisute=kiriage;
    zei=[NSString stringWithFormat:@"%@",[formatter stringFromNumber:[NSNumber numberWithInt:kirisute]]];//消費税
    sashihiki=[NSString stringWithFormat:@"%@",[formatter stringFromNumber:[NSNumber numberWithInt:uriage-kirisute]]];//税込み
    henpin_goukei=[NSString stringWithFormat:@"%@",[formatter stringFromNumber:[NSNumber numberWithInt:henpin]]];
    aridaka=[NSString stringWithFormat:@"%@",[formatter stringFromNumber:[NSNumber numberWithInt:uriage+nebiki_goukei+henpin]]];
    
    kyaku_num=[NSString stringWithFormat:@"%d",[[renoArry objectAtIndex:renoArry.count-1] intValue]];
    kyaku_tennum=[NSString stringWithFormat:@"%2.1f",kosu_goukei/[kyaku_num doubleValue]];
    kyaku_tanka=[NSString stringWithFormat:@"%@",[formatter stringFromNumber:[NSNumber numberWithInt:uriage/[kyaku_num intValue]]]];
    
    idArry=[[NSMutableArray alloc]init];
    titleArry=[[NSMutableArray alloc]init];
    priceArry=[[NSMutableArray alloc]init];
    kosuArry=[[NSMutableArray alloc]init];
    [DataModels selectID:idArry selectFlag:@"4"];
    [DataModels selectTitle:titleArry selectFlag:@"4"];
    [DataModels selectPrice:priceArry selectFlag:@"4"];
    [DataModels selectKosu:kosuArry selectFlag:@"4"];
    
    
    idArry3=[[NSMutableArray alloc]init];
    titleArryHenpin=[[NSMutableArray alloc]init];
    priceArryHenpin=[[NSMutableArray alloc]init];
    kosuArry3=[[NSMutableArray alloc]init];
    [DataModels selectID:idArry3 selectFlag:@"5"];
    [DataModels selectTitle:titleArryHenpin selectFlag:@"5"];
    [DataModels selectPrice:priceArryHenpin selectFlag:@"5"];
    [DataModels selectKosu:kosuArry3 selectFlag:@"5"];
    

    _tableview=[[UITableView alloc]init];
    _tableview.frame = CGRectMake(0, 0, 320, 460-44);
    _tableview.dataSource=self;
    _tableview.delegate=self;
    
    if([self.settings.picmode intValue]==0 || [self.settings.nimode intValue]==1){
        _tableview.rowHeight=45.0;
    }
    else{
        _tableview.rowHeight=75.0;
    }
    [self.view addSubview:_tableview];
    _tableview.allowsSelection=NO;
}
//セクション数の設定
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

//セクション名の設定
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section==0){
        if([self.settings.picmode intValue]==0 || [self.settings.nimode intValue]==1){
            if([self.settings.nimode intValue]==1)return @"    部門名   　　  　  数量　 売上合計";
            else return @"商品番号　　売価　数量　 売上合計";
        }
        else{
            return @"商品画像　　売価　 数量　売上合計";
        }
    }
    if(section==1){
        if([self.settings.picmode intValue]==0 || [self.settings.nimode intValue]==1){
            if([self.settings.nimode intValue]==1)return @"    部門名   　　  　  数量　 返品合計";
            else return @"商品番号　　売価　数量　 返品合計";
        }
        else{
            return @"商品画像　　 売価　数量　返品合計";
        }
    }
    if(section==2)return @"総合売上";
    if(section==3)return @"お客別";
    return nil;
    
}
//行数の設定
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section==0){
        return idArry.count;
    }
    if(section==1){
        return idArry3.count;
    }
    if(section==2){
        return 6;
    }
    if(section==3){
        return 3;
    }
    return 0;
     
}

//セルに表示する内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // NSNumberFormatterの作成
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@",###"];

    
    static NSString *CellIdentifier=@"Cell";//空のセルを生成
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //if(cell==nil){
    if(indexPath.section==0 || indexPath.section==1){
        if([self.settings.nimode intValue]==1){
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        else{
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
    }
    else if(indexPath.section==2 || indexPath.section==3){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    //}

    if(indexPath.section==0){
        NSString *title=[titleArry objectAtIndex:indexPath.row];
        NSString *idno=[idArry objectAtIndex:indexPath.row];
        
        //3桁区切りの為にNSNumber
        NSNumber *price=[NSNumber numberWithInt:[[priceArry objectAtIndex:indexPath.row]intValue]];
        NSString *price2=[formatter stringFromNumber:price];
        
        if([self.settings.nimode intValue]==1){
            for(int i=0; i<13-[[formatter stringFromNumber:price] length]; i++){//空白導入
                if(i%4==0)price2=[NSString stringWithFormat:@" %@",price2];
                else price2=[NSString stringWithFormat:@"  %@",price2];
            }
        }
        else{
            for(int i=0; i<7-[[formatter stringFromNumber:price] length]; i++){//空白導入
                if(i%3==0)price2=[NSString stringWithFormat:@" %@",price2];
                else price2=[NSString stringWithFormat:@"  %@",price2];
            }
        }
        
        NSString *kosu=[kosuArry objectAtIndex:indexPath.row];
        for(int i=0; i<4-[[kosuArry objectAtIndex:indexPath.row] length]; i++){//空白導入
            kosu=[NSString stringWithFormat:@"  %@",kosu];
        }
        
        NSNumber *goukei=[NSNumber numberWithInt:[price intValue]*[kosu intValue]];
        NSString *goukei2=[formatter stringFromNumber:goukei];
       
        for(int i=0; i<11-[[formatter stringFromNumber:goukei] length]; i++){//空白導入
            if(i%3==0)goukei2=[NSString stringWithFormat:@" %@",goukei2];
            else goukei2=[NSString stringWithFormat:@"  %@",goukei2];
        }
        
        if([self.settings.picmode intValue]==0  || [self.settings.nimode intValue]==1){
            if([self.settings.nimode intValue]==1){
                [cell.textLabel setFont:[UIFont boldSystemFontOfSize: 16]];
                [cell.detailTextLabel setFont:[UIFont boldSystemFontOfSize: 16]];
                cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ %@",kosu,price2];
                cell.textLabel.text=[NSString stringWithFormat:@"%@ %@",idno,title];
            }
            else{
                [cell.textLabel setFont:[UIFont boldSystemFontOfSize: 14]];
                [cell.detailTextLabel setFont:[UIFont boldSystemFontOfSize: 18]];
                cell.detailTextLabel.text=[NSString stringWithFormat:@"%@  %@ %@ %@",idno,price2,kosu,goukei2];
                cell.textLabel.text=[NSString stringWithFormat:@"%@",title];
            }
        }
        else{
            [cell.textLabel setFont:[UIFont boldSystemFontOfSize: 18]];
            [cell.detailTextLabel setFont:[UIFont boldSystemFontOfSize: 16]];
            contentsArry=[[NSMutableArray alloc]init];
            [DataModels selectContents:contentsArry where_id:idno];
            cell.imageView.image=[[UIImage alloc]initWithData:[contentsArry objectAtIndex:0]];
            cell.textLabel.text=[NSString stringWithFormat:@" %@ %@%@",price2,kosu,goukei2];
        }
        
    }

    else if(indexPath.section==1){

        NSString *title=[titleArryHenpin objectAtIndex:indexPath.row];
        NSString *idno=[idArry3 objectAtIndex:indexPath.row];
        
        //cell.textLabel.text=[NSString stringWithFormat:@"%@:%@",idno,title];
        
        NSNumber *price=[NSNumber numberWithInt:[[priceArryHenpin objectAtIndex:indexPath.row]intValue]];
        NSString *price2=[formatter stringFromNumber:price];
        if([self.settings.nimode intValue]==1){
            for(int i=0; i<13-[[formatter stringFromNumber:price] length]; i++){//空白導入
                if(i%4==0)price2=[NSString stringWithFormat:@" %@",price2];
                else price2=[NSString stringWithFormat:@"  %@",price2];
            }
        }
        else{
            for(int i=0; i<7-[[formatter stringFromNumber:price] length]; i++){//空白導入
                if(i%3==0)price2=[NSString stringWithFormat:@" %@",price2];
                else price2=[NSString stringWithFormat:@"  %@",price2];
            }
        }
        
        NSString *kosu=[kosuArry3 objectAtIndex:indexPath.row];
        for(int i=0; i<4-[[kosuArry3 objectAtIndex:indexPath.row] length]; i++){//空白導入
            kosu=[NSString stringWithFormat:@"  %@",kosu];
        }
        
        NSNumber *goukei=[NSNumber numberWithInt:[price intValue]*[kosu intValue]];
        NSString *goukei2=[formatter stringFromNumber:goukei];
        for(int i=0; i<11-[[formatter stringFromNumber:goukei] length]; i++){//空白導入
            if(i%3==0)goukei2=[NSString stringWithFormat:@" %@",goukei2];
            else goukei2=[NSString stringWithFormat:@"  %@",goukei2];
        }
        
        //cell.detailTextLabel.text=[NSString stringWithFormat:@"%@円×%@個=%@円",price2,kosu,goukei2];
        if([self.settings.picmode intValue]==0 || [self.settings.nimode intValue]==1){
            if([self.settings.nimode intValue]==1){
                [cell.textLabel setFont:[UIFont boldSystemFontOfSize: 16]];
                [cell.detailTextLabel setFont:[UIFont boldSystemFontOfSize: 16]];
                cell.detailTextLabel.text=[NSString stringWithFormat:@"%@  %@",kosu,price2];
                cell.textLabel.text=[NSString stringWithFormat:@"%@ %@",idno,title];
            }
            else{
                [cell.textLabel setFont:[UIFont boldSystemFontOfSize: 14]];
                [cell.detailTextLabel setFont:[UIFont boldSystemFontOfSize: 18]];
                cell.detailTextLabel.text=[NSString stringWithFormat:@"%@  %@ %@ %@",idno,price2,kosu,goukei2];
                cell.textLabel.text=[NSString stringWithFormat:@"%@",title];
            }
        }
        else{
            [cell.textLabel setFont:[UIFont boldSystemFontOfSize: 18]];
            [cell.detailTextLabel setFont:[UIFont boldSystemFontOfSize: 16]];
            contentsArry=[[NSMutableArray alloc]init];
            [DataModels selectContents:contentsArry where_id:idno];
            cell.imageView.image=[[UIImage alloc]initWithData:[contentsArry objectAtIndex:0]];
            cell.textLabel.text=[NSString stringWithFormat:@" %@  %@ %@",price2,kosu,goukei2];
        }
            
        
    }
    else if(indexPath.section==2){
        if(indexPath.row==0){
            cell.textLabel.text=@"売上げ";
            cell.detailTextLabel.text=sashihiki;
        }
        else if(indexPath.row==1){
            cell.textLabel.text=@"消費税";
            cell.detailTextLabel.text=zei;
        }
        else if(indexPath.row==2){
        cell.textLabel.text=@"差引計";
        cell.detailTextLabel.text=all_goukei;
        }
        else if(indexPath.row==3){
            cell.textLabel.text=@"値引き";
            cell.detailTextLabel.text=nebiki;  
        }
        else if(indexPath.row==4){
            cell.textLabel.text=@"返品額";
            cell.detailTextLabel.text=henpin_goukei;  
        }
        else if(indexPath.row==5){
            cell.textLabel.text=@"現金在高";
            cell.detailTextLabel.text=aridaka;  
        }
    }
    else if(indexPath.section==3){
 
        if(indexPath.row==0){
            cell.textLabel.text=@"客数";
            cell.detailTextLabel.text=kyaku_num;
        }
        else if(indexPath.row==1){
            cell.textLabel.text=@"客点数";
            cell.detailTextLabel.text=kyaku_tennum;
        }
        else {
            cell.textLabel.text=@"客単価";
            cell.detailTextLabel.text=kyaku_tanka;
        }
    }
    return cell;

}

////////////////////////印刷処理///////////////////////////////
-(void)print_syori{
    [self connectCommand];
    
    if(Printer_flg==0){
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setPositiveFormat:@",###"];
        
        idArry=[[NSMutableArray alloc]init];
        [DataModels selectID:idArry selectFlag:@"4"];
        priceArry=[[NSMutableArray alloc]init];
        [DataModels selectPrice:priceArry selectFlag:@"4"];
        kosuArry2=[[NSMutableArray alloc]init];
        [DataModels selectKosu:kosuArry2 selectFlag:@"4"];
        titleArry=[[NSMutableArray alloc]init];
        [DataModels selectTitle:titleArry selectFlag:@"4"];
    
        //売上
        priceArryHenpin=[[NSMutableArray alloc]init];
        [DataModels selectPrice:priceArryHenpin selectFlag:@"5"];
        kosuArry3=[[NSMutableArray alloc]init];
        [DataModels selectKosu:kosuArry3 selectFlag:@"5"];
        titleArryHenpin=[[NSMutableArray alloc]init];
        [DataModels selectTitle:titleArryHenpin selectFlag:@"5"];
    
        char normalSize[3] = {0x1D,0x21,0x00};
        char dWidthSize[3] = {0x1D,0x21,0x10};
        char centerAlign[3] = {0x1B,0x61,0x01};
        [escp setEncoding:NSShiftJISStringEncoding];
        [escp printData:dWidthSize withLength:sizeof(dWidthSize)];				   
        [escp printData:centerAlign withLength:sizeof(centerAlign)];
        
        NSString * imgfile1 = [[NSBundle mainBundle] pathForResource:@"logo.png" ofType:nil];
        [escp printBitmap:imgfile1 withAlignment:ALIGNMENT_LEFT withSize:BITMAP_NORMAL withBrightness:0];
        [escp lineFeed:1];
        [escp printString:@" ＜＜日計表＞＞\r\n"];
        [escp printData:normalSize withLength:sizeof(normalSize)];	
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy/MM/dd(EEE) H:mm\r\n"];  
        NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
        [escp printString:dateString];
        if([self.settings.nimode intValue]==1){
            [escp printText:@"部門            数量        金額\r\n" withAlignment:ALIGNMENT_LEFT withOption:(FNT_UNDERLINE) withSize:(TXT_1WIDTH)];
        }
        else{
            [escp printText:@"品名               数量     金額\r\n" withAlignment:ALIGNMENT_LEFT withOption:(FNT_UNDERLINE) withSize:(TXT_1WIDTH)];
        }
    
        for(int i=0;i<titleArry.count;i++){
            NSString *title=[titleArry objectAtIndex:i];
            NSString *price=[priceArry objectAtIndex:i];
            NSString *Kosu=[kosuArry2 objectAtIndex:i];
            if([self.settings.nimode intValue]==1){
                [escp printString:[NSString stringWithFormat:@"%@ %@\r\n",[idArry objectAtIndex:i],title]];
            }
            else{
                [escp printString:[NSString stringWithFormat:@"%@\r\n",title]];
            }
        
            NSNumber *price1=[NSNumber numberWithInt:[price intValue]];
            NSString *price2=[formatter stringFromNumber:price1];
            price1=[NSNumber numberWithInt:[price intValue]*[Kosu intValue]];
            NSString *price3=[formatter stringFromNumber:price1];
        
            int len2=[price2 length];
            int len3=[price3 length];
        
            if([self.settings.nimode intValue]==1){
                for(int j=0; j<12-len2; j++)price2=[NSString stringWithFormat:@" %@",price2];
                if(i!=titleArry.count-1){
                    [escp printString:[NSString stringWithFormat:@"               %4d %@\r\n",[Kosu intValue],price2]];
                }
                else{
                    [escp printText:[NSString stringWithFormat:@"               %4d %@\r\n",[Kosu intValue],price2] withAlignment:ALIGNMENT_LEFT withOption:(FNT_UNDERLINE) withSize:(TXT_1WIDTH)];
                }
            }
            else{
                for(int j=0; j<7-len2; j++)price2=[NSString stringWithFormat:@" %@",price2];
                for(int j=0; j<7-len3; j++)price3=[NSString stringWithFormat:@" %@",price3];
                if(i!=titleArry.count-1){
                    [escp printString:[NSString stringWithFormat:@"        %@ ×%4d   %@\r\n",price2,[Kosu intValue],price3]];
                }
                else{
                    [escp printText:[NSString stringWithFormat:@"        %@ ×%4d   %@\r\n",price2,[Kosu intValue],price3] withAlignment:ALIGNMENT_LEFT withOption:(FNT_UNDERLINE) withSize:(TXT_1WIDTH)];
                }
            }
        }
        for(int i=0;i<titleArryHenpin.count;i++){
            NSString *title=[titleArryHenpin objectAtIndex:i];
            NSString *price=[priceArryHenpin objectAtIndex:i];
            NSString *Kosu=[kosuArry3 objectAtIndex:i];
            if([self.settings.nimode intValue]==1){
                [escp printString:[NSString stringWithFormat:@"%@ %@\r\n",[idArry objectAtIndex:i],title]];
            }
            else{
                [escp printString:[NSString stringWithFormat:@"%@\r\n",title]];
            }
            NSNumber *price1=[NSNumber numberWithInt:[price intValue]];
            NSString *price2=[formatter stringFromNumber:price1];
            price1=[NSNumber numberWithInt:[price intValue]*[Kosu intValue]];
            NSString *price3=[formatter stringFromNumber:price1];
        
            int len2=[price2 length];
            int len3=[price3 length];
        
            //空白の挿入
            if([self.settings.nimode intValue]==1){
                for(int j=0; j<12-len2; j++)price2=[NSString stringWithFormat:@" %@",price2];
                if(i!=titleArryHenpin.count-1){
                    [escp printString:[NSString stringWithFormat:@"               %4d %@\r\n",[Kosu intValue],price2]];
                }
                else{
                    [escp printText:[NSString stringWithFormat:@"               %4d %@\r\n",[Kosu intValue],price2] withAlignment:ALIGNMENT_LEFT withOption:(FNT_UNDERLINE) withSize:(TXT_1WIDTH)];
                }
            }
            else{
                for(int j=0; j<7-len2; j++)price2=[NSString stringWithFormat:@" %@",price2];
                for(int j=0; j<7-len3; j++)price3=[NSString stringWithFormat:@" %@",price3];
                if(i!=titleArryHenpin.count-1){
                    [escp printString:[NSString stringWithFormat:@"        %@ ×%4d   %@\r\n",price2,[Kosu intValue],price3]];
                }
                else{
                    [escp printText:[NSString stringWithFormat:@"        %@ ×%4d   %@\r\n",price2,[Kosu intValue],price3] withAlignment:ALIGNMENT_LEFT withOption:(FNT_UNDERLINE) withSize:(TXT_1WIDTH)];
                }
            }
        }
    
        NSString *koumoku;
        koumoku=[self space_insert:sashihiki];
        [escp printString:[NSString stringWithFormat:@"売上げ　　　%@\r\n",koumoku]];
        koumoku=[self space_insert:zei];
        [escp printString:[NSString stringWithFormat:@"消費税　　　%@\r\n",koumoku]];
        koumoku=[self space_insert:all_goukei];
        [escp printText:[NSString stringWithFormat:@"差引額　　　%@\r\n",koumoku] withAlignment:ALIGNMENT_LEFT withOption:(FNT_UNDERLINE) withSize:(TXT_1WIDTH)];
        koumoku=[self space_insert:nebiki];
        [escp printString:[NSString stringWithFormat:@"値引き　　　%@\r\n",koumoku]];
        koumoku=[self space_insert:henpin_goukei];
        [escp printString:[NSString stringWithFormat:@"返品額　　　%@\r\n",koumoku]];
        koumoku=[self space_insert:aridaka];
        [escp printText:[NSString stringWithFormat:@"現金在高　　%@\r\n",koumoku] withAlignment:ALIGNMENT_LEFT withOption:(FNT_UNDERLINE) withSize:(TXT_1WIDTH)];
        koumoku=[self space_insert:kyaku_num];
        [escp printString:[NSString stringWithFormat:@"客数　　　　%@\r\n",koumoku]];
        koumoku=[self space_insert:kyaku_tennum];
        [escp printString:[NSString stringWithFormat:@"客点数　　　%@\r\n",koumoku]];
        koumoku=[self space_insert:kyaku_tanka];
        [escp printString:[NSString stringWithFormat:@"客単価　　　%@\r\n",koumoku]];
        // 2Line Feed
        [escp lineFeed:3];

    }
    [self disconnectCommand];
}
//空白の挿入
-(NSString *)space_insert:(NSString *)koumoku{
    NSString *koumoku2=koumoku;
    for(int i=0; i<20-koumoku.length; i++){
        koumoku2=[NSString stringWithFormat:@" %@",koumoku2];
    }
    return koumoku2;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
