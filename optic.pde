
Vect refract(Vect uv, Vect n, float etai_over_etat, float cos_theta){

	Vect r_out_perp = uv.add(n.m(cos_theta)).m(etai_over_etat);
	Vect r_out_parallel = n.m(-1*sqrt(abs(1.0 - r_out_perp.squarednorm())));
	return r_out_perp.add(r_out_parallel);
}

Vect reflect(Vect v, Vect n){
		return v.sub(n.m(2*n.dot(v)));
	}

float schlick(float R_0, float cos_theta){
	R_0 *= R_0;
	return (R_0 + (1.0 - R_0)*pow((1 - cos_theta), 5)); 
}