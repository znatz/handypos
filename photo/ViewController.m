/* ZNATZ
 
 This view is navigated from TantoViewController with strBumon equals to 0
 OR                     from BumonViewController with strBumon equals to the selected.
 
 */

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
    
    // Cache goods image
    NSMutableArray * all_goods_images;
    
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
    
    /* ----------------------------------  UI and Sound setup --------------------------------*/
    self.title=@"売上登録";
    self.navigationController.navigationBar.tintColor=[UIColor brownColor];
    UIImage *imgback=[UIImage imageNamed:@"back.bmp"];
    self.view.backgroundColor=[UIColor colorWithPatternImage:imgback];
    
    UIBarButtonItem *syoukei = [[UIBarButtonItem alloc]initWithTitle:@"小計" style:UIBarButtonItemStyleBordered target:self action:@selector(syoukei_controller)];
    self.navigationItem.rightBarButtonItem=syoukei;
    
    path=[[NSBundle mainBundle]pathForResource:@"butin" ofType:@"wav"];
    url=[NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url,&soundID);
    
    imgbutton=[UIImage imageNamed:@"button1.gif"];
    /* ----------------------------------  END : UI and Sound setup --------------------------*/
    
    
    
    /* ----------------------------------  Table setup ---------------------------------------*/
    _tableview    = [[UITableView alloc]init];
    _tableview.frame        = CGRectMake(0, 0, [self.view frame].size.width, [self.view frame].size.height-60);
    _tableview.dataSource   = self;
    _tableview.delegate     = self;
    _tableview.rowHeight    = picMode ? 80.0 : 60.0;
    _tableview.allowsSelection = NO;
    [self.view addSubview:_tableview];
    /* ----------------------------------  END : Table setup ---------------------------------*/

    
    /* ----------------------------------  Contents preparation ------------------------------*/
    self.settings = [DataAzukari getSettings];
    allSyoukei    = [DataModels getAllSyoukei];
    
    picMode       = [self.settings.picmode isEqual:@"1"] ? YES : NO;
    
    if([strBumon intValue]>0) allGoods = [DataModels getAllGoodsByBumon:strBumon];
    else allGoods = [DataModels getAllGoods];
    
    all_goods_images = [[NSMutableArray alloc] init];
    for (Goods * g in allGoods) {
        UIImage * image     = [[UIImage alloc]initWithData:g.contents];
        [all_goods_images addObject:image];
    }
    all_goods_images = [self arrayOfThumbnailsOfSize:CGSizeMake(80.0, 80.0) fromArray:all_goods_images];
    /* ----------------------------------  END : Contents preparation -------------------------*/
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
 
    /* ----------------------------------  Local variables           -------------------------*/
    Goods * eachGood = allGoods[indexPath.row];
    kosuArry         = [[NSMutableArray alloc]init];
    idArry2          = [[NSMutableArray alloc]init];
    /* ----------------------------------  END : Local variables     -------------------------*/
    
    
    /* ----------------------------------  Cell initialization       -------------------------*/
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil) cell = [[UITableViewCell alloc] initWithStyle : UITableViewCellStyleSubtitle reuseIdentifier : CellIdentifier];
    /* ----------------------------------  END : Cell initialization -------------------------*/
    
    
    /* ----------------------------------  Cell UI setup             -------------------------*/
    [cell setOpaque:YES];
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize: 18]];
    [cell.detailTextLabel setFont:[UIFont boldSystemFontOfSize: 16]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:imgbutton forState:UIControlStateNormal];
    button.frame=CGRectMake(0, 0,40,40);
    [button addTarget:self
               action:@selector(control:event:)forControlEvents:UIControlEventTouchUpInside];
    button.tag = indexPath.row;
    cell.accessoryView=button;
    
    cell.textLabel.text = eachGood.title;
    /* ----------------------------------  END : Cell UI setup       -------------------------*/
    
    
    
    /* ----------------------------------  Cell contents setup       -------------------------*/
    [DataModels selectKosu : kosuArry
                selectFlag : @"1"];
    [DataModels selectID   : idArry2
                selectFlag : @"1"];
    
    
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
    if(picMode) cell.imageView.image= (UIImage *) [all_goods_images objectAtIndex:indexPath.row];
    cell.imageView.frame = CGRectMake(0,0,10,10);
    
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

- (NSMutableArray *)arrayOfThumbnailsOfSize:(CGSize)size fromArray:(NSMutableArray*)original {
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:[original count]];
    for(UIImage *image in original){
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(0,0,size.width,size.height)];
        UIImage *thumb = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [temp addObject:thumb];
    }
    return [NSMutableArray arrayWithArray:temp];
}
 

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_tableview reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return allGoods.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
@end
