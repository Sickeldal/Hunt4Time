//
//  HelloWorldLayer.m
//  Hunt4Time
//
//  Created by David on 2013-04-23.
//  Copyright David 2013. All rights reserved.
//

// Import the interfaces
#import "WorldOneTutorialLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "Player.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation WorldOneTutorialLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.


    +(CCScene *) scene
{
    
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
       
    
 
       // 'layer' is an autorelease object.
	WorldOneTutorialLayer *layer = [WorldOneTutorialLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
    
    //Adam
    HUDLayer *anotherlayer = [HUDLayer node];
    [scene addChild: anotherlayer];
    layer.hud=anotherlayer;
    

    // return the scene
	return scene;
}

// Två metoder för att få ut storleken på min Tilemap(mapSize tar ut hur många tile mappen har)
// multiplicerar mapsize med map size för att få storleken i points
- (float)tileMapHeight{
    return self.tileMap.mapSize.height * self.tileMap.tileSize.height;
}
- (float)tileMapWidth{
    return self.tileMap.mapSize.width * self.tileMap.tileSize.width;
}
//////////////


// kollar om positionen är utanför eller i skärmen,
- (BOOL)isValidPosition:(CGPoint)position{
    if (position.x <0 || position.y <0 || position.x > [self tileMapWidth] || position.y > [self tileMapHeight]) {
        return NO;
        
    }else{
        return YES;
    }
}
// Kollar om TileCoordinaterna är utanför eller i skärmen
- (BOOL)isValidTileCoord:(CGPoint)tileCord{
    if (tileCord.x < 0  || tileCord.y <0 || tileCord.x >= self.tileMap.mapSize.width || tileCord.y >= self.tileMap.mapSize.height){
        return NO;
    }else{
        return YES;
    }
}

//Konventerar tilePosition(positionen man är på?) till en tile coordinat
- (CGPoint)tileCoordForPosition:(CGPoint)position{
    
    if (![self isValidPosition:position]) {
        return ccp(-1, -1);
    }
    
    int x = position.x / self.tileMap.tileSize.width;
    int y = ([self tileMapHeight] - position.y / self.tileMap.tileSize.height);
    
    return ccp(x, y);
}
//Konventerar tileCoordinat till tileposition, gör även så det retunerar center av en tile
- (CGPoint)positionForTileCoord:(CGPoint)tileCoord{
    
    int x = (tileCoord.x * self.tileMap.tileSize.width) + self.tileMap.tileSize.width/2;
    int y = [self tileMapHeight] - (tileCoord.y * self.tileMap.tileSize.height) - self.tileMap.tileSize.height/2;
    
    return ccp(x,y);
}

// on "init" you need to initialize your instance
-(id) init
{
if( (self=[super init])) {
                
        // Lägger in min TileMap
        self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"TileMapFirstLvL.tmx"];
        self.background = [self.tileMap layerNamed:@"Background"];
    
        self.mushroom = [_tileMap layerNamed:@"Mushroom"];
    
        self.specialTile = [_tileMap layerNamed:@"SpecialTiles"];
    
    //  Gör mitt specialTile lager Osynligt
        _specialTile.visible = NO;

    
        // behöver man z:-1?
        [self addChild:self.tileMap];
    
    CCTMXObjectGroup *objectGroup = [_tileMap objectGroupNamed:@"Objects"];
    NSAssert(objectGroup != nil, @"tile map has no objects object layer");

    //Adam
    NSDictionary *spawnPoint = [objectGroup objectNamed:@"SpawnPoint"];
    int x = [spawnPoint[@"x"] integerValue];
    int y = [spawnPoint[@"y"] integerValue];


    for (spawnPoint in [objectGroup objects]) {
        if ([[spawnPoint valueForKey:@"Enemy"] intValue] == 1){
            x = [[spawnPoint valueForKey:@"x"] intValue];
            y = [[spawnPoint valueForKey:@"y"] intValue];
            [self addEnemyAtX:x y:y];
        }
    }
    
        // Looks for an image with the same name as the passed-in property list, but ending with “.png” instead, and loads that file into the shared CCTextureCache (in our case, AnimPlayer.png).
        // Parses the property list file and keeps track of where all of the sprites are, using CCSpriteFrame objects internally to keep track of this information.
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"AnimPlayer-ipadhd.plist"];
    
    
        // create a CCSpriteBatchNode object passing in the image file containing all of the sprites, as you did here, and add that to your scene **.
        // Now, any time you create a sprite that comes from that sprite sheet, you should add the sprite as a child of the CCSpriteBatchNode. As long as the sprite comes from the sprite sheet it will work, otherwise you’ll get an error.
        //The CCSpriteBatchNode code has the smarts to look through its CCSprite children and draw them in a single OpenGL ES call rather than multiple calls, which again is much faster
		_batchNode = [CCSpriteBatchNode batchNodeWithFile:@"AnimPlayer-ipadhd.png"];
    
        // ** Lägger ut min _batchNode på skärmen
        [self.tileMap addChild:_batchNode];
    

        // To create the list of frames, you simply loop through your image’s names (they are named with a convention of Bear1.png -> Bear8.png)
        NSMutableArray *walkAnimFrames = [NSMutableArray array];
        for (int i=1; i<=8; i++) {
            [walkAnimFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"nudeplayer_e_%d.png",i]]];
        }
    
    
        
        //You create a CCAnimation by passing in the list of sprite frames, and specifying how fast the animation should play. You are using a 0.1 second delay between frames here.
        CCAnimation *walkAnim = [CCAnimation
                                 animationWithSpriteFrames:walkAnimFrames delay:0.1f];
        
        self.walkAction = [CCRepeatForever actionWithAction:
                           [CCAnimate actionWithAnimation:walkAnim]];

    
        
        self.player = [[Player alloc] initWithLayer:self];
    
        // sätter ut min gubbe på min tilemap
        [_batchNode addChild:self.player];
    
        //Sätter ut positionen på min gubbe! ( vi kanske ska ha en spawn point?)
        self.player.position = ccp(80, 75);
    
        self.touchEnabled = YES;

    
    
        [self scheduleUpdate];
    



	}
	return self;
}

-(void)loadmap{
    
    // Lägger in min TileMap
    self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"TileMapFirstLvL.tmx"];
    self.background = [self.tileMap layerNamed:@"Background"];
    
    self.mushroom = [_tileMap layerNamed:@"Mushroom"];
    
    self.specialTile = [_tileMap layerNamed:@"SpecialTiles"];
    
    //  Gör mitt specialTile lager Osynligt
    // _specialTile.visible = NO;
    
    
    // behöver man z:-1?
    [self addChild:self.tileMap];
    
}

/*
// After init
- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch * touch = [touches anyObject];
    CGPoint mapLocation = [_tileMap convertTouchToNodeSpace:touch];
    
    CGPoint playerPos = self.player.position;
    
    self.player.moving = YES;

    [self.player moveToward:mapLocation];

}
 */

#pragma mark - handle touches
-(void)registerWithTouchDispatcher
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self
                                                              priority:0
                                                       swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	return YES;
}

// Metoden för att collidera och plocka upp (setPlayerPosition)ska ha ett bättre namn. 
-(void)setPlayerPosition:(CGPoint)position {
	CGPoint tileCoord = [self tileCoordForPositions:position];
    int tileGid = [_specialTile tileGIDAt:tileCoord];
    if (tileGid) {
        NSDictionary *properties = [_tileMap propertiesForGID:tileGid];
        if (properties) {
            
            //För att få gubben att stanna vid våra väggar
            NSString *collision = properties[@"Collidable"];
            if (collision && [collision isEqualToString:@"True"]) {
              
                _playerX = self.player.position.x;
                _playerY = self.player.position.y;
                
                _playerPos = ccp(_playerX/2, _playerY);

                return [self.player pauseSchedulerAndActions];;
            }
            //För att kunna plocka upp Svampar
            NSString *collectible = properties[@"Collectable"];
            if (collectible && [collectible isEqualToString:@"True"]) {
                [_specialTile removeTileAt:tileCoord];
                [_mushroom removeTileAt:tileCoord];
                
                [self.hud addToScore:1];
            }
        }
    }
    
}



//Adam
-(void)addEnemyAtX:(int)x y:(int)y {
    CCSprite *enemy = [CCSprite spriteWithFile:@"minotaurus_red.png"];
    enemy.position = ccp(x, y);
    [self.tileMap addChild:enemy];
    
    // Use our animation method and
    // start the enemy moving toward the player
    //[self animateEnemy:enemy];
    
    //[self.enemies addObject:enemy];
}


-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    // Converting the touch point into local node coordinates using the usual method.
    CGPoint mapLocation = [self.tileMap convertTouchToNodeSpaceAR:touch];
    
    
    _playerPos = _player.position;
    
    /*
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    // /6.0 hur lång tid det ska ta för gubben att gå från ena änden till den andra
    float playerVelocity = screenSize.width / 6.0;
    
    //You need to figure out how far the bear is moving along both the x and y axis. You can do this by simply subtracting the bear’s position from the touch location. There is a convenient helper function Cocos2D provides called ccpSub to do this.
    CGPoint moveDifference = ccpSub(mapLocation, _playerPos);
    
    //You then need to calculate the distance that the bear actually moves along a straight line (the hypotenuse of the triangle). Cocos2D also has a helper function to figure this out based on the offset moved: ccpLength!
    float distanceToMove = ccpLength(moveDifference);
    
    //You need to calculate how long it should take the bear to move this length, so you simply divide the length moved by the velocity to get that.
    float moveDuration = distanceToMove / playerVelocity;
    
    //you stop any existing move action (because you’re about to override any existing command to tell the bear to go somewhere else!)
    [self.player stopAction:self.moveAction];
    
    //  Also, if you’re not moving, you stop any running animation action. If you are already moving, you want to let the animation continue so as to not interrupt its flow.
    if (!self.player.moving) {
        [self.player runAction:self.walkAction];
    }
    
    // Finally, you create the move action itself, specifying where to move, how long it should take, and having a callback to run when it’s done. You also record that we’re moving at this point by setting our instance variable bearMoving=YES.
    self.moveAction = [CCSequence actions:
                       [CCMoveTo actionWithDuration:moveDuration position:mapLocation],
                       [CCCallFunc actionWithTarget:self selector:@selector(playerMoveEnded)],
                       nil];
    
    
    self.player.moving = YES;
    
    //Sätter igång moveAction på min gubbe 
    //[self.player runAction:self.moveAction];
    */
    
    if (!self.player.moving) {
        [self.player runAction:self.walkAction];
    }
    

    self.player.moving = YES;
    
    //Skickar mapLocation till min moveToward i player"classen"
    [self.player moveToward:mapLocation];
    
    //Startar alla actions igen(pausar dem när man går in i en vägg)
    [self.player resumeSchedulerAndActions];
}

// Add new method För collisition
- (CGPoint)tileCoordForPositions:(CGPoint)position {
    int x = position.x / _tileMap.tileSize.width;
    int y = ((_tileMap.mapSize.height * _tileMap.tileSize.height) - position.y) / _tileMap.tileSize.height;
    return ccp(x, y);
}

//Adam 2013-05-10
// callback. starts another iteration of enemy movement.
- (void) enemyMoveFinished:(id)sender {
    CCSprite *enemy = (CCSprite *)sender;
    
    [self animateEnemy: enemy];
}

//Adam 2013-05-10
// a method to move the enemy 10 pixels toward the player
- (void) animateEnemy:(CCSprite*)enemy
{
    // speed of the enemy
    ccTime actualDuration = 0.3;
    
    // Create the actions
    id actionMove = [CCMoveBy actionWithDuration:actualDuration
                                        position:ccpMult(ccpNormalize(ccpSub(_player.position,enemy.position)), 10)];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self
                                             selector:@selector(enemyMoveFinished:)];
    [enemy runAction:
     [CCSequence actions:actionMove, actionMoveDone, nil]];
    
    //Adam 2013-05-10
    // immediately before creating the actions in animateEnemy
    // rotate to face the player
    CGPoint diff = ccpSub(_player.position,enemy.position);
    float angleRadians = atanf((float)diff.y / (float)diff.x);
    float angleDegrees = CC_RADIANS_TO_DEGREES(angleRadians);
    float cocosAngle = -1 * angleDegrees;
    if (diff.x < 0) {
        cocosAngle += 180;
    }
    enemy.rotation = cocosAngle;
}

// When the player stops
- (void)playerMoveEnded
{
    [self.player stopAction:self.walkAction];
    self.player.moving = NO;
    
}

// update every frame
- (void)update:(ccTime)dt{
    //
    [self setPlayerPosition:self.player.position];
    //Gubben blir centrerad av skärmen
    [self setViewpointCenter:self.player.position];
}

// Man flyttar tilemappen
- (void)setViewpointCenter:(CGPoint) position{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    int x = MAX(position.x, winSize.width / 2 / self.scale);
    int y = MAX(position.y, winSize.height /2 / self.scale);
    
    x = MIN(x, [self tileMapWidth] - winSize.width / 2 / self.scale);
    y = MIN(y, [self tileMapHeight] -winSize.height / 2 / self.scale);
    CGPoint actualPosition = ccp(x, y);
    
    CGPoint centerOfView = ccp(winSize.width/2, winSize.height/2);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    
    self.tileMap.position = viewPoint;
}

@end


