//
//  ScratchableView.m
//  CGScratch
//
//  Created by Olivier Yiptong on 11-01-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScratchableView.h"


@implementation ScratchableView


/// Gabi - Redimensiona uma UIImage para um tamanho arbitrário passado como CGSize e retorna a UIImage resultante.
/// @param image imagem a ser redimensionada.
/// @param newSize CGSize com Width e Height arbitrário que será usado para redimensionar a image.
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {

        UIImage * image = [UIImage imageNamed:@"scratchable.jpg"];

        //Gabi - Redimensionando a image, UIImage construída direto do jpg, para o tamanho do frame recebido no init.
        UIImage * scaledImage = [self imageWithImage:image scaledToSize:frame.size];

        //Gabi - usando o CGImage da scaledImage em vez da UIImage construída a partir do jpg.
		scratchable = scaledImage.CGImage;

        width = CGImageGetWidth(scratchable);
        height = CGImageGetHeight(scratchable);
		self.opaque = NO;
        
		CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceGray();
		
		CFMutableDataRef pixels = CFDataCreateMutable(kCFAllocatorDefault, width * height );
        CFDataSetLength(pixels, width * height);
        alphaPixels = CGBitmapContextCreate(
                            CFDataGetMutableBytePtr(pixels),
                            width,
                            height,
                            8,
                            width,
                            colorspace,
                            kCGImageAlphaNone
                      );
		provider = CGDataProviderCreateWithCFData(pixels);
		
		
		CGContextSetFillColorWithColor(alphaPixels, [UIColor blackColor].CGColor);
		CGContextFillRect(alphaPixels, frame);
		
		CGContextSetStrokeColorWithColor(alphaPixels, [UIColor whiteColor].CGColor);
		CGContextSetLineWidth(alphaPixels, 20.0); //Gabi - Talvez fosse legal parametrizar na API esse valor aqui também
		CGContextSetLineCap(alphaPixels, kCGLineCapRound);
		
		CGImageRef mask = CGImageMaskCreate(width, height, 8, 8, width, provider, nil, NO);
		scratched = CGImageCreateWithMask(scratchable, mask);
		
		CGImageRelease(mask);
		CGColorSpaceRelease(colorspace);
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
	CGContextDrawImage(UIGraphicsGetCurrentContext() , [self bounds] , scratched);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event touchesForView:self] anyObject];
	firstTouch = YES;
	location = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event touchesForView:self] anyObject];
	
	if (firstTouch) {
		firstTouch = NO;
		previousLocation = [touch previousLocationInView:self];
	} else {
		location = [touch locationInView:self];
		previousLocation = [touch previousLocationInView:self];
	}
	
	// Render the stroke
	[self renderLineFromPoint:previousLocation toPoint:location];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event touchesForView:self] anyObject];
	if (firstTouch) {
		firstTouch = NO;
		previousLocation = [touch previousLocationInView:self];
		
		[self renderLineFromPoint:previousLocation toPoint:location];
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (void) renderLineFromPoint:(CGPoint)start toPoint:(CGPoint)end {
	
	CGContextMoveToPoint(alphaPixels, start.x, start.y);
	CGContextAddLineToPoint(alphaPixels, end.x, end.y);
	CGContextStrokePath(alphaPixels);
	[self setNeedsDisplay];
}


@end
