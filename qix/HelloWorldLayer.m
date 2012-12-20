//
//  HelloWorldLayer.m
//  qix
//
//  Created by Patrick Huesler on 18.12.12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "cocos2d.h"
#import "BoardLayer.h"

#pragma mark - HelloWorldLayer

#define BOARD_X 300
#define BOARD_Y 10
#define BOARD_WIDTH 700
#define BOARD_HEIGHT 700

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		
        BoardLayer * boardLayer = [[BoardLayer alloc] initWithColor:ccc4(230, 42, 42, 255)];
        boardLayer.anchorPoint = ccp(0,0);
        boardLayer.position = ccp(10,10);
        boardLayer.contentSize = CGSizeMake(1000, 750);
        boardLayer.isTouchEnabled = YES;
        
        [self addChild: boardLayer];

	}
	return self;
}

//-(void)navigationButtonPressed:(NavigationDirection) direction
//{
//    self.startPoint = CGPointMake(self.currentPosX, self.currentPosY);
//    self.endPoint = CGPointMake(self.currentPosX, self.currentPosY);
//}
//
//-(void)navigationButtonReleased:(NavigationDirection) direction
//{
//    //finish drawing here
//    self.endPoint = CGPointMake(self.currentPosX, self.currentPosY);
//    QixLine line = {.start = self.startPoint, .end = self.endPoint};
//    NSValue *value = [NSValue value:&line withObjCType:@encode(QixLine)];
//    [self.lines addObject: value];
//}

// You have to over-ride this method
//-(void)draw
//{
//    if(self.upButton.pressed || self.downButton.pressed || self.leftButton.pressed || self.rightButton.pressed)
//    {
//        if(self.upButton.pressed)
//        {
//            self.currentPosY++;
//        }
//        if(self.downButton.pressed)
//        {
//            self.currentPosY--;
//        }
//        if(self.leftButton.pressed)
//        {
//            self.currentPosX--;
//        }
//        if(self.rightButton.pressed)
//        {
//            self.currentPosX++;
//        }
//        ccDrawColor4B(255, 255, 255, 255);
//        ccDrawLine(self.startPoint, CGPointMake(self.currentPosX, self.currentPosY));
//    }
//    
//    for(int i = 0; i < [self.lines count];i++)
//    {
//        QixLine line;
//        NSValue *currentValue = [self.lines objectAtIndex:i];
//        [currentValue getValue:&line];
//        ccDrawColor4B(255, 255, 255, 255);
//        ccDrawLine(line.start, line.end);
//    }
//    ccDrawColor4B(230, 42, 42, 255);
//    ccDrawRect(CGPointMake(BOARD_X, BOARD_Y), CGPointMake(BOARD_X + BOARD_WIDTH, BOARD_Y + BOARD_HEIGHT));
//    
//}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
}
@end
