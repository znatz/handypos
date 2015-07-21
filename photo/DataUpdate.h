//
//  DataUpdate.h
//  photo
//
//  Created by POSCO on 12/08/20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"

@interface DataUpdate : NSObject

+(NSMutableArray *) getAllSeisan ;

+(NSMutableArray *) getAllNebiki ;

+(void)saveToUriageWithTime:(NSString *) time
                      re_no:(NSString *) re_no
                         ID:(NSString *) ID
                      title:(NSString *) title
                      price:(NSString *) price
                       kosu:(NSString *) kosu ;

+(void)drop_table2;
+ (FMDatabase *) getUpdateDataDB ;
@end
