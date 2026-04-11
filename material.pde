abstract class Material{
	abstract boolean scatter(Ray r, Hit_record rec, Ray scattered);
}

class lambertian extends Material{
	Vect albedo;

	lambertian (Vect attenuation)
	{
		attenuation = attenuation.div(255);
		this.albedo = attenuation;
	}

	@Override
	boolean scatter(Ray r, Hit_record rec, Ray scattered){
		scattered.dir = rec.normal.add(random_on_hemisphere(rec.normal));
		scattered.orig = rec.p;
		rec.attenuation = albedo;
		return true;

	}
}

class metal extends Material{
	Vect albedo;
	float fuzz;

	metal (Vect attenuation, float fuzz){
		attenuation = attenuation.div(255);
		albedo = attenuation;
		this.fuzz = fuzz < 1 ? fuzz :1;
	}

	@Override
	boolean scatter(Ray r, Hit_record rec, Ray scattered){
		scattered.dir = reflect(r.dir,rec.normal);
		scattered.dir = scattered.dir.normalized().add(random_unit_vector().m(fuzz));
		scattered.orig = rec.p;
		rec.attenuation = albedo;
		return true;
	}
}
	Vect reflect(Vect v, Vect n){
		return v.sub(n.m(2*n.dot(v)));
	}