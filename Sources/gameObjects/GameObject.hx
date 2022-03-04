package gameObjects;

import rendering.InstancedRenderComponent;
import rendering.RenderComponent;
import kha.math.FastVector3;
import kha.Image;

class GameObject {
	public var transform:Transform;
	public var renderer:RenderComponent;
	public var instancedRenderer:InstancedRenderComponent;

	public var isVisible:Bool;



	public static function create(position:FastVector3, rotation:FastVector3, scale:FastVector3, image:Image): GameObject {
		var t = new Transform(position, rotation, scale);
		var r = new RenderComponent(t, image);

		var g = new GameObject(t);
		g.renderer = r;

		return g;
	}

	public static function createInstanced(position:FastVector3, rotation:FastVector3, scale:FastVector3): GameObject {
		var t = new Transform(position, rotation, scale);
		var r = new InstancedRenderComponent(t);

		var g = new GameObject(t);
		g.instancedRenderer = r;

		return g;
	}

	public function new(transform:Transform) {
		this.transform = transform;
	}
}