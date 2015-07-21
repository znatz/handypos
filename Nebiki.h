//
//  Nebiki.h
//  TEST_HandyPOS
//
//  Created by POSCO on 15/07/06.
//
//

#import <Foundation/Foundation.h>

@interface Nebiki : NSObject
@property NSString * _time;
@property NSString * _re_no;
@property NSString * _tantou_id;
@property NSString * _goukei;
@property NSString * _nebiki;
@property NSString * _azukari;
@property NSString * _oturi;
-(Nebiki *) initWithTime : (NSString *) time
                   re_no : (NSString *) re_no
               tantou_id : (NSString *) tantou_id
                  goukei : (NSString *) goukei
                  nebiki : (NSString *) nebiki
                 azukari : (NSString *) azukari
                   oturi : (NSString *) oturi;
@end
