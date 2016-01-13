//
//  textProcessor.m
//  nmiss-ios
//
//  Created by NIall McGinness on 2016-01-06.
//  Copyright © 2016 Niall McGinness. All rights reserved.
//

#import "textProcessor.h"

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

@end
