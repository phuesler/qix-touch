//
//  BoardLayer.m
//  qix
//
//  Created by Patrick Huesler on 20.12.12.
//
//

#import "BoardLayer.h"
#define THRESHOLD 20.0;
#define BOARD_PADDING 50.0

@implementation BoardLayer

-(id)init
{
    if(self = [super initWithColor:ccc4(230, 42, 42, 255)])
    {
        self.lines = [[NSMutableArray alloc] initWithCapacity:20];
        self.linesBeingDrawn = [[NSMutableArray alloc] initWithCapacity:20];
        self.currentDirection = kUp;
        self.border = CGRectMake(BOARD_PADDING, BOARD_PADDING, self.contentSize.width - BOARD_PADDING, self.contentSize.height - BOARD_PADDING);
        self.pixels = [[NSMutableArray alloc] initWithCapacity:1000];
        
        
        //build grid array, not sure if I am even going to need this
        for(int i = 0; i < self.border.size.width;i++)
        {
            NSMutableArray *columns = [[NSMutableArray alloc] initWithCapacity:750];
            for(int j =0; j < self.border.size.height;j++)
            {
                [columns addObject:@(0)];
            }
            [self.pixels addObject: columns];
        }
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
//    [self drawTestGrid];
    ccDrawRect(ccp(BOARD_PADDING,BOARD_PADDING), ccp(self.contentSize.width - BOARD_PADDING, self.contentSize.height - BOARD_PADDING));
    if (self.pressed) {
        ccDrawLine(self.start, self.end);
    }
    [self drawLines:self.lines];
    [self drawLines:self.linesBeingDrawn];
}


-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
     CGPoint correctedLocation = [self absoluteToRelativeLocation:location];
       
    if(CGRectContainsPoint([self boundingBox], location) && [self isValidStartPoint:correctedLocation])
    {
        CCLOG(@"touch began");
        self.start = correctedLocation;
        self.end = correctedLocation;
        self.uncorrectedEnd = correctedLocation;
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
        if([self isHittingNewLines])
        {
            [self resetGame];
            return ;
        }
        
        if([self isHittingExistingLines])
        {
            //add last line
            QixLine line = {.start = self.start, .end = self.end};
            NSValue *value = [NSValue value:&line withObjCType:@encode(QixLine)];
            [self.linesBeingDrawn addObject: value];
            
            for(int i = 0; i < [self.linesBeingDrawn count];i++)
            {
                [self addLine: [self.linesBeingDrawn objectAtIndex:i]];
            }
            [self.linesBeingDrawn removeAllObjects];
            self.pressed = NO;
            // flood fill
            // draw rectangles
            // clear current lines
        }
        
        float threshold = THRESHOLD;
        float dY = abs(self.uncorrectedEnd.y - self.start.y);
        float dX = abs(self.uncorrectedEnd.x - self.start.x);
        QixNavigationDirection newDirection;
        if(dX <= threshold && self.start.y < self.end.y)
        {
            newDirection = kUp;
            self.end = [self correctedLocation:location forDirection:newDirection];
            CCLOG(@"going up");
        }
        else if(dX <= threshold && self.start.y > self.end.y)
        {
            newDirection = kDown;
            self.end = [self correctedLocation:location forDirection:newDirection];
            CCLOG(@"going down");
        }
        else if(dY <= threshold && self.start.x < self.end.x)
        {
            newDirection = kRight;
            self.end = [self correctedLocation:location forDirection:newDirection];
            CCLOG(@"moving right");
        }
        else if(dY <= threshold && self.start.x > self.end.x)
        {
            newDirection = kLeft;
            self.end = [self correctedLocation:location forDirection:newDirection];
            CCLOG(@"moving left");
        }
        else
        {
            NSLog(@"out of threshold bounds");
            CGPoint correctionPoint = [self newEndPoint];
            self.end = correctionPoint;
            QixLine line = {.start = self.start, .end = self.end};
            NSValue *value = [NSValue value:&line withObjCType:@encode(QixLine)];
            [self.linesBeingDrawn addObject: value];
            self.start = correctionPoint;
            
            newDirection = self.currentDirection;
            self.end = [self absoluteToRelativeLocation:location];
        }
        
        self.currentDirection = newDirection;
        self.uncorrectedEnd = [self absoluteToRelativeLocation:location];
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

-(CGPoint)correctedLocation:(CGPoint)location forDirection:(QixNavigationDirection)direction
{
    CGPoint relativePosition = [self absoluteToRelativeLocation:location];
    float correctedX = relativePosition.x;
    float correctedY = relativePosition.y;
    switch (direction) {
        case kUp:
        case kDown:
            correctedX = self.start.x;
            break;
        case kLeft:
        case kRight:
            correctedY = self.start.y;
            break;
        default:
            break;
    }
    return ccp(correctedX, correctedY);
    
}

-(BOOL)isValidStartPoint:(CGPoint) location
{
    return !CGRectContainsPoint(self.border, location);
}

-(void)drawLines:(NSArray *) lines
{
    for(int i = 0; i < [lines count];i++)
    {
        QixLine line;
        NSValue *currentValue = [lines objectAtIndex:i];
        [currentValue getValue:&line];
        ccDrawColor4B(255, 255, 255, 255);
        ccDrawLine(line.start, line.end);
    }
    
}

-(void)drawTestGrid
{
    for(int i = 0; i < 20;i++)
    {
        for(int j =0; j < 20;j++)
        {
            int boxSize = 20;
            int x = j * boxSize + BOARD_PADDING;
            int y = i * boxSize + BOARD_PADDING;
            ccDrawSolidRect(ccp(x,y), ccp(x + boxSize, y + boxSize), ccc4f(0, 0, 0, 255));
        }
    }
}

-(BOOL) isHittingExistingLines
{
    if(self.end.x == self.border.origin.x || self.end.x == self.border.origin.x + self.border.size.width || self.end.y == self.border.origin.y || self.end.y == self.border.origin.y + self.border.size.height)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(BOOL) isHittingNewLines
{
    return NO;
}

-(void) resetGame
{
    [self.lines removeAllObjects];
    [self.linesBeingDrawn removeAllObjects];
}

-(void) addLine:(NSValue *) lineValue
{
    QixLine line;
    [lineValue getValue:&line];
    if(line.start.x == line.end.x && line.start.y < line.end.y)
    {
        //up
        for(int i=line.start.y;i <= line.end.y;i++)
        {
            [[self.pixels objectAtIndex:line.start.x] replaceObjectAtIndex:i withObject:@(2)];
        }
    }
    else if (line.start.x == line.end.x && line.start.y > line.start.y)
    {
        //down
        for(int i=line.start.y;i >= line.end.y;i--)
        {
            [[self.pixels objectAtIndex:line.start.x] replaceObjectAtIndex:i withObject:@(2)];
        }
    }
    else if(line.start.y == line.end.y && line.start.x < line.end.x)
    {
        //right
        for(int i=line.start.x;i <= line.end.x;i++)
        {
            [[self.pixels objectAtIndex:i] replaceObjectAtIndex:line.start.y withObject:@(2)];
        }
        
    }
    else if(line.start.y == line.end.y && line.start.x > line.end.x)
    {
        //left
        for(int i=line.start.x;i >= line.end.x;i--)
        {
            [[self.pixels objectAtIndex:i] replaceObjectAtIndex:line.start.y withObject:@(2)];
        }
    }
    [self.lines addObject: lineValue];
}


@end
