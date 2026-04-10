class Hit_record
{
	Vect p;
	Vect normal;
	float t;
	boolean front_face;

	void set_face_normal(Ray r, Vect outward_normal)
	{
		front_face = r.dir.dot(outward_normal)  < 0;
		normal = front_face ? outward_normal : outward_normal.m(-1);
	}
}

abstract class Hittable{
	abstract boolean hit(Ray r, Interval ray_t,Hit_record rec);
}

class Hittable_list extends Hittable
{
	ArrayList<Hittable> hittables; // Liste des élèments touchable

	Hittable_list(){
		hittables = new ArrayList<Hittable>();
	}

	void add(Hittable object){
		hittables.add(object);
	}

	

	boolean hit(Ray r, Interval ray_t, Hit_record rec)
	{
		Hit_record temp_rec = new Hit_record();
		boolean hit_anything = false;
		float closest_so_far = ray_t.max;

		for (Hittable target : hittables)
		{
			if(target.hit(r, new Interval(ray_t.min, closest_so_far), temp_rec)){
				hit_anything = true;
				closest_so_far = temp_rec.t;
				rec.t = temp_rec.t;
				rec.p = temp_rec.p;
				rec.normal = temp_rec.normal;
				rec.front_face = temp_rec.front_face;

			}
		}
		return hit_anything;
	}

}