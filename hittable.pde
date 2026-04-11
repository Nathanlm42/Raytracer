class Hit_record
{
	Vect p; // Point de l'intersection
	Vect normal; // Normale de l'intersection
	float t; // distance entre origine et intersection
	boolean front_face;
	Material mat;
	Vect attenuation;

	void set_face_normal(Ray r, Vect outward_normal)
	{
		front_face = r.dir.dot(outward_normal)  < 0;
		normal = front_face ? outward_normal : outward_normal.m(-1);
	}
}

abstract class Hittable{
	Material mat;
	abstract boolean hit(Ray r, Interval ray_t,Hit_record rec);
	Hittable(Material m){
		mat = m;
	}
	Hittable()
	{
		mat = null;
	}
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
		boolean hit_anything = false; // determine si une touche a eu lieu
		float closest_so_far = ray_t.max; // point d'intersection le plus proche

		for (Hittable target : hittables) // Pour chaque objet touchable regarde si le rayon touche
		{
			if(target.hit(r, new Interval(ray_t.min, closest_so_far), temp_rec)){
				hit_anything = true;
				closest_so_far = temp_rec.t;
				rec.t = temp_rec.t;
				rec.p = temp_rec.p;
				rec.normal = temp_rec.normal;
				rec.front_face = temp_rec.front_face;
				rec.mat = temp_rec.mat;
			}
		}
		return hit_anything;
	}

}