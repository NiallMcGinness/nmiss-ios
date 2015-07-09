//
//  IncData.h
//  
//
//  Created by NIall McGinness on 2015-04-20.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface IncData : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSString * location;
@property (nonatomic) NSTimeInterval dateLastChanged;

@end
