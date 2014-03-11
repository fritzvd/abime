import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import openfl.Assets;
import flash.display.BitmapData;
import Raycast;
import Player;

class MainScene extends Scene
{
	public static var rayCast:Raycast;
	public static var player:Player;
	public static var texturesCache:BitmapData;
	public override function begin()
	{
		super.begin();
		texturesCache = Assets.getBitmapData("graphics/walls.png");

		player = new Player(1, 1);
		rayCast = new Raycast();

		add(player);
		add(rayCast);
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