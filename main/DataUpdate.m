//
//  DataUpdate.m
//  photo
//
//  Created by POSCO on 12/08/20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


//FMDBファイルの定義
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "DataUpdate.h"
#import "Seisan.h"
#import "Nebiki.h"

#define CREATE_Uriage @"CREATE TABLE IF NOT EXISTS Uriage(time TEXT,re_no TEXT,id TEXT,title TEXT,price TEXT,Kosu TEXT)"
#define INSERT_Uriage @"INSERT INTO Uriage(time,re_no,id,title,price,Kosu) VALUES(?,?,?,?,?,?)"
#define ALL_Seisan @"SELECT * FROM Seisan"
#define ALL_Nebiki @"SELECT * FROM Nebiki"
//database name
#define DB_FILE_BurData @"BurData.sqlite"
#define DB_FILE_UpdateData @"UpdateData.sqlite"
#define DB_FILE_Master @"Master.sqlite"

#define DEL_Seisan @"DELETE FROM Seisan"
#define DEL_Nebiki @"DELETE FROM Nebiki"
#define DEL_Uriage @"DELETE FROM Uriage"

#define BTSMAS_Kosu_SET_0 @"UPDATE BTSMAS SET Kosu = 0"

@implementation DataUpdate

+ (FMDatabase *) getUpdateDataDB {
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir =[paths objectAtIndex:0];
    
    FMDatabase *db=[FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:DB_FILE_UpdateData]];
    return db;
    
}


+ (FMDatabase *) getBurDataDB {
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir =[paths objectAtIndex:0];
    
    FMDatabase *db=[FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:DB_FILE_BurData]];
    return db;
    
}

+ (FMDatabase *) getMasterDB {
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir =[paths objectAtIndex:0];
    
    FMDatabase *db=[FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:DB_FILE_Master]];
    return db;
    
}

+(void)saveToUriageWithTime:(NSString *) time re_no:(NSString *) re_no ID:(NSString *) ID title:(NSString *) title price:(NSString *) price kosu:(NSString *) kosu {
    FMDatabase *db = [DataUpdate getUpdateDataDB];
    [db open];
    
    [db executeUpdate:CREATE_Uriage];
    [db executeUpdate:INSERT_Uriage,time,re_no,ID,title,price,kosu];
    [db close];
}


+(NSMutableArray *) getAllSeisan {
    
    NSMutableArray * allSeisan = [[NSMutableArray alloc] init];
    FMDatabase *db = [DataUpdate getBurDataDB];
    [db open];
    FMResultSet *results;
    results=[db executeQuery:ALL_Seisan];
    
    while ([results next]) {
        Seisan * u = [[Seisan alloc]
                      initWithTime:[results stringForColumn:@"time"]
                      re_no:[results stringForColumn:@"re_no"]
                      ID:[results stringForColumn:@"id"]
                      title:[results stringForColumn:@"title"]
                      price:[results stringForColumn:@"price"]
                      kosu:[results stringForColumn:@"Kosu"]];
        [allSeisan addObject:u];
        
    }
    return allSeisan;
}



+(NSMutableArray *) getAllNebiki {
    
    NSMutableArray * allNebiki = [[NSMutableArray alloc] init];
    FMDatabase *db = [DataUpdate getBurDataDB];
    [db open];
    FMResultSet *results;
    results=[db executeQuery:ALL_Nebiki];
    
    while ([results next]) {
        Nebiki * n = [[Nebiki alloc]
                      initWithTime : [results stringForColumn:@"time"]
                      re_no : [results stringForColumn:@"re_no"]
                      tantou_id : [results stringForColumn:@"tantou_id"]
                      goukei : [results stringForColumn:@"goukei"]
                      nebiki : [results stringForColumn:@"nebiki"]
                      azukari : [results stringForColumn:@"azukari"]
                      oturi : [results stringForColumn:@"oturi"]];
        [allNebiki addObject:n];
        
    }
    return allNebiki;
}



//テーブルを空に、ベスト表の個数を０に
+(void)drop_table{
    
    FMDatabase *db = [DataUpdate getBurDataDB];

    FMDatabase *db2=[DataUpdate getMasterDB];
    [db open];
    [db executeUpdate:DEL_Seisan];
    [db executeUpdate:DEL_Nebiki];
    [db close];
    
    [db2 open];
    [db2 executeUpdate:BTSMAS_Kosu_SET_0];
    [db2 close];
}

//テーブルを空に
+(void)drop_table2{
    
    FMDatabase *db = [DataUpdate getUpdateDataDB];
    [db open];
    [db executeUpdate:DEL_Uriage];
    [db close];
    
}
@end
