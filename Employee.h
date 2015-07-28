//
//  Employee.h
//  TEST_HandyPOS
//
//  Created by POSCO on 15/07/13.
//
//

#import <Foundation/Foundation.h>

@interface Employee : NSObject
@property int ID;
@property NSString * name;
@property NSString * created_at;
@property NSString * updated_at;
-(Employee *) initWithID : (int) i
              name : (NSString *) n
        created_at : (NSString *) c
        updated_at : (NSString *) u;
@end
