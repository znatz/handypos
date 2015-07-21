//
//  DataMente.m
//  HandyPOS
//
//  Created by POSCO on 12/12/27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DataMente.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "ShopSettings.h"
#import "ReceiptSettings.h"


@implementation DataMente

/* ZNATZ */
+(FMDatabase *) getDB {
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir =[paths objectAtIndex:0];    
    FMDatabase *db=[FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:@"Azukari.sqlite"]];
    return db;
}



/* ShopSettings Table ========================================================== */
+(void) createShopSettingsTable {
    
    FMDatabase *db = [DataMente getDB];
    
    [db open];
    NSString * query =
    @"CREATE TABLE IF NOT EXISTS ShopSettings (tempo TEXT, reji TEXT, receipt TEXT);";
    [db executeUpdate:query];
    [db close];
}


+(void) insertShopSettings : (ShopSettings *) s {
    FMDatabase *db = [DataMente getDB];
    NSString * query = @"INSERT INTO ShopSettings (tempo, reji, receipt) VALUES (?, ?, ?); ";
    [db open];
    [db executeUpdate:query, s.tempo, s.reji, s.receipt];
    [db close];
    return;
}

+(ShopSettings *) getShopSettings {
    
    FMDatabase *db = [DataMente getDB];
    NSString * query = @"SELECT * FROM ShopSettings;";
    
    ShopSettings * s;
    [db open];
    FMResultSet * results=[db executeQuery:query];
    
    while ([results next]) {
        s = [[ShopSettings alloc]
             initWithTempo : [results stringForColumn:@"tempo"]
             reji : [results stringForColumn : @"reji"]
             receipt : [results stringForColumn:@"receipt"]];
    }
    [db close];
    return  s;
}

+(void) updateShopSettings : (ShopSettings *) s {
    
    FMDatabase *db = [DataMente getDB];
    NSString * query = @"DELETE FROM ShopSettings";
    [db open];
    [db executeUpdate:query];
    [db close];
    [self insertShopSettings:s];
    return;
}
/* =============================================================== */



/* ReceiptSettings Table ========================================================== */


+(void) createReceiptSettingsTable {
      
        FMDatabase *db = [DataMente getDB];
        
        [db open];
        NSString * query =
        @"CREATE TABLE IF NOT EXISTS ReceiptSettings (tax INTEGER, haveReceipt INTEGER, haveStamp INTEGER, haveComment INTEGER);";
        [db executeUpdate:query];
        [db close];       
}


+(void) insertReceiptSettings : (ReceiptSettings *) s {
    FMDatabase *db = [DataMente getDB];
    NSString * query = @"INSERT INTO ReceiptSettings (tax, haveReceipt, haveStamp, haveComment) VALUES (?, ?, ?, ?); ";
    [db open];
    [db executeUpdate:query, [NSString stringWithFormat:@"%d",s.tax],
                                [NSString stringWithFormat:@"%d", s.haveReceipt],
                                    [NSString stringWithFormat:@"%d", s.haveStamp],
                                        [NSString stringWithFormat:@"%d", s.haveComment]];

    [db close];
    return;
}

+(ReceiptSettings *) getReceiptSettings {
    
    FMDatabase *db = [DataMente getDB];
    NSString * query = @"SELECT * FROM ReceiptSettings;";
    
    ReceiptSettings * s;
    [db open];
    FMResultSet * results=[db executeQuery:query];
    
    while ([results next]) {
        s = [[ReceiptSettings alloc]
                initWithTax : [results intForColumn:@"tax"]
                haveReceipt : [results intForColumn:@"haveReceipt"]
                haveStamp : [results intForColumn:@"haveStamp"]
                haveComment : [results intForColumn:@"haveComment" ]];
    }
    [db close];
    return  s;
}

+(void) updateReceiptSettings : (ReceiptSettings *) s {
    
    FMDatabase *db = [DataMente getDB];
    NSString * query = @"DELETE FROM ReceiptSettings";
    [db open];
    [db executeUpdate:query];
    [db close];
    [self insertReceiptSettings:s];
    return;
}
/* =============================================================== */


@end