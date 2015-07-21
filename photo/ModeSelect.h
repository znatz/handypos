//
//  ModeSelect.h
//  HandyPOS
//
//  Created by POSCO on 12/12/14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModeSelect : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(retain,nonatomic)UITableView *tableview;
@end
