class Interval
{
	float min, max;

	Interval(float min, float max)
	{
		this.min = min;
		this.max = max;
	}
	
	float size(){
		return max - min;
	}
	boolean contains(float x){
		return min <= x && x <= max;
	}
	boolean surround(float x){
		return min < x && x < max;
	}
}