//
//  BoardLayer.m
//  qix
//
//  Created by Patrick Huesler on 20.12.12.
//
//

#import "BoardLayer.h"
#define THRESHOLD 2.0;

@implementation BoardLayer

-(id)init
{
    if(self = [super initWithColor:ccc4(230, 42, 42, 255)])
    {
        self.lines = [[NSMutableArray alloc] initWithCapacity:20];
        self.currentDirection = kUp;
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

-(void)draw
{
    [super draw];
    if (self.pressed) {
        ccDrawLine(self.start, self.end);
    }
    for(int i = 0; i < [self.lines count];i++)
    {
        QixLine line;
        NSValue *currentValue = [self.lines objectAtIndex:i];
        [currentValue getValue:&line];
        ccDrawColor4B(255, 255, 255, 255);
        ccDrawLine(line.start, line.end);
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
        float threshold = THRESHOLD;
        float dY = abs(self.end.y - self.start.y);
        float dX = abs(self.end.x - self.start.x);
        QixNavigationDirection newDirection;
        if(dX <= threshold && self.start.y < self.end.y)
        {
            newDirection = kUp;
            CCLOG(@"going up");
        }
        else if(dX <= threshold && self.start.y > self.end.y)
        {
            newDirection = kDown;
            CCLOG(@"going down");
        }
        else if(dY <= threshold && self.start.x < self.end.x)
        {
            newDirection = kRight;
            CCLOG(@"moving right");
        }
        else if(dY <= threshold && self.start.x > self.end.x)
        {
            newDirection = kLeft;
            CCLOG(@"moving left");
        }
        else
        {
            NSLog(@"out of threshold bounds");
            CGPoint correctionPoint = [self newEndPoint];
            self.end = correctionPoint;
            QixLine line = {.start = self.start, .end = self.end};
            NSValue *value = [NSValue value:&line withObjCType:@encode(QixLine)];
            [self.lines addObject: value];
            self.start = correctionPoint;
            
            newDirection = self.currentDirection;
        }
        
        self.currentDirection = newDirection;
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

-(CGPoint)newEndPoint
{
    switch (self.currentDirection) {
        case kUp:
        case kDown:
            return CGPointMake(self.start.x, self.end.y);
        case kLeft:
        case kRight:
            return CGPointMake(self.end.x, self.start.y);
        default:
            return self.end;
    }
}


-(CGPoint)absoluteToRelativeLocation:(CGPoint) location
{
    return ccp(location.x - self.position.x, location.y - self.position.y);
}

@end
