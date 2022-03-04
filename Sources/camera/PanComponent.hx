package camera;

import kha.math.FastVector3;
import kha.input.Mouse;

class PanComponent {
	private var camera:Camera;
	private var zoom:ZoomComponent;
	private var isLeftMouseButtonDown:Bool = false;

	private var cameraSpeedBase:Float = 0.01;
	private var cameraSpeed:Float = 0.01;

	private var inertiaFalloff:Float = 0.95;
	private var inertiaX:Float;
	private var inertiaY:Float;



	public function new(camera:Camera, zoom:ZoomComponent) {
		this.camera = camera;
		this.zoom = zoom;
		notifyInputs();
	}

	public function updatePosition(deltaTime:Float): Void {
		var x = camera.position.x;
		var y = camera.position.y;

		if(!isLeftMouseButtonDown) {
			x += inertiaX;
			y += inertiaY;

			inertiaX *= inertiaFalloff;
			inertiaY *= inertiaFalloff;

			if(Math.abs(inertiaX) < 0.0001) {
				inertiaX = 0;
			}

			if(Math.abs(inertiaY) < 0.0001) {
				inertiaY = 0;
			}
		}

		camera.position = new FastVector3(x, y, camera.position.z);
	}
	
	private function notifyInputs(): Void {
		Mouse.get().notify(onMouseDown, onMouseUp, onMouseMoved, onScrollWheel, null);
	}

	private function onMouseDown(button:Int, x:Int, y:Int) {
		if(button == 0) {
			isLeftMouseButtonDown = true;
		}
	}
	
	private function onMouseUp(button:Int, x:Int, y:Int) {
		if(button == 0) {
			isLeftMouseButtonDown = false;
		}
	}

	private function onMouseMoved(x:Int, y:Int, moveX:Int, moveY:Int) {
		if(isLeftMouseButtonDown) {
			var x = camera.position.x + (-moveX * cameraSpeed);
			var y = camera.position.y + (moveY * cameraSpeed);

			camera.position = new FastVector3(x, y, camera.position.z);

			inertiaX = -moveX * cameraSpeed;
			inertiaY = moveY * cameraSpeed;
		}
	}
	
	private function onScrollWheel(direction: Int) {
		cameraSpeed = cameraSpeedBase + (zoom.zoomLevel * 0.0033);
	}
}