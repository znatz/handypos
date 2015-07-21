//
//  ReceiptSettings.m
//  TEST_HandyPOS
//
//  Created by POSCO on 15/07/08.
//
//

#import "ReceiptSettings.h"

@implementation ReceiptSettings
-(ReceiptSettings *) initWithTax : (int) t
                     haveReceipt : (int) r
                       haveStamp : (int) s
                     haveComment : (int) c
{
    self = [super init];
    self.tax = t;
    self.haveReceipt = r;
    self.haveStamp = s;
    self.haveComment = c;
    return self;
}
@end
