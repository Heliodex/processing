// ball bounce yay

PVector location = new PVector(100,100);
PVector velocity = new PVector(1.5, 2.1);
PVector gravity = new PVector(0, 0.2);

int radius = 25;

void setup() {
	size(640,360);
}

void draw() {
	background(0);
	
	location.add(velocity);
	velocity.add(gravity);
	
	// Bounce off edges
	if (location.x + radius > width || location.x - radius < 0)
		velocity.x *= - 1;

	if (location.y + radius > height) {
		velocity.y *= - 0.9; 
		location.y = height - radius;
	}
	
	// Display circle at location vector
	fill(127);
	ellipse(location.x,location.y, radius * 2, radius * 2);

	fill(255);
	textSize(20);
	text("Location: " + location, 10, 50);
}

