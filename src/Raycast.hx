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

	public function new()
	{
		super(x, y);
		miniMapScale = 4;
		mapDef = [
  [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
  [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
  [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
  [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
  [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
  [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
  [1,0,0,2,0,0,0,0,2,2,2,2,2,2,2,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
  [1,0,0,2,0,0,0,0,2,2,2,2,2,2,2,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
  [1,0,0,2,0,0,0,0,2,2,2,2,2,2,2,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
  [1,0,0,2,0,0,0,0,2,2,2,2,2,2,2,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
  [1,0,0,2,0,0,0,0,2,2,2,2,2,2,2,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
		];
		mapWidth = mapDef[0].length;
		mapHeight = mapDef.length;
		miniMap = new BitmapData(mapWidth * miniMapScale, 
			mapHeight * miniMapScale, false, 0xcccccc);
		Draw.setTarget(miniMap);
		drawMiniMap();	
		graphic = new Stamp(miniMap, x0, y0);
		
	}

	private function drawMiniMap()
	{
		// trace(miniMap.rect);
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
		var x2 = Math.round(x1 + Math.cos(MainScene.player.rot) * miniMapScale);
		var y2 = Math.round(y1 + Math.sin(MainScene.player.rot) * miniMapScale);
		Draw.line(x1, y1, x2, y2, 0xFFFFFF); 
		trace(x1, y1, x2, y2);
	}

	public override function update()
	{
		drawMiniMap();
	}
}