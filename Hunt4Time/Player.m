//
//  Player.m
//  Hunt4Time
//
//  Created by David on 2013-04-23.
//  Copyright 2013 David. All rights reserved.
//

#import "Player.h"

#import "WorldOneTutorialLayer.h"

@implementation Player


- (id)initWithLayer:(WorldOneTutorialLayer *)layer{
   
   
    NSString *spiritFrameName = [NSString stringWithFormat:@"nudeplayer_e_1.png"];
    if (self = [super initWithSpriteFrameName:spiritFrameName]) {
        
        _layer = layer;
        
        
        
        //priority -1 vill att denna update ska köras innan layers update
        [self scheduleUpdateWithPriority:-1];
    }
    return self;
    
}

// Hämtar mapLocation från WorldOneTutorialLayer och lägger som targetPosition
- (void)moveToward:(CGPoint)targetPosition {
    //Lägger in targetPosition i min _targetPosition
    _targetPosition = targetPosition;
}

- (void)updateMove:(ccTime)dt{
    
    //1 If moving is false, just bail. Moving will be false when the app first begins.
    if (!self.moving) return;
    
    
    // You need to figure out how far the player is moving along both the x and y axis. You can do this by simply subtracting the player’s position from the touch location(_targetPosition). There is a convenient helper function Cocos2D provides called ccpSub to do this.
    //2 Subtract the current position from the target position,(Maplocation touch to get a vector that points in the direction of where we’re going. (räknar ut skillnaden mellan två punkter)
    CGPoint offset = ccpSub(_targetPosition, self.position);
    
    //3 Check the length of that line, and see if it’s less than 10 points. If it is, we’re “close enough” and we just return.
    float MIN_OFFSET = 10;
    if (ccpLength(offset) < MIN_OFFSET) return;
    
    //4 Make the directional vector a unit vector (length of 1) by calling ccpNormalize. This makes it easy to make the line any length we want next.
    CGPoint targetVector = ccpNormalize(offset);
    
    //5 Multiply the vector by however fast we want the player to travel in a second (150 here). The result is a vector in points/1 second the tank should travel.
    float POINTS_PER_SECOND = 100;
    CGPoint targetPerSecond = ccpMult(targetVector, POINTS_PER_SECOND);
    
    //6 This method is being called several times a second, so we multiply this vector by the delta time (around 1/60 of a second) to figure out how much we should actually travel.
    CGPoint actualTarget = ccpAdd(self.position, ccpMult(targetPerSecond, dt));
    
    //7 Set the position of the tank to what we figured out. We also keep track of the old position in a local variable, which we’ll use soon.
    CGPoint oldPosition = self.position;
    self.position = actualTarget;
    
    
}

- (void)update:(ccTime)dt{
    [self updateMove:dt];
}



@end
