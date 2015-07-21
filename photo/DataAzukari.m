//
//  DataAzukari.m
//  photo
//
//  Created by POSCO on 12/10/31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DataAzukari.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "Settings.h"



#define DB_FILE_NAME @"Azukari.sqlite"
//#define SQL_UPDATE @"UPDATE Mode SET Mode = ?"

@interface DataAzukari ()
+(FMDatabase *) defaultDB;
@end

@implementation DataAzukari

+(FMDatabase *) defaultDB {
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir =[paths objectAtIndex:0];
    FMDatabase *db=[FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:DB_FILE_NAME]];
    return db;
}

/* ZNATZ ================================ */
+(void) insertSettings : (Settings *) s {
    FMDatabase *db = [DataAzukari defaultDB];
    NSString * query = @"INSERT INTO Settings (azmode, tantou, bumode, picmode, nimode) VALUES (?, ?, ?, ?, ?); ";
    [db open];
    [db executeUpdate:query, s.azmode, s.tantou, s.bumode, s.picmode, s.nimode];
    [db close];
    return;
}

+(Settings *) getSettings {

    FMDatabase * db = [DataAzukari defaultDB];
    NSString * query = @"SELECT * FROM Settings;";
    
    Settings * s;
    [db open];
    FMResultSet * results=[db executeQuery:query];

    while ([results next]) {
        s = [[Settings alloc]
             initWithAZmode : [results stringForColumn:@"azmode"]
             tantou : [results stringForColumn : @"tantou"]
             bumode : [results stringForColumn:@"bumode"]
             picmode : [results stringForColumn:@"picmode"]
             nimode : [results stringForColumn:@"nimode" ]];
    }
    [db close];
    return  s;
}

+(ReceiptSettings *) getReceiptSettings {
    
    FMDatabase * db = [DataAzukari defaultDB];
    NSString * query = @"SELECT * FROM ReceiptSettings;";
    
    ReceiptSettings * s;
    [db open];
    FMResultSet * results=[db executeQuery:query];
    while ([results next]) {
        s = [[ReceiptSettings alloc]
                               initWithTax : [results intForColumn:@"tax"]
                               haveReceipt : [results intForColumn:@"haveReceipt"]
                               haveStamp : [results intForColumn:@"haveStamp"]
                               haveComment : [results intForColumn:@"haveComment"]];
    }
    [db close];
    return  s;
}

+(void) updateSettings : (Settings *) s {

    FMDatabase *db = [DataAzukari defaultDB];
    NSString * query = @"DELETE FROM Settings";
    [db open];
    [db executeUpdate:query];
    [db close];
    [self insertSettings:s];
    return;
}

/* ============================ */







+(void) create_Azukari{
    
           
    FMDatabase *db = [DataAzukari defaultDB];
    
    [db open];
    NSString * query =
    @"CREATE TABLE IF NOT EXISTS Settings (azmode TEXT, tantou TEXT, bumode TEXT, picmode TEXT, nimode TEXT);";
    [db executeUpdate:query];
    [db close];

    
}


@end