//
//  SeisanViewController.h
//  photo
//
//  Created by POSCO on 12/07/23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESCPOSPrinter.h"
//#import <AudioToolbox/AudioServices.h>

@interface SeisanViewController : UIViewController{
}

@property(weak,nonatomic)IBOutlet UILabel *goukeiLabel;
@property(weak,nonatomic)IBOutlet UILabel *oturiLabel;
@property(weak,nonatomic)IBOutlet UIButton *btnkettei;
//@property(weak,nonatomic)IBOutlet UITextField *priceField;
//@property(weak,nonatomic)IBOutlet UITextField *nebikiField;
@property(weak,nonatomic)IBOutlet UIButton *percent;
@property(weak,nonatomic)IBOutlet UIButton *enbiki;
@property(weak,nonatomic)IBOutlet UILabel *priceLabel;
//@property(nonatomic,assign)NSString *tantou_id;

@property int totalPrice;
@end
