package rendering;

import kha.math.FastMatrix4;
import gameObjects.Transform;

class InstancedRenderComponent {
	private var transform:Transform;



	public function new(transform:Transform) {
		this.transform = transform;
	}

	public function getModelMatrix(): FastMatrix4 {
		return transform.trs;
	}
}