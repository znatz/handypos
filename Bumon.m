//
//  Bumon.m
//  TEST_HandyPOS
//
//  Created by POSCO on 15/07/06.
//
//

#import "Bumon.h"

@implementation Bumon
-(Bumon *) initWithID :(NSString *) ID
                bumon : (NSString *) bumon {
    Bumon * b = [Bumon alloc];
    b.ID = ID;
    b.bumon = bumon;
    return b;
}
@end
