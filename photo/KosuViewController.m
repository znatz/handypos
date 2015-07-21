//
//  KosuViewController.m
//  photo
//
//  Created by POSCO on 12/07/30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "KosuViewController.h"
#import "MainViewController.h"
#import "DataModels.h"
#import "Syoukei.h"

@interface KosuViewController ()

@end


@implementation KosuViewController{
    
    
    NSString *Flag;
    NSString *strPrice;
    NSString *strKosu;
    
    //wav再生用
    NSString *path;
    NSURL *url;
    SystemSoundID soundID;
}

@synthesize titleLabel;
@synthesize priceLabel;
@synthesize kosuLabel;
@synthesize goukeiLabel;
@synthesize photoImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	self.title=@"個数変更";
    
    Flag=@"1";
    //背景用の設定
    self.navigationController.navigationBar.tintColor=[UIColor brownColor];
    UIImage *imgback=[UIImage imageNamed:@"back.bmp"];
    self.view.backgroundColor=[UIColor colorWithPatternImage:imgback];
    
    //音用の設定
    path=[[NSBundle mainBundle]pathForResource:@"butin" ofType:@"wav"];
    url=[NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url,&soundID);
    


    Goods * g = [DataModels getGoodsByID:self.selectedSyoukei.ID];
    
    titleLabel.text  =  self.selectedSyoukei.title;

    priceLabel.text  =  [NSString stringWithFormat:@"%d 円", self.selectedSyoukei.price];
    kosuLabel.text   =  [NSString stringWithFormat:@"%d 点", self.selectedSyoukei.kosu];
    goukeiLabel.text =  [NSString stringWithFormat:@"%d 円", self.selectedSyoukei.price * self.selectedSyoukei.kosu];
    
    photoImage.image=[[UIImage alloc]initWithData:g.contents];
    
    UIBarButtonItem * kettei = [[UIBarButtonItem alloc]
                               initWithTitle : @"決定"
                               style : UIBarButtonItemStyleBordered
                               target : self
                               action :@selector(submit)];
    
    self.navigationItem.rightBarButtonItem = kettei;         
}

-(IBAction)plus:(id)sender{
    AudioServicesPlaySystemSound(soundID);
    self.selectedSyoukei.kosu ++;
    goukeiLabel.text=[NSString stringWithFormat:@"%d 円", self.selectedSyoukei.kosu * self.selectedSyoukei.price ];
    kosuLabel.text=[NSString stringWithFormat:@"%d 点", self.selectedSyoukei.kosu];

}

-(IBAction)minus:(id)sender{
    if(self.selectedSyoukei.kosu >0){
        self.selectedSyoukei.kosu -- ;
        goukeiLabel.text=[NSString stringWithFormat:@"%d 円", self.selectedSyoukei.kosu * self.selectedSyoukei.price ];
        kosuLabel.text=[NSString stringWithFormat:@"%d 点", self.selectedSyoukei.kosu];
    }
}


-(void)submit {
    AudioServicesPlaySystemSound(soundID);
    [DataModels updateSyoukeiByID:self.selectedSyoukei.ID withKosu:[NSString stringWithFormat:@"%d", self.selectedSyoukei.kosu]];
    [self.navigationController popViewControllerAnimated:YES];
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
