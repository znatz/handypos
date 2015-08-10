//
//  Tanto.m
//  TEST_HandyPOS
//
//  Created by POSCO on 15/07/06.
//
//

#import "Tanto.h"

@implementation Tanto
-(Tanto *) initWithID : (NSString *) ID
                 name : (NSString *) name
                 shop : (int) s {
    Tanto * t = [Tanto alloc];
    t._ID = ID;
    t._name = name;
    t.shop = s;
    return t;
}
@end
