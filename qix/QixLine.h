//
//  QixLine.h
//  qix
//
//  Created by Patrick Huesler on 07.01.13.
//
//

#import <Foundation/Foundation.h>

@interface QixLine : NSObject

@property (nonatomic) CGPoint start;
@property (nonatomic) CGPoint end;

-(id) initWithStart:(CGPoint)start end:(CGPoint)end;
-(NSArray *) pointsInLine;

@end
