// ball bounce yay

// fundamental units
double uTime = 100; // s
double uLength = 100; // m
double uMass = 100; // kg

double uVelocity = uLength / uTime; // m * s^-1
double uForce = uMass * uVelocity / uTime; // kg * m * s^-2

class Vector {
	double x, y;
	
	public Vector(double x, double y) {
		this.x = x;
		this.y = y;
	}
	
	public Vector add(Vector v) {
		return new Vector(this.x + v.x, this.y + v.y);
	}
	
	public Vector multiply(double scalar) {
		return new Vector(this.x * scalar, this.y * scalar);
	}
	
	public Vector divide(double scalar) {
		return new Vector(this.x / scalar, this.y / scalar);
	}
	
	public Vector clone() {
		return new Vector(this.x, this.y);
	}
	
	public String toString() {
		int rc = 100;
		return "(" + (double)Math.round(x * rc) / rc + " " + (double)Math.round(y * rc) / rc + ")";
	}
}

// F = ma
double drag = 0.01;

class Shape {
	Vector position, velocity = new Vector(0, 0);
	double mass;
	
	// forces
	Vector force = new Vector(0, 0);
	Vector groundNormal = new Vector(0, 0);
	Vector gravity = new Vector(0, 0);
	
	// ground
	Vector ground;
	
	public Shape(Vector p, Vector v, double m, double g) {
		position = p;
		velocity = v;
		mass = m;
		ground = new Vector(0, g);
	}
	
	public Vector totalForce() {
		return force.add(groundNormal).add(gravity);
	}
	
	public void update(double t) {
		Vector f = totalForce(); // kg * m * s^-2
		
		groundNormal.y = 0;
		
		if (position.y > ground.y) {
			velocity.y /= 2;
			groundNormal.y = -velocity.y / 5e4 * (uMass / uTime) * mass * (position.y - ground.y) / uLength; // basically what the line above used to do
			position.y = ground.y;
		}
		
		position = position.add(velocity);
		// F = m * a
		
		Vector v = f.divide(mass).multiply(t); // m * s^-1
		
		// v = u + a * t
		velocity = velocity
		.add(v)
			.multiply(1 - drag);
	}
	
	public void draw() {
		// debug
		int px = (int)(position.x / uLength);
		int py = (int)(position.y / uLength);
		int lw = 10;
		
		fill(255, 0, 0);
		stroke(255, 0, 0);
		strokeWeight(1);
		line(px - lw, py, px + lw, py);
		line(px, py - lw, px, py + lw);
		noStroke();
		
		fill(255);
		textSize(15);
		text("s " + position, px + 5, py - 20);
		text("v " + velocity, px + 5, py - 5);
	}
}

class Circle extends Shape {
	double radius;
	float colour;
	
	public Circle(Vector p, Vector v, double r, double g) {
		super(p, v, Math.PI * r * r * uMass, g);
		radius = r;
		colour = random(50, 150);
	}
	
	public void draw() {
		fill(colour);
		int r = (int)(radius / uLength);
		int px = (int)(position.x / uLength);
		int py = (int)(position.y / uLength);
		ellipse(px, py, r * 2, r * 2);
		
		super.draw();
	}
}

Circle[] shapes = new Circle[3];

void setup() {
	size(640, 480);
	double r;
	
	r = 80 * uLength;
	shapes[0] = new Circle(
		new Vector(35 * uLength, 65 * uLength),
		new Vector(1.2 * uLength, 0),
		r,
		height * uLength - r);
	
	r = 50 * uLength;
	shapes[1] = new Circle(
		new Vector(350 * uLength, 65 * uLength),
		new Vector(1.2 * uLength, 0),
		r,
		height * uLength - r);
	
	r = 35 * uLength;
	shapes[2] = new Circle(
		new Vector(550 * uLength,height * uLength - r),
		new Vector( -2.2 * uLength, 0),
		r,
		height * uLength - r);
}

double gForcePerMass = 0.6 * uForce / uMass; // Force per unit mass (m * s^-2)

void draw() {
	background(0);
	noStroke();
	
	for (Circle shape : shapes) {
		double gForce = gForcePerMass * shape.mass; // kg * m * s^-2
		shape.gravity = new Vector(0, gForce);
		
		shape.update(100 * uTime);
		shape.draw();
	}
}

