import com.haxepunk.Entity;

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
	}

	private function calculateMovement()
	{
		var moveStep = speed * moveSpeed;
		rot += dir * rotSpeed;
	}

	override public function update()
	{
		super.update();
		calculateMovement();
	}
}