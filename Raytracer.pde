Camera camera;
import java.util.stream.IntStream;
import java.util.concurrent.ThreadLocalRandom;

int clamp255(float value) {
	if (value < 0) return 0;
	if (value > 255) return 255;
	return int(value + 0.5);
}

int rgb_safe(float r, float g, float b) {
	int ri = clamp255(r);
	int gi = clamp255(g);
	int bi = clamp255(b);
	return (255 << 24) | (ri << 16) | (gi << 8) | bi;
}

float red_safe(int c) {
	return float((c >> 16) & 0xFF);
}

float green_safe(int c) {
	return float((c >> 8) & 0xFF);
}

float blue_safe(int c) {
	return float(c & 0xFF);
}

int lerp_color_safe(int c1, int c2, float t) {
	float k = constrain(t, 0.0, 1.0);
	float inv = 1.0 - k;
	float r = red_safe(c1) * inv + red_safe(c2) * k;
	float g = green_safe(c1) * inv + green_safe(c2) * k;
	float b = blue_safe(c1) * inv + blue_safe(c2) * k;
	return rgb_safe(r, g, b);
}

color ray_color(Ray r, Hittable_list world, Interval ray_t, int max_depth)
{
	float red, green, blue;
	int color_pixel;

	if (max_depth == 0)
		return rgb_safe(0, 0, 0);
	Hit_record rec = new Hit_record();
	if (world.hit(r, ray_t, rec)){
		Ray bounce = new Ray();
		rec.mat.scatter(r, rec, bounce);
		color_pixel = ray_color(bounce, world, ray_t, max_depth - 1);
		red = lineartogamma(red_safe(color_pixel));
		green = lineartogamma(green_safe(color_pixel));
		blue = lineartogamma(blue_safe(color_pixel));
		return rgb_safe(red*rec.attenuation.x,green*rec.attenuation.y,blue*rec.attenuation.z);
	}
	Vect unit_direction = r.dir.normalized();
	float a = 0.5*(unit_direction.y + 1.0);
	return lerp_color_safe(
		rgb_safe(255, 255, 255),
		rgb_safe(0.5*255.0, 255.0*0.7, 255.0),
		a
	);
}
float lineartogamma(float component){
	return (component);
}

void settings()
{
	camera = new Camera();
	camera.aspect_ratio = 16.0/9.0;
	camera.image_width = 1920;
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
	Material material_ground = new lambertian(new Vect(0.8*255, 0.8*255, 0.0));
	Material material_center = new lambertian(new Vect(0.1*255, 0.2*255, 0.5*255));
	Material material_left = new dielectric(1.00/1.33);
	Material material_right = new metal(new Vect(0.8*255, 0.6*255, 0.2*255), 1.0);
	Material material_up = new metal(new Vect(0.8*255, 0.8*255, 0.8*255),0.02);
	world.add(new Sphere(0.0, -100.5, -1.0, 100, material_ground));
	world.add(new Sphere(0.0, 0.0, -1.2, 0.5, material_center));
	world.add(new Sphere(-1.0, 0.09, -1.0, 0.5, material_left));
	world.add(new Sphere(1.0, 0.0, -1.0, 0.5, material_right));
	world.add(new Sphere(0.7, 0.90, -1.5, 0.5, material_up));
	ray_t = new Interval(0.1, Float.POSITIVE_INFINITY);
	camera.pixel_sample = 500;
	camera.max_depth = 500;
	loadPixels();
	float start = millis();
	camera.render(world, ray_t);
	float stop = millis();
	println("temps écoulé : " + ((stop - start)/1000) + "s");
	updatePixels();
}