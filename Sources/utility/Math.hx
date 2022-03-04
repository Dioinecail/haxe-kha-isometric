package utility;

class Math {
	public static function clamp(x:Float, min:Float, max:Float):Float {
		if(x < min) {
			return min;
		} else if (x > max) {
			return max;
		} else {
			return x;
		}
	}
}