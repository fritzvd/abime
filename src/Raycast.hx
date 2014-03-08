// This is totally inspired 'ripped off'
// from the raytracer tutorial by Opera Browser
// and some looks at Qilin Eggs' RetroBomber3d

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
			mapHeight * miniMapScale, false, 0x23335);
		Draw.setTarget(miniMap);
		drawMiniMap();	
	}

	private function drawMiniMap()
	{
		// trace(miniMap.rect);
		for (y in 0...mapHeight) {
			for (x in 0...mapWidth) {
				var wall = mapDef[y][x];
				var color :Int = 0xffffff;

				if (wall != 0) {
					Draw.rect(x * miniMapScale, y * miniMapScale, 
						miniMapScale, miniMapScale, color, 1);
				}
			}
		}
		var x0 = HXP.width - mapWidth * miniMapScale;
		var y0 = HXP.height - mapHeight* miniMapScale;
		graphic = new Stamp(miniMap, x0, y0);
		trace(graphic);
		
	}
}