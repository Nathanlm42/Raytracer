class Ray
{
	Vect orig;
	Vect dir;

	Ray (Vect origin, Vect direction) // ray constructor
	{
		orig = origin.copy();
		dir = direction.copy();
	}

	Vect at (float t) // Ray moving function
	{
		// Static ops return a new vector and keep orig/dir unchanged.
		return orig.add(dir.m(t));
	}
}