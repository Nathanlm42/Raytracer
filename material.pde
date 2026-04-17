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
	float cos_theta = r.dir.m(-1).dot(rec.normal);
	float sin_theta = sqrt(1.0 - cos_theta*cos_theta);
	float ri = rec.front_face ? (1.0/refraction_index) : refraction_index;
	float R_0 = (1 - refraction_index)/ (1 + refraction_index);

	if (ri*sin_theta < 1.0 || schlick(R_0, cos_theta) >  random(0,1))
		reflect(r.dir, rec.normal);
	scattered.orig = rec.p;
	scattered.dir = refract(r.dir.normalized(), rec.normal, ri, cos_theta);
	rec.attenuation = new Vect(1.0, 1.0, 1.0);
	return true;
	}
}
