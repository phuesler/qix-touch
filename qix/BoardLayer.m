//
//  BoardLayer.m
//  qix
//
//  Created by Patrick Huesler on 20.12.12.
//
//

#import "BoardLayer.h"
#import "QixLine.h"
#define THRESHOLD 20.0
#define BOARD_PADDING 50
#define TILE_SIZE 10
#define TILE_EMPTY 0
#define TILE_LINE 1
#define TILE_FILL 2
#define TILE_OUTSIDE 3
#define BOARD_WIDTH 800
#define BOARD_HEIGHT 600
#define WIDTH 900
#define HEIGHT 700

@implementation BoardLayer

-(id)init
{
    if(self = [super initWithColor:ccc4(230, 42, 42, 255)])
    {
        self.lines = [[NSMutableArray alloc] initWithCapacity:20];
        self.linesBeingDrawn = [[NSMutableArray alloc] initWithCapacity:20];
        self.currentDirection = kUp;
        self.contentSize = CGSizeMake(WIDTH, HEIGHT);
        self.border = CGRectMake(BOARD_PADDING, BOARD_PADDING, BOARD_WIDTH - BOARD_PADDING, BOARD_HEIGHT - BOARD_PADDING);
        
        self.pixels = [[NSMutableArray alloc] initWithCapacity:BOARD_WIDTH];
        
        
        //build pixel array, not sure if I am even going to need this
        for(int i = 0; i <= BOARD_PADDING + BOARD_WIDTH;i++)
        {
            NSMutableArray *columns = [[NSMutableArray alloc] initWithCapacity:BOARD_HEIGHT];
            for(int j = 0; j <= BOARD_PADDING + BOARD_HEIGHT;j++)
            {
                if(i < BOARD_PADDING || i > BOARD_PADDING + BOARD_WIDTH)
                {
                    [columns addObject: @(TILE_OUTSIDE)];
                }
                else
                {
                    [columns addObject: @(TILE_EMPTY)];
                }
            
            }
            [self.pixels addObject:columns];
        }
        
        
        self.tilesGrid = [NSMutableArray array];
        for (int i = 0; i <= (BOARD_WIDTH)/TILE_SIZE ;  i++){
            
            NSMutableArray *subGrid = [NSMutableArray array];
            
            for (int j = 0; j <= (BOARD_HEIGHT)/TILE_SIZE; j++){
                
                [subGrid addObject:@(TILE_EMPTY)];
                
            }
            [self.tilesGrid addObject:subGrid];
        }
        
        
        CGPoint lowerLeft = ccp(BOARD_PADDING, BOARD_PADDING);
        CGPoint lowerRight = ccp(lowerLeft.x + BOARD_WIDTH, lowerLeft.y);
        CGPoint upperRight = ccp(lowerRight.x, lowerRight.y + BOARD_HEIGHT);
        CGPoint upperLeft = ccp(lowerLeft.x, upperRight.y);
        
        [self addLine: [[QixLine alloc] initWithStart:lowerLeft end: lowerRight]];
        [self addLine: [[QixLine alloc] initWithStart:lowerRight end: upperRight]];
        [self addLine: [[QixLine alloc] initWithStart:upperRight end: upperLeft]];
        [self addLine: [[QixLine alloc] initWithStart:upperLeft end: lowerLeft]];

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
            QixLine *line = [[QixLine alloc] initWithStart:self.start end:self.end];
            [self.linesBeingDrawn addObject: line];
            
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
            QixLine *line = [[QixLine alloc] initWithStart:self.start end:self.end];
            [self.linesBeingDrawn addObject: line];
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
        if([self isHittingExistingLines])
        {
            CCLOG(@"touch ended");
            self.pressed = false;
        }
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
        QixLine *line = [lines objectAtIndex:i];
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
    CCLOG(@"%i",[[[self.pixels objectAtIndex:self.end.x] objectAtIndex:self.end.y] integerValue] );
    if([[[self.pixels objectAtIndex:self.end.x] objectAtIndex:self.end.y] integerValue] > 0)
        return YES;
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

-(void) addLine:(QixLine *) line
{
    NSArray * points = [line pointsInLine];
    for(int i = 0;i < [points count];i++)
    {
        CGPoint point;
        NSValue *pointValue = [points objectAtIndex:i];
        [pointValue getValue:&point];
        [[self.pixels objectAtIndex:point.x] replaceObjectAtIndex:point.y withObject:@(2)];
    }
    [self.lines addObject: line];
}


@end
