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
		
        self.lines = [[NSMutableArray alloc] initWithCapacity:10];
		self.currentPosX = 200;
        self.currentPosY = 200;
        self.leftButton =  [[NavigationButton alloc] initWithDirection:kLeft position:CGPointMake(50, 60) delegate:self];
        self.rightButton = [[NavigationButton alloc] initWithDirection:kRight position:CGPointMake(200, 60) delegate:self];
        self.upButton = [[NavigationButton alloc] initWithDirection:kUp position:CGPointMake(125, 125) delegate:self];
        self.downButton = [[NavigationButton alloc] initWithDirection:kDown position:CGPointMake(125, 5) delegate:self];
        
        [self addChild: self.leftButton];
        [self addChild: self.rightButton];
        [self addChild: self.upButton];
        [self addChild: self.downButton];

	}
	return self;
}

-(void)navigationButtonPressed:(NavigationDirection) direction
{
    self.startPoint = CGPointMake(self.currentPosX, self.currentPosY);
    self.endPoint = CGPointMake(self.currentPosX, self.currentPosY);
}

-(void)navigationButtonReleased:(NavigationDirection) direction
{
    //finish drawing here
    self.endPoint = CGPointMake(self.currentPosX, self.currentPosY);
    QixLine line = {.start = self.startPoint, .end = self.endPoint};
    NSValue *value = [NSValue value:&line withObjCType:@encode(QixLine)];
    [self.lines addObject: value];
}

// You have to over-ride this method
-(void)draw
{
    if(self.upButton.pressed || self.downButton.pressed || self.leftButton.pressed || self.rightButton.pressed)
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
        ccDrawLine(self.startPoint, CGPointMake(self.currentPosX, self.currentPosY));
    }
    
    for(int i = 0; i < [self.lines count];i++)
    {
        QixLine line;
        NSValue *currentValue = [self.lines objectAtIndex:i];
        [currentValue getValue:&line];
        ccDrawLine(line.start, line.end);
    }
    
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
}
@end
