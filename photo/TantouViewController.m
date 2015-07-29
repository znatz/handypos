//
//  TantouViewController.m
//  photo
//
//  Created by POSCO on 12/07/26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <AudioToolbox/AudioServices.h>
#import "TantouViewController.h"
#import "DataModels.h"
#import "DataAzukari.h"
#import "BumonViewController.h"
#import "Tanto.h"
#import "Seisan.h"
#import "DataUpdate.h"
#import "Settings.h"
#import "DataMente.h"

@interface TantouViewController (){
    

    NSMutableArray * tantos;
    Tanto * defaultTanto;
    NSString * selectedTable;
    
    
    //音用の設定
    NSString *path;
    NSURL *url;
    SystemSoundID soundID;
}
@property     Settings * settings;
@end


@implementation TantouViewController

@synthesize name;
@synthesize idno;

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
    /* Solve overlapping navigation bar in iOS 7 */
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [super viewDidLoad];

    self.title=@"担当登録";
    self.settings = [DataAzukari getSettings];
    selectedTable = @"0";
    
    //背景用の設定
    self.navigationController.navigationBar.tintColor=[UIColor brownColor];
    UIImage *imgback=[UIImage imageNamed:@"back.bmp"];
    self.view.backgroundColor=[UIColor colorWithPatternImage:imgback];
    
    UIPickerView *pic=[[UIPickerView alloc]init];
    pic.frame = CGRectMake(10.0, [self.view frame].size.height/4, [self.view frame].size.width-20.0, [self.view frame].size.height/2);
    pic.delegate=self;
    pic.dataSource=self;
    pic.showsSelectionIndicator=YES;
    [self.view addSubview:pic];
    
    
    
    tantos = [DataModels getAllTantos];
    defaultTanto = tantos[0];
    name.text = defaultTanto._name;
    idno.text = @"担当者";
    
    
    
    //音用の設定
    path=[[NSBundle mainBundle]pathForResource:@"butin" ofType:@"wav"];
    url=[NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url,&soundID);
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(component == 0) return tantos.count;
    // Maximum count of table in the restaurant
    else return 50;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        Tanto * t = tantos[row];
        return [NSString stringWithFormat:@"%@",t._name];
    } else {
        return [NSString stringWithFormat:@"%d", row];
    }
    
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0) {
        defaultTanto = tantos[row];
        name.text = defaultTanto._name;
    } else {
        self.tableNO.text = [NSString stringWithFormat:@"%d", row];
        selectedTable = self.tableNO.text;
        
    }
}
// Submit selection of Tanto and Table
-(IBAction)kettei:(id)sender{
    AudioServicesPlaySystemSound(soundID);
    
    /* Syoukei をクリア */
    [DataModels drop_table:@"Syoukei"];
    
    
    NSUserDefaults * globalVar = [NSUserDefaults standardUserDefaults];
    [globalVar setObject:defaultTanto._ID forKey:@"tantoID"];
    [globalVar setObject:selectedTable forKey:@"tableNO"];
    [globalVar synchronize];
    self.settings.tantou = defaultTanto._ID;
    [DataAzukari updateSettings:self.settings];
    
    
    if([self.settings.bumode intValue]==0){
        ViewController *vc = [self.storyboard
                              instantiateViewControllerWithIdentifier:@"Uriage"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        BumonViewController * bvc=[self.storyboard
                                   instantiateViewControllerWithIdentifier:@"Bumon"];
        [self.navigationController pushViewController:bvc animated:YES];
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
