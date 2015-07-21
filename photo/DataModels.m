//
//  DataModels.m
//  photo
//
//  Created by POSCO on 12/07/12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

//FMDBファイルの定義
#import "DataModels.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "Tanto.h"
#import "Bumon.h"
#import "Goods.h"
#import "Syoukei.h"
#import "Nikkei.h"
#import "Nebiki.h"
#import "TransferData.h"
#import "Tenpo.h"

/* BTAMAS : 担当 */
/* BRUMAS : MASTER 部門 */
/* BTSMAS : MASTER 商品 */

//database name
#define DB_FILE_Master @"Master.sqlite"
#define DB_FILE_BurData @"BurData.sqlite"
// all tantou
#define ALL_Tanto @"SELECT * FROM BTAMAS"
#define ALL_Goods @"SELECT * FROM BTSMAS ORDER BY Kosu DESC,price DESC"
#define ALL_Bumon @"SELECT * FROM BBUMAS ORDER BY id"


#define INSERT_to_Seisan @"INSERT INTO Seisan(time,re_no,id,title,bumon,price,Kosu) VALUES(?,?,?,?,?,?,?)"
#define INIT_Syoukei @"CREATE TABLE IF NOT EXISTS Syoukei(id TEXT,title TEXT,price INTEGER,Kosu INTEGER)"
#define INIT_Nikkei @"CREATE TABLE IF NOT EXISTS Nikkei(id TEXT,title TEXT,price INTEGER,Kosu INTEGER)"
#define Tanpo_By_ID @"SELECT * FROM BMIMAS WHERE id = ? ORDER BY id"
#define Goods_By_ID @"SELECT * FROM BTSMAS WHERE id = ?"

//SQL文の管理
#define CREATE_Seisan @"CREATE TABLE IF NOT EXISTS Seisan(time TEXT,re_no TEXT,id TEXT,title TEXT,bumon TEXT,price INTEGER,Kosu INTEGER)"
#define CREATE_Nikkei @"CREATE TABLE IF NOT EXISTS Nikkei(id TEXT,title TEXT,price INTEGER,Kosu INTEGER)"
#define CREATE_Nebiki @"CREATE TABLE IF NOT EXISTS Nebiki(time TEXT,re_no TEXT,tantou_id TEXT,goukei INTEGER,nebiki INTEGER,azukari INTEGER,oturi INTEGER)"
#define CREATE_Henpin @"CREATE TABLE IF NOT EXISTS Henpin(id TEXT,title TEXT,price INTEGER,Kosu INTEGER)"

#define INSERT_Syoukei @"INSERT INTO Syoukei(id,title,price,Kosu) VALUES(?,?,?,?)"
#define INSERT_Nikkei @"INSERT INTO Nikkei(id,title,price,Kosu) VALUES(?,?,?,?)"
#define INSERT_Nebiki @"INSERT INTO Nebiki(time,re_no,tantou_id,goukei,nebiki,azukari,oturi) VALUES(?,?,?,?,?,?,?)"
#define INSERT_Henpin @"INSERT INTO Henpin(id,title,price,Kosu) VALUES(?,?,?,?)"

#define ALL_BTSMAS_BY_Bumon @"SELECT * FROM BTSMAS WHERE Bumon = ? ORDER BY Kosu DESC,price DESC"
#define ALL_Syoukei @"SELECT * FROM Syoukei"
#define ALL_Seisan @"SELECT * FROM Seisan"
#define ALL_Nikkei @"SELECT * FROM Nikkei ORDER BY Kosu DESC,price DESC"
#define ALL_Nebiki @"SELECT * FROM Nebiki"
#define ALL_Henpin @"SELECT * FROM Henpin ORDER BY Kosu DESC,price DESC"
#define ALL_BMIMAS @"SELECT * FROM BMIMAS ORDER BY id"

#define DEL_Syoukei @"DELETE FROM Syoukei"
#define DEL_Nikkei @"DELETE FROM Nikkei"
#define DEL_Henpin @"DELETE FROM Henpin"

#define UPDATE_Kosu_Syoukei @"UPDATE Syoukei SET Kosu = ? WHERE id = ?"
#define UPDATE_Kosu_Nikkei @"UPDATE Nikkei SET Kosu = ? WHERE id = ?"
#define UPDATE_Kosu_Henpin @"UPDATE Henpin SET Kosu = ? WHERE id = ?"
#define UPDATE_Kosu_BTSMAS @"UPDATE BTSMAS SET Kosu = ? WHERE id = ?"

#define REMOVE_FROM_Syoukei_BY_ID @"DELETE FROM Syoukei WHERE id = ?"
#define REMOVE_FROM_Nikkei_BY_ID @"DELETE FROM Nikkei WHERE id = ?"


@interface DataModels()
+(FMDatabase *) getMasterDB ;
+(FMDatabase *) getBurDataDB ;
@end

@implementation DataModels

+(FMDatabase *) getMasterDB {
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir =[paths objectAtIndex:0];
    
    FMDatabase *db=[FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:DB_FILE_Master]];
    return db;
}

+(FMDatabase *) getBurDataDB {
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir =[paths objectAtIndex:0];
    
    FMDatabase *db=[FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:DB_FILE_BurData]];
    return db;
}



//小計用の一時ファイル
+(void)insertID:(NSString *)idno insertTitle:(NSString *)title insertPrice:(NSString *)price insertKosu:(NSString *)Kosu selectFlag:(NSString *)Flag{//引数：タイトル・値段・
    
    FMDatabase *db = [DataModels getBurDataDB];
    [db open];
        //NSLog(@"%d",[Kosu intValue]);
        if([Kosu intValue]>0){
            [db executeUpdate:CREATE_Nikkei];
            [db executeUpdate:INSERT_Nikkei,idno,title,price,Kosu];
        }
        else{
            [db executeUpdate:CREATE_Henpin];
            [db executeUpdate:INSERT_Henpin,idno,title,price,Kosu];
        }
            
    [db close];
}


//値引きデータと担当の保存
+(void)insertTime:(NSString *)time insertReno:(NSString *)reno insertTantou:(NSString *)tantou_id insertGoukei:(NSString *)goukei insertNebiki:(NSString *)nebiki insertAzukari:(NSString *)azukari insertOturi:(NSString *)oturi{

    FMDatabase *db = [DataModels getBurDataDB];
    [db open];    
    [db executeUpdate:CREATE_Nebiki];
    [db executeUpdate:INSERT_Nebiki,time,reno,tantou_id,goukei,nebiki,azukari,oturi];
    [db close];
    
}


//title取り出し
+(NSMutableArray *)selectTitle:(NSMutableArray *)array selectFlag:(NSString *)Flag{ //引数：
    
    FMDatabase *db;
 
    if([Flag isEqual:@"0"]){
         db = [DataModels getMasterDB];
    }
    else{
         db = [DataModels getBurDataDB];
    }
    [db open];
    FMResultSet *results;
    if([Flag isEqual:@"1"]){
        results=[db executeQuery:ALL_Syoukei];
    }
    if([Flag isEqual:@"3"]){
        results=[db executeQuery:ALL_Seisan];
    }
    if([Flag isEqual:@"4"]){
        results=[db executeQuery:ALL_Nikkei];
    }
    if([Flag isEqual:@"5"]){
        results=[db executeQuery:ALL_Henpin];
    }

    NSString *titleData;
    while ([results next]) {
        titleData=[results stringForColumn:@"title"];
        [array addObject:titleData];
    }
    [db close];
    return array;
}

//値段取り出し
+(NSMutableArray *)selectPrice:(NSMutableArray *)array selectFlag:(NSString *)Flag { //引数：
    
    FMDatabase *db;
    
    if([Flag isEqual:@"0"]){
        db = [DataModels getMasterDB];
    }
    else{
        db = [DataModels getBurDataDB];
    }
    [db open];
    
    FMResultSet *results;
    if([Flag isEqual:@"4"]){
        results=[db executeQuery:ALL_Nikkei];
    }
    else if([Flag isEqual:@"5"]){
        results=[db executeQuery:ALL_Henpin];
    }
    NSString *priceData;
    while ([results next]) {
        priceData=[results stringForColumn:@"price"];
        [array addObject:priceData];
    }
    [db close];
    return array;
}


/* ---------------------------------------------*/
//画像の取り出し 部門：通常モードに呼び出し
+(NSMutableArray *)selectContents:(NSMutableArray *)array{

    FMDatabase *db = [DataModels getMasterDB];
    [db open];
    FMResultSet *results=[db executeQuery:ALL_Goods];
    NSData *contentsData;
    while ([results next]) {
        contentsData=[results dataForColumn:@"contents"];
        if([contentsData length]==0){
            UIImage *image=[UIImage imageNamed:@"NoImage.png"];
            contentsData=[[NSData alloc]initWithData:UIImagePNGRepresentation(image)];
        }
        [array addObject:contentsData];
    }
    [db close];
    return array;                          
}


+(NSMutableArray *) getAllGoods {
    FMDatabase *db = [DataModels getMasterDB];
    [db open];
    
    FMResultSet *results=[db executeQuery:ALL_Goods];
    NSMutableArray * allGoods = [[NSMutableArray alloc] init];
    while ([results next]) {
        Goods * g = [[Goods alloc] initWithID:[results stringForColumn:@"id"] price:[results intForColumn:@"price"] genka:[results intForColumn:@"genka"] title:[results stringForColumn:@"title"] bumon:[results stringForColumn:@"Bumon"] contents:[results dataForColumn:@"contents"] kosu:[results intForColumn:@"Kosu"]];
        [allGoods addObject:g];
    }
    
    [db close];
    return allGoods;
}

+(NSMutableArray *) getAllGoodsByBumon : (NSString *) bumon {
    FMDatabase *db = [DataModels getMasterDB];
    NSString * query = [NSString stringWithFormat:@"SELECT * FROM BTSMAS WHERE Bumon = '%@'", bumon];
    
    [db open];
    
    FMResultSet *results=[db executeQuery: query];
    NSMutableArray * allGoods = [[NSMutableArray alloc] init];
    
    while ([results next]) {
        Goods * g = [[Goods alloc] initWithID:[results stringForColumn:@"id"] price:[results intForColumn:@"price"] genka:[results intForColumn:@"genka"] title:[results stringForColumn:@"title"] bumon:[results stringForColumn:@"Bumon"] contents:[results dataForColumn:@"contents"] kosu:[results intForColumn:@"Kosu"]];
        [allGoods addObject:g];
    }

    [db close];

    return allGoods;
}

+(Goods *) getGoodsByID : (NSString *) ID {
    FMDatabase *db = [DataModels getMasterDB];
    NSString * query = [NSString stringWithFormat:@"SELECT * FROM BTSMAS WHERE id = '%@'", ID];
    
    [db open];
    
    
    FMResultSet *results=[db executeQuery: query];
    Goods * g = [Goods alloc];
    
    while ([results next]) {
        g = [[Goods alloc] initWithID:[results stringForColumn:@"id"] price:[results intForColumn:@"price"] genka:[results intForColumn:@"genka"] title:[results stringForColumn:@"title"] bumon:[results stringForColumn:@"Bumon"] contents:[results dataForColumn:@"contents"] kosu:[results intForColumn:@"Kosu"]];
    }
    
    [db close];
    
    return g;
}

+(Bumon *) getBumonByID : (NSString *) ID {
    FMDatabase *db = [DataModels getMasterDB];
    NSString * query = [NSString stringWithFormat:@"SELECT * FROM BBUMAS WHERE id = '%@'", ID];
    
    Bumon * b = [Bumon alloc];

    [db open];
    
    
    FMResultSet *results=[db executeQuery: query];
    
    while ([results next]) {
        b = [[Bumon alloc] initWithID:[results stringForColumn:@"id"] bumon:[results stringForColumn:@"Bumon"]];
    }
    
    [db close];
    
    return b;
}


//個数の取り出し
+(NSMutableArray *)selectKosu:(NSMutableArray *)array selectFlag:(NSString *)Flag{ //引数：

    FMDatabase *db;
    
    if([Flag isEqual:@"0"]){
        db = [DataModels getMasterDB];
    }
    else{
        db = [DataModels getBurDataDB];
    }
    [db open];
    
    FMResultSet *results;
    if([Flag isEqual:@"3"]) {
        results=[db executeQuery:ALL_Seisan];
    }
    else if([Flag isEqual:@"4"]) {
        results=[db executeQuery:ALL_Nikkei];
    }
    else if([Flag isEqual:@"5"]){
        results=[db executeQuery:ALL_Henpin];
    }
    else {
        results=[db executeQuery:ALL_Syoukei];
    }
    NSString *kosuData;
    while ([results next]) {
        kosuData=[results stringForColumn:@"Kosu"];
        [array addObject:kosuData];
    }
    [db close];
    return array;
}

/* ------------------------------------------------ */
+ (NSMutableArray *) getAllTantos {
    
    FMDatabase *db = [DataModels getMasterDB];
    [db open];
    
    FMResultSet *results=[db executeQuery:ALL_Tanto];
    NSMutableArray * tantos = [[NSMutableArray alloc] init];
    while ([results next]) {
        Tanto * t = [[Tanto alloc] initWithID:[results stringForColumn:@"id"]
                                         name:[results stringForColumn:@"name"]];
        [tantos addObject:t];
    }
    
    [db close];
    return tantos;
}

//担当者の数を取り出す
+(int)getTantoCount {

    FMDatabase *db = [DataModels getMasterDB];
    [db open];
    
    int i = 0;
    FMResultSet *results=[db executeQuery:ALL_Tanto];
    while ([results next]) {
        i++;
    }
    
    [db close];
    return i;
    
}


/* ------------------------------------------------ */
+(NSMutableArray *) getAllBumon {
    FMDatabase *db = [DataModels getMasterDB];
    [db open];
    
    FMResultSet *results=[db executeQuery:ALL_Bumon];
    NSMutableArray * bumons = [[NSMutableArray alloc] init];
    while ([results next]) {
        Bumon * b = [[Bumon alloc] initWithID:[results stringForColumn:@"id"]
                                         bumon:[results stringForColumn:@"Bumon"]];
        [bumons addObject:b];
    }
    
    [db close];
    return bumons;
    
}

//レシートナンバーの取り出し
+(NSMutableArray *)selectReno:(NSMutableArray *)array{
    FMDatabase *db = [DataModels getBurDataDB];

    [db open];
    
    FMResultSet *results=[db executeQuery:ALL_Seisan];
    NSString *nameData;
    while ([results next]) {
        nameData=[results stringForColumn:@"re_no"];
        [array addObject:nameData];
    }
    [db close];
    return array;
}
//値引きデータ呼び出し
+(NSMutableArray *)selectNebiki:(NSMutableArray *)array{

    FMDatabase *db = [DataModels getBurDataDB];

    [db open];
    
    FMResultSet *results=[db executeQuery:ALL_Nebiki];
    NSString *nameData;
    while ([results next]) {
        nameData=[results stringForColumn:@"nebiki"];
        [array addObject:nameData];
    }
    [db close];
    return array;
}

+(NSMutableArray *)selectBumonID:(NSMutableArray *)array selectFlag:(NSString *)Flag{

    FMDatabase *db;

    if([Flag isEqual:@"4"]){
        db=[DataModels getBurDataDB];
    }
    else if([Flag isEqual:@"8"]){
        db=[DataModels getMasterDB];
    }
    [db open];
    FMResultSet *results;
    if([Flag isEqual:@"4"]){
        results=[db executeQuery:ALL_Seisan];
    }
    NSString *idData;
    while ([results next]) {
        if([Flag isEqual:@"4"]){
            idData=[results stringForColumn:@"bumon"];
        }
        else if([Flag isEqual:@"8"]){
            idData=[results stringForColumn:@"id"];
        }
        [array addObject:idData];
    }
    [db close];
    return array;
}


//原価呼び出し
+(NSMutableArray *)selectGenka:(NSMutableArray *)array{

    FMDatabase *db = [DataModels getMasterDB];

    [db open];
    
    FMResultSet *results=[db executeQuery:ALL_Goods];
    NSString *nameData;
    while ([results next]) {
        nameData=[results stringForColumn:@"genka"];
        [array addObject:nameData];
    }
    [db close];
    return array;
    
}

//部門管理時の呼び出し
+(NSMutableArray *)select:(NSMutableArray *)array selectBumon:(NSString *)Bumon selectFlag:(NSString *)Flag{
    
    FMDatabase *db = [DataModels getMasterDB];
    [db open];
    
    FMResultSet *results;
    results=[db executeQuery:ALL_BTSMAS_BY_Bumon,Bumon];
    
    NSString *nameData;
    NSData *contentsData;
    if([Flag isEqual:@"4"]){
        while ([results next]) {
            contentsData=[results dataForColumn:@"contents"];
            if([contentsData length]==0){
                UIImage *image=[UIImage imageNamed:@"NoImage.png"];
                contentsData=[[NSData alloc]initWithData:UIImagePNGRepresentation(image)];
            }
            [array addObject:contentsData];
        }
    }
    else{
        while ([results next]) {
            if([Flag isEqual:@"1"]){
                nameData=[results stringForColumn:@"id"];
            }
            else if([Flag isEqual:@"2"]){
                nameData=[results stringForColumn:@"title"];
            }
            else if([Flag isEqual:@"3"]){
                nameData=[results stringForColumn:@"price"];
            }
            [array addObject:nameData];
        }
    }
    [db close];
    return array;
}

+(NSMutableArray *)selectTenpo:(NSMutableArray *)array where_id:(NSString *)idno{

    FMDatabase *db = [DataModels getMasterDB];

    [db open];
    
    FMResultSet *results=[db executeQuery:Tanpo_By_ID,idno];
    NSString *TenpoData;
    while ([results next]) {
        TenpoData=[results stringForColumn:@"Tenpo"];
        [array addObject:TenpoData];
    }
    [db close];
    return array;   
}

//idの取り出し
+(NSMutableArray *)selectID:(NSMutableArray *)array selectFlag:(NSString *)Flag{ //引数：

    FMDatabase *db;
    if([Flag isEqual:@"0"] || [Flag isEqual:@"6"]){
        db=[DataModels getMasterDB];    }
    else{
        db=[DataModels getBurDataDB];   }
    
    [db open];
    
    FMResultSet *results;
    if([Flag isEqual:@"1"]){
        results=[db executeQuery:ALL_Syoukei];
    }
    if([Flag isEqual:@"3"]){
        results=[db executeQuery:ALL_Seisan];
    }
    if([Flag isEqual:@"4"]){
        results=[db executeQuery:ALL_Nikkei];
    }
    if([Flag isEqual:@"5"]){
        results=[db executeQuery:ALL_Henpin];
    }
    NSString *idData;
    while ([results next]) {
        idData=[results stringForColumn:@"id"];
        [array addObject:idData];
    }
    [db close];
    return array;
}








/* ----------------------------------------- */
//既存商品の個数増加
+(void)selectID:(NSString *)idno updateKosu:(NSString *)Kosu selectFlag:(NSString *)Flag{

    FMDatabase *db;
    if([Flag isEqual:@"4"]){
        db=[DataModels getMasterDB];
    }
    else{
        db=[DataModels getBurDataDB];
    }
    [db open];
    if([Flag isEqual:@"4"]){
        [db executeUpdate:UPDATE_Kosu_BTSMAS,Kosu,idno];
    }
    else if([Flag isEqual:@"3"]){
        if([Kosu intValue]>0){
            [db executeUpdate:UPDATE_Kosu_Nikkei,Kosu,idno];
        }
        else{
            [db executeUpdate:UPDATE_Kosu_Henpin,Kosu,idno];
        }
    }
    else{
        [db executeUpdate:UPDATE_Kosu_Syoukei,Kosu,idno];
    }
    [db close];
    
}

//特定項目の削除
+(void)delete_table:(NSString *)idno{

    FMDatabase *db = [DataModels getBurDataDB];
   
    [db open];
    [db executeUpdate:REMOVE_FROM_Syoukei_BY_ID,idno];
    [db close];
    
}

//テーブルを空にする
+(void)drop_table:(NSString *)Flag{

    
    FMDatabase *db;
    if([Flag isEqual:@"0"]|| [Flag isEqual:@"6"]){
        db=[DataModels getMasterDB];
    }
    else{
        db=[DataModels getBurDataDB];    }
    [db open];
    
  
    if([Flag isEqual:@"Syoukei"]){
        [db executeUpdate:DEL_Syoukei];
    }
    else if([Flag isEqual:@"3"]){
        [db executeUpdate:DEL_Nikkei];
        [db executeUpdate:DEL_Henpin];
    }
    [db close];
}




/* ZNATZ ============================================  */
+(NSMutableArray *) getAllSyoukei {
    FMDatabase * db = [DataModels getBurDataDB];
    NSMutableArray * allSyoukei = [[NSMutableArray alloc] init];
    [db open];
    FMResultSet *results=[db executeQuery:ALL_Syoukei];
    while ([results next]) {
        Syoukei * s = [[Syoukei alloc]
                       initWithID : [results stringForColumn:@"id"]
                       title      : [results stringForColumn:@"title"]
                       price      : [results intForColumn:@"price"]
                       kosu : [results intForColumn:@"Kosu"]];
        [allSyoukei addObject:s];
    }
    [db close];
    return allSyoukei;
    
}

+(void) insertSyoukei : (Syoukei *) s {
    FMDatabase * db = [DataModels getBurDataDB];
    [db open];
    [db executeUpdate:INIT_Syoukei];
    [db close];
    [db open];
    [db executeUpdate:@"INSERT INTO Syoukei ( id, title, price, Kosu) VALUES(?,?,?,?)", s.ID, s.title, [@(s.price) stringValue], [@(s.kosu) stringValue]];
    [db close];
    return;
}

+(void) updateSyoukeiByID : (NSString *) ID withKosu : (NSString *) kosu {
    FMDatabase * db = [DataModels getBurDataDB];
    [db open];
    if ([kosu isEqualToString: @"0"]  ) {
        [db executeUpdate:REMOVE_FROM_Syoukei_BY_ID, ID];
        [db close];
        return;
    }
    [db executeUpdate:UPDATE_Kosu_Syoukei, kosu, ID];
    [db close];
    return;
}

+(NSString *) getTanpoNameByID : (NSString *) i {
    FMDatabase * db = [DataModels getMasterDB];

    NSString * name = [[NSString alloc] init];
    [db open];
    FMResultSet *results=[db executeQuery:@"SELECT Tenpo FROM BMIMAS WHERE id = ?", i];
    while ([results next]) {
        name = [results stringForColumn:@"Tenpo"];
    }
    [db close];
    return name;
}

+(NSString *) getTantoNameByID : (NSString *) i {
    FMDatabase * db = [DataModels getMasterDB];

    NSString * name = [[NSString alloc] init];
    [db open];
    FMResultSet *results=[db executeQuery:@"SELECT name FROM BTAMAS WHERE id = ?", i];
    while ([results next]) {
        name = [results stringForColumn:@"name"];
    }
    [db close];
    return name;
}



+(NSMutableArray *) getAllTanpo {
    FMDatabase * db = [DataModels getMasterDB];

    NSMutableArray * allTenpo = [[NSMutableArray alloc] init];
    [db open];
    FMResultSet *results=[db executeQuery:@"SELECT * FROM BMIMAS"];
    while ([results next]) {
        Tenpo * t = [[Tenpo alloc] initWithID:[NSString stringWithFormat:@"%d", [results intForColumn:@"id"]] tenpo:[results stringForColumn:@"Tenpo"]];
        [allTenpo addObject:t];
    }
    NSLog(@"%@",[db lastErrorMessage]);
    [db close];
    return allTenpo;
}





+ (void) saveToSeisan : (Syoukei *) s
             withTime : (NSString *) t
        withReceiptNo : (NSString *) r
            withBumon : (NSString *) b
{
    FMDatabase * db = [DataModels getBurDataDB];
    NSLog(@"%@, %@, %@", t, r, b);
    [db open];
    [db executeUpdate:INSERT_to_Seisan, t, r, s.ID, s.title, b, [NSString stringWithFormat:@"%d",s.price],[NSString stringWithFormat:@"%d", s.kosu]];
    [db close];
}

+ (void) createTransferData {
    FMDatabase * db = [DataModels getBurDataDB];
    [db open];
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS transfer ( tantoID TEXT, goodsTitle TEXT, kosu TEXT, time TEXT, receiptNo TEXT);"];
    [db close];
}

+ (void) dropTransferData {
    FMDatabase * db = [DataModels getBurDataDB];
    [db open];
    [db executeUpdate:@"DELETE FROM transfer;"];
    [db close];
}

+ (void) saveToTransfer : (TransferData *) t
{
    FMDatabase * db = [DataModels getBurDataDB];
    [db open];
    [db executeUpdate:@"INSERT INTO transfer VALUES (?, ?, ?, ?, ?)", t.tantoID, t.goodsTitle, t.kosu, t.time, t.receiptNo];
    [db close];
}

/* Nikkie */
+(NSMutableArray *) getAllNikkei {
    FMDatabase * db = [DataModels getBurDataDB];
    NSMutableArray * allNikkei = [[NSMutableArray alloc] init];
    [db open];
    FMResultSet *results=[db executeQuery:ALL_Nikkei];
    while ([results next]) {
        Nikkei * s = [[Nikkei alloc]
                       initWithID : [results stringForColumn:@"id"]
                       title      : [results stringForColumn:@"title"]
                       price      : [results intForColumn:@"price"]
                       kosu : [results intForColumn:@"Kosu"]];
        [allNikkei addObject:s];
    }
    [db close];
    return allNikkei;
    
}

+(void) insertNikkei : (Nikkei *) s {
    FMDatabase * db = [DataModels getBurDataDB];
    [db open];
    [db executeUpdate:INIT_Nikkei];
    [db close];
    [db open];
    [db executeUpdate:@"INSERT INTO Nikkei ( id, title, price, Kosu) VALUES(?,?,?,?)", s.ID, s.title, [@(s.price) stringValue], [@(s.kosu) stringValue]];
    [db close];
    return;
}

+(void) updateNikkeiByID : (NSString *) ID withKosu : (NSString *) kosu {
    FMDatabase * db = [DataModels getBurDataDB];
    [db open];
    if ([kosu isEqualToString: @"0"]  ) {
        [db executeUpdate:REMOVE_FROM_Nikkei_BY_ID, ID];
        [db close];
        return;
    }
    [db executeUpdate:UPDATE_Kosu_Nikkei, kosu, ID];
    [db close];
    return;
}

+(Nebiki *) getNebikkiByReceiptNo : (NSString *) re_no {
    FMDatabase * db = [DataModels getBurDataDB];
    Nebiki * n = [Nebiki alloc];
    [db open];
    FMResultSet *results=[db executeQuery:@"SELECT * FROM Nebiki WHERE re_no = ?", re_no];
    while ([results next]) {
        n = [[Nebiki alloc] initWithTime : [results stringForColumn:@"time"]
                                   re_no : [results stringForColumn:@"re_no"]
                               tantou_id : [results stringForColumn:@"tantou_id"]
                                  goukei : [NSString stringWithFormat:@"%d", [results intForColumn:@"goukei"]]
                                  nebiki : [NSString stringWithFormat:@"%d", [results intForColumn:@"nebiki"]]
                                 azukari : [NSString stringWithFormat:@"%d", [results intForColumn:@"azukari"]]
                                   oturi : [NSString stringWithFormat:@"%d", [results intForColumn:@"oturi"]]];
    }
    [db close];
    return n;
   
}

+(NSMutableArray *) getAllTransfer {
    FMDatabase * db = [DataModels getBurDataDB];
    NSMutableArray * allTransfer = [[NSMutableArray alloc] init];
    [db open];
    FMResultSet *results=[db executeQuery:@"SELECT * FROM transfer"];
    while ([results next]) {
        TransferData * t = [[TransferData alloc] initWithTantoID:[results stringForColumn:@"tantoID"] goodsTitle:[results stringForColumn:@"goodsTitle"] kosu:[results stringForColumn:@"kosu"] time:[results stringForColumn:@"time"] receiptNo:[results stringForColumn:@"receiptNo"]];
        [allTransfer addObject:t];
    }
    [db close];
    return allTransfer;
}


@end
