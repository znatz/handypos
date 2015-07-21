//
//  DataMente.h
//  HandyPOS
//
//  Created by POSCO on 12/12/27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "ShopSettings.h"
#import "ReceiptSettings.h"

@interface DataMente : NSObject

+(FMDatabase *) getDB ;

/* ShopSettings Table */
+(void) createShopSettingsTable;
+(void) insertShopSettings : (ShopSettings *) s;
+(void) updateShopSettings : (ShopSettings *) s ;
+(ShopSettings *) getShopSettings ;


+(void) createReceiptSettingsTable;
+(void) insertReceiptSettings : (ReceiptSettings *) s;
+(void) updateReceiptSettings : (ReceiptSettings *) s ;
+(ReceiptSettings *) getReceiptSettings ;


@end
