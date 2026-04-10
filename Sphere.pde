class Sphere extends Hittable
{
	Vect center;
	float radius;

	Sphere(int x, int y, int z, float radius)
	{
		this.center = new Vect(x,y,z);
		this.radius = radius;
	}

	@Override
	boolean hit(Ray r, Interval ray_t, Hit_record rec)
	{
		Vect oc = center.sub(r.orig);
		float a = r.dir.norm()*r.dir.norm();
		float h = r.dir.dot(oc);
		float c = oc.norm()*oc.norm() - radius*radius;
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
		return true;
	}
} 