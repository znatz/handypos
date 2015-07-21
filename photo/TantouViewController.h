//
//  TantouViewController.h
//  photo
//
//  Created by POSCO on 12/07/26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TantouViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>

@property(weak,nonatomic)IBOutlet UILabel *name;
@property(weak,nonatomic)IBOutlet UILabel *idno;

@end
