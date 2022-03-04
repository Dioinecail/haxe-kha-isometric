package camera;

import kha.input.Mouse;
import kha.math.FastMatrix4;
import utility.Math;

class ZoomComponent {
	private var camera:Camera;

	private var zoomSpeed:Float = 1.5;
	private var zoomBaseLevel:Float = 3.0;
	private var _zoomLevel:Float = 0.0;
	public var zoomLevel (get, never):Float;
	private function get_zoomLevel():Float { return _zoomLevel; }

	private var zoomMin:Float = 0.0;
	private var zoomMax:Float = 20.0;
	private var currentZoom:Float;



	public function new(camera:Camera) {
		this.camera = camera;
		notifyInputs();

		currentZoom = zoomBaseLevel + zoomLevel;

		camera.setProjection(FastMatrix4.orthogonalProjection(-currentZoom, currentZoom, -currentZoom, currentZoom, 0.0, 100.0));
	}

	
	private function notifyInputs(): Void {
		Mouse.get().notify(null, null, null, onScrollWheel, null);
	}

	private function onScrollWheel(direction: Int) {
		_zoomLevel += direction * zoomSpeed;
		_zoomLevel = Math.clamp(zoomLevel, zoomMin, zoomMax);

		currentZoom = zoomBaseLevel + zoomLevel;
		camera.setProjection(FastMatrix4.orthogonalProjection(-currentZoom, currentZoom, -currentZoom, currentZoom, 0.0, 100.0));
	}
}