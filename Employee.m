//
//  Employee.m
//  TEST_HandyPOS
//
//  Created by POSCO on 15/07/13.
//
//

#import "Employee.h"

@implementation Employee

-(Employee *) initWithID : (int) i
              name : (NSString *) n
        created_at : (NSString *) c
        updated_at : (NSString *) u
{
    self = [super init];
    self = [super init];
    self.ID = i;
    self.name = n;
    self.created_at = c;
    self.updated_at = u;
    return self;
}

@end
