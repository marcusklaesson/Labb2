//
//  ToDoData.h
//  Labb2
//
//  Created by Marcus Klaesson on 2020-01-20.
//  Copyright © 2020 Marcus Klaesson. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ToDoData : NSObject

@property (nonatomic) NSString *date;
@property (nonatomic) NSString *task;

- (instancetype) initWithDate: (NSString*) date andTask: (NSString*)task;

@end

NS_ASSUME_NONNULL_END
