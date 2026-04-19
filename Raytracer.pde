Camera camera;
import java.util.stream.IntStream;
import java.util.concurrent.ThreadLocalRandom;


color ray_color(Ray r, Hittable_list world, Interval ray_t, int max_depth)
{
	float red, green, blue;
	int color_pixel;

	if (max_depth == 0)
		return color(0, 0, 0);
	Hit_record rec = new Hit_record();
	if (world.hit(r, ray_t, rec)){
		Ray bounce = new Ray();
		if (rec.mat.scatter(r, rec, bounce))
			color_pixel = ray_color(bounce, world, ray_t, max_depth - 1);
		else 
			return (color(0,0,0));
		red = red(color_pixel);
		green = green(color_pixel);
		blue = blue(color_pixel);
		return color(red*rec.attenuation.x,green*rec.attenuation.y,blue*rec.attenuation.z);
	}
	Vect unit_direction = r.dir.normalized();
	float a = 0.5*(unit_direction.y + 1.0);
	return lerpColor(
		color(255, 255, 255),
		color(0.5*255.0, 255.0*0.7, 255.0),
		a
	);
}

void settings()
{
	camera = new Camera();
	camera.aspect_ratio = 16.0/9.0;
	camera.image_width = 800;
	camera.pixel_sample = 100;
	camera.max_depth = 50;
	camera.vfov = 20;
	camera.lookfrom = new Vect (-2,2,1);
	camera.lookat = new Vect(0, 0, -1);
	camera.vup = new Vect(0,1,0);
	camera.defocus_angle = 3.0;
	camera.focus_dist = 3.4;
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
	Hittable_list world = new Hittable_list();
	Material material_ground = new lambertian(new Vect(0.8*255.0, 0.8*255.0, 0.0));
	Material material_center = new lambertian(new Vect(0.1*255.0, 0.2*255.0, 0.5*255.0));
	Material material_left = new dielectric(1.00/1.55);
	Material material_right = new metal(new Vect(0.8*255.0, 0.6*255.0, 0.2*255.0), 1.0);
	Material material_up = new metal(new Vect(0.8*255.0, 0.8*255.0, 0.8*255.0),0.02);
	world.add(new Sphere(0.0, -100.5, -1.0, 100, material_ground));
	world.add(new Sphere(0.0, 0.0, -1.2, 0.5, material_center));
	world.add(new Sphere(-1.0, 0.09, -1.0, 0.5, material_left));
	world.add(new Sphere(1.0, 0.0, -1.0, 0.5, material_right));
	world.add(new Sphere(0.7, 0.90, -1.5, 0.5, material_up));
	world.add(new Sphere(0, 0.6, -1.0, 0.2, new dielectric(1.0/1.55)));
	ray_t = new Interval(0.1, Float.POSITIVE_INFINITY);
	loadPixels();
	float start = millis();
	camera.render(world, ray_t);
	float stop = millis();
	println("temps écoulé : " + ((stop - start)/1000) + "s");
	updatePixels();
}