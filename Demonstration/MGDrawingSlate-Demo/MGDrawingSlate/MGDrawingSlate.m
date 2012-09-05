//
//  MGDrawingSlate.m
//  MGDrawingSlate
//
//  Created by gtmtg on 6/28/12.
//  Copyright (c) 2012 MG App Development ( http://mgapps.weebly.com ).
//  Licensed for use under the MIT License. See the license file included with this source code or visit http://opensource.org/licenses/MIT for more information.
//

#import "MGDrawingSlate.h"

@implementation MGDrawingSlate

static const NSInteger IDX_COLOR = 0;
static const NSInteger IDX_PATH = 1;

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame withExistingImage:(UIImage *)existingImage;
{
    
    self = [self initWithFrame:frame];
    
    if (self)
    {
        if (existingImage != nil)
            [self setBackgroundColor:[UIColor colorWithPatternImage:existingImage]];
    }
    
    return self;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        drawingPaths = [[NSMutableArray alloc] init];
        
        //Initialize MGDrawingSlate and set default values
        self.backgroundColor = [UIColor whiteColor];
                
        drawingColor = [UIColor blackColor]; //Default color - change with changeColorTo: method.
        
    }
    
    return self;

}

- (void)viewDidUnload
{
    drawingPaths = nil;
    drawingPath = nil;
    savedColor = nil;
}

#pragma mark - Customization Methods

//Call from view controller to change the line weight of the drawing path. Alternatively, just change [drawingSlate]->drawingPath.lineWidth.
- (void)changeLineWeightTo:(NSInteger)weight {
    
    drawingPath.lineWidth = weight;   
}

//Call from view controller to change the color of the drawing path. Alternatively, just change [drawingSlate]->drawingColor.
- (void)changeColorTo:(UIColor *)color
{
    drawingColor = color;
}

- (void)setEraseMode:(BOOL)eraseMode;
{
    if (!eraseMode)
    {
        drawingColor = savedColor;
    } else {
        savedColor = drawingColor;
        drawingColor = [UIColor whiteColor];
    }
    
    if (eraseMode != _eraserMode && drawingPath != nil)
    {
        NSArray *pathInfo = @[drawingColor, drawingPath];
        [drawingPaths addObject:pathInfo];
        drawingPath = nil;
    }
    
    _eraserMode = eraseMode;
}

#pragma mark - Drawing Methods

- (void)drawRect:(CGRect)rect
{
    for (NSArray *pathInfo in drawingPaths)
    {
        UIColor *theColor = [pathInfo objectAtIndex:IDX_COLOR];
        UIBezierPath *thePath = [pathInfo objectAtIndex:IDX_PATH];
        
        [theColor setStroke];
        [thePath strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
    }
    
    if (drawingPath != nil)
    {
        [drawingColor setStroke];
        [drawingPath strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (drawingPath == nil)
    {
        drawingPath = [[UIBezierPath alloc]init];
        drawingPath.lineCapStyle = kCGLineCapRound;
        drawingPath.miterLimit = 0;
        
        if (_eraserMode)
            drawingPath.lineWidth = 15;
        else
            drawingPath.lineWidth = 2;
    }
    
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    [drawingPath moveToPoint:[touch locationInView:self]];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    [drawingPath addLineToPoint:[touch locationInView:self]];
    
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (drawingPath != nil)
    {
        NSArray *pathInfo = @[drawingColor, [drawingPath copy]];
        [drawingPaths addObject:pathInfo];
    }
    
    drawingPath = nil;
}

@end