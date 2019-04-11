//
//  MLDReadView.m
//  MobLinkProDemo
//
//  Created by lujh on 2018/12/19.
//  Copyright © 2018 mob. All rights reserved.
//

#import "MLDReadView.h"

#import "MLDBookParser.h"

@interface MLDReadView ()

@property (nonatomic, assign) CTFrameRef frameRef;

@end

@implementation MLDReadView

- (void)setContent:(NSMutableAttributedString *)content
{
    _content = content;
    if (content && content.length > 0)
    {
        self.frameRef = [MLDBookParser readFrameRef:content rect:CGRectMake(0, 0, SCREEN_WIDTH - 30, SCREEN_HEIGHT - MOBLINK_StatusBarSafeBottomMargin - MOBLINK_TabbarSafeBottomMargin)];
    }
}

- (void)setFrameRef:(CTFrameRef)frameRef
{
    _frameRef = frameRef;
    if (frameRef)
    {
        [self setNeedsDisplay];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self.frame = frame;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (self.frameRef)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        
        CGContextTranslateCTM(context, 0, rect.size.height);
        
        CGContextScaleCTM(context, 1.0, -1.0);
        
        CTFrameDraw(self.frameRef, context);
    }
}

- (void)dealloc
{
    self.frameRef = nil;
}

@end
