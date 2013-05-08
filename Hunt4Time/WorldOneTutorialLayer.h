//
//  HelloWorldLayer.h
//  Hunt4Time
//
//  Created by David on 2013-04-23.
//  Copyright David 2013. All rights reserved.
//



#import <GameKit/GameKit.h>
#import "HUDLayer.h"

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"


//Säger att det finns en class som heter Player
@class Player;

@interface WorldOneTutorialLayer : CCLayerColor
{
    //Adam
    HUDLayer *hud;
    
    // David
    CGPoint _playerPos;
    
}

+(CCScene *) scene;

//Adam
@property (nonatomic,retain) HUDLayer *hud;



@property (nonatomic,strong) Player *player;
@property (nonatomic) float playerX;
@property (nonatomic) float playerY;

@property (nonatomic,strong) CCSpriteBatchNode *batchNode;
@property (nonatomic, strong) CCAction *walkAction;
@property (nonatomic, strong) CCAction *moveAction;

//Tilemap property
@property (nonatomic,strong) CCTMXTiledMap *tileMap;
@property (strong) CCTMXLayer *background;
@property (strong) CCTMXLayer *specialTile;
@property (strong) CCTMXLayer *mushroom;

////////

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;






@end
