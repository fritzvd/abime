/* This is totally inspired 'ripped off'
 from the raytracer tutorial by Opera Browser
 and some looks at Qilin Eggs' RetroBomber3d
	
 Was playing around with haxepunk.graphics.Canvas;
 But that was a dead end. BitmapData did not seem to be working.
 But switched back to it. Only works in HTML5/Flash.. grmbl

*/

import com.haxepunk.Entity;
import com.haxepunk.utils.Draw;
import com.haxepunk.HXP;
import flash.display.BitmapData;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.Stamp;
import com.haxepunk.graphics.Image;
import flash.geom.Rectangle;


class Raycast extends Entity 
{
	public var mapDef:Array<Array<Int>>;
	private var mapWidth:Int;
	private var mapHeight:Int;
	private var miniMapScale:Int;
	private var miniMap:BitmapData;
	private var fov:Float;
	private var numRays:Int;
	private var viewDist:Float;
	private var stripWidth:Int;
	private var twoPI:Float;
	private var walls:Spritemap;

	public var objectsMap(default, null):Array<Array<Entity>>;
	private var strips:Array<Entity>;

	public function new()
	{
		super();
		miniMapScale = 4;
		mapDef = [
  [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
  [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
  [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
  [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
  [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
		];
		mapWidth = mapDef[0].length;
		mapHeight = mapDef.length;


		walls = new Spritemap('graphics/walls.png', 128, 128);
		drawMiniMap();
		stripWidth = 2;
		numRays = Math.ceil(HXP.width / stripWidth);
		fov = 120 * HXP.RAD;
		viewDist = 255;
		twoPI = Math.PI * 2;
	}

	public override function added()
	{
		initSpriteMap();		
	}

	private function initSpriteMap()
	{
		strips = new Array<Entity>();
		for (i in 0 ...numRays) {
			var img:Image = new Image(MainScene.texturesCache, new Rectangle(0, 0, 2, 64));
			img.scaledWidth = stripWidth;
			var strip = new Entity(i * 2, 0, img);
			strips.push(strip);
			scene.add(strip); 
		}

				// objects map
		objectsMap = new Array<Array<Entity>>();
		objectsMap = [];
		for (y in 0 ... mapDef.length)
			objectsMap[y] = [];
		
	}

	private function drawMiniMap()
	{
		miniMap = new BitmapData(mapWidth * miniMapScale, 
			mapHeight * miniMapScale, false, 0xcccccc);
		Draw.setTarget(miniMap);
		for (y in 0...mapHeight) {
			for (x in 0...mapWidth) {
				var wall = mapDef[y][x];
				var color :Int = 0x000000;

				if (wall != 0) {
					Draw.rect(x * miniMapScale, y * miniMapScale, 
						miniMapScale, miniMapScale, color, 1);
				}
			}
		}
		var x0 = HXP.width - mapWidth * miniMapScale;
		var y0 = HXP.height - mapHeight* miniMapScale;
		var x1 = Math.round(MainScene.player.x * miniMapScale);
		var y1 = Math.round(MainScene.player.y * miniMapScale);
		Draw.rect(x1, y1, miniMapScale, miniMapScale, 0xF, 1);
		layer = 1;
		graphic = new Stamp(miniMap, x0, y0);
	}

	private function castRays()
	{
		var stripIdx = 0;
		for (i in 0...numRays) {
			var rayScreenPos = (-numRays/2 + i) * stripWidth;
			var rayViewDist = Math.sqrt(rayScreenPos * rayScreenPos + viewDist * viewDist);
			var rayAngle:Float = Math.asin(rayScreenPos / rayViewDist);

			castSingleRay(MainScene.player.rot + rayAngle, stripIdx++);
		}
	}

	private function castSingleRay(rayAngle:Float, stripIdx:Int)
	{
		rayAngle %= twoPI;
		if (rayAngle < 0) rayAngle += twoPI;

		var right = (rayAngle > twoPI * 0.75 || rayAngle < twoPI * 0.25);
		var up = (rayAngle < 0 || rayAngle > Math.PI);

		var angleSin = Math.sin(rayAngle);
		var angleCos = Math.cos(rayAngle);
		var wallType = 0;

		var dist:Float = HXP.NUMBER_MAX_VALUE,
			xHit:Float = 0,
			yHit:Float = 0,
			textureX:Float = 0,
			wallX=0,
			wallY=0,
			wallType = 0;

		var slope:Float = angleSin / angleCos;
		var dX:Float = right ? 1 : -1;
		var dY:Float = dX * slope;
		var wallIsHorizontal = false;

		// var rayX = MainScene.player.x;
		// var rayY = MainScene.player.y;
		var rayX:Float = right ? Math.ceil(MainScene.player.x) : Math.floor(MainScene.player.x);  // starting horizontal position, at one of the edges of the current map block
		var rayY:Float = MainScene.player.y + (x - MainScene.player.x) * slope;  // starting vertical position. We add the small horizontal step we just made, multiplied by the slope.


		while (rayX >= 0 && rayX < mapWidth && rayY >= 0 && rayY < mapHeight) {
			var wallX = Math.floor(rayX + (right ? 0 : -1));
			var wallY = Math.floor(rayY);
			
			// trace(mapDef[wallY][wallX]);
			if (mapDef[wallY][wallX] > 0) {
				var distX = rayX - MainScene.player.x;
				var distY = rayY - MainScene.player.y;
				dist = distX * distX + distY * distY;

				wallType = mapDef[wallY][wallX];
				textureX = rayY % 1;
				if (!right) textureX = 1 - textureX;
				xHit = rayX;
				yHit = rayY;

				wallIsHorizontal = true;
				break;
			}

			rayX += dX;
			rayY += dY;
		}

		slope = angleCos / angleSin;
		// trace('BEfORE ######',dY, dX);
		dY = up ? -1 : 1;
		dX = dY * slope;
		// trace('aFter	 ######', dY, dX);
		rayY = up ? Math.floor(MainScene.player.y) : Math.ceil(MainScene.player.y);
		rayX = MainScene.player.x + (rayY - MainScene.player.x) * slope;

		while (rayX >= 0 && rayX < mapWidth && rayY >= 0 && rayY < mapHeight) {
			var wallY = Math.floor(rayY + (up ? -1 : 0));
			var wallX = Math.floor(rayX);


			if (wallY < 0) wallY = 0;

			if (mapDef[wallY][wallX] > 0) {
				var distX = rayX - MainScene.player.x;
				var distY = rayY - MainScene.player.y;
				var blockDist = distX * distX + distY * distY;
				if (blockDist < dist) {
					dist = blockDist;
					xHit = rayX;
					yHit = rayY;

					wallType = mapDef[wallY][wallX];
					textureX = rayX % 1;
					if (up) textureX = 1 - textureX;
				}
				break;
			}
			rayX += dX;
			rayY += dY;
		}
		// trace(dist);
		if (dist != 0) {
			dist = Math.sqrt(dist);
			// walls.getTile(stripIdx, 0);
			// use perpendicular distance to adjust for fish eye
			// distorted_dist = correct_dist / cos(relative_angle_of_ray)
			dist = dist * Math.cos(MainScene.player.rot - rayAngle);

			// now calc the position, height and width of the wall strip

			// "real" wall height in the game world is 1 unit, the distance from the player to the screen is viewDist,
			// thus the height on the screen is equal to wall_height_real * viewDist / dist

			var height:Float = viewDist / dist;
			// top placement is easy since everything is centered on the x-axis, so we simply move
			// it half way down the screen and then half the wall height back up.
			var top = Math.round((HXP.height - height)) >> 1; // /2
			
			var texX = Math.floor(textureX * 64);
			if (texX > 64 - stripWidth)	// make sure we don't move the texture too far to avoid gaps.
				texX = Math.floor(64 - stripWidth);
			if (dist > 5 )
				texX += 64;
				
			var texY = (wallType-1) << 6; // *64
			
			var dwx = xHit - MainScene.player.x;
			var dwy = yHit - MainScene.player.y;
			var wallDist = dwx*dwx + dwy*dwy;
			
			var img:Image = cast(strips[stripIdx].graphic, Image);
			img.clipRect.left = texX; // new Rectangle(texX, texY, 2, 64);
			img.clipRect.top = texY; 
			img.clipRect.width = 2; 
			img.clipRect.height = 64; 
			img.updateBuffer();
			
			img.scaledHeight = height;
			img.y = top;
			strips[stripIdx].layer = Math.floor(wallDist) + 10;
		}

	}

	

	public override function update()
	{
		castRays();
		drawMiniMap();
		super.update();
	}
}