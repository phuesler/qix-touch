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

@protocol NavigationButtonDelegate <NSObject>

@required
-(void)navigationButtonPressed:(NavigationDirection) direction;
-(void)navigationButtonReleased:(NavigationDirection) direction;

@end

@interface NavigationButton : CCLayerColor

@property (atomic) NavigationDirection direction;
@property (atomic) NavigationDirection pressed;
@property(nonatomic, unsafe_unretained) id <NavigationButtonDelegate> delegate;

-(id) initWithDirection:(NavigationDirection) direction position:(CGPoint) position delegate:(id) delegate;
@end
