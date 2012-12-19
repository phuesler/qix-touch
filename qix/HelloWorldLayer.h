//
//  HelloWorldLayer.h
//  qix
//
//  Created by Patrick Huesler on 18.12.12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "NavigationButton.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
}

@property (atomic) NSUInteger currentPosY;
@property (atomic) NSUInteger currentPosX;
@property (atomic, strong) NavigationButton * leftButton;
@property (atomic, strong) NavigationButton * rightButton;
@property (atomic, strong) NavigationButton * downButton;
@property (atomic, strong) NavigationButton * upButton;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
