package;

import camera.Camera;
import kha.Image;
import gameObjects.GameObject;
import kha.graphics4.Graphics;
import kha.Framebuffer;
import kha.Color;
import rendering.InstancedBatch;
import rendering.InstancedRenderComponent;

class World {
	public var objects:Array<GameObject>;

	public var instancedRenderers:Array<InstancedBatch>;

	private var camera:Camera;




	public function new(camera:Camera) {
		this.camera = camera;
		objects = new Array<GameObject>();
		instancedRenderers = new Array();
	}

	public function update() {
		checkObjectsVisibility();
	}
	
	// setup instanced RenderComponents
	public function setupInstances(instances:Array<InstancedRenderComponent>, image:Image) {
		instancedRenderers.push(new InstancedBatch(instances, image));
	}

	// render instanced RenderComponents here
	public function render(frames:Array<Framebuffer>) {
		var g = frames[0].g4;

        g.begin();
		g.clear(Color.fromFloats(0.0, 0.0, 0.2));

		for (i in 0...objects.length) {
			objects[i].renderer.render(g);
		}

		for (i in 0...instancedRenderers.length) {
			renderInstanced(instancedRenderers[i], g);
		}

		g.end();
	}

	private function renderInstanced(batch:InstancedBatch, g:Graphics) {
		batch.render(g);
	}

	private function checkObjectsVisibility() {
		for(i in 0...objects.length) {
			// check is tile is within camera frustrum
			var position = objects[i].transform.position;
			
		}
	}
}