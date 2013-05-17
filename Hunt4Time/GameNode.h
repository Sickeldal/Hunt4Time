//
//  GameNode.h
//  Hunt4Time
//
//  Created by admin on 5/15/13.
//  Copyright 2013 David. All rights reserved.
//
#import "AppDelegate.h"
#import <GameKit/GameKit.h>
#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface GameNode : CCNode {
    
    CGPoint _playerPos;
    
}


@property (nonatomic,strong) CCTMXTiledMap *tileMap;
@property (strong) CCTMXLayer *specialTile;

@end
