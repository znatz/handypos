//
//  Uriage.h
//  TEST_HandyPOS
//
//  Created by POSCO on 15/07/06.
//
//

#import <Foundation/Foundation.h>

@interface Seisan : NSObject
@property NSString * _time;
@property NSString * _re_no;
@property NSString * _ID;
@property NSString * _title;
@property NSString * _price;
@property NSString * _kosu;
-(Seisan *) initWithTime : (NSString *) time
                   re_no : (NSString *) re_no
                      ID : (NSString *) ID
                   title : (NSString *) title
                   price : (NSString *) price
                    kosu : (NSString *) kosu ;
@end
