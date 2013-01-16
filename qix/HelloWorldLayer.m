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
        BoardLayer * boardLayer = [[BoardLayer alloc] init];
        boardLayer.anchorPoint = ccp(0,0);
        boardLayer.position = ccp(10,10);
        boardLayer.isTouchEnabled = YES;
        
        [self addChild: boardLayer];
        

	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
}
@end
