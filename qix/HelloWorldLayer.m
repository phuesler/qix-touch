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
#import "NavigationButton.h"

#pragma mark - HelloWorldLayer

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
		
		self.currentPosX = 200;
        self.currentPosY = 200;
        self.leftButton =  [[NavigationButton alloc] initWithDirection:kLeft position:CGPointMake(50, 60)];
        self.rightButton = [[NavigationButton alloc] initWithDirection:kRight position:CGPointMake(200, 60)];
        self.upButton = [[NavigationButton alloc] initWithDirection:kUp position:CGPointMake(125, 125)];
        self.downButton = [[NavigationButton alloc] initWithDirection:kDown position:CGPointMake(125, 5)];
        
        [self addChild: self.leftButton];
        [self addChild: self.rightButton];
        [self addChild: self.upButton];
        [self addChild: self.downButton];

	}
	return self;
}

// You have to over-ride this method
-(void)draw
{
    if(self.upButton.pressed)
    {
      self.currentPosY++;
    }
    if(self.downButton.pressed)
    {
        self.currentPosY--;
    }
    if(self.leftButton.pressed)
    {
        self.currentPosX--;
    }
    if(self.rightButton.pressed)
    {
        self.currentPosX++;
    }
    ccDrawLine( ccp(200, 200), ccp(self.currentPosX, self.currentPosY) );
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
}
@end
