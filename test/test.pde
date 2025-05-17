// ball bounce yay

// fundamental units
double uTime = 1; // s
double uLength = 1; // m
double uMass = 1; // kg

double uVelocity = uLength / uTime; // m * s^-1
double uForce = uMass * uVelocity / uTime / uTime; // kg * m * s^-2

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

	public Shape(Vector p, Vector v, double m) {
		position = p;
		velocity = v;
		mass = m;
	}

	public Vector totalForce() {
		return force.add(groundNormal).add(gravity);
	}

	public void update() {
		position = position.add(velocity);
		// F = m * a

		Vector f = totalForce(); // kg * m * s^-2
		Vector a = f.divide(mass); // m * s^-2

		// v = u + a * t
		velocity = velocity.add(a.multiply(uTime)); // m * s^-1

		velocity = velocity.multiply(1 - drag);
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
		text("p " + position, px + 5, py - 20);
		text("v " + velocity, px + 5, py - 5);
	}
}

class Circle extends Shape {
	double radius;
	float colour;

	public Circle(Vector p, Vector v, double r) {
		super(p, v, Math.PI * r * r * uMass);
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
	size(640, 360);

	shapes[0] = new Circle(
		new Vector(35 * uLength, 65 * uLength),
		new Vector(1.2 * uLength, 0),
		80 * uLength);

	shapes[1] = new Circle(
		new Vector(350 * uLength, 65 * uLength),
		new Vector(1.2 * uLength, 0),
		50 * uLength);

	double r = 35 * uLength;
	shapes[2] = new Circle(
		new Vector(550 * uLength,height * uLength - r),
		new Vector( -1 * uLength, 0),
		r);
}

double gForce = 0.6 * uForce; // Force per unit mass

void draw() {
	background(0);
	noStroke();

	for (Circle shape : shapes) {

		shape.update();

		shape.gravity = new Vector(0, gForce * shape.mass); // m * s^-2

		double bottom = (height * uLength) - shape.radius;
		double py = shape.position.y;
		if (py > bottom) {
			// shape.position.y = bottom; // reset position to bottom
			shape.velocity.y *= -0.3; // bounce with some energy loss
			shape.groundNormal = new Vector(0,(bottom - py) * 500 * uForce);
		} else {
			shape.groundNormal = new Vector(0, 0);
		}

		shape.draw();
	}
}

