//
//  ToDoData.m
//  Labb2
//
//  Created by Marcus Klaesson on 2020-01-20.
//  Copyright © 2020 Marcus Klaesson. All rights reserved.
//

#import "ToDoData.h"

@implementation ToDoData

- (instancetype) initWithDate:(NSString *)date andTask:(NSString *)task{
    self = [super init];
    
    if(self){
        self.date = date;
        self.task = task;
    }
    return self;
}


@end
