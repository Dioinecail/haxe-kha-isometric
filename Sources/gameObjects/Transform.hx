package gameObjects;

import kha.math.FastMatrix4;
import kha.math.FastVector3;

class Transform {

	// POSITION
	private var _position: FastVector3;
	public var position (get, set): FastVector3;

	private function get_position(): FastVector3{
		return _position;
	}

	private function set_position(value:FastVector3): FastVector3 {
		_position = value;
		recalculateMatrix();
		return _position;
	}

	// ROTATION
	private var _rotation: FastVector3;
	public var rotation (get, set): FastVector3;

	private function get_rotation(): FastVector3 {
		return _rotation;
	}
	private function set_rotation(value: FastVector3): FastVector3 {
		_rotation = value;
		recalculateMatrix();

		return _rotation;
	}

	// SCALE
	private var _scale: FastVector3;
	public var scale (get, set): FastVector3;

	private function get_scale(): FastVector3 {
		return _scale;
	}

	private function set_scale(value: FastVector3): FastVector3 {
		_scale = value;
		recalculateMatrix();
		return _scale;
	}

	// TRS MATRIX
	private var _trs:FastMatrix4;
	public var trs (get, never):FastMatrix4;

	private function get_trs():FastMatrix4 {
		return _trs;
	}


	public function new(position:FastVector3, rotation:FastVector3, scale:FastVector3) {
		_position = position;
		_rotation = rotation;
		_scale = scale;
		recalculateMatrix();
	}

	private function recalculateMatrix() {
		_trs = FastMatrix4.identity();
		_trs = _trs.multmat(FastMatrix4.translation(_position.x, _position.y, _position.z));
		_trs = _trs.multmat(FastMatrix4.rotation(_rotation.z, _rotation.y, _rotation.x));
		_trs = _trs.multmat(FastMatrix4.scale(_scale.x, _scale.y, _scale.z));
	}
}