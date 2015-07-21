//
//  FTPController.m
//  HandyPOS
//
//  Created by POSCO on 12/12/13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SendViewController.h"
#import "DataUpdate.h"

@interface SendViewController()<NSStreamDelegate>
@end

@implementation SendViewController

NSString *UserName;
NSString *DLFlag;
NSString *strURL;
NSString *strName;
NSString *strPass;
bool Connection;
bool blnMode;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"データ通信";
    //背景用の設定
    self.navigationController.navigationBar.tintColor=[UIColor brownColor];
    UIImage *imgback=[UIImage imageNamed:@"back.bmp"];
    self.view.backgroundColor=[UIColor colorWithPatternImage:imgback];
    
    strURL=@"ftp://posco-web.com/httpdocs/posco/Master.sqlite";
    strName=@"a10254787";
    strPass=@"sB9pwjW4";
    blnMode=true;
    
}

@end

