class Camera{
	float aspect_ratio = 1.0;
	int image_width = 100;
	int pixel_sample = 1;
	float invpixel_sample;
	int max_depth = 10;
	float vfov = 20;
	int image_height;
	Vect lookfrom = new Vect(0,0,0);
	Vect lookat = new Vect(0,0,-1);
	Vect vup;
	float defocus_angle = 1.0;
	float focus_dist = 3.4;
	Vect focus_disk_u;
	Vect focus_disk_v;
	private Vect center;
	Hittable_list renderworld;
	Interval renderray_t;
	private Vect pixel00_loc;
	private Vect pixel_delta_u;
	private Vect pixel_delta_v;
	private Vect u, v, w; // u : x, v : y, w :z

	void render(Hittable_list world, Interval ray_t){
	renderworld = world;
	renderray_t = ray_t;
	for(int j = 0; j < image_height; j ++){
		for (int i = 0; i < image_width; i ++)
		{
			Vect pixel_center = pixel00_loc.add(pixel_delta_u.m(i)).add(pixel_delta_v.m(j));
			antialiasing(pixel_center, i, j);
		}
	}
}
	void antialiasing(Vect pixel_center, int i, int j)
	{
		float red = 0;
		float green = 0;
		float blue = 0;
		for (int k = 0; k < pixel_sample; k ++)
		{
			Vect tmp_pixel_center = pixel_center.copy();
			float offsetx = ThreadLocalRandom.current().nextFloat(-1.0, 1.0);
			float offsety = ThreadLocalRandom.current().nextFloat(-1.0, 1.0);
			tmp_pixel_center = tmp_pixel_center.add(pixel_delta_u.m(offsetx)).add(pixel_delta_v.m(offsety));
			Vect ray_origin = defocus_disk_sample();
			Vect ray_direction = tmp_pixel_center.sub(ray_origin);
			Ray r = new Ray(ray_origin, ray_direction);
			color sample_color = ray_color(r, renderworld, renderray_t, max_depth);
			red += red(sample_color);
			green += green(sample_color);
			blue += blue(sample_color);
		}
		PutPixel(i, j, color(red * invpixel_sample, green * invpixel_sample, blue * invpixel_sample));
	}
	void initialize(){
		image_height = int(image_width/aspect_ratio);
		image_height = (image_height < 1) ? 1 : image_height;
		center = lookfrom;
		invpixel_sample = 1.0/float(pixel_sample);
		println(invpixel_sample);
		float theta = radians(vfov);
		float h = tan(theta/2);
		float viewport_height = 2.0 * h * focus_dist;
		float viewport_width = viewport_height*(float(image_width)/image_height);
		w = lookfrom.sub(lookat).normalized();
		u = vup.cross(w).normalized();
		v = w.cross(u);
		float defocus_disk_radius = focus_dist * tan(radians(defocus_angle/2));
		focus_disk_u = u.m(defocus_disk_radius);
		focus_disk_v = v.m(defocus_disk_radius);
		Vect viewport_u = u.m(viewport_width);
		Vect viewport_v = v.m(-1).m(viewport_height);
		pixel_delta_u = viewport_u.div(image_width);
		pixel_delta_v = viewport_v.div(image_height);
		Vect viewport_upper_left = center.sub(w.m(focus_dist)).sub(viewport_u.div(2)).sub(viewport_v.div(2));
		pixel00_loc = viewport_upper_left.add(pixel_delta_u.add(pixel_delta_v).m(0.5));
	}

	void PutPixel(int x, int y, color pixel_color){
		int i = y*image_width + x;
		pixels[i] = pixel_color;
	}

	Vect defocus_disk_sample(){
		Vect p = random_unit_vector();
		return center.add(focus_disk_u.m(p.x)).add(focus_disk_v.m(p.y));
	}
}