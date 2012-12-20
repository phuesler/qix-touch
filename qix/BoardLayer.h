//
//  BoardLayer.h
//  qix
//
//  Created by Patrick Huesler on 20.12.12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum { kLeft, kRight, kUp, kDown} QixNavigationDirection;
typedef struct {CGPoint start; CGPoint end;} QixLine;

@interface BoardLayer : CCLayerColor

@property (atomic) CGPoint start;
@property (atomic) CGPoint end;
@property (atomic) QixNavigationDirection currentDirection;
@property (atomic) BOOL pressed;
@property (atomic, strong) NSMutableArray * lines;

@end
