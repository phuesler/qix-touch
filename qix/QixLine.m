//
//  QixLine.m
//  qix
//
//  Created by Patrick Huesler on 07.01.13.
//
//

#import "QixLine.h"

@implementation QixLine

@synthesize start, end;

-(id) initWithStart:(CGPoint)startPoint end:(CGPoint)endPoint
{
    self = [super init];
    if(self)
    {
        self.start = startPoint;
        self.end = endPoint;
    }
    return self;
}

-(NSArray *) pointsInLine
{
    NSMutableArray * points = [NSMutableArray array];
    if (self.start.x < self.end.x)
    {
        //left to right
        for(int x = self.start.x;x <= self.end.x;x++)
        {
            [points addObject:[NSValue valueWithCGPoint:CGPointMake(x, self.start.y)]];
        }
    }
    else if (self.start.x > self.end.x) {
        //right to left
        for(int x = self.start.x;x >= self.end.x;x--)
        {
            [points addObject:[NSValue valueWithCGPoint:CGPointMake(x, self.start.y)]];
        }
    }
    else if(self.start.y < self.end.y)
    {
        //up
        for(int y = self.start.y;y <= self.start.y;y++)
        {
            [points addObject:[NSValue valueWithCGPoint:CGPointMake(self.start.x, y)]];
        }
    }
    else if(self.start.y > self.end.y)
    {
        //down
        for(int y = self.start.y;y >= self.start.y;y--)
        {
            [points addObject:[NSValue valueWithCGPoint:CGPointMake(self.start.x, y)]];
        }
    }
    else if(self.start.x == self.end.x && self.start.y == self.end.y)
    {
        [points addObject:[NSValue valueWithCGPoint:CGPointMake(self.start.x, self.start.y)]];
    }
    else
    {
        NSAssert(NULL, @"lines should always be of directions: up, down, left, right");
    }
    
    return points;
}

@end
