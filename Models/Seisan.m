//
//  Uriage.m
//  TEST_HandyPOS
//
//  Created by POSCO on 15/07/06.
//
//

#import "Seisan.h"

@implementation Seisan
-(Seisan *) initWithTime : (NSString *) time
re_no : (NSString *) re_no
ID : (NSString *) ID
title : (NSString *) title
price : (NSString *) price
kosu : (NSString *) kosu
{
    Seisan * u = [Seisan alloc];
    u._time = time;
    u._re_no = re_no;
    u._ID = ID;
    u._title = title;
    u._price = price;
    u._kosu = kosu;
    return u;
}

@end
