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
import com.haxepunk.graphics.Stamp;


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


	public function new()
	{
		super(x, y);
		miniMapScale = 4;
		mapDef = [
  [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
  [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
  [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
  [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
		];
		mapWidth = mapDef[0].length;
		mapHeight = mapDef.length;

		drawMiniMap();
		stripWidth = 4;
		numRays = Math.ceil(HXP.width / stripWidth);
		fov = 60 * Math.PI / 180;
		viewDist = (HXP.width/2) / Math.tan((fov / 2));
		twoPI = Math.PI * 2;
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
		// var x2 = Math.round(x1 + Math.cos(MainScene.player.rot) * miniMapScale);
		// var y2 = Math.round(y1 + Math.sin(MainScene.player.rot) * miniMapScale);
		// Draw.line(x1, y1, x2, y2, 0xFFFFFF); 
		layer = 1;
		graphic = new Stamp(miniMap, x0, y0);
	}

	// public function drawRay(xHit:Float, yHit:Float) {
	// 	var x1 = Math.round(MainScene.player.x * miniMapScale);
	// 	var y1 = Math.round(MainScene.player.y * miniMapScale);
	// 	var x2 = Math.round(xHit * miniMapScale);
	// 	var y2 = Math.round(yHit * miniMapScale);
	// 	Draw.line(x1, y1, x2, y2, 0x888888); 
	// 	super.render();
	// }

	private function castRays()
	{
		var stripIdx = 0;
		for (i in 0...numRays) {
			var rayScreenPos = (-numRays/2 + i) * stripWidth;
			var rayViewDist = Math.sqrt(rayScreenPos * rayScreenPos + viewDist * viewDist);
			var rayAngle:Float = Math.asin(rayScreenPos / rayViewDist);

			castSingleRay(10, stripIdx++);
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

		var dist:Float = 0,
			xHit:Float = 0,
			yHit:Float = 0,
			textureX,
			wallX,
			wallY;

		var slope:Float = angleSin / angleCos;
		var dX:Float = right ? 1 : -1;
		var dY:Float = dX * slope;

		var rayX = MainScene.player.x;
		var rayY = MainScene.player.y;

		while (rayX >= 0 && rayX < HXP.width && rayY >= 0 && rayY < HXP.height) {
			var wallX = Math.floor(rayX + (right ? 0 : -1));
			var wallY = Math.floor(rayY);

			if (mapDef[wallY][wallX] > 0) {
				var distX = rayX - MainScene.player.x;
				var distY = rayY - MainScene.player.y;
				dist = distX * distX + distY * distY;

				textureX = rayY % 1;
				if (!right) textureX = 1 - textureX;
				xHit = rayX;
				yHit = rayY;

				break;
			}

			rayX += dX;
			rayY += dY;
		}

		slope = angleCos / angleSin;
		dY = up ? -1 : 1;
		dX = dY * slope;
		rayY  = up ? Math.floor(MainScene.player.y) : Math.ceil(MainScene.player.y);
		rayX = MainScene.player.x + (rayY - MainScene.player.y) * slope;

		while (rayX >= 0 && rayX < HXP.width && rayY >= 0 && rayY < HXP.height) {
			var wallY = Math.floor(rayY + (up ? -1 : 0));
			var wallX = Math.floor(x);

			if (mapDef[wallY][wallX] > 0) {
				var distX = rayX - MainScene.player.x;
				var distY = rayY - MainScene.player.y;
				var blockDist = distX * distX + distY * distY;
				if (blockDist < dist) {
					dist = blockDist;
					xHit = rayX;
					yHit = rayY;
					textureX = rayX % 1;
					if (up) textureX = 1 - textureX;
				}
				break;
			}
			rayX += dX;
			rayY += dY;
		}

	}

	public override function update()
	{
		drawMiniMap();
	}
}