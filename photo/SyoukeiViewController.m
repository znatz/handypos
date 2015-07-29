//
//  SyoukeiViewController.m
//  photo
//
//  Created by POSCO on 12/07/18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SyoukeiViewController.h"
#import "SeisanViewController.h"
#import "DataModels.h"
#import "DataAzukari.h"
#import "KosuViewController.h"
#import "Syoukei.h"
#import "Goods.h"
#import "Settings.h"
#import "ConnectionManager.h"
#import "NSString+Ruby.h"
#import "Bumon.h"
#import "ShopSettings.h"
#import "DataMente.h"
#import "TransferData.h"
#import "Printer.h"
#import <AudioToolbox/AudioServices.h>


@interface SyoukeiViewController ()
@property(retain,nonatomic)UITableView *tableview;
@property Settings * settings;
@property ShopSettings * shopSettings;
@property Printer * printer;
- (NSString *) setupTitle : (NSMutableArray *) s ;
- (int) getTotalPrice : (NSMutableArray *) s ;
@end

@implementation SyoukeiViewController{
    
    NSMutableArray * allSyoukei;
    
    NSMutableArray *idArry2;
    NSMutableArray *kosuArry;
    NSMutableArray *PicModeArry;
    NSString *seisanFlg;

    NSString *price;
    NSString *kosu;
    
    BOOL picMode;
    
    // Sound Resource
    NSString *path;
    NSURL *url;
    SystemSoundID soundID;
    
}


//@synthesize tantou_id;
@synthesize tableview=_tableview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    /* Solve overlapping navigation bar in iOS 7 */
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    [super viewDidLoad];
    
    allSyoukei = [DataModels getAllSyoukei];
    self.settings = [DataAzukari getSettings];
    self.shopSettings = [DataMente getShopSettings];
    
    // Use photo or not
    picMode = [self.settings.picmode isEqual:@"1"] ? YES : NO;
    
    self.title = [self setupTitle:allSyoukei];
    
    /* Printer Setup */
    /*
    NSUserDefaults * defaulSettings = [NSUserDefaults standardUserDefaults];
    NSString * printerURL = [defaulSettings valueForKey:@"PrinterURL"];
    printerURL = printerURL ? printerURL : @"192.168.1.231";
    self.printer = [[Printer alloc] initWithURL:printerURL];
     */
    
    //背景用の設定
    self.navigationController.navigationBar.tintColor=[UIColor brownColor];
    UIImage *imgback=[UIImage imageNamed:@"back.bmp"];
    self.view.backgroundColor=[UIColor colorWithPatternImage:imgback];
    
    //音用の設定
    path=[[NSBundle mainBundle]pathForResource:@"butin" ofType:@"wav"];
    url=[NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url,&soundID);
    
    // Navigate to the SENDING page
    UIBarButtonItem *seisan;
    seisan = [[UIBarButtonItem alloc]initWithTitle:@"決定" style:UIBarButtonItemStyleBordered target:self action:@selector(seisan_controller)];
    self.navigationItem.rightBarButtonItem=seisan;//右側にボタン設置
    self.navigationItem.leftBarButtonItem.title=@"戻る";//左側のボタンタイトル
    
    _tableview=[[UITableView alloc]init];
    _tableview.frame = CGRectMake(0, 0, [self.view frame].size.width, [self.view frame].size.height-60);
    _tableview.dataSource=self;
    _tableview.delegate=self;
    _tableview.rowHeight=80.0;
    [_tableview reloadData];
    
    [self.view addSubview:_tableview];


}

//呼ばれるたびデータとテーブルを更新
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = [self setupTitle:allSyoukei];

    
    idArry2=[[NSMutableArray alloc]init];
    kosuArry=[[NSMutableArray alloc]init];//個数格納
    PicModeArry=[[NSMutableArray alloc]init];
    
   
    
    [DataModels selectID:idArry2 selectFlag:@"0"];
    
    if(picMode){
        _tableview.rowHeight=100.0;
    }
    else{
        _tableview.rowHeight=70.0;
    }

    [_tableview reloadData];//テーブルリロードで更新

    allSyoukei = [DataModels getAllSyoukei];
    [_tableview reloadData];
  
}
//行数の設定       ----------------------------------------------------------------------------------------------------------*/
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return allSyoukei.count;
}

//セクション数の設定 ----------------------------------------------------------------------------------------------------------*/
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//セクション名の設定 ----------------------------------------------------------------------------------------------------------*/
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"商品一覧";
}

/* セルに表示する内容 ----------------------------------------------------------------------------------------------------------*/

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Syoukei * eachSyoukei = allSyoukei[indexPath.row];
    
    /* Cell Initialization */
    static NSString *CellIdentifier=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell==nil){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
  
    /* Cell Text Setup -----------------------------------------------------*/
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize: 18]];
    [cell.detailTextLabel setFont:[UIFont boldSystemFontOfSize: 22]];
    
    cell.detailTextLabel.textAlignment= NSTextAlignmentLeft; //ios6
    cell.textLabel.text=eachSyoukei.title;
    
    /* Accessory Setup -----------------------------------------------------*/
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    /* Detailed Text Setup -------------------------------------------------*/
    price= [NSString stringWithFormat:@"%d", eachSyoukei.price ];

    kosu= [NSString stringWithFormat:@"%d",eachSyoukei.kosu];

    /* Picture Setup --------------------------------------------------------*/
    if(picMode){
        cell.imageView.image=[[UIImage alloc]initWithData:[DataModels getGoodsByID:eachSyoukei.ID].contents];
    }
    
    /* Price X Count Setup --------------------------------------------------------*/
    cell.detailTextLabel.text=[NSString stringWithFormat:@"¥%@ × %@",price,kosu];
    return cell;
}


//セルがタップされたときの処理 Call KosuViewController
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //セルの選択解除
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        self.title=@"小計";
    
    KosuViewController *kvc=[self.storyboard instantiateViewControllerWithIdentifier:@"Kosu"];
    kvc.selectedSyoukei = allSyoukei[indexPath.row];
    [self.navigationController pushViewController:kvc animated:YES];
    

}

- (int) getTotalPrice : (NSMutableArray *) s {
    int total = 0;
    for (Syoukei * i in s) {
        total += i.price * i.kosu;
    }
    return total;
}


- (NSString *) setupTitle : (NSMutableArray *) s {
    int total = 0;
    int count = 0;
    for (Syoukei * i in s) {
        total += i.price * i.kosu;
        count += i.kosu;
    }
    NSString * title = @"小計";

    if (count == 0) return title;

    title = [NSString stringWithFormat:@"%d個%d円", count, total];
    return title;
}


/* This will called the old Seisan page which is disable now 
 
    -(void)seisan_controller{
        self.title=@"小計";
        SeisanViewController *svc=[self.storyboard instantiateViewControllerWithIdentifier:@"Seisan"];
        svc.totalPrice = [self getTotalPrice:allSyoukei];
        [self.navigationController pushViewController:svc animated:YES];
    }
*/


/* Submit and Send to server */
-(void)seisan_controller{
    
    //日付の取得
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
    NSDate *now=[NSDate date];
    [formatter setDateFormat:@"yyyy年MM月dd日(E) HH:mm"];
    NSString *time=[formatter stringFromDate:now];
    
    allSyoukei = [DataModels getAllSyoukei];
    NSString * Re_no= self.shopSettings.receipt;

    NSUserDefaults * defaultSettings = [NSUserDefaults standardUserDefaults];
    NSString * tableNO = [defaultSettings objectForKey:@"tableNO"];
    
    //各要素の保存
    for(int i=0;i<allSyoukei.count;i++){

        Syoukei * s = allSyoukei[i];
        
        
        Goods * g = [DataModels getGoodsByID:s.ID];
        Bumon * b = (Bumon *) [DataModels getBumonByID:g.bumon];
        
        [DataModels saveToSeisan:s withTime:time withReceiptNo:Re_no withBumon:b.bumon];

        /* Prepare data for sending !!!   --------------------------- */
        [DataModels createTransferData];
        TransferData * transfer = [[TransferData alloc] initWithTantoID : self.settings.tantou
                                                             goodsTitle : s.title
                                                                   kosu : [NSString stringWithFormat:@"%d", s.kosu]
                                                                   time : time
                                                              receiptNo : Re_no
                                                                tableNO : tableNO];
        [DataModels saveToTransfer:transfer];
        
        /* Update Stock
            for(int j=0;j<idArry2.count;j++){
                // TODO Unknown
                if([s.ID intValue]==[[idArry2 objectAtIndex:j] intValue]){
                    [DataModels selectID:[idArry2 objectAtIndex:j] updateKosu:[NSString stringWithFormat:@"%d",[[kosuArry2 objectAtIndex:j] intValue]+s.kosu] selectFlag:@"4"];
                }
            }
         */
    }
    
    
    //レシートNoの増加
    Re_no=[NSString stringWithFormat:@"%d",[Re_no intValue]+1];

    self.shopSettings.receipt = Re_no;
    [DataMente updateShopSettings:self.shopSettings];
    
    
    
    /* Print -------------------------------------------- */
    /*
    [self.printer printHeader];
    [self.printer printContentsWith:[DataModels getAllTransfer] syoukei:allSyoukei];
    [self.printer printFooter];
    [self.printer close];
     */
    
    // TODO Cleanup before return to home!
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0]animated:YES];//保存後ホームに戻る
   
    /* Send To Kichen ----------------------------------- */
    [ConnectionManager uploadFile:@"BurData.sqlite"];
    [DataModels dropTransferData];
    
    AudioServicesPlaySystemSound(soundID);
}



/* WasteLand */
- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
