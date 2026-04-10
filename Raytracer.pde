Camera camera;

color ray_color(Ray r, Hittable_list world, Interval ray_t, int depth)
{
	if (depth <= 0)
		return color(0, 0, 0);

	Hit_record rec = new Hit_record();
	if (world.hit(r, ray_t, rec)){
		Vect scatter_direction = rec.normal.add(random_unit_vector());
		if (scatter_direction.norm() < 1e-8)
			scatter_direction = rec.normal;

		Ray scattered = new Ray(rec.p, scatter_direction);
		color bounce = ray_color(scattered, world, new Interval(0.001, ray_t.max), depth - 1);
		return color(red(bounce) * 0.5, green(bounce) * 0.5, blue(bounce) * 0.5);
	}
	Vect unit_direction = r.dir.normalized();
	float a = 0.5*(unit_direction.y + 1.0);
	return lerpColor(
		color(255, 255, 255),
		color(int(0.5*255.0), int(255.0*0.7), int(255*1.0)),
		a
	);
}
Vect randomvect(){
	return new Vect(random(-1,1), random(-1,1), random(-1,1));
	
}
Vect random_unit_vector(){
	while(true){
		Vect p = randomvect();
		float lensq = p.norm()*p.norm();
		if (lensq<=1)
			return p.div(sqrt(lensq)); 
	}
}

Vect randon_on_hemisphere(Vect normal)
{
	Vect on_unit_sphere = random_unit_vector();
	if (normal.dot(on_unit_sphere) > 0)
		return on_unit_sphere;
	else
		return on_unit_sphere.div(-1);
}

void settings()
{
	camera = new Camera();
	camera.aspect_ratio = 16.0/9.0;
	camera.image_width = 800;
	camera.initialize();
	size(camera.image_width, camera.image_height);
	noSmooth();
}
void setup()
{
	noLoop();
}

void draw()
{
	Interval ray_t;
	Hittable_list world;
	world = new Hittable_list();
	world.add(new Sphere(0,0,-1,0.5));
	world.add(new Sphere(0, -101, -1, 100));
	ray_t = new Interval(0, Float.POSITIVE_INFINITY);
	loadPixels();
	camera.render(world, ray_t);
	updatePixels();
}