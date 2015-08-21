//
//  IncData.h
//  
//
//  Created by NIall McGinness on 2015-08-21.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface IncData : NSManagedObject

@property (nonatomic, retain) NSString * body;
@property (nonatomic) NSTimeInterval dateLastChanged;
@property (nonatomic, retain) NSString * location;
@property (nonatomic) BOOL status;
@property (nonatomic, retain) NSString * title;

@end
