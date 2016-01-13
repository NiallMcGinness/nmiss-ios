//
//  HelpData.h
//  
//
//  Created by NIall McGinness on 2015-05-04.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HelpData : NSManagedObject

@property (nonatomic, retain) NSString * helpsheetID;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * body;
@property (nonatomic) NSTimeInterval dateChanged;
@property (nonatomic, retain) NSData * image;

@end
