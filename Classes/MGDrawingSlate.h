//
//  MGDrawingSlate.h
//  MGDrawingSlate
//
//  Created by gtmtg on 6/28/12.
//  Copyright (c) 2012 MG App Development ( http://mgapps.weebly.com ).
//  Licensed for use under the MIT License. See the license file included with this source code or visit http://opensource.org/licenses/MIT for more information.
//

#import <UIKit/UIKit.h>

@interface MGDrawingSlate : UIView
{
    @public UIColor *drawingColor;
    @private BOOL _eraserMode;
    UIColor *_savedColor;
    UIBezierPath *_drawingPath;
    NSMutableArray *_drawingPaths;
}

- (id)initWithFrame:(CGRect)frame withExistingNotes:(UIImage *)existingNotes;
- (void)changeLineWeightTo:(NSInteger)weight;
- (void)changeColorTo:(UIColor *)color;
- (void)setEraseMode:(BOOL)eraseMode;

@end
