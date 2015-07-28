//
//  NikkeiViewController.h
//  photo
//
//  Created by POSCO on 12/08/02.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESCPOSPrinter.h"

@interface NikkeiViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    ESCPOSPrinter *escp;
}

@property(retain,nonatomic)UITableView *tableview;

@end
