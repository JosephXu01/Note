//
//  User.h
//  Note
//
//  Created by Shallong on 15/12/13.
//  Copyright (c) 2015年 Shallong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Note;

@interface User : NSManagedObject

@property (nonatomic, retain) NSData * faceImage;
@property (nonatomic, retain) NSString * loginAccount;
@property (nonatomic, retain) NSString * loginPassword;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSString * readingPassword;
@property (nonatomic, retain) NSSet *notes;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addNotesObject:(Note *)value;
- (void)removeNotesObject:(Note *)value;
- (void)addNotes:(NSSet *)values;
- (void)removeNotes:(NSSet *)values;

@end
