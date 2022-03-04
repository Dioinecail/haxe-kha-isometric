package camera;

import kha.math.FastVector2;
import kha.math.FastVector3;
import kha.math.FastMatrix4;
import utility.Math;

class Camera  {
	private var _position:FastVector3 = new FastVector3(0, 0, 3);
	private var _direction :FastVector3 = new FastVector3(0, 0, -1);

	public var position (get, set): FastVector3;
	public var direction (get, set): FastVector3;

	private function get_position(): FastVector3 { return _position; }
	private function set_position(value:FastVector3): FastVector3 {
		var x = Math.clamp(value.x, boundsX.x, boundsX.y);
		var y = Math.clamp(value.y, boundsY.x, boundsY.y);

		_position = new FastVector3(x, y, 0);
		recalculatePVMatrix();
		return _position;
	}

	private function get_direction(): FastVector3 { return _direction; }
	private function set_direction(value:FastVector3): FastVector3 {
		_direction = value;
		recalculatePVMatrix();
		return _direction;
	}

	private var view:FastMatrix4;
	private var projection:FastMatrix4;
	private var pvMatrix:FastMatrix4;
	private var zoom:ZoomComponent;
	private var pan:PanComponent;

	public var boundsX:FastVector2;
	public var boundsY:FastVector2;

	

	public function new(debugEnabled:Bool, boundsX:FastVector2, boundsY:FastVector2) {
		zoom = new ZoomComponent(this);
		pan = new PanComponent(this, zoom);

		this.boundsX = boundsX;
		this.boundsY = boundsY;

		recalculatePVMatrix();
	}

	public function update(deltaTime:Float) {
		updatePosition(deltaTime);
		updateView();
	}

	public function getPVMatrix(): FastMatrix4 {
		return pvMatrix;
	}

	public function setProjection(projection:FastMatrix4) {
		this.projection = projection;

		recalculatePVMatrix();
	}

	private function recalculatePVMatrix() {
		updateView();

		pvMatrix = FastMatrix4.identity();
		pvMatrix = pvMatrix.multmat(projection);
		pvMatrix = pvMatrix.multmat(view);
	}

	private function updatePosition(deltaTime:Float): Void {
		pan.updatePosition(deltaTime);
	}

	private function updateView(): Void {
		view = FastMatrix4.lookAt(_position, // camera position
								  _position.add(_direction), // camera lookTo position
								  new FastVector3(0, 1, 0) // camera up vector
		);
	}
}