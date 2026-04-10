float ratio = 16.0/9.0;
int image_width = 400;
int image_height = int (image_width/ratio);
float focal_length = 1.0; // distance entre la caméra et le viewport
float viewport_height = 2.0;
float viewport_width = viewport_height*float(image_width)/float(image_height);
Vect camera_center = new Vect(0,0,0);
Vect viewport_u = new Vect(viewport_width, 0, 0);
Vect viewport_v = new Vect(0, -viewport_height, 0);
Vect pixel_delta_u = viewport_u.div(image_width);
Vect pixel_delta_v = viewport_v.div(image_height);
Vect viewport_upper_left = camera_center.sub(new Vect(0, 0, focal_length)).sub(viewport_u.div(2)).sub(viewport_v.div(2));
Vect pixel00_loc = viewport_upper_left.add(pixel_delta_u.add(pixel_delta_v).div(0.5));

float hit_sphere (Vect center, float radius, Ray r)
{
	Vect oc = center.sub(r.orig);
	float a = r.dir.norm()*r.dir.norm();
	float h = r.dir.dot(oc);
	float c = oc.norm()*oc.norm() - radius*radius;
	float discriminant = h*h - a*c;
	if (discriminant < 0)
		return -1.0;
	else
		return (h -sqrt(discriminant)) /a;
}
color ray_color(Ray r)

{
	float t = hit_sphere(new Vect(0,0,-1), 0.5, r);
	if (t > 0.0){
		Vect normal = r.at(t).sub(new Vect(0,0,-1)).normalized();
		float red = 0.5 * (normal.x + 1.0);
		float g = 0.5 * (normal.y + 1.0);
		float b = 0.5 * (normal.z + 1.0);
		return color(red * 255, g * 255, b * 255);
	}
	Vect unit_direction = r.dir.normalized();
	float a = 0.5*(unit_direction.y + 1.0);
	return lerpColor(
		color(255, 255, 255),
		color(int(0.5*255.0), int(255.0*0.7), int(255*1.0)),
		a
	);
}

void settings()
{
	size(image_width, image_height);
}
void setup()
{
	loadPixels();
	noLoop();
	for (int j = 0; j < image_height; j ++)
	{
		for (int i = 0; i < image_width; i ++)
		{
			Vect pixel_center = pixel00_loc.add(pixel_delta_u.m(i)).add(pixel_delta_v.m(j));
			Vect ray_direction = pixel_center.sub(camera_center);
			Ray r = new Ray(camera_center, ray_direction);
			color pixel_color = ray_color(r);
			PutPixel(i,j,pixel_color);
		}
	}
	updatePixels();
}
void PutPixel(int x, int y, color pixel_color)
{
	int i = y*image_width + x;
	pixels[i] = pixel_color;
}
void draw()
{

}