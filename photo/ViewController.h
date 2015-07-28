//
//  ViewController.h
//  photo
//
//  Created by POSCO on 12/07/12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,assign)NSInteger row_num;
//@property(weak,nonatomic)IBOutlet UIButton *uriage;
@property(nonatomic,assign)NSString *strBumon;

@end
