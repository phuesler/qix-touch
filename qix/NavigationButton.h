//
//  NavigationButton.h
//  qix
//
//  Created by Patrick Huesler on 19.12.12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {
    kLeft,
    kRight,
    kUp,
    kDown
} NavigationDirection;

@interface NavigationButton : CCLayerColor

@property (atomic) NavigationDirection direction;
@property (atomic) BOOL pressed;

-(id) initWithDirection:(NavigationDirection) direction position:(CGPoint) position;
@end
