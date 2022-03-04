package;

import kha.math.FastVector2;
import kha.math.FastVector3;
import kha.Window;
import kha.Assets;
import kha.Scheduler;
import kha.System;
import kha.Image;
import gameObjects.GameObject;
import camera.Camera;

class Main {
	public static var camera:Camera;
	public static var world:World;

	private static var lastUpdateTime:Float;
	private static var boundsX:FastVector2;
	private static var boundsY:FastVector2;

	private static var gridSize:Int = 50;



	public static function main() {
		System.start({title: "Empty", width: 640, height: 640}, init);
	}

	private static function init(window:Window) {
		boundsX = new FastVector2(-(gridSize + 1) / 2, (gridSize - 1) / 2);
		boundsY = new FastVector2(-(gridSize + 1) / 2, (gridSize - 1) / 2);

		Assets.loadEverything(onFinishedLoading);
		camera = new Camera(false, boundsX, boundsY);
	}

	private static function onFinishedLoading():Void {
		var image1 = Assets.images.uvmap;

		world = new World(camera);

		createGrid(gridSize, gridSize, image1, world);

		Scheduler.addTimeTask(update, 0, 1 / 60);
		System.notifyOnFrames(world.render);
	}

	private static function update() {
		var deltaTime = Scheduler.time() - lastUpdateTime;
		camera.update(deltaTime);

		world.update();

		lastUpdateTime = Scheduler.time();
	}

	private static function createGrid(sizeX:Int, sizeY:Int, gridImage:Image, world:World) {
		for (x in 0...sizeX) {
			for (y in 0...sizeY) {
				var p1 = new FastVector3(x * 1 - sizeX / 2, y * 1 - sizeY / 2, 0);
				var r1 = new FastVector3(0, 0, 0);
				var s1 = new FastVector3(1, 1, 1);

				var g1 = GameObject.create(p1, r1, s1, gridImage);
				world.objects.push(g1);
			}
		}
	}

	private static function createInstancedGrid(sizeX:Int, sizeY:Int, gridImage:Image, world:World) {
		var instances = new Array();

		for (x in 0...sizeX) {
			for (y in 0...sizeY) {
				var p1 = new FastVector3(x * 1, y * 1, 0);
				var r1 = new FastVector3(0, 0, 0);
				var s1 = new FastVector3(1, 1, 1);

				var g1 = GameObject.createInstanced(p1, r1, s1);
				instances.push(g1.instancedRenderer);
			}
		}

		world.setupInstances(instances, gridImage);
	}
}