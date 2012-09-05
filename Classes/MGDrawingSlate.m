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

- (id)initWithFrame:(CGRect)frame withExistingNotes:(UIImage *)existingNotes;
{
    
    self = [self initWithFrame:frame];
    
    if (self)
    {
        if (existingNotes != nil)
            [self setBackgroundColor:[UIColor colorWithPatternImage:existingNotes]];
    }
    
    return self;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _drawingPaths = [[NSMutableArray alloc] init];
        
        //Initialize MGDrawingSlate and set default values
        self.backgroundColor = [UIColor whiteColor];
                
        drawingColor = [UIColor blackColor]; //Default color - change with changeColorTo: method.
        
    }
    
    return self;

}

- (void)viewDidUnload
{
    _drawingPaths = nil;
    _drawingPath = nil;
    _savedColor = nil;
}

#pragma mark - Customization Methods

//Call from view controller to change the line weight of the drawing path. Alternatively, just change [drawingSlate]->drawingPath.lineWidth.
- (void)changeLineWeightTo:(NSInteger)weight {
    
    _drawingPath.lineWidth = weight;   
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
        drawingColor = _savedColor;
    } else {
        _savedColor = drawingColor;
        drawingColor = [UIColor whiteColor];
    }
    
    if (eraseMode != _eraserMode && _drawingPath != nil)
    {
        NSArray *pathInfo = @[drawingColor, _drawingPath];
        [_drawingPaths addObject:pathInfo];
        _drawingPath = nil;
    }
    
    _eraserMode = eraseMode;
}

#pragma mark - Drawing Methods

- (void)drawRect:(CGRect)rect
{
    for (NSArray *pathInfo in _drawingPaths)
    {
        UIColor *theColor = [pathInfo objectAtIndex:IDX_COLOR];
        UIBezierPath *thePath = [pathInfo objectAtIndex:IDX_PATH];
        
        [theColor setStroke];
        [thePath strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
    }
    
    if (_drawingPath != nil)
    {
        [drawingColor setStroke];
        [_drawingPath strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_drawingPath == nil)
    {
        _drawingPath = [[UIBezierPath alloc]init];
        _drawingPath.lineCapStyle = kCGLineCapRound;
        _drawingPath.miterLimit = 0;
        
        if (_eraserMode)
            _drawingPath.lineWidth = 15;
        else
            _drawingPath.lineWidth = 2;
    }
    
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    [_drawingPath moveToPoint:[touch locationInView:self]];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    [_drawingPath addLineToPoint:[touch locationInView:self]];
    
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_drawingPath != nil)
    {
        NSArray *pathInfo = @[drawingColor, [_drawingPath copy]];
        [_drawingPaths addObject:pathInfo];
    }
    
    _drawingPath = nil;
}

@end