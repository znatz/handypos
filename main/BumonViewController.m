//
//  BumonViewController.m
//  HandyPOS
//
//  Created by POSCO on 12/12/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BumonViewController.h"
#import "ViewController.h"
#import "DataModels.h"
#import "Bumon.h"


@interface BumonViewController ()

@property(retain,nonatomic)UITableView *tableview;

@end

@implementation BumonViewController{
    
    NSMutableArray * bumons;
}

@synthesize  tableview=_tableview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {}
    return self;
}

- (void)viewDidLoad
{
    /* Solve overlapping navigation bar in iOS 7 */
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [super viewDidLoad];
    
	self.title=@"部門一覧";

    //背景用の設定
    self.navigationController.navigationBar.tintColor=[UIColor brownColor];
    UIImage *imgback=[UIImage imageNamed:@"back.bmp"];
    self.view.backgroundColor=[UIColor colorWithPatternImage:imgback];
    
    // Setup Table View
    _tableview=[[UITableView alloc]init];
    _tableview.frame = CGRectMake(0, 0, [self.view frame].size.width, [self.view frame].size.height-40);
    _tableview.dataSource=self;
    _tableview.delegate=self;
    _tableview.rowHeight=45.0;
    [self.view addSubview:_tableview];
}

//呼ばれるたびデータとテーブルを更新
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    bumons = [DataModels getAllBumon];
    [_tableview reloadData];
}

//行数の設定
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return bumons.count;
}

//セクション数の設定
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//セルに表示する内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell==nil){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize: 23]];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    Bumon * eachBumon = bumons[indexPath.row];
    cell.textLabel.text=[NSString stringWithFormat:@"     %@", eachBumon.bumon];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //セルの選択解除
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Set strBumon as selected and jump to ViewController
    ViewController * vc;
    vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Uriage"];
    
    Bumon * selectedBumon = bumons[indexPath.row];
    vc.strBumon = selectedBumon.ID;
    vc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;

    [self.navigationController pushViewController:vc animated:YES];
    
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
