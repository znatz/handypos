//
//  Tanto.h
//  TEST_HandyPOS
//
//  Created by POSCO on 15/07/06.
//
//

#import <Foundation/Foundation.h>

@interface Tanto : NSObject
@property NSString * _ID;
@property NSString * _name;
-(Tanto *) initWithID : (NSString *) ID
                 name : (NSString *) name;
@end
