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
                 name : (NSString *) name {
    Tanto * t = [Tanto alloc];
    t._ID = ID;
    t._name = name;
    return t;
}
@end
