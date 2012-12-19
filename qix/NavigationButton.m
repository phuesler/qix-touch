//
//  NavigationButton.m
//  qix
//
//  Created by Patrick Huesler on 19.12.12.
//
//

#import "NavigationButton.h"

@implementation NavigationButton

-(id) initWithDirection:(NavigationDirection) direction position:(CGPoint) position
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super initWithColor:ccc4(230, 42, 42, 255)]) ) {
        self.direction = direction;
        self.position = position;
        self.contentSize = CGSizeMake(50, 50);
        self.isTouchEnabled = YES;
        self.pressed = NO;
        [self setup];
	}
	return self;
}

- (void)registerWithTouchDispatcher
{
	[[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(void)unregisterWithTouchDispatcher
{
    [[CCDirector sharedDirector].touchDispatcher removeDelegate:self];
}

-(void)cleanup
{
    [super cleanup];
    [self unregisterWithTouchDispatcher];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
    
    if(CGRectContainsPoint([self boundingBox], location))
    {
        self.pressed = YES;
        return YES;
    }
    else
    {
        return NO;
    }
    
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
    
    if(CGRectContainsPoint([self boundingBox], location))
    {
        self.pressed = NO;
    }    
}

-(void)setup
{
    
    NSString * buttonText;
    switch (self.direction)
    
    {
        case kLeft:
            buttonText = @"Left";
            break;
            
        case kRight:
            buttonText = @"Right";
            break;
            
        case kUp:
            buttonText = @"Up";
            break;

        case kDown:
            buttonText = @"Down";
            break;
            
        default:
            NSAssert(nil, @"how did we end up here?");
            break;
            
    }
    
    // create and initialize a Label
    CCLabelTTF *label = [CCLabelTTF labelWithString:buttonText fontName:@"Marker Felt" fontSize:20];
    label.position = ccp(0, 0);
    label.anchorPoint = ccp(0,0);
    self.contentSize = CGSizeMake(50, 50);
    
    // add the label as a child to this Layer
    [self addChild: label];
}

@end
