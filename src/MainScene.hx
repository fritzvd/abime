import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import Raycast;
import Player;

class MainScene extends Scene
{
	public static var player:Player;
	public override function begin()
	{
		super.begin();
		player = new Player();
		add(player);
		var rayTracer:Raycast = new Raycast();
		add(rayTracer);

		Input.define("left", [Key.LEFT, Key.A]);
		Input.define("right", [Key.RIGHT, Key.D]);
		Input.define("up", [Key.UP, Key.W]);
		Input.define("down", [Key.DOWN, Key.S]);
	}

	private function handleInput()
	{
		if (Input.check("up"))
		{
			player.speed = 1;
		}
		if (Input.check("down"))
		{
			player.speed = -1;
		}
		if (Input.check("left"))
		{
			player.dir = -1;
		}
		if (Input.check("right"))
		{
			player.dir = 1;
		}
		
	}

	public override function update()
	{
		super.update();
		handleInput();
	}
}