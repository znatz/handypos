//
//  TransferData.m
//  TEST_HandyPOS
//
//  Created by POSCO on 15/07/10.
//
//

#import "TransferData.h"

@implementation TransferData

-(TransferData *) initWithTantoID : (NSString *) i
                       goodsTitle : (NSString *) t
                             kosu : (NSString *) k
                             time : (NSString *) time
                        receiptNo : (NSString *) r
                          tableNO : (NSString *)tb
{
    self = [super init];
    self.tantoID = i;
    self.goodsTitle = t;
    self.kosu = k;
    self.time = time;
    self.receiptNo = r;
    self.tableNO = tb;
    return self;
}
@end
