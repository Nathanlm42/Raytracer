class Camera{
	float aspect_ratio = 1.0;
	int image_width = 100;
	int image_height;
	private Vect center;
	Hittable_list renderworld;
	Interval renderray_t;
	private Vect pixel00_loc;
	private Vect pixel_delta_u;
	private Vect pixel_delta_v;
	int pixel_sample = 1;
	int max_depth = 10;

	void render(Hittable_list world, Interval ray_t){
	renderworld = world;
	renderray_t = ray_t;
	IntStream.range(0, image_height).parallel().forEach( j ->{
		for (int i = 0; i < image_width; i ++)
		{
			Vect pixel_center = pixel00_loc.add(pixel_delta_u.m(i)).add(pixel_delta_v.m(j));
			antialiasing(pixel_center, i, j);
		}});
	}
	void antialiasing(Vect pixel_center, int i, int j)
	{
		float red = 0;
		float green = 0;
		float blue = 0;
		for (int s = 0; s < pixel_sample; s ++)
		{
			Vect tmp_pixel_center = pixel_center.copy();
			float offsetx = ThreadLocalRandom.current().nextFloat(-1.0, 1.0);
			float offsety = ThreadLocalRandom.current().nextFloat(-1.0, 1.0);
			tmp_pixel_center = tmp_pixel_center.add(pixel_delta_u.m(offsetx)).add(pixel_delta_v.m(offsety));
			Vect ray_direction = tmp_pixel_center.sub(center);
			Ray r = new Ray(center, ray_direction);
			color sample_color = ray_color(r, renderworld, renderray_t, max_depth);
			red += red_safe(sample_color);
			green += green_safe(sample_color);
			blue += blue_safe(sample_color);
		}
		PutPixel(i, j, rgb_safe(red / pixel_sample, green / pixel_sample, blue / pixel_sample));
	}
	void initialize(){
		image_height = int(image_width/aspect_ratio);
		image_height = (image_height < 1) ? 1 : image_height;
		center = new Vect(0,0,0);
		float focal_lenght = 1;
		float viewport_height = 2.0;
		float viewport_width = viewport_height*(float(image_width)/image_height);
		Vect viewport_u = new Vect(viewport_width, 0, 0);
		Vect viewport_v = new Vect(0, -viewport_height, 0);
		pixel_delta_u = viewport_u.div(image_width);
		pixel_delta_v = viewport_v.div(image_height);
		Vect viewport_upper_left = center.sub(new Vect(0,0, focal_lenght)).sub(viewport_u.div(2)).sub(viewport_v.div(2));
		pixel00_loc = viewport_upper_left.add(pixel_delta_u.add(pixel_delta_v).m(0.5));
	}

	void PutPixel(int x, int y, color pixel_color){
		int i = y*image_width + x;
		pixels[i] = pixel_color;
	}
}