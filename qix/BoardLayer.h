//
//  BoardLayer.h
//  qix
//
//  Created by Patrick Huesler on 20.12.12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface BoardLayer : CCLayerColor

@property (atomic) CGPoint start;
@property (atomic) CGPoint end;
@property (atomic) BOOL pressed;

@end
