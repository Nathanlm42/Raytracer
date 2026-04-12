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

class dielectric extends Material{
	float refraction_index;
	
	dielectric(float refraction_index){
		this.refraction_index = refraction_index;
	}


	boolean scatter(Ray r, Hit_record rec, Ray scattered){
		float ri = rec.front_face ? (1.0/refraction_index) : refraction_index;
		scattered.orig = rec.p;
		scattered.dir = refract(r.dir.normalized(), rec.normal, ri);
		rec.attenuation = new Vect(1.0, 1.0, 1.0);
		return true;
	}
}
Vect refract(Vect uv, Vect n, float etai_over_etat){
	float cos_theta = min(uv.m(-1).dot(n), 1.0);
	float sin_theta = sqrt(1.0 - cos_theta*cos_theta);

	if (etai_over_etat*sin_theta <= 1.0)
		reflect(uv, n);
	Vect r_out_perp = uv.add(n.m(cos_theta)).m(etai_over_etat);
	Vect r_out_parallel = n.m(-1*sqrt(abs(1.0 - r_out_perp.squarednorm())));
	return r_out_perp.add(r_out_parallel);
}

Vect reflect(Vect v, Vect n){
		return v.sub(n.m(2*n.dot(v)));
	}