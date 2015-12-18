//
//  AttributedBody.m
//  CoreDataTest
//
//  Created by Shallong on 15/12/17.
//  Copyright (c) 2015年 Shallong. All rights reserved.
//

#import "AttributedBody.h"

@implementation AttributedBody

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.body =  [aDecoder decodeObjectForKey:BODY];
    }
    return self;

}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.body forKey:BODY];
    
}

@end
