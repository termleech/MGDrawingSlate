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
    @public
    UIColor *drawingColor;
    UIBezierPath *drawingPath;
    @private
    BOOL _eraserMode;
    UIColor *savedColor;
    NSMutableArray *drawingPaths;
}

- (id)initWithFrame:(CGRect)frame withExistingImage:(UIImage *)existingImage;
- (void)changeLineWeightTo:(NSInteger)weight;
- (void)changeColorTo:(UIColor *)color;
- (void)setEraseMode:(BOOL)eraseMode;

@end
