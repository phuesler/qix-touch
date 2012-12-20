//
//  BoardLayer.m
//  qix
//
//  Created by Patrick Huesler on 20.12.12.
//
//

#import "BoardLayer.h"
#define THRESHOLD 15.0;

@implementation BoardLayer


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

-(void)draw
{
    [super draw];
    if (self.pressed) {
        ccDrawLine(self.start, self.end);
    }
    ccDrawRect(ccp(0,0), ccp(self.contentSize.width, self.contentSize.height));
}


-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
    
       
    if(CGRectContainsPoint([self boundingBox], location))
    {
        CCLOG(@"touch began");
        CGPoint correctedLocation = [self absoluteToRelativeLocation:location];
        self.start = correctedLocation;
        self.end = correctedLocation;
        self.pressed = YES;
        return YES;
    }
    else
    {
        return NO;
    }
}


-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    if(CGRectContainsPoint([self boundingBox], location))
    {
//        CCLOG(@"touch moved : %f", ccpAngle(self.start, self.end));
        float threshold = THRESHOLD;
        float dY = abs(self.end.y - self.start.y);
        float dX = abs(self.end.x - self.start.x);
        if(dX <= threshold && self.start.y < self.end.y)
        {
            CCLOG(@"going up");
        }
        else if(dX <= threshold && self.start.y > self.end.y)
        {
            CCLOG(@"going down");
        }
        else if(dY <= threshold && self.start.x < self.end.x)
        {
            CCLOG(@"moving right");
        }
        else if(dY <= threshold && self.start.x > self.end.x)
        {
            CCLOG(@"moving left");
        }
        else
        {
            CCLOG(@"Need to adjust the delta");
        }

        self.end = [self absoluteToRelativeLocation:location];


    }
    else
    {
        self.pressed = NO;
    }
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    CCLOG(@"touch moved");
	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
    if(CGRectContainsPoint([self boundingBox], location))
    {
        CCLOG(@"touch ended");
        self.pressed = false;
    }
}


-(CGPoint)absoluteToRelativeLocation:(CGPoint) location
{
    return ccp(location.x - self.position.x, location.y - self.position.y);
}

@end
