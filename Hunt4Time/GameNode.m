//
//  GameNode.m
//  Hunt4Time
//
//  Created by admin on 5/15/13.
//  Copyright 2013 David. All rights reserved.
//

#import "GameNode.h"


@implementation GameNode{
    
//    Mushroom *mushroom;
//}
//
//- (id)init{
//    
//    mushroom = [Mushroom node];
//  
//    
//    
//    
//    if (self = [super init]) {
//        CCTMXTiledMap *tileMap;
//        
//        tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"TileMapFirstLvL.tmx"];
//        
//    }
//    return self;
//    
//}
//
//-(void)initCollect(CGPoint)position{
//    
//        CGPoint tileCoord = [self tileCoordForPositions:position_];
//        int tileGid = [_specialTile tileGIDAt:tileCoord];
//        if (tileGid) {
//            NSDictionary *properties = [_tileMap propertiesForGID:tileGid];
//            if (properties) {
//                
//                //För att få gubben att stanna vid våra väggar
//                NSString *collision = properties[@"Collidable"];
//                if (collision && [collision isEqualToString:@"True"]) {
//                    
//                    
//                    _playerX = self.player.position.x;
//                    _playerY = self.player.position.y;
//                    
//                    _playerPos = ccp(_playerX/2, _playerY);
//                    
//                    return [self.player pauseSchedulerAndActions];
//                    
//                }
//    
//    
//        //För att kunna plocka upp Svampar
//        NSString *collectible = properties[@"Collectable"];
//        if (collectible && [collectible isEqualToString:@"True"]) {
//            [_specialTile removeTileAt:tileCoord];
//            [_mushroom removeTileAt:tileCoord];
//    
//    [self.hud addToScore:1];
//    
//                }
//            }
//    
//        }
}








@end
