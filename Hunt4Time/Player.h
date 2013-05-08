//
//  Player.h
//  Hunt4Time
//
//  Created by David on 2013-04-23.
//  Copyright 2013 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class WorldOneTutorialLayer;

@interface Player : CCSprite {
    
    WorldOneTutorialLayer *_layer;
    CGPoint _targetPosition;
    
}

@property (nonatomic, strong) CCAction *walkAction;
@property (nonatomic, weak) CCSpriteBatchNode *batchNode;
@property (nonatomic) BOOL moving;

- (id)initWithLayer:(WorldOneTutorialLayer *)layer; // type:(int)type hp:(int)hp;
- (void)moveToward:(CGPoint)targetPosition;

@end

