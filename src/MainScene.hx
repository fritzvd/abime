import com.haxepunk.Scene;
import Raycast;

class MainScene extends Scene
{
	public override function begin()
	{
		super.begin();
		var rayTracer:Raycast = new Raycast();
		add(rayTracer);
	}
}