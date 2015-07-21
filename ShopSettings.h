//
//  ShopSettings.h
//  TEST_HandyPOS
//
//  Created by POSCO on 15/07/08.
//
//

#import <Foundation/Foundation.h>

@interface ShopSettings : NSObject
@property NSString * tempo;
@property NSString * reji;
@property NSString * receipt;
-(ShopSettings *) initWithTempo : (NSString *) t
                           reji : (NSString *) r
                        receipt : (NSString *) rt;
@end
