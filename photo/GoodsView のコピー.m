//
//  ViewController.m
//  photo
//
//  Created by POSCO on 12/07/12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "SyoukeiViewController.h"
#import "GoodsView.h"
//#import "NewViewController.h"
#import "MainViewController.h"
#import "DataModels.h"
#import "DataAzukari.h"

@interface GoodsView ()

@property(retain,nonatomic)UITableView *tableview;

@end

@implementation GoodsView{
    @private
    NSMutableArray *idArry;
    NSMutableArray *titleArry;
    NSMutableArray *titleArry2;
    NSMutableArray *PriceArry;
    NSMutableArray *contentsArry;
    
    NSMutableArray *kosuArry;
    NSMutableArray *idArry2;
    NSMutableArray *priceArry2;
    NSMutableArray *PicModeArry;

    NSString *Flag;
    NSString *Blank;
    NSString *Blank2;
    //音用の設定
    NSString *path;
    NSURL *url;
    SystemSoundID soundID;
    
}
//@synthesize uriage;

@synthesize row_num;
@synthesize tableview=_tableview;
@synthesize strBumon;

- (void)viewDidLoad
{
    [super viewDidLoad];

    Flag = @"0";
    self.title=@"売上登録";//title名
    
    //背景用の設定
    self.navigationController.navigationBar.tintColor=[UIColor brownColor];
    UIImage *imgback=[UIImage imageNamed:@"back.bmp"];
    self.view.backgroundColor=[UIColor colorWithPatternImage:imgback];
    
    // Initialize Table View
    _tableview=[[UITableView alloc]init];
    _tableview.frame = CGRectMake(0, 0, 320, 460-44);
    _tableview.dataSource = self;
    _tableview.delegate   = self;
    [self.view addSubview:_tableview];
    
    //音用の設定
    path=[[NSBundle mainBundle]pathForResource:@"butin" ofType:@"wav"];
    url=[NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url,&soundID);
    
    //右上のボタンの表示
    UIBarButtonItem *syoukei = [[UIBarButtonItem alloc] initWithTitle:@"小計"
                                                                style:UIBarButtonItemStyleBordered
                                                               target:self
                                                               action:@selector(syoukei_controller)];
    self.navigationItem.rightBarButtonItem=syoukei;
}

//呼ばれるたびデータとテーブルを更新
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    idArry=[[NSMutableArray alloc]init];
    titleArry=[[NSMutableArray alloc]init];//タイトル格納配列
    PriceArry=[[NSMutableArray alloc]init];
    PicModeArry=[[NSMutableArray alloc]init];
    [DataAzukari selectPicMode:PicModeArry];
    
    if([[PicModeArry objectAtIndex:0] intValue]==0){
        _tableview.rowHeight=60.0;//セルの高さ
    }
    else{
        if([strBumon intValue]==0){//部門管理を使わない場合
            contentsArry=[[NSMutableArray alloc]init];//画像格納配列
            [DataModels selectContents:contentsArry];//コンテンツフィールド取り出し
        }
        _tableview.rowHeight=80.0;//セルの高さ
    }
    
    //idArry2=[[NSMutableArray alloc]init];
    if([strBumon intValue]>0) {
        [DataModels select:idArry selectBumon:strBumon selectFlag:@"1"];
        [DataModels select:titleArry selectBumon:strBumon selectFlag:@"2"];//タイトルフィールド取り出し
        [DataModels select:PriceArry selectBumon:strBumon selectFlag:@"3"];
    }
    else{
        [DataModels selectID:idArry selectFlag:Flag];
        [DataModels selectTitle:titleArry selectFlag:Flag];//タイトルフィールド取り出し
        [DataModels selectPrice:PriceArry selectFlag:Flag];
    }
    
    [_tableview reloadData];//テーブルリロードで更新
    _tableview.allowsSelection=NO;//セルタッチ禁止

}

//行数の設定
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titleArry.count;
}

//セクション数の設定
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//セルに表示する内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier=@"Cell";//空のセルを生成
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell==nil){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    if([[PicModeArry objectAtIndex:0] intValue]==0){
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize: 18]];
        [cell.detailTextLabel setFont:[UIFont boldSystemFontOfSize: 24]];
    }
    else{
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize: 18]];
        [cell.detailTextLabel setFont:[UIFont boldSystemFontOfSize: 22]];
    }
    
    //＋ボタンの表示
    UIImage *imgbutton=[UIImage imageNamed:@"button1.gif"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:imgbutton forState:UIControlStateNormal];
    button.frame=CGRectMake(0, 0,55,55);
   
    [button addTarget:self action:@selector(control:event:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView=button;  
    
    
    cell.textLabel.text=[titleArry objectAtIndex:indexPath.row];
   
    kosuArry=[[NSMutableArray alloc]init];
    [DataModels selectKosu:kosuArry selectFlag:@"1"];
    idArry2=[[NSMutableArray alloc]init];
    [DataModels selectID:idArry2 selectFlag:@"1"];
    
    NSString *kosu=@"0";
    NSString *id2=@"";
    NSString *id1= [idArry objectAtIndex:indexPath.row];
    
    //小計のテーブルを参照し、個数の取得
    for (int n=0; n<idArry2.count; n++) {
        id2=[idArry2 objectAtIndex:n];
        if([id1 intValue]==[id2 intValue]){
            //NSLog(@"id2:%@",id2);
            kosu=[kosuArry objectAtIndex:n];
        }
        if([kosu intValue]>0)break;
    }
    
    Blank=[PriceArry objectAtIndex:indexPath.row];
    for(int i=0; i<5-[[PriceArry objectAtIndex:indexPath.row] length]; i++){
        Blank=[NSString stringWithFormat:@"  %@",Blank];
    }
    
    Blank2=kosu;
    if(![kosu isEqual:@"0"]){
        for(int i=0; i<3-[kosu length]; i++){
            Blank2=[NSString stringWithFormat:@"  %@",Blank2];
        }
    }
    NSString *price;
    if(![kosu isEqual:@"0"])price=[NSString stringWithFormat:@"%@円 ×%@",Blank,Blank2];
    else price=[NSString stringWithFormat:@"%@円   ",Blank];
    
    if([[PicModeArry objectAtIndex:0] intValue]==0){
        price=[NSString stringWithFormat:@"       %@",price];
    }
    else{
        if([strBumon intValue]==0){
            cell.imageView.image=[[UIImage alloc]initWithData:[contentsArry objectAtIndex:indexPath.row]];
        }
        else {
            contentsArry=[[NSMutableArray alloc]init];
            [DataModels selectContents:contentsArry where_id:id1];
            cell.imageView.image=[[UIImage alloc]initWithData:[contentsArry objectAtIndex:0]];
        }
    }
    cell.detailTextLabel.text=price;
    
    return cell;
}

//+ボタンがタップされたときの処理
-(void)control:(id)sender event:(id)event{
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AudioServicesPlaySystemSound(soundID);
    //index.pathの設定
    NSSet *touches=[event allTouches];
    UITouch *touch=[touches anyObject];
    CGPoint currentTouchPosition=[touch locationInView:_tableview];
    NSIndexPath *indexPath=[_tableview indexPathForRowAtPoint:currentTouchPosition];
    
    int ghou=titleArry.count+1;
    for(int i=0; i<titleArry.count;i++){
        if(indexPath.row==i){
            ghou=i;
        }
    }
        //[self Kosu_controller:i];
            
            
    if(ghou<titleArry.count){
            idArry=[[NSMutableArray alloc]init];
            idArry2=[[NSMutableArray alloc]init];
            titleArry=[[NSMutableArray alloc]init];
            PriceArry=[[NSMutableArray alloc]init];
            kosuArry=[[NSMutableArray alloc]init];
            
            if([strBumon intValue]>0) {
                [DataModels select:idArry selectBumon:strBumon selectFlag:@"1"];
                [DataModels select:titleArry selectBumon:strBumon selectFlag:@"2"];//タイトルフィールド取り出し
                [DataModels select:PriceArry selectBumon:strBumon selectFlag:@"3"];
            }
            else{
                [DataModels selectID:idArry selectFlag:Flag];
                [DataModels selectTitle:titleArry selectFlag:Flag];
                [DataModels selectPrice:PriceArry selectFlag:Flag];
            }
            [DataModels selectKosu:kosuArry selectFlag:@"1"];
            [DataModels selectID:idArry2 selectFlag:@"1"];
            int kakunin=0;
            
            NSString *kosu;
            NSString *strID=[idArry objectAtIndex:ghou];
            NSString *strTitle=[titleArry objectAtIndex:ghou];
            NSString *strPrice=[PriceArry objectAtIndex:ghou];
            
            UITableViewCell *cell=[_tableview cellForRowAtIndexPath:indexPath];
            
            //既存のidかどうかのチェック
            for(int n=0;n<idArry2.count;n++){
                NSString *idno=[idArry2 objectAtIndex:n];
                if([strID intValue]==[idno intValue]){
                    kosu=[kosuArry objectAtIndex:n];
                    kakunin=1;//既存のidの場合
                }
            }
       
            //idが存在しない場合
            if(kakunin==0){
                       
                [DataModels insertID:strID insertTitle:strTitle insertPrice:strPrice insertKosu:@"1" selectFlag:Flag];
                Blank=[PriceArry objectAtIndex:ghou];
                for(int i=0; i<5-[[PriceArry objectAtIndex:ghou] length]; i++){
                    Blank=[NSString stringWithFormat:@"  %@",Blank];
                }
                
                NSString *price=[NSString stringWithFormat:@"%@円 ×    1",Blank];
                if([[PicModeArry objectAtIndex:0] intValue]==0)price=[NSString stringWithFormat:@"       %@",price];
                cell.detailTextLabel.text=price;
                
            }
            //idが存在する場合
            else{
                int intkosu=[kosu intValue]+1;
                kosu=[NSString stringWithFormat:@"%d",intkosu];
                [DataModels selectID:strID updateKosu:kosu selectFlag:Flag];
                
                Blank=[PriceArry objectAtIndex:ghou];
                for(int i=0; i<5-[[PriceArry objectAtIndex:ghou] length]; i++){
                    Blank=[NSString stringWithFormat:@"  %@",Blank];
                }
                Blank2=kosu;
                for(int i=0; i<3-[kosu length]; i++){
                    Blank2=[NSString stringWithFormat:@"  %@",Blank2];
                }
                NSString *price=[NSString stringWithFormat:@"%@円 ×%@",Blank,Blank2];
                if([[PicModeArry objectAtIndex:0] intValue]==0)price=[NSString stringWithFormat:@"       %@",price];
                
                cell.detailTextLabel.text=price;
            }
            [self title_controler];

        }
        //[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
           
}

//小計が押されたときの処理
-(void)syoukei_controller{
    AudioServicesPlaySystemSound(soundID);
    titleArry2=[[NSMutableArray alloc]init];//タイトル格納配列
    [DataModels selectTitle:titleArry2 selectFlag:@"1"];//タイトルフィールド取り出し
    if(titleArry2.count==0) {
        UIAlertView *av =[[UIAlertView alloc]initWithTitle:@"商品選択" message:@"商品が一つも選択されていません" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [av show];
    }
    else{
        //storyboardの画面遷移
        SyoukeiViewController *svc=[self.storyboard instantiateViewControllerWithIdentifier:@"Syoukei"];
        //svc.tantou_id=tantou_id;
        [self.navigationController pushViewController:svc animated:YES];
        self.title=@"商品選択";

    }
}

//deleteで個数を0に
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

    PriceArry=[[NSMutableArray alloc]init];
    idArry=[[NSMutableArray alloc]init];
    if([strBumon intValue]>0) {
        [DataModels select:idArry selectBumon:strBumon selectFlag:@"1"];
        [DataModels select:PriceArry selectBumon:strBumon selectFlag:@"3"];
    }
    else{
        [DataModels selectPrice:PriceArry selectFlag:Flag];
        [DataModels selectID:idArry selectFlag:Flag];
    }
    
    UITableViewCell *cell=[_tableview cellForRowAtIndexPath:indexPath];
    
    //IDが一致する項目の削除
    NSString *strID=[idArry objectAtIndex:indexPath.row];
    [DataModels delete_table:strID];
    
    Blank=[PriceArry objectAtIndex:indexPath.row];
    for(int i=0; i<5-[[PriceArry objectAtIndex:indexPath.row] length]; i++){
        Blank=[NSString stringWithFormat:@"  %@",Blank];
    }
    NSString *price=[NSString stringWithFormat:@"%@円       ",Blank];
    if([[PicModeArry objectAtIndex:0] intValue]==0)price=[NSString stringWithFormat:@"       %@",price];
    cell.detailTextLabel.text=price;
    
    [self title_controler];
}

//titleに個数・値段表示
-(void)title_controler{   
    priceArry2=[[NSMutableArray alloc]init];
    kosuArry=[[NSMutableArray alloc]init];
    [DataModels selectPrice:priceArry2 selectFlag:@"1"];
    [DataModels selectKosu:kosuArry selectFlag:@"1"];
    int intprice=0;
    int intkosu=0;
    
    for(int i=0;i<kosuArry.count;i++){
        NSString *price=[priceArry2 objectAtIndex:i];
        NSString *kosu=[kosuArry objectAtIndex:i];
        intkosu=intkosu+[kosu intValue];
        intprice=intprice+[price intValue]*[kosu intValue];
    } 
         
    NSString *strgoukei=[NSString stringWithFormat:@"%d点 %d円",intkosu,intprice];
    self.title=strgoukei;
       
}

//画面遷移するときの処理
//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

//}
 

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
