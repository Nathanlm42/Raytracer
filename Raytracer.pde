Camera camera;

color ray_color(Ray r, Hittable_list world, Interval ray_t, int max_depth)
{
	float red, green, blue;
	color color_pixel;

	if (max_depth == 0)
		return color(0, 0,0);
	Hit_record rec = new Hit_record();
	if (world.hit(r, ray_t, rec)){
		color emitted = rec.mat.emitted();
		Ray bounce = new Ray();
		if (!rec.mat.scatter(r, rec, bounce))
			return emitted;
		color_pixel = ray_color(bounce, world, ray_t, max_depth - 1);
		red = lineartogamma(red(color_pixel));
		green = lineartogamma(green(color_pixel));
		blue = lineartogamma(blue(color_pixel));
		color bounced = color(red*rec.attenuation.x,green*rec.attenuation.y,blue*rec.attenuation.z);
		return color(
			min(255, red(emitted) + red(bounced)),
			min(255, green(emitted) + green(bounced)),
			min(255, blue(emitted) + blue(bounced))
		);
	}
	Vect unit_direction = r.dir.normalized();
	float a = 0.5*(unit_direction.y + 1.0);
	return lerpColor(
		color(255, 255, 255),
		color(int(0.5*255.0), int(255.0*0.7), int(255*1.0)),
		a
	);
}
float lineartogamma(float component){
	float factor = component/255.0;
	return(sqrt(factor)*component);
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
	Material m1 = new lambertian(new Vect(0.8*255,0.8*255,0.8*255));
	Material m2 = new lambertian(new Vect(0.1*255, 0.2*255, 0.5 *255));
	Material m3 = new metal(new Vect(0.8*255,0.8*255,0.8*255), 0.3);
	Material m4 = new diffuse_light(color(255, 235, 200));
	world = new Hittable_list();
	world.add(new Sphere(0,0,-1,0.5, m1));
	world.add(new Sphere(0, -100.5, -1, 100, m2));
	world.add(new Sphere(-1, 1.25, -2, 1, m3));
	world.add(new Sphere(1, 1.25, -2, 0.5, m4));
	ray_t = new Interval(0.1, Float.POSITIVE_INFINITY);
	camera.pixel_sample = 10;
	camera.max_depth = 10;
	loadPixels();
	float start = millis();
	camera.render(world, ray_t);
	float stop = millis();
	println("temps écoulé : " + ((stop - start)/1000) + "s");
	updatePixels();
}