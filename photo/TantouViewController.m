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

@interface TantouViewController (){
    

    NSMutableArray * tantos;
    Tanto * defaultTanto;
    
    
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
    
    //背景用の設定
    self.navigationController.navigationBar.tintColor=[UIColor brownColor];
    UIImage *imgback=[UIImage imageNamed:@"back.bmp"];
    self.view.backgroundColor=[UIColor colorWithPatternImage:imgback];
    
    UIPickerView *pic=[[UIPickerView alloc]init];
    pic.center=self.view.center;
    pic.delegate=self;
    pic.dataSource=self;
    pic.showsSelectionIndicator=YES;
    [self.view addSubview:pic];
    
    
    
    tantos = [DataModels getAllTantos];
    defaultTanto = tantos[0];
    name.text = defaultTanto._name;
    idno.text = defaultTanto._ID;
    
    
    
    //音用の設定
    path=[[NSBundle mainBundle]pathForResource:@"butin" ofType:@"wav"];
    url=[NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url,&soundID);
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return tantos.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    Tanto * t = tantos[row];
    return [NSString stringWithFormat:@"%@",t._name];
    
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)componen{
    defaultTanto = tantos[row];
    name.text = defaultTanto._name;
    idno.text = defaultTanto._ID;
}
//担当決定
-(IBAction)kettei:(id)sender{
    AudioServicesPlaySystemSound(soundID);
    
    /* Syoukei をクリア */
    [DataModels drop_table:@"Syoukei"];
    
    /* Azukari の Tanto をクリア後挿入 */
//    [DataAzukari update_Tantou:defaultTanto._ID];
    
    
    NSUserDefaults * globalVar = [NSUserDefaults standardUserDefaults];
    [globalVar setObject:defaultTanto._ID forKey:@"tantoID"];
    [globalVar synchronize];
    
   
    
    
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
