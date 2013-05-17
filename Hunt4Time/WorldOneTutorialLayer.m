//
//  HelloWorldLayer.m
//  Hunt4Time
//
//  Created by David on 2013-04-23.
//  Copyright David 2013. All rights reserved.
//

/////////////////////////
//chipmunk spacemanager//
/////////////////////////



// Import the interfaces
#import "WorldOneTutorialLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "Player.h"
#pragma mark - HelloWorldLayer



// HelloWorldLayer implementation
@implementation WorldOneTutorialLayer{
    
    //Mushroom *mushroom;
    
}

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
    
    
    
    
    
    
    
    
    
    //Adam 2013-05-13
    //[[[CCDirector sharedDirector] openGLView] setMultipleTouchEnabled:YES]; //ny
    
    //Adam 2013-05-10 Innehåller min colission
    // you need to put these initializations before you add the enemies,
    // because addEnemyAtX:y: uses these arrays.
    self.enemies = [[NSMutableArray alloc] init];
    self.projectiles = [[NSMutableArray alloc] init];
    
    
    
    
    
    [self schedule:@selector(testCollisions:)];
    
    //Adam 2013-05-10
    //_mode = 0;
    
    
    // Lägger in min TileMap
    self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"TileMapFirstLvL.tmx"];
    self.background = [self.tileMap layerNamed:@"Background"];// Inside the init method, after setting self.background
   
    self.mushroom = [_tileMap layerNamed:@"Mushroom"];
    self.specialTile = [_tileMap layerNamed:@"SpecialTiles"];
    

    //_mushroom = [_mushroom node];
    //[mushroom initMushi];
    
    
    self.player = [[Player alloc] initWithLayer:self];
    
    
    CCTMXObjectGroup *objectGroup = [_tileMap objectGroupNamed:@"Objects"];
    NSAssert(objectGroup != nil, @"tile map has no objects object layer");
    
    NSDictionary *spawnPoint = [objectGroup objectNamed:@"SpawnPoint"];
    int x = [spawnPoint[@"x"] integerValue];
    int y = [spawnPoint[@"y"] integerValue];
    
   // _player = [CCSprite spriteWithFile:@"GreenMan.png"];
     [self playerAnim];
    _player.position = ccp(x,y);
    
   // [self.tileMap addChild:_player];
    
 
    
    

    //  Gör mitt specialTile lager Osynligt
    //_specialTile.visible = NO;
    
    
    // behöver man z:-1?
    [self addChild:self.tileMap];
    
    
    
    //Adam 2013-05-08
    for (spawnPoint in [objectGroup objects]) {
        if ([[spawnPoint valueForKey:@"Enemy"] intValue] == 1){
            x = [[spawnPoint valueForKey:@"x"] intValue];
            y = [[spawnPoint valueForKey:@"y"] intValue];
            [self addEnemyAtX:x y:y];
        
            
      
        }
        
    }
    
    
    
        
        
        
    
        
        //Sätter ut positionen på min gubbe! ( vi kanske ska ha en spawn point?)
        //self.player.position = ccp(80, 90);
    
        //self.touchEnabled = YES;

    [self initShootButton];
    [self addJoystick];
    [self scheduleUpdate];
    //[self playerAnim];
    //[self swordAnimation];
   
    
    
    
        


	}
	return self;
}



-(void)playerAnim{
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"player.plist"];
    
    CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"player.png"];
    [self addChild:spriteSheet];
    
    NSMutableArray *walkAnimFrames = [NSMutableArray array];
    for (int i=1; i<=8; i++) {
        [walkAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"eastgoing%d.png",i]]];
    }
    
    CCAnimation *walkAnim = [CCAnimation
                             animationWithSpriteFrames:walkAnimFrames delay:0.1f];
    
    self.player = [CCSprite spriteWithSpriteFrameName:@"eastgoing1.png"];
    //self.player.position = ccp(100, 100);
    self.walkAction = [CCRepeatForever actionWithAction:
                       [CCAnimate actionWithAnimation:walkAnim]];
    [self.player runAction:self.walkAction];
    //Måste vara self.tileMap för att allt ska blir rätt!
    [self.tileMap addChild:self.player];
    

    
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

                return [self.player pauseSchedulerAndActions];
                
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


//Adam 2013-05-08
-(void)addEnemyAtX:(int)x y:(int)y {
    CCSprite *enemy = [CCSprite spriteWithFile:@"CrabbEnemie.png"];
    enemy.position = ccp(x, y);
    [self.tileMap addChild:enemy];
   
    //Adam 2013-05-10
    // Use our animation method and
    // start the enemy moving toward the player
    [self animateEnemy:enemy];
    
    
    //Adam 2013-05-10 Innehåller min colission
    [self.enemies addObject:enemy];
    
 
    
    
}

-(void)addPlayerAtX:(int)x y:(int)y {
    CCSprite *player = [CCSprite spriteWithFile:@"CrabbEnemie.png"];
    player.position = ccp(x, y);
    [self.tileMap addChild:player];
    
    //Adam 2013-05-10
    // Use our animation method and
    // start the enemy moving toward the player
    [self animateEnemy:player];
    
    
    //Adam 2013-05-10 Innehåller min colission
    [self.enemies addObject:player];
    
    
    
    
}




-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    
    //Adam 2013-05-10
    if (_mode == 0) {
        // old contents of ccTouchEnded:withEvent:
    } else {
        // code to throw ninja stars will go here
        // Find where the touch is
        CGPoint touchLocation = [touch locationInView: [touch view]];
        touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
        touchLocation = [self convertToNodeSpace:touchLocation];
        
        // Create a projectile and put it at the player's location
        CCSprite *projectile = [CCSprite spriteWithFile:@"Projectile.png"];
        projectile.position = _player.position;
        
        //Ändra tillbaka ditt vildsvin
        [self.tileMap addChild:projectile];
         
        
        // Determine where we wish to shoot the projectile to
        int realX;
        
        // Are we shooting to the left or right?
        CGPoint diff = ccpSub(touchLocation, _player.position);
        if (diff.x > 0)
        {
            realX = (_tileMap.mapSize.width * _tileMap.tileSize.width) +
            (projectile.contentSize.width/2);
        } else {
            realX = -(_tileMap.mapSize.width * _tileMap.tileSize.width) -
            (projectile.contentSize.width/2);
             
        }
        float ratio = (float) diff.y / (float) diff.x;
        int realY = ((realX - projectile.position.x) * ratio) + projectile.position.y;
        CGPoint realDest = ccp(realX, realY);
        
        // Determine the length of how far we're shooting
        int offRealX = realX - projectile.position.x;
        int offRealY = realY - projectile.position.y;
        float length = sqrtf((offRealX*offRealX) + (offRealY*offRealY));
        float velocity = 480/1; // 480pixels/1sec
        float realMoveDuration = length/velocity;
        
        // Move projectile to actual endpoint
        id actionMoveDone = [CCCallFuncN actionWithTarget:self
                                                 selector:@selector(projectileMoveFinished:)];
        [projectile runAction:
         [CCSequence actionOne:
          [CCMoveTo actionWithDuration: realMoveDuration
                              position: realDest]
                           two: actionMoveDone]];
        
        
        //Adam 2013-05-10 Innehåller min colission
        [self.projectiles addObject:projectile];
    }
 
 

    
    // Converting the touch point into local node coordinates using the usual method.
    CGPoint mapLocation = [self.tileMap convertTouchToNodeSpaceAR:touch];
    
    
    _playerPos = _player.position;
    
    
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
    //
    
    if (!self.player.moving) {
        [self.player runAction:self.walkAction];
    }
    

    self.player.moving = YES;
    
    //Skrickar mapLocation till min moveToward i player "classen"
    //[self.player moveToward:mapLocation];
    

    
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
// update every frame
- (void)update:(ccTime)delta{
    
    //David 2013-05-13
    // You use the velocity property of the joystick to change the ship’s position, but not without scaling it up. The velocity values are a tiny fraction of a pixel, so you need to multiply the velocity using cocos2d’s ccpMult method, which takes a CGPoint and a float factor, for the joypad velocity to have a noticeable effect. The scale factor is arbitrary; it’s just a value that feels good for this game.
    // Velocity must be scaled up by a factor that feels right
    CGPoint velocity=ccpMult(leftJoystick.velocity, 7000 * delta);
    _player.position=CGPointMake(_player.position.x+velocity.x * delta, _player.position.y+velocity.y * delta);

    
    //
    [self setPlayerPosition:self.player.position];
    //Gubben blir centrerad av skärmen
    [self setViewpointCenter:self.player.position];
    
  
    if (shootButton.active == YES) {
        
        [self swordAnimation];
        
    
    }
  
    else ([_sword removeFromParentAndCleanup:YES]);
    
    
}

        
        //[self testCollisions];
        
        
        
        
       

        
       /*
        CCSprite *missile=[CCSprite spriteWithFile:@"swooshsprite.png"];
        missile.position=ccp(self.player.position.x,self.player.position.y);
        [self.tileMap addChild:missile];
        id move=[CCMoveBy actionWithDuration:1.0 position:ccp(600,0)];
        [missile runAction:move];
        //[[SimpleAudioEngine sharedEngine] playEffect:@"shoot.mp3"];
        
        
        // Looks for an image with the same name as the passed-in property list, but ending with “.png” instead, and loads that file into the shared CCTextureCache (in our case, AnimPlayer.png).
        // Parses the property list file and keeps track of where all of the sprites are, using CCSpriteFrame objects internally to keep track of this information.
        
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"swooshsprite.plist"];
        
        
        // create a CCSpriteBatchNode object passing in the image file containing all of the sprites, as you did here, and add that to your scene **.
        // Now, any time you create a sprite that comes from that sprite sheet, you should add the sprite as a child of the CCSpriteBatchNode. As long as the sprite comes from the sprite sheet it will work, otherwise you’ll get an error.
        //The CCSpriteBatchNode code has the smarts to look through its CCSprite children and draw them in a single OpenGL ES call rather than multiple calls, which again is much faster
		CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"swooshsprite.png"];
        
        // ** Lägger ut min _batchNode på skärmen
        [self.tileMap addChild:spriteSheet];
        
        
        // To create the list of frames, you simply loop through your image’s names (they are named with a convention of Bear1.png -> Bear8.png)
        NSMutableArray *walkAnimFrames = [NSMutableArray array];
        for (int i=1; i<=walkAnimFrames.count; i++) {
            [walkAnimFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"swoosh%d.png",i]]];
            
             [spriteSheet addChild:self.player];
            
            
        }
        
        
        
        //You create a CCAnimation by passing in the list of sprite frames, and specifying how fast the animation should play. You are using a 0.1 second delay between frames here.
        CCAnimation *walkAnim = [CCAnimation
                                 animationWithSpriteFrames:walkAnimFrames delay:0.1f];
        
        self.walkAction = [CCRepeatForever actionWithAction:
                           [CCAnimate actionWithAnimation:walkAnim]];
        
        [self.player runAction:self.walkAction];
        
        */
        
        //[spriteSheet addChild:self.player];
 


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



//Adam 2013-05-10
- (void) projectileMoveFinished:(id)sender {
    CCSprite *sprite = (CCSprite *)sender;
    [self.tileMap removeChild:sprite cleanup:YES];
    
    //Adam 2013-05-10 Innehåller min collision
    [self.projectiles removeObject:sprite];
    
}



//Adam 2013-05-10 Innehåller min colission

- (void)testCollisions:(ccTime)dt {
    
    
    NSMutableArray *projectilesToDelete = [[NSMutableArray alloc] init];
    
    // iterate through projectiles
    for (CCSprite *projectile in self.projectiles) {
        CGRect projectileRect = CGRectMake(
                                           projectile.position.x - (projectile.contentSize.width/2),
                                           projectile.position.y - (projectile.contentSize.height/2),
                                           projectile.contentSize.width,
                                           projectile.contentSize.height);
        
        
        NSMutableArray *targetsToDelete = [[NSMutableArray alloc] init];
        
        // iterate through enemies, see if any intersect with current projectile
        for (CCSprite *target in self.enemies) {
            CGRect targetRect = CGRectMake(
                                           target.position.x - (target.contentSize.width/2),
                                           target.position.y - (target.contentSize.height/2),
                                           target.contentSize.width,
                                           target.contentSize.height);
            
            
            if (CGRectIntersectsRect(projectileRect, targetRect)) {
                [targetsToDelete addObject:target];
            }
        }
        
        // delete all hit enemies
        for (CCSprite *target in targetsToDelete) {
            [self.enemies removeObject:target];
            
           
            [self removeChild:target cleanup:YES];
        }
        
        if (targetsToDelete.count > 0) {
            // add the projectile to the list of ones to remove
            [projectilesToDelete addObject:projectile];
        }
    }
             
    
    
   
    // remove all the projectiles that hit.
    for (CCSprite *projectile in projectilesToDelete) {
        [self.projectiles removeObject:projectile];
        [self removeChild:projectile cleanup:YES];
    }
    
}


//Adam 2013-05-13
-(void)initShootButton {
    
    
    CGRect shootButtonDimensions = CGRectMake(0, 0, 64, 64);
    //Bestämmer min position på knappen!
    CGPoint shootButtonPosition = ccp(400,80);
    
    SneakyButtonSkinnedBase *shootButtonBase = [[SneakyButtonSkinnedBase alloc] init];
    shootButtonBase.position = shootButtonPosition;
    shootButtonBase.defaultSprite = [CCSprite spriteWithFile:@"projectile-button-off.png"];
    shootButtonBase.activatedSprite = [CCSprite spriteWithFile:@"projectile-button-on.png"];
    shootButtonBase.pressSprite = [CCSprite spriteWithFile:@"projectile-button-on.png"];
    
    shootButtonBase.button = [[SneakyButton alloc] initWithRect:shootButtonDimensions];
    shootButton = shootButtonBase.button;
    shootButton.isToggleable = NO;
    [self addChild:shootButtonBase];
    
    NSLog(@"pressed");
 
}
-(void)swingBtnPressed
{

    
    
}
 
//David 2013-05-13
-(void) addJoystick
{
    float stickRadius=50;
    leftJoystick=[[SneakyJoystick alloc] initWithRect: CGRectMake(0, 0, stickRadius, stickRadius)];
    leftJoystick.autoCenter = YES;
    leftJoystick.hasDeadzone = YES;
    leftJoystick.deadRadius = 10;
    CCSprite* back=[CCSprite spriteWithFile:@"dpad.png"];
    CCSprite* thumb=[CCSprite spriteWithFile:@"joystick.png"];
    SneakyJoystickSkinnedBase* skinStick=[[SneakyJoystickSkinnedBase alloc] init];
    skinStick.joystick = leftJoystick;
    skinStick.backgroundSprite.color = ccYELLOW;
    skinStick.backgroundSprite = back;
    skinStick.thumbSprite = thumb;
    skinStick.position=CGPointMake(stickRadius * 1.5f, stickRadius * 1.5f);
    [self addChild:skinStick];
}

-(void)swordAnimation{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"SWORDSWOOOOSH.plist"];
    CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"SWORDSWOOOOSH.png"];
    [self addChild:spriteSheet];
    
    NSMutableArray *walkAnimFrames = [NSMutableArray array];
    for (int i=1; i<=4; i++) {
        [walkAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"swordswoosh%d.png",i]]];
    }
    
    CCAnimation *walkAnim = [CCAnimation
                             animationWithSpriteFrames:walkAnimFrames delay:0.1f];
    
   // CGSize winSize = [[CCDirector sharedDirector] winSize];
    self.sword = [CCSprite spriteWithSpriteFrameName:@"swordswoosh1.png"];
    CGPoint swordPos = ccp(self.player.position.x,self.player.position.y);
    self.sword.position = swordPos;
    self.walkAction = [CCRepeatForever actionWithAction:
                       [CCAnimate actionWithAnimation:walkAnim]];
    
    
    
   
    [self.sword runAction:self.walkAction];
    [self.tileMap addChild:self.sword];
    
    
    
   
    //[self.tileMap removeChild:self.sword cleanup:YES];
    
    
     NSLog(@"hajdooken");

    
    
    //id move=[CCMoveBy actionWithDuration:1.0 position:ccp(600,0)];
    //[missile runAction:move];
    
    /*
    CCSprite *missile=[CCSprite spriteWithFile:@"SWORDSWOOOOSH.png"];
    missile.position=ccp(self.player.position.x,self.player.position.y);
    [self.tileMap addChild:missile];
    id move=[CCMoveBy actionWithDuration:1.0 position:ccp(600,0)];
    [missile runAction:move];
*/
 
}






//Allt nedanför är nytt skräp!!
////////////////////////////////////////////////
////////////////////////////////////////////////
-(float) minScale
{
	CGSize s = [[CCDirector sharedDirector] winSize];
	return s.width / self.contentSize.width;
}


/** Returns the minimum allowable scale factor for the gameViewLayer */
//This should probably be a property?

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
	NSSet *allTouches = [event allTouches]; //this gets not just the touch
	//that triggered the event, but all the touches.  You need this!
    
	switch ([allTouches count]) {
		case 1: { //Single touch
			//Get the first touch.
			UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
            
			switch ([touch tapCount])
			{
				case 1: case 2: //Single or Double Tap.
				{
                    [self initDragZoomValues:allTouches];
				} break;
			}
		} break;
		case 2: { //Double Touch <-- this almost never happens, btw.
			//NSLog(@"Double Touch");
		} break;
		default:
			break;
	}
    
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
	NSSet *allTouches = [event allTouches];
    
	switch ([allTouches count])
	{
		case 1: {
			//NSLog(@"One touch moved");
			// drag method
			[self dragLayer:[touches anyObject]];
            
		} break;
		case 2: {
			//The image is being zoomed in or out. ) mTargetLayer
			//NSLog(@"Two touch moved");
			[self doubleDragZoomLayer:allTouches];
            
		} break;
	}
    
}

//Calculates position of layer based on original location, two-finger midpoint, original zoom and end zoom
- (CGPoint)adjustZoomPosition:(CGPoint)fromPoint anchoredOn:(CGPoint)anchorPoint fromZoom:(float)fromZoom toZoom:(float)toZoom {
	float newX, newY;
	newX = anchorPoint.x - ((anchorPoint.x-fromPoint.x)*toZoom/fromZoom);
	newY = anchorPoint.y - ((anchorPoint.y-fromPoint.y)*toZoom/fromZoom);
	return ccp(newX,newY);
}

//Adjusts the layer position so that the viewport doesn't go outside the contentSize
- (CGPoint)adjustPositionInbounds:(CGPoint)currentPoint {
	float newX, newY, zoomWidth, zoomHeight;
	BOOL changedX, changedY;
	changedX = NO;
	changedY = NO;
	CGSize size = [[CCDirector sharedDirector] winSize];
	zoomWidth = self.contentSize.width*self.scale;
	zoomHeight = self.contentSize.height*self.scale;
	if( currentPoint.x < -zoomWidth*(1-self.anchorPoint.x)+size.width){
		newX = -zoomWidth*(1-self.anchorPoint.x)+size.width;
		changedX = YES;
	}
	if( currentPoint.x > zoomWidth*(self.anchorPoint.x) ){
		newX = zoomWidth*(self.anchorPoint.x);
		changedX = YES;
	}
    if( currentPoint.y < -zoomHeight*(1-self.anchorPoint.y)+size.height) {
        newY = -zoomHeight*(1-self.anchorPoint.y)+size.height;
        changedY = YES;
    }
    if( currentPoint.y > zoomHeight*(self.anchorPoint.y)) {
        newY = zoomHeight*(self.anchorPoint.x);
		changedY = YES;
	}
    if (changedX | changedY) {
        if(changedX!=YES) newX = currentPoint.x;
        if(changedY!=YES) newY = currentPoint.y;
        return ccp(newX,newY);
	} else {
		return currentPoint;
	}
    
}

//Sets up the dragging and zooming initial variables so they are reset between touches.
-(void)initDragZoomValues:(NSSet *)allTouches {
	oneTouchStart = ccp(0.0f, 0.0f);
    
	//NSSet *allTouches = [event allTouches];
	if ([allTouches count] == 2) {
		//Track the initial distance between two fingers.
		UITouch *touch1 = [[allTouches allObjects] objectAtIndex:0];
		UITouch *touch2 = [[allTouches allObjects] objectAtIndex:1];
		CGPoint firstTouch = [touch1 locationInView:[touch1 view]];
		CGPoint secondTouch = [touch2 locationInView:[touch2 view]];
		twoTouchStart = ccp(0.0f,0.0f);
		initialDistance = sqrt(pow(firstTouch.x - secondTouch.x, 2.0f) + pow(firstTouch.y - secondTouch.y, 2.0f));
	}
}


//Drags the layer when a single touch moves
-(void)dragLayer:(UITouch *)dragTouch{
    
	CGPoint location = [dragTouch locationInView: [dragTouch view]];
	CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];
    
	float newCenterX, newCenterY;
    
	//set the start values if they haven't been set yet
	if (oneTouchStart.x == 0.0f){oneTouchStart.x=convertedLocation.x;}
	if (oneTouchStart.y == 0.0f){oneTouchStart.y=convertedLocation.y;}
    
	//determine new layer position
	newCenterX = self.position.x+(convertedLocation.x-oneTouchStart.x);
	newCenterY = self.position.y+(convertedLocation.y-oneTouchStart.y);
    
	[self setPosition:[self adjustPositionInbounds:ccp(newCenterX, newCenterY)]];
	//set new location for next touchesmoved
	oneTouchStart = ccp(convertedLocation.x,convertedLocation.y);
}

//Drags/Zooms the layer when double touch moves
-(void)doubleDragZoomLayer:(NSSet *)allTouches {
    
	UITouch *touch1 = [[allTouches allObjects] objectAtIndex:0];
	UITouch *touch2 = [[allTouches allObjects] objectAtIndex:1];
	CGPoint firstTouch = [touch1 locationInView:[touch1 view]];
	CGPoint secondTouch = [touch2 locationInView:[touch2 view]];
    
	CGPoint twoTouchMoved = [[CCDirector sharedDirector] convertToGL:ccp((firstTouch.x+secondTouch.x)/2,(firstTouch.y+secondTouch.y)/2)];
	if (twoTouchStart.x == 0) {twoTouchStart.x = twoTouchMoved.x;}
	if (twoTouchStart.y == 0) {twoTouchStart.y = twoTouchMoved.y;}
	CGPoint newMidPoint = ccp(self.position.x+(twoTouchMoved.x-twoTouchStart.x),self.position.y+(twoTouchMoved.y-twoTouchStart.y));
	twoTouchStart = twoTouchMoved;
	CGFloat finalDistance = sqrt(pow(firstTouch.x - secondTouch.x, 2.0f) + pow(firstTouch.y - secondTouch.y, 2.0f));
    
	float startZoom, endZoom;
    
	//Check if zoom in or zoom out.
	if(initialDistance > finalDistance*1.01f) { //added the multiplier to get rid of jitter when double-dragging
		// zoom out
		if (self.scale > self.minScale) {
			startZoom = self.scale;
			endZoom = startZoom -startZoom*0.05f;
			if (endZoom < self.minScale) endZoom = self.minScale;
			self.scale = endZoom;
			CGPoint newPoint = [self adjustZoomPosition:self.position anchoredOn:twoTouchMoved fromZoom:startZoom toZoom:endZoom];
            
            
            
            //Ändrat till tileMap
			[self.tileMap setPosition:[self adjustPositionInbounds:newPoint]];
		}
	}
	else if(initialDistance < finalDistance*0.99f) { //added the multiplier to get rid of jitter when double-dragging
		// zoom in
		if (self.scale < 1.0f) {
			startZoom=self.scale;
			endZoom = startZoom +startZoom *0.05f;
			if (endZoom > 1.0f) endZoom = 1.0f;
			self.scale = endZoom;
			CGPoint newPoint = [self adjustZoomPosition:self.position anchoredOn:twoTouchMoved fromZoom:startZoom toZoom:endZoom];
            
            //Ändrat till tileMap
			[self.tileMap setPosition:[self adjustPositionInbounds:newPoint]];
		}
	}
	else {
        //Ändrat till tileMap
		[self.tileMap setPosition:[self adjustPositionInbounds:newMidPoint]];
	}
    
	initialDistance = finalDistance;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	NSSet *allTouches = [event allTouches];
	if([allTouches count]==2){
		oneTouchStart = ccp(0.0f, 0.0f);
        
	}
}
////////////////////////////////////////////////
////////////////////////////////////////////////
////////////////////////////////////////////////
////////////////////////////////////////////////


@end



