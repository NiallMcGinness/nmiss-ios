//
//  textProcessor.m
//  nmiss-ios
//
//  Created by NIall McGinness on 2016-01-06.
//  Copyright © 2016 Niall McGinness. All rights reserved.
//

#import "textProcessor.h"
#import <GameplayKit/GKRandomSource.h>

@implementation textProcessor

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(CGFloat)textBoxHeight:(NSString *)inputString {
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentNatural;
    
    NSAttributedString *rawText = [[NSAttributedString alloc] initWithString:inputString
                                                                    attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Verdana"  size:18],
                                                                                 NSParagraphStyleAttributeName : paragraph }];
    
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:rawText];
    
    CGFloat thirty = 30;
    CGFloat width = textStorage.size.width;
    CGFloat height = textStorage.size.height;
    CGFloat heightOfBox = ((width / screenBounds.size.width) * height * 1.2 ) + thirty;
    if (heightOfBox < 30.0) {
        heightOfBox = 60.0;
    }
    return heightOfBox;
    
}

+(NSMutableString *)generateID{
   
   NSMutableString *stringID = [NSMutableString string];
    NSMutableString *placeholder;
   NSArray *alphanum = @[@"!",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",@"$",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"?",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"Y",@"Z"];
    
    for (int i = 0; i < 32; i++) {
        placeholder = alphanum[[[GKRandomSource sharedRandom] nextIntWithUpperBound:55.0]];
        [stringID  appendString:(placeholder)];
    }
    return stringID;
}

@end
