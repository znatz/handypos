//
//  KosuViewController.h
//  photo
//
//  Created by POSCO on 12/07/30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Syoukei.h"

@interface KosuViewController : UIViewController
@property(nonatomic,assign)NSInteger row_num;
@property(weak,nonatomic)IBOutlet UILabel *titleLabel;
@property(weak,nonatomic)IBOutlet UILabel *priceLabel;
@property(weak,nonatomic)IBOutlet UILabel *kosuLabel;
@property(weak,nonatomic)IBOutlet UILabel *goukeiLabel;
@property(weak,nonatomic)IBOutlet UIImageView *photoImage;

@property     Syoukei * selectedSyoukei;
@end
