//
//  ModeSelect.m
//  HandyPOS
//
//  Created by POSCO on 12/12/14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ModeSelect.h"
#import "DataAzukari.h"
#import "Settings.h"

@interface ModeSelect ()
@property Settings * settings;
@end

@implementation ModeSelect{

}

@synthesize tableview=_tableview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"モード選択";
    
    /* Setup Settings */
    self.settings = [DataAzukari getSettings];
    if (!self.settings) {
        self.settings = [[Settings alloc] initWithAZmode:@"0" tantou:@"0" bumode:@"0" picmode:@"0" nimode:@"0"];
        [DataAzukari insertSettings:self.settings];
    } ;
    
    //背景用の設定
    self.navigationController.navigationBar.tintColor=[UIColor brownColor];
    UIImage *imgback=[UIImage imageNamed:@"back.bmp"];
    self.view.backgroundColor=[UIColor colorWithPatternImage:imgback];
    
    
    _tableview=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableview.frame = CGRectMake(0, 0, 320, 460-44);
    _tableview.rowHeight=40.0;
    _tableview.dataSource=self;
    _tableview.delegate=self;
    _tableview.backgroundView=nil;
    [_tableview setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_tableview];
}

//セクション数の設定
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

//セクション名の設定
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section==0)return @"預り金";
    if(section==1)return @"部門管理";
    if(section==2)return @"画像管理";
    if(section==3)return @"日計表";
    return nil;
}

//行数の設定
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 2;
}
//セルに表示する内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* Cell Initialization */
    static NSString *CellIdentifier=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize: 19]];
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text=@"通常モード";
                    if ([self.settings.azmode isEqual: @"0"]) {
                        cell.accessoryType=UITableViewCellAccessoryCheckmark;
                    }
                    break;
                case 1:
                    cell.textLabel.text=@"自動預り金モード";
                    if ([self.settings.azmode isEqual: @"1"]) {
                        cell.accessoryType=UITableViewCellAccessoryCheckmark;
                    }
                    break;
            }
            break;
            
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text=@"通常モード";
                    if ([self.settings.bumode isEqual: @"0"]) {
                        cell.accessoryType=UITableViewCellAccessoryCheckmark;
                    }
                    break;
                case 1:
                    cell.textLabel.text=@"部門管理モード";
                    if ([self.settings.bumode isEqual: @"1"]) {
                        cell.accessoryType=UITableViewCellAccessoryCheckmark;
                    }
                    break;
            }
            break;
            
        case 2:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text=@"通常モード";
                    if ([self.settings.picmode isEqual: @"0"]) {
                        cell.accessoryType=UITableViewCellAccessoryCheckmark;
                    }
                    break;
                case 1:
                    cell.textLabel.text=@"画像管理モード";
                    if ([self.settings.picmode isEqual: @"1"]) {
                        cell.accessoryType=UITableViewCellAccessoryCheckmark;
                    }
                    break;
            }
            break;
            
        case 3:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text=@"単品表示";
                    if ([self.settings.nimode isEqual: @"0"]) {
                        cell.accessoryType=UITableViewCellAccessoryCheckmark;
                    }
                    break;
                case 1:
                    cell.textLabel.text=@"部門表示";
                    if ([self.settings.nimode isEqual: @"1"]) {
                        cell.accessoryType=UITableViewCellAccessoryCheckmark;
                    }
                    break;
            }
            break;
            
        default:
            break;
    }
    return cell;
}

    

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //セルの選択解除
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
            self.settings.azmode = [NSString stringWithFormat:@"%d", indexPath.row];
            break;
        case 1:
            self.settings.bumode = [NSString stringWithFormat:@"%d", indexPath.row];
            break;
        case 2:
            self.settings.picmode = [NSString stringWithFormat:@"%d", indexPath.row];
            break;
        case 3:
            self.settings.nimode = [NSString stringWithFormat:@"%d", indexPath.row];
            break;
            
        default:
            break;
    }
    
    [DataAzukari updateSettings:self.settings];
    
    for(int i=0; i<2; i++){
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
        if(indexPath.row==i){
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }
        else{
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
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
