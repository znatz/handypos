//
//  DataAzukari.h
//  photo
//
//  Created by POSCO on 12/10/31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Settings.h"
#import "ReceiptSettings.h"

@interface DataAzukari : NSObject

+(void)create_Azukari;
+(void) insertSettings : (Settings *) s ;
+(void) updateSettings : (Settings *) s ;
+(Settings *) getSettings ;
+(ReceiptSettings *) getReceiptSettings ;


+(void)drop_table;
+(void)update_Tantou:(NSString *)Code;

+(NSMutableArray *)selectNo:(NSMutableArray *)array;
+(NSMutableArray *)selectTantou:(NSMutableArray *)array;

@end
