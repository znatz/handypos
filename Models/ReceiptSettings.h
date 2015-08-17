//
//  ReceiptSettings.h
//  TEST_HandyPOS
//
//  Created by POSCO on 15/07/08.
//
//

#import <Foundation/Foundation.h>

@interface ReceiptSettings : NSObject
@property int tax;
@property int haveReceipt;
@property int haveStamp;
@property int haveComment;

-(ReceiptSettings *) initWithTax : (int) t
                     haveReceipt : (int) r
                       haveStamp : (int) s
                     haveComment : (int) c;
@end
