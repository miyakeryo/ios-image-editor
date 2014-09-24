#import "HFImageEditorFrameView.h"
#import "QuartzCore/QuartzCore.h"


@interface HFImageEditorFrameView ()
@property (nonatomic,strong) UIImageView *imageView;
@end

@implementation HFImageEditorFrameView

@synthesize cropRect = _cropRect;
@synthesize imageView  = _imageView;
@synthesize borderColor = _borderColor;
@synthesize borderWidth = _borderWidth;
@synthesize circle = _circle;

- (void) initialize
{
    self.opaque = NO;
    self.layer.opacity = 0.7;
    self.backgroundColor = [UIColor clearColor];
    self.borderColor = [UIColor colorWithWhite:1 alpha:0.5];
    self.borderWidth = 1;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:imageView];
    self.imageView = imageView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self initialize];
    }
    return self;
}

void CGContextRoundRectPath(CGContextRef context, CGRect rect, CGFloat radius)
{
    CGFloat lx = CGRectGetMinX(rect);
    CGFloat rx = CGRectGetMaxX(rect);
    CGFloat ty = CGRectGetMinY(rect);
    CGFloat by = CGRectGetMaxY(rect);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, lx+radius, by);
    CGContextAddArcToPoint(context, lx, by, lx, by-radius, radius);
    CGContextAddArcToPoint(context, lx, ty, lx+radius, ty, radius);
    CGContextAddArcToPoint(context, rx, ty, rx, ty+radius, radius);
    CGContextAddArcToPoint(context, rx, by, rx-radius, by, radius);
    CGContextClosePath(context);
}
void CGContextCirclePath(CGContextRef context, CGRect rect)
{
    CGContextRoundRectPath(context, rect, rect.size.width/2);
}

- (void)setCropRect:(CGRect)cropRect
{
    if(!CGRectEqualToRect(_cropRect,cropRect)){
        _cropRect = CGRectOffset(cropRect, self.frame.origin.x, self.frame.origin.y);
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.f);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [[UIColor blackColor] setFill];
        UIRectFill(self.bounds);
        
        [[UIColor clearColor] setFill];
        
        if(_circle){
            CGContextCirclePath(context,CGRectInset(cropRect, 1, 1));
            CGContextSetBlendMode(context,kCGBlendModeClear);
            CGContextFillPath(context);
            CGContextSetBlendMode(context,kCGBlendModeNormal);
        }else{
            UIRectFill(CGRectInset(cropRect, 1, 1));
        }
        
        CGContextSetStrokeColorWithColor(context, _borderColor.CGColor);
        CGContextSetLineWidth(context, _borderWidth);
        CGRect borderRect = cropRect;
        borderRect.origin.x += _borderWidth/2;
        borderRect.origin.y += _borderWidth/2;
        borderRect.size.width -= _borderWidth;
        borderRect.size.height -= _borderWidth;
        if(_circle){
            CGContextCirclePath(context,borderRect);
            CGContextStrokePath(context);
        }else{
            CGContextStrokeRect(context, borderRect);
        }
        
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();

        UIGraphicsEndImageContext();
    }
}

- (void)addCirclePath:(CGContextRef)context rect:(CGRect)rect
{
    
}

/*
- (void)drawRect:(CGRect)rect
{
   CGContextRef context = UIGraphicsGetCurrentContext();

    [[UIColor blackColor] setFill];
    UIRectFill(rect);
    CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor);
    CGContextStrokeRect(context, self.cropRect);
    [[UIColor clearColor] setFill];
    UIRectFill(CGRectInset(self.cropRect, 1, 1));

}
*/

@end
