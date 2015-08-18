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

    
    NSString       * pricetag;
    
    // Sound Resource
    NSString *path;
    NSURL *url;
    SystemSoundID soundID;
    
    UIImage *imgbutton;
    NSMutableArray * all_goods_images;
    
    BOOL picMode ;
    
}

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
    int kosu         = 0;
    /* ----------------------------------  END : Local variables     -------------------------*/
    
    
    /* ----------------------------------  Cell initialization       -------------------------*/
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell   = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil) cell      = [[UITableViewCell alloc] initWithStyle : UITableViewCellStyleSubtitle reuseIdentifier : CellIdentifier];
    /* ----------------------------------  END : Cell initialization -------------------------*/
    
    
    /* ----------------------------------  Cell UI setup             -------------------------*/
    [cell setOpaque:YES];
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize: 18]];
    [cell.detailTextLabel setFont:[UIFont boldSystemFontOfSize: 16]];
    if(picMode) cell.imageView.image= (UIImage *) [all_goods_images objectAtIndex:indexPath.row];
    cell.imageView.frame    = CGRectMake(0,0,10,10);
    
    UIButton *button        = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:imgbutton forState:UIControlStateNormal];
    button.frame=CGRectMake(0, 0,40,40);
    [button addTarget : self
               action : @selector(control:event:)
     forControlEvents : UIControlEventTouchUpInside];
    button.tag              = [eachGood.ID intValue] * 1000 + indexPath.row;
    cell.accessoryView=button;
    
    cell.textLabel.text = eachGood.title;
    /* ----------------------------------  END : Cell UI setup       -------------------------*/
    
    
    
    /* ----------------------------------  Cell contents setup       -------------------------*/
    for (Syoukei * eachSyoukei in allSyoukei) {
        if ([eachSyoukei.ID isEqual: eachGood.ID]) {
            kosu = eachSyoukei.kosu;
        }
    }
    
    pricetag =[ NSString stringWithFormat:@"¥%d", eachGood.price ];
    pricetag = [pricetag leftJustify:5 with:@" "];
    cell.detailTextLabel.text = kosu > 0 ? [NSString stringWithFormat:@"%@ x%d", pricetag, kosu] : pricetag;
    /* ----------------------------------  END : Cell contents setup  -------------------------*/
    
    return cell;
}

/* PLUS button handler */
-(void)control:(id)sender event:(id)event{
    
    /* ----------------------------------  Sound effect              -------------------------*/
    AudioServicesPlaySystemSound(soundID);
    /* ----------------------------------  END : Sound effect        -------------------------*/
    
    
    /* ----------------------------------  Retrieve context          -------------------------*/
    UIButton * clickedButton    = (UIButton *) sender;
    int selectedRow             = clickedButton.tag % 1000;
    int selectGoodsID_int       = (int)(clickedButton.tag - selectedRow) / 1000;
    NSString * selectedGoodsID  = [NSString stringWithFormat:@"%d", selectGoodsID_int];
    /* ----------------------------------  END : Retrieve context    -------------------------*/
    
    
    /* ----------------------------------  Update syoukei            -------------------------*/
    Syoukei * s;
    for (Goods * g in allGoods) {
        if ([g.ID isEqual: selectedGoodsID]) {
            s = [DataModels getSyoukeiByID:g.ID];
            if (s.ID) {
                s.kosu ++;
                [DataModels updateSyoukeiByID : g.ID
                                     withKosu : [NSString stringWithFormat:@"%d",s.kosu]];
                break;
            } else {
                s = [[Syoukei alloc] initWithID : g.ID
                                          title : g.title
                                          price : g.price
                                           kosu : 1];
                [DataModels insertSyoukei:s];
                break;
            }
            
        }
    }
    /* ----------------------------------  END : Update syoukei       -------------------------*/
    
    
    /* ----------------------------------  Update cell                -------------------------*/
    UITableViewCell * selectedCell = [_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0] ];
    NSString * new_pricetag        = [NSString stringWithFormat:@"¥%d", s.price ];
               new_pricetag        = [new_pricetag leftJustify:5 with:@" "];
    selectedCell.detailTextLabel.text = [NSString stringWithFormat:@"%@ x%d", new_pricetag, s.kosu];
    /* ----------------------------------  END : Update cell           -------------------------*/
    
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
    
    pricetag    = [NSString stringWithFormat:@"%d",deleteTarget.price];
    pricetag    = [pricetag rightJustify:5 with:@" "];
    
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
    allSyoukei = [DataModels getAllSyoukei];    // If not reload it, pricetag will not change as supposed when kosu is modified in KosuViewController
    [_tableview reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return allGoods.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
@end
