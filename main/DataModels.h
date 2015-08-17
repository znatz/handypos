//
//  DataModels.h
//  photo
//
//  Created by POSCO on 12/07/12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Syoukei.h"
#import "Nikkei.h"
#import "Goods.h"
#import "TransferData.h"
#import "Nebiki.h"

@interface DataModels : NSObject
+(void)insertID:(NSString *)idno insertTitle:(NSString *)title insertPrice:(NSString *)price insertKosu:(NSString *)Kosu selectFlag:(NSString *)Flag;
+(void)insertTime:(NSString *)time insertReno:(NSString *)reno insertTantou:(NSString *)tantou_id insertGoukei:(NSString *)goukei insertNebiki:(NSString *)nebiki insertAzukari:(NSString *)azukari insertOturi:(NSString *)oturi;
+(NSMutableArray *)selectTitle:(NSMutableArray *)array selectFlag:(NSString *)Flag;
+(NSMutableArray *)selectPrice:(NSMutableArray *)array selectFlag:(NSString *)Flag;
+(NSMutableArray *)selectContents:(NSMutableArray *)array;
+(NSMutableArray *)selectKosu:(NSMutableArray *)array selectFlag:(NSString *)Flag;





/* ZNATZ */
+ (void) createTransferData ;
+ (void) dropTransferData ;
+ (void) saveToTransfer : (TransferData *) t;
+ (NSMutableArray *) getAllTransfer;

+(NSString *) getTanpoNameByID : (NSString *) i;
+(NSString *) getTantoNameByID : (NSString *) i;
+(NSMutableArray *) getTantosByShopID : (NSString *) i ;

+(int)getTantoCount ;
+(NSMutableArray *) getAllTantos;
+(NSMutableArray *) getAllBumon ;
+(NSMutableArray *) getAllGoods ;
+(NSMutableArray *) getAllTanpo ;
+(NSMutableArray *) getAllGoodsByBumon : (NSString *) bumon ;
+(Goods *) getGoodsByID : (NSString *) ID ;
+(Goods *) getBumonByID : (NSString *) ID ;
+(NSMutableArray *) getAllSyoukei;
+(void) insertSyoukei : (Syoukei *) s ;
+(Syoukei *) getSyoukeiByID : (NSString *) ID;
+(void) updateSyoukeiByID : (NSString *) ID
                 withKosu : (NSString *) kosu;
+ (void) saveToSeisan : (Syoukei *) s
             withTime : (NSString *) t
        withReceiptNo : (NSString *) r
            withBumon : (NSString *) b ;

+(void) updateNikkeiByID : (NSString *) ID withKosu : (NSString *) kosu ;
+(void) insertNikkei : (Nikkei *) s ;
+(NSMutableArray *) getAllNikkei ;

+(Nebiki *) getNebikkiByReceiptNo : (NSString *) re_no ;



+(NSMutableArray *)selectID:(NSMutableArray *)array selectFlag:(NSString *)Flag;
+(NSMutableArray *)selectReno:(NSMutableArray *)array;
//+(NSMutableArray *)selectBumonID:(NSMutableArray *)array selectFlag:(NSString *)Flag;
//+(NSMutableArray *)selectNebiki:(NSMutableArray *)array;
//+(NSMutableArray *)selectGenka:(NSMutableArray *)array;
//+(NSMutableArray *)select:(NSMutableArray *)array selectBumon:(NSString *)Bumon selectFlag:(NSString *)Flag;
+(NSMutableArray *)selectTenpo:(NSMutableArray *)array where_id:(NSString *)idno;
+(void)selectID:(NSString *)idno updateKosu:(NSString *)Kosu selectFlag:(NSString *)Flag;
+(void)drop_table:(NSString *)Flag;
+(void)delete_table:(NSString *)idno;

@end
