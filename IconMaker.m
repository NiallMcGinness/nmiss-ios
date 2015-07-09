//
//  IconMaker.m
//  nmiss-ios
//
//  Created by NIall McGinness on 2015-04-15.
//  Copyright (c) 2015 Niall McGinness. All rights reserved.
//

#import "IconMaker.h"

@implementation IconMaker

static UIColor* _colorWhite = nil;
static UIColor* _colorBlack = nil;

+ (void)initialize {
    _colorWhite = [UIColor whiteColor];
    _colorBlack = [UIColor blackColor];
}

+(UIColor*)colorWhite{return _colorWhite;}
+(UIColor*)colorBlack{return _colorBlack;}

-(UIImage *)createBackIconImage{
    UIImage *iconImage = [UIImage new];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(40, 40), NO, 0.0f);
    [self backIconBlueprint];
    iconImage =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return iconImage;
}

-(UIImage *)createMaintIconImage{
    
    UIImage *iconImage = [UIImage new];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(50, 50), NO, 0.0f);
    [self maintIconBlueprint];
    iconImage =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return iconImage;
}

-(UIImage *)createIncIconImage{
    
    UIImage *iconImage = [UIImage new];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(50, 50), NO, 0.0f);
    [self incIconBlueprint];
    iconImage =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return iconImage;
}

-(UIImage *)createBackChevronImage{
    
    UIImage *iconImage = [UIImage new];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(50, 50), NO, 0.0f);
    [self backChevronBlueprint];
    iconImage =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return iconImage;
}

-(UIImage *)logIncImage{
    
    UIImage *iconImage = [UIImage new];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(50, 50), NO, 0.0f);
    [self logIncBlueprint];
    iconImage =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return iconImage;
}

-(void)backIconBlueprint{
    int startx = 10;
    int starty = 20;
    int backx = 16;
    int arrowWidth = 1;
    
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(2.5, 2.5, 30, 30)];
    [UIColor.blackColor setStroke];
    ovalPath.lineWidth = 0.5;
    [ovalPath stroke];
    
    UIBezierPath* bezierPath = UIBezierPath.bezierPath;
    [bezierPath moveToPoint: CGPointMake(startx, starty)];
    [bezierPath addLineToPoint: CGPointMake(24.0, starty)];
    [UIColor.blackColor setStroke];
    bezierPath.lineWidth = arrowWidth;
    [bezierPath stroke];
    
    UIBezierPath *up = UIBezierPath.bezierPath;
    [up moveToPoint: CGPointMake(startx, starty)];
    [up addLineToPoint: CGPointMake(backx, starty - 7.0)];
    [UIColor.blackColor setStroke];
    up.lineWidth = arrowWidth;
    [up stroke];
    
    UIBezierPath *down = UIBezierPath.bezierPath;
    [down moveToPoint: CGPointMake(startx, starty)];
    [down addLineToPoint: CGPointMake(backx, starty + 7.0)];
    [UIColor.blackColor setStroke];
    down.lineWidth = arrowWidth;
    [down stroke];
}

-(void)backChevronBlueprint{
    int startx = 11;
    int starty = 18;
    int backx = 20;
    int arrowWidth = 2;
    
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(2.5, 2.5, 30, 30)];
    [UIColor.blackColor setStroke];
    ovalPath.lineWidth = 0.5;
    [ovalPath stroke];
    
    
    UIBezierPath *up = UIBezierPath.bezierPath;
    [up moveToPoint: CGPointMake(startx, starty)];
    [up addLineToPoint: CGPointMake(backx, starty - 7.0)];
    [UIColor.blackColor setStroke];
    up.lineWidth = arrowWidth;
    [up stroke];
    
    UIBezierPath *down = UIBezierPath.bezierPath;
    [down moveToPoint: CGPointMake(startx, starty)];
    [down addLineToPoint: CGPointMake(backx, starty + 7.0)];
    [UIColor.blackColor setStroke];
    down.lineWidth = arrowWidth;
    [down stroke];
}

-(void)maintIconBlueprint{


    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(3, 4, 18, 4)];
    [_colorWhite setFill];
    [rectanglePath fill];
    
    
    //// Rectangle 2 Drawing
    UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRect: CGRectMake(3, 10, 18, 4)];
    [_colorWhite setFill];
    [rectangle2Path fill];
    
    
    //// Rectangle 3 Drawing
    UIBezierPath* rectangle3Path = [UIBezierPath bezierPathWithRect: CGRectMake(3, 16, 18, 4)];
    [_colorWhite setFill];
    [rectangle3Path fill];
    
    
    
    //// Rectangle 5 Drawing
    UIBezierPath* rectangle5Path = [UIBezierPath bezierPathWithRect: CGRectMake(23, 10, 4, 4)];
    [_colorBlack setFill];
    [rectangle5Path fill];
    
    
    //// Rectangle 6 Drawing
    UIBezierPath* rectangle6Path = [UIBezierPath bezierPathWithRect: CGRectMake(23, 4, 4, 4)];
    [_colorBlack setFill];
    [rectangle6Path fill];
    
    
    //// Rectangle 7 Drawing
    UIBezierPath* rectangle7Path = [UIBezierPath bezierPathWithRect: CGRectMake(23.5, 16.25, 3.5, 3.5)];
    [UIColor.whiteColor setStroke];
    rectangle7Path.lineWidth = 0.5;
    [rectangle7Path stroke];

}
-(void)incIconBlueprint{
    
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(1.75, 1.75, 26.5, 26.5)];
    [UIColor.blackColor setStroke];
    ovalPath.lineWidth = 0.5;
    [ovalPath stroke];
    
    
    
    UIBezierPath* oval3Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(13, 20, 4, 4)];
    [UIColor.whiteColor setFill];
    [oval3Path fill];
    
    UIBezierPath* polygonPath = UIBezierPath.bezierPath;
    [polygonPath moveToPoint: CGPointMake(13.75, 18)];
    [polygonPath addLineToPoint: CGPointMake(12.25, 7)];
    [polygonPath addLineToPoint: CGPointMake(17.75, 7)];
    [polygonPath addLineToPoint: CGPointMake(16.25, 18)];
    [polygonPath addLineToPoint: CGPointMake(13.75, 18)];
    [polygonPath closePath];
    [UIColor.whiteColor setFill];
    [polygonPath fill];
    
}

-(void)logIncBlueprint{

    /// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    //// Shadow Declarations
    NSShadow* shadow = [[NSShadow alloc] init];
    [shadow setShadowColor: UIColor.blackColor];
    [shadow setShadowOffset: CGSizeMake(3.1, 3.1)];
    [shadow setShadowBlurRadius: 5];
    
    //// Text Drawing
    CGRect textRect = CGRectMake(11, 6, 74, 20);
    {
        NSString* textContent = @"log incident +";
        NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        textStyle.alignment = NSTextAlignmentLeft;
        
        NSDictionary* textFontAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize: UIFont.smallSystemFontSize], NSForegroundColorAttributeName: UIColor.whiteColor, NSParagraphStyleAttributeName: textStyle};
        
        CGFloat textTextHeight = [textContent boundingRectWithSize: CGSizeMake(textRect.size.width, INFINITY)  options: NSStringDrawingUsesLineFragmentOrigin attributes: textFontAttributes context: nil].size.height;
        CGContextSaveGState(context);
        CGContextClipToRect(context, textRect);
        [textContent drawInRect: CGRectMake(CGRectGetMinX(textRect), CGRectGetMinY(textRect) + (CGRectGetHeight(textRect) - textTextHeight) / 2, CGRectGetWidth(textRect), textTextHeight) withAttributes: textFontAttributes];
        CGContextRestoreGState(context);
    }
    
    
    //// Bezier Drawing
    UIBezierPath* bezierPath = UIBezierPath.bezierPath;
    [bezierPath moveToPoint: CGPointMake(7.5, 5.5)];
    [bezierPath addLineToPoint: CGPointMake(89.5, 5.5)];
    [bezierPath addLineToPoint: CGPointMake(89.5, 26.5)];
    [bezierPath addLineToPoint: CGPointMake(7.5, 26.5)];
    [bezierPath addLineToPoint: CGPointMake(7.5, 5.5)];
    [bezierPath closePath];
    bezierPath.lineCapStyle = kCGLineCapSquare;
    
    bezierPath.lineJoinStyle = kCGLineJoinBevel;
    
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadow.shadowOffset, shadow.shadowBlurRadius, [shadow.shadowColor CGColor]);
    [UIColor.whiteColor setStroke];
    bezierPath.lineWidth = 1;
    [bezierPath stroke];
    CGContextRestoreGState(context);

}

@end
