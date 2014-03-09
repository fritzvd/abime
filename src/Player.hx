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
	public function new()
	{
		super();
		rotSpeed = 6 * Math.PI / 180;
		speed = 0;
		moveSpeed = 0.18; // arbitrary.. 
		dir = 0;
		rot = 0;
		graphic = Image.createRect(30,30, 0x0);
	}

	private function calculateMovement()
	{
		var moveStep = speed * moveSpeed;
		rot += dir * rotSpeed;
		x = x + Math.cos(rot) * moveStep;	// calculate new player position with simple trigonometry
		y = y + Math.sin(rot) * moveStep;
	}


	override public function update()
	{
		super.update();
		calculateMovement();
		speed = 0;
		dir = 0;
	}
}