//
//  Nebiki.m
//  TEST_HandyPOS
//
//  Created by POSCO on 15/07/06.
//
//

#import "Nebiki.h"

@implementation Nebiki

-(Nebiki *) initWithTime : (NSString *) time
                   re_no : (NSString *) re_no
               tantou_id : (NSString *) tantou_id
                  goukei : (NSString *) goukei
                  nebiki : (NSString *) nebiki
                 azukari : (NSString *) azukari
                   oturi : (NSString *) oturi {
    Nebiki * n = [Nebiki alloc];
    n._time = time;
    n._re_no = re_no;
    n._tantou_id = tantou_id;
    n._goukei = goukei;
    n._nebiki = nebiki;
    n._azukari = azukari;
    n._oturi = oturi;
    return n;
}

@end
