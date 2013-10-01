//
//  TestCustomAnnotationView.m
//  LocationApp
//
//  Created by Mihails Prihodko on 6/20/13.
//  Copyright (c) 2013 Mihails Prihodko. All rights reserved.
//

#import "TestCustomAnnotationView.h"

@implementation TestCustomAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.image = [UIImage imageNamed:@"apple_icon_small.jpg"];
        
        CGRect frameToSet = self.frame;
        frameToSet.size = self.image.size;
        self.frame = frameToSet;
        
        self.opaque = NO;
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
