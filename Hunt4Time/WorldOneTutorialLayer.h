//
//  HelloWorldLayer.h
//  Hunt4Time
//
//  Created by David on 2013-04-23.
//  Copyright David 2013. All rights reserved.
//

#import "SneakyButtonSkinnedBase.h"
#import "SneakyButton.h"
#import <GameKit/GameKit.h>
#import "HUDLayer.h"
#import "SneakyJoystickSkinnedBase.h"
#import "SneakyJoystick.h"
//#import "Mushroom.h"

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"




//Säger att det finns en class som heter Player
@class Player;

@interface WorldOneTutorialLayer : CCLayerColor
{
    //Adam
    HUDLayer *hud;
   // @property (nonatomic,retain) HUDLayer *hud;
    
    // David
    CGPoint _playerPos;
    
    //Adam 2013-05-13
     SneakyButton *shootButton;
    
    //David 2013-05-13
    SneakyJoystick *leftJoystick;
    
    
    
    //Nytt skräp!
    ////////////////////////////////////////////////
    CGPoint oneTouchStart; //Initial position of single touch
	CGPoint twoTouchStart; //Initial mid-point of double touch
	CGFloat initialDistance; //Initial distance between double touch
    ////////////////////////////////////////////////
    
    
    
}




//Adam 2013-05-10 Till min collision
@property (strong) NSMutableArray *enemies;
@property (strong) NSMutableArray *projectiles;



//Adam
@property (nonatomic,retain) HUDLayer *hud;
@property (assign) int mode;


@property (nonatomic,strong)Player *player;
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

//////////////////////////////////////////////
//////////////////////////////////////////////
@property (nonatomic, strong) CCSprite *sword;
//////////////////////////////////////////////
//////////////////////////////////////////////



//Nytt skräp!
////////////////////////////////////////////////
-(float)minScale;
-(CGPoint)adjustZoomPosition:(CGPoint)fromPoint anchoredOn:(CGPoint)anchorPoint fromZoom:(float)fromZoom toZoom:(float)toZoom; 
-(CGPoint)adjustPositionInbounds:(CGPoint)currentPoint;
-(void)initDragZoomValues:(NSSet *)allTouches;
-(void)dragLayer:(UITouch *)dragTouch;
-(void)doubleDragZoomLayer:(NSSet *)allTouches;
////////////////////////////////////////////////

-(void)swordAnimation;


// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;






@end









