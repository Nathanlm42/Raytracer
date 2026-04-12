class Vect
{
  float x;
  float y;
  float z;
  Vect(float x, float y, float z) // Constructeur
  {
    this.x = x;
    this.y = y;
    this.z = z;
  }
  Vect copy()
  {
	return new Vect(x,y,z);
  }
  float distvect(Vect u)
  {
    return (dist (x, y, z, u.x, u.y, u.z));
  }
  float squarednorm(){
    return (x*x + y*y + z*z);
  }
  float distance(Vect u)
  {
    return distvect(u);
  }
  Vect add(Vect u)
  {
    return(new Vect(this. x + u.x, this.y + u.y, this.z + u.z));
  }
  Vect sub(Vect u)
  {
    return(new Vect(this.x - u.x, this.y - u.y, this.z - u.z));
  }
  Vect m(float a)
  {
    return scale(a);
  }
  Vect div (float a)
  {
	return scale(1/a);
  }
  Vect scale(float a)
  {
    return (new Vect(this.x * a, this.y * a, this.z * a));
  }
  float ps(Vect u)
  {
    return dot(u);
  }
  float dot(Vect u)
  {
    return(this.x * u.x + this.y * u.y + this.z * u.z);
  }
  float norm()
  {
    return (sqrt(pow(this.x, 2) + pow(this.y, 2) + pow(this.z, 2)));
  }
  void normalize()
  {
    float n = norm();
    if (n == 0)
      return;
    x /= n;
    y /= n;
    z /= n;
  }
  Vect normalized()
  {
    Vect v = new Vect(this.x, this.y, this.z);
    v.normalize();
    return v;
  }
  String toString()
  {
    return("x : " + this.x + '\n' + "y : " + this.y + '\n' + "z : " + this.z);
  }
}

Vect randomvect(){
	return new Vect(ThreadLocalRandom.current().nextFloat(-1.0, 1.0), ThreadLocalRandom.current().nextFloat(-1.0, 1.0), random(-1,1));
	
}
Vect random_unit_vector(){
	while(true){
		Vect p = randomvect();
		float lensq = p.squarednorm();
		if (lensq<=1.0f && lensq > 1e-8f)
			return p.div(sqrt(lensq)); 
	}
}