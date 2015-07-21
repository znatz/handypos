//
//  ShopSettings.m
//  TEST_HandyPOS
//
//  Created by POSCO on 15/07/08.
//
//

#import "ShopSettings.h"

@implementation ShopSettings
-(ShopSettings *) initWithTempo : (NSString *) t
                           reji : (NSString *) r
                        receipt : (NSString *) rt
{
    self = [super init];
    self.tempo = t;
    self.reji = r;
    self.receipt = rt;
    return self;
}
@end
