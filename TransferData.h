//
//  TransferData.h
//  TEST_HandyPOS
//
//  Created by POSCO on 15/07/10.
//
//

#import <Foundation/Foundation.h>

@interface TransferData : NSObject
@property NSString * tantoID;
@property NSString * goodsTitle;
@property NSString * kosu;
@property NSString * time;
@property NSString * receiptNo;
@property NSString * tableNO;
-(TransferData *) initWithTantoID : (NSString *) i
                       goodsTitle : (NSString *) t
                             kosu : (NSString *) k
                             time : (NSString *) time
                        receiptNo : (NSString *) r
                          tableNO : (NSString *) tb;
@end
