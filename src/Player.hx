import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import flash.geom.Point;

class Player extends Entity
{
	public var dir:Int;
	public var rot:Float;
	public var speed:Int;
	private var moveSpeed:Float;
	private var rotSpeed:Float;
	public function new(x:Int, y:Int)
	{
		super(x, y);
		rotSpeed = 6 * Math.PI / 180;
		speed = 1;
		moveSpeed = 0.18; // arbitrary.. 
		dir = 0;
		rot = 0;
		// graphic = Image.createRect(30,30, 0x0);
	}

	private function calculateMovement()
	{
		var moveStep = speed * moveSpeed;
		rot += dir * rotSpeed;
		var newX = x + Math.cos(rot) * moveStep;	// calculate new player position with simple trigonometry
		var newY = y + Math.sin(rot) * moveStep;
		var tile = MainScene.rayCast.mapDef[Math.round(newY)][Math.round(newX)];
		var collides = true ? (tile != 0) : false;
		if (!collides) {
			x = newX;
			y = newY;
		}
	}


	override public function update()
	{
		super.update();
		calculateMovement();
		dir = 0;
		speed = 0;
	}
}