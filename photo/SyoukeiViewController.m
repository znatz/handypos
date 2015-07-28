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


@interface SyoukeiViewController ()
@property(retain,nonatomic)UITableView *tableview;
@property Settings * settings;
- (NSString *) setupTitle : (NSMutableArray *) s ;
- (int) getTotalPrice : (NSMutableArray *) s ;
@end

@implementation SyoukeiViewController{
    
    NSMutableArray * allSyoukei;
    
    NSMutableArray *idArry2;
    NSMutableArray *kosuArry;
    NSMutableArray *PicModeArry;
    NSString *Flag;
    NSString *Flag2;
    NSString *seisanFlg;

    NSString *price;
    NSString *kosu;
    
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
    [super viewDidLoad];
    
    allSyoukei = [DataModels getAllSyoukei];
    self.settings = [DataAzukari getSettings];
    
    Flag= @"1";
    Flag2=@"1";
    
    self.title = [self setupTitle:allSyoukei];
    
    //背景用の設定
    self.navigationController.navigationBar.tintColor=[UIColor brownColor];
    UIImage *imgback=[UIImage imageNamed:@"back.bmp"];
    self.view.backgroundColor=[UIColor colorWithPatternImage:imgback];
    
    
    UIBarButtonItem *seisan;

    //NSLog(@"%@",seisanFlg);
    
    // AZMode
    if([self.settings.azmode intValue]==0){
        seisan = [[UIBarButtonItem alloc]initWithTitle:@"決定" style:UIBarButtonItemStyleBordered target:self action:@selector(seisan_controller)];
    }
    else{
        seisan = [[UIBarButtonItem alloc]initWithTitle:@"決定" style:UIBarButtonItemStyleBordered target:self action:@selector(seisan_controller2)];
    }
    self.navigationItem.rightBarButtonItem=seisan;//右側にボタン設置
    self.navigationItem.leftBarButtonItem.title=@"戻る";//左側のボタンタイトル
    
    _tableview=[[UITableView alloc]init];
    _tableview.frame = CGRectMake(0, 0, 320, 460-44);
    _tableview.dataSource=self;
    _tableview.delegate=self;
    _tableview.rowHeight=100.0;
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
    
   
    /* Flag 1 */
    
    [DataModels selectID:idArry2 selectFlag:@"0"];
    
    if([self.settings.picmode intValue]==0){
        _tableview.rowHeight=70.0;//セルの高さ
    }
    else{
        _tableview.rowHeight=100.0;//セルの高さ
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
    if([self.settings.picmode intValue]==0){
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize: 22]];
        [cell.detailTextLabel setFont:[UIFont boldSystemFontOfSize: 25]];
    }
    else{
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize: 24]];
        [cell.detailTextLabel setFont:[UIFont boldSystemFontOfSize: 25]];
    }
    
    /* Cell Text Setup -----------------------------------------------------*/
    //cell.detailTextLabel.textAlignment=UITextAlignmentLeft;
    cell.detailTextLabel.textAlignment= NSTextAlignmentLeft; //ios6
    cell.textLabel.text=eachSyoukei.title;
    
    /* Accessory Setup -----------------------------------------------------*/
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    /* Detailed Text Setup -------------------------------------------------*/
    price= [NSString stringWithFormat:@"%d", eachSyoukei.price ];
    int l = price.length;
    for(int i=0; i<5-l; i++){
            price=[NSString stringWithFormat:@"  %@",price];
    }

    kosu= [NSString stringWithFormat:@"%d",eachSyoukei.kosu];
    l = kosu.length;
    for(int i=0; i<3-l; i++){
        kosu=[NSString stringWithFormat:@"  %@",kosu];
    }

    /* Picture Setup --------------------------------------------------------*/
    if([self.settings.picmode intValue]==0){
        cell.detailTextLabel.text=[NSString stringWithFormat:@"        %@円 ×%@",price,kosu];
    }
    else{
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%@円 ×%@",price,kosu];       
        cell.imageView.image=[[UIImage alloc]initWithData:[DataModels getGoodsByID:eachSyoukei.ID].contents];
    }
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


// Finish Editing, Call SeisanViewController 1 or 2
-(void)seisan_controller{
    self.title=@"小計";
//    [ConnectionManager uploadFile:@"BurData.sqlite"];
    SeisanViewController *svc=[self.storyboard instantiateViewControllerWithIdentifier:@"Seisan"];
    svc.totalPrice = [self getTotalPrice:allSyoukei];
    [self.navigationController pushViewController:svc animated:YES];
}


/* Auto amount in button of Seisan View */
-(void)seisan_controller2{
    self.title=@"小計";
//    [ConnectionManager uploadFile:@"BurData.sqlite"];
    SeisanViewController *svc=[self.storyboard instantiateViewControllerWithIdentifier:@"Seisan"];
    svc.totalPrice = [self getTotalPrice:allSyoukei];
    [self.navigationController pushViewController:svc animated:YES];
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
