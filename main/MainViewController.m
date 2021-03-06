//
//  MainViewController.m
//  photo
//
//  Created by POSCO on 12/07/24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "DataUpdate.h"
#import "DataModels.h"
#import "TantouViewController.h"
#import "DataAzukari.h"
#import "DataMente.h"
#import "Seisan.h"
#import "Nebiki.h"
#import "Settings.h"
#import "ConnectionManager.h"

#import "NSString+Ruby.h"

@interface MainViewController (){
    

    NSMutableArray *tantou_idArry;

    
    NSMutableArray * allSeisan;
    NSMutableArray * allNebiki;

    
    NSString *Flag;
    //音用の設定
    NSString *path;
    NSURL *url;
    SystemSoundID soundID;
}

@end

@implementation MainViewController

@synthesize uriage;

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
    [DataAzukari create_Azukari];

	self.title=@"メイン";
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];//ナビゲーションバーをblackに
    self.navigationController.toolbar.tintColor=[UIColor blackColor];
    //背景用の設定
    self.navigationController.navigationBar.tintColor=[UIColor brownColor];
    UIImage *imgback=[UIImage imageNamed:@"back.bmp"];
    self.view.backgroundColor=[UIColor colorWithPatternImage:imgback];
    
    //効果音の設定    
    path=[[NSBundle mainBundle]pathForResource:@"butin" ofType:@"wav"];
    url=[NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url,&soundID);
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
-(IBAction)uriage:(id)sender{
    
    ShopSettings * shopSettings = [DataMente getShopSettings];
    if([DataModels getTantoCount]>0){
        if ([DataModels getTantosByShopID:shopSettings.tempo].count > 0) {
            AudioServicesPlaySystemSound(soundID);
            TantouViewController *tvc=[self.storyboard
                                       instantiateViewControllerWithIdentifier:@"Tantou"];
            [self.navigationController pushViewController:tvc animated:YES];
        } else {
            UIAlertView *av =[[UIAlertView alloc] initWithTitle : @"担当"
                                                        message : @"該当店舗の担当が登録されていません"
                                                       delegate : self
                                              cancelButtonTitle : nil
                                              otherButtonTitles : @"OK", nil];
            [av show];
            
        }
        
    }
    else{
        UIAlertView *av =[[UIAlertView alloc] initWithTitle : @"担当"
                                                    message : @"担当者が一人も登録されていません"
                                                   delegate : self
                                          cancelButtonTitle : nil
                                          otherButtonTitles : @"OK", nil];
        [av show];
    }
    
}

-(IBAction)data_kousin:(id)sender{
    AudioServicesPlaySystemSound(soundID);
    
    UIAlertView *av =[[UIAlertView alloc]
                        initWithTitle:@"サーバーと接続する"
                        message:@"よろしいですか？"
                        delegate:self
                        cancelButtonTitle:@"キャンセル"
                        otherButtonTitles:@"OK", nil];
    av.tag = 1;
    [av show];
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag != 1) {
        return; /* 追加予定 */
    }
    
    /* マスターデータ更新を選んだ　*/
    switch (buttonIndex) {
        case 1:
        {
            [alertView dismissWithClickedButtonIndex:1 animated:NO];
            
            [NSThread detachNewThreadSelector:@selector(getDB:) toTarget:self withObject:nil];
            break;
        }
        case 0:
            break;
    }
    
}

-(void)getDB:(id)sender {
    [ConnectionManager fetchAllDB : self];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *av =[[UIAlertView alloc] initWithTitle : @"データー更新しました\r\nレシート番号を設定してください"
                                                    message : nil
                                                   delegate : self
                                          cancelButtonTitle : nil
                                          otherButtonTitles : @"OK", nil];
        [av show];
    });
                
    
}


- (IBAction)sendUriage:(id)sender {
}



//ページ遷移時の処理
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
        AudioServicesPlaySystemSound(soundID);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end