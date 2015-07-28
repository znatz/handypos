//
//  SeisanViewController2.h
//  photo
//
//  Created by POSCO on 12/10/31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESCPOSPrinter.h"

@interface SeisanViewController2 : UIViewController{
        ESCPOSPrinter *escp;
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
    @property(weak,nonatomic)IBOutlet UIButton *btn1;
    @property(weak,nonatomic)IBOutlet UIButton *btn2;
    @property(weak,nonatomic)IBOutlet UIButton *btn3;
    @property(weak,nonatomic)IBOutlet UIButton *btn4;
    @property(weak,nonatomic)IBOutlet UIButton *btn5;
    @property(weak,nonatomic)IBOutlet UIButton *btn6;
    @property(weak,nonatomic)IBOutlet UIButton *btn500;
    @property(weak,nonatomic)IBOutlet UIButton *btn1000;
    @property(weak,nonatomic)IBOutlet UIButton *btn5000;
    @property(weak,nonatomic)IBOutlet UIButton *btn10000;

@end
