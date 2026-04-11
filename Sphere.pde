class Sphere extends Hittable
{
	Vect center;
	float radius;
	Material m;
	Sphere(float x, float y, float z, float radius, Material mat)
	{
		this.center = new Vect(x,y,z);
		this.radius = radius;
		m = mat;
	}

	@Override
	boolean hit(Ray r, Interval ray_t, Hit_record rec)
	{
		Vect oc = center.sub(r.orig);
		float a = r.dir.squarednorm();
		float h = r.dir.dot(oc);
		float c = oc.squarednorm() - radius*radius;
		float discriminant = h*h - a*c;
		if (discriminant < 0)
			return false;
		float sqrtd = sqrt(discriminant);

		float root = (h - sqrtd)/a;
		if (root <= ray_t.min || ray_t.max <= root){
			root = (h + sqrtd)/a;
			if (root <= ray_t.min || ray_t.max <= root)
				return false;
		}
		rec.t = root;
		rec.p = r.at(rec.t);
		Vect outward_normal = (rec.p.sub(center).div(radius));
		rec.set_face_normal(r, outward_normal);
		rec.mat = m;
		return true;
	}
}

Vect random_on_hemisphere(Vect normal)
{
	Vect on_unit_sphere = random_unit_vector();
	if (normal.dot(on_unit_sphere) > 0)
		return on_unit_sphere;
	else
		return on_unit_sphere.div(-1);
}