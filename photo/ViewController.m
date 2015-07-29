//

//  ViewController.m
//  photo
//
//  Created by POSCO on 12/07/12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.

/* ZNATZ 
 
 This view is navigated from TantoViewController with strBumon equals to 0
 OR                     from BumonViewController with strBumon equals to the selected.
 
 */

//
#import "SyoukeiViewController.h"
#import "ViewController.h"
#import "MainViewController.h"
#import "DataModels.h"
#import "DataAzukari.h"
#import "DataUpdate.h"
#import "Goods.h"
#import "Syoukei.h"
#import "Settings.h"
#import "NSString+Ruby.h"

@interface ViewController ()

@property(retain,nonatomic)UITableView *tableview;
@property Settings * settings;
@end

@implementation ViewController{
    
    NSMutableArray * allGoods;
    NSMutableArray * allSyoukei;
    NSMutableArray * updateSyoukei;

    
    /* temporary load all pages goods id and count */
    NSMutableArray *kosuArry;
    NSMutableArray *idArry2;

    
    
    NSMutableArray *titleArry2;
    NSMutableArray *priceArry2;

    NSString * pricetag;
    NSString *count;
    
    // Sound Resource
    NSString *path;
    NSURL *url;
    SystemSoundID soundID;
    
    // "PLUS"  Button Image
    UIImage *imgbutton;
    
    BOOL picMode ;
    
}
//@synthesize uriage;

@synthesize row_num;
@synthesize tableview=_tableview;
@synthesize strBumon;

- (void)viewDidLoad
{
    /* Solve overlapping navigation bar in iOS 7 */
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [super viewDidLoad];
    self.title=@"売上登録";//title名
    
    self.settings = [DataAzukari getSettings];
    allSyoukei = [DataModels getAllSyoukei];
    
    // Use photo or not
    picMode = [self.settings.picmode isEqual:@"1"] ? YES : NO;
    
    // Button Image Initialization
    imgbutton=[UIImage imageNamed:@"button1.gif"];
    
    //背景用の設定
    self.navigationController.navigationBar.tintColor=[UIColor brownColor];
    UIImage *imgback=[UIImage imageNamed:@"back.bmp"];
    self.view.backgroundColor=[UIColor colorWithPatternImage:imgback];
    
    _tableview=[[UITableView alloc]init];
    // minus 40 for rebouning UI;
    _tableview.frame = CGRectMake(0, 0, [self.view frame].size.width, [self.view frame].size.height-60);
    _tableview.dataSource=self;
    _tableview.allowsSelection=NO;
    _tableview.delegate=self;
    [self.view addSubview:_tableview];

    
    //音用の設定
    path=[[NSBundle mainBundle]pathForResource:@"butin" ofType:@"wav"];
    url=[NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url,&soundID);
    
    //右上のボタンの表示
    UIBarButtonItem *syoukei = [[UIBarButtonItem alloc]initWithTitle:@"小計" style:UIBarButtonItemStyleBordered target:self action:@selector(syoukei_controller)];
    self.navigationItem.rightBarButtonItem=syoukei;//右側にボタン設置
    
}

//呼ばれるたびデータとテーブルを更新
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    
    /* 画像管理モードかどうかのチェック　*/
    if(!picMode){
        _tableview.rowHeight=60.0;    }
    else{
        if([strBumon intValue]==0){
            allGoods = [DataModels getAllGoods];
        }
        _tableview.rowHeight=80.0;
    }
    
    /* Bumon Mode Check */
    if([strBumon intValue]>0) {
        // Select goods under the Bumon
        allGoods = [DataModels getAllGoodsByBumon:strBumon];
    }
    else{
        allGoods = [DataModels getAllGoods];
    }
    
    [_tableview reloadData];

}

//行数の設定
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{  
    return allGoods.count;
}

//セクション数の設定
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//セルに表示する内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
 
    /* Initialize Cell */
    static NSString *CellIdentifier=@"Cell";//空のセルを生成
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell==nil){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [cell setOpaque:YES];
    
    
   [cell.textLabel setFont:[UIFont boldSystemFontOfSize: 18]];
   [cell.detailTextLabel setFont:[UIFont boldSystemFontOfSize: 16]];
    
   /* Good at each line */
    Goods * eachGood = allGoods[indexPath.row];
    
    //＋ボタンの表示
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:imgbutton forState:UIControlStateNormal];
    button.frame=CGRectMake(0, 0,30,30);
    [button addTarget:self
               action:@selector(control:event:)forControlEvents:UIControlEventTouchUpInside];
    button.tag = indexPath.row;
    cell.accessoryView=button;  
        
    
    /* Goods Name */
    cell.textLabel.text = eachGood.title;
   
/* TODO kosu and id temporay hold goods under bumon ----------------------------------------------------------  */
    kosuArry=[[NSMutableArray alloc]init];
    [DataModels selectKosu:kosuArry selectFlag:@"1"];

    // get all syou kei
    idArry2=[[NSMutableArray alloc]init];
    [DataModels selectID:idArry2 selectFlag:@"1"];
    
    
    
    int kosu = 0;
    NSString *id2=@"";
    
    //小計のテーブルを参照し、個数の取得
    
    for (int n=0; n<idArry2.count; n++) {
        
        id2=[idArry2 objectAtIndex:n];
        
        if([eachGood.ID isEqual:id2]){
            Syoukei * eachSyoukei = allSyoukei[n];
            kosu = eachSyoukei.kosu;

        }
        if(kosu>0) break;
    }
    
    

/* END OF TODO ----------------------------------------------------------  */
    
    /* Draw Price and Pad */
    pricetag =[ NSString stringWithFormat:@"¥%d", eachGood.price ];
    pricetag = [pricetag leftJustify:5 with:@" "];
    
    
    /* Use photo or not */
    cell.imageView.frame = CGRectMake(0,0,10,10);
    if(picMode) cell.imageView.image=[[UIImage alloc]initWithData:eachGood.contents];
    
    cell.detailTextLabel.text = kosu > 0 ? [NSString stringWithFormat:@"%@ x%d", pricetag, kosu] : pricetag;
    
    return cell;
}

//+ボタンがタップされたときの処理 "PLUS" button handler
-(void)control:(id)sender event:(id)event{
    
    AudioServicesPlaySystemSound(soundID);
    
    
    
    /* Get to know which goods is clicked */
    UIButton * clickedButton = (UIButton *) sender;
    int ghou = clickedButton.tag;
    
    
    /* Get selected cell object for changing its detailed text */
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:ghou inSection:0];
    UITableViewCell *cell=[_tableview cellForRowAtIndexPath:indexPath];

    /* Get selected Goods */
    
//    if(ghou<titleArry.count){
        if(ghou < allGoods.count){




            if([strBumon intValue]>0) {
                allGoods = [DataModels getAllGoodsByBumon:strBumon];
            }
            else{
                allGoods = [DataModels getAllGoods];
            }
            
            Goods * selectedGoods = allGoods[ghou];
            allSyoukei = [DataModels getAllSyoukei];
                   
            /* From Burdata */
            /* kosuArray idArray are appended but not refilled!! */
            [DataModels selectKosu:kosuArry selectFlag:@"1"];
            [DataModels selectID:idArry2 selectFlag:@"1"];
        
            
/*********** kosuArry is updated everytime but allSyoukie is NOT WIP WIP ******************************************/

        
            int kakunin=0;
            
            NSString *kosu;

       
            //既存のidかどうかのチェック
            for(int n=0;n<idArry2.count;n++){
                NSString *idno=[idArry2 objectAtIndex:n];
                if([selectedGoods.ID intValue]==[idno intValue]){
                     
                    kosu=[kosuArry objectAtIndex:n];
                    kakunin=1;//既存のidの場合

                }
            }
          
            
            /* For cell detailed text */
            NSString *price;
            pricetag =[ NSString stringWithFormat:@"%d", selectedGoods.price ];
            pricetag = [pricetag leftJustify:5 with:@" "];
       
            //idが存在しない場合
            /* If no previous Syoukei exists */
            if(kakunin==0){
                // Create Syoukei Table Insert to Syoukei
                Syoukei * s = [[Syoukei alloc] initWithID:selectedGoods.ID title:selectedGoods.title price:selectedGoods.price kosu:1];
                [DataModels insertSyoukei:s];
                price=[NSString stringWithFormat:@"¥%@ ×1",pricetag];
            }
            //idが存在する場合
            else{
                /* update if selected */
                kosu=[NSString stringWithFormat:@"%d",[kosu intValue]+1];
                [DataModels updateSyoukeiByID:selectedGoods.ID withKosu:kosu];
                
                // Show detailed price
                price =[NSString stringWithFormat:@"¥%@ ×%@",pricetag,kosu];

            }
        
            cell.detailTextLabel.text=price;
        
        }
           
}

//小計が押されたときの処理
-(void)syoukei_controller{
    AudioServicesPlaySystemSound(soundID);
 
    allSyoukei = [DataModels getAllSyoukei];
    if(allSyoukei.count==0) {

        UIAlertView *av =[[UIAlertView alloc]
                          initWithTitle : @"商品選択"
                          message : @"商品が一つも選択されていません"
                          delegate : self
                          cancelButtonTitle : nil
                          otherButtonTitles : @"OK", nil];
        [av show];
    }
    else{

        SyoukeiViewController *svc=[self.storyboard instantiateViewControllerWithIdentifier:@"Syoukei"];
        [self.navigationController pushViewController:svc animated:YES];
        self.title=@"商品選択";

    }
}

//deleteで個数を0に
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if([strBumon intValue]>0) {
        allGoods = [DataModels getAllGoodsByBumon:strBumon];
    }
    else{
        allGoods = [DataModels getAllGoods];
    }
    
    UITableViewCell *cell=[_tableview cellForRowAtIndexPath:indexPath];
    
    //IDが一致する項目の削除
    
    Goods * deleteTarget = allGoods[indexPath.row];
    
    NSString *strID= deleteTarget.ID;
    
    [DataModels delete_table:strID];
    
    pricetag= [NSString stringWithFormat:@"%d",deleteTarget.price];
    int l = [pricetag length];
    for(int i=0; i<5-l; i++){
        pricetag=[NSString stringWithFormat:@"  %@",pricetag];
    }
    NSString *price=[NSString stringWithFormat:@"%@円       ",pricetag];
    if([self.settings.picmode intValue]==0)price=[NSString stringWithFormat:@"       %@",price];
    cell.detailTextLabel.text=price;
    
}

 

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
