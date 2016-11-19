#include <stdio.h>

// Slope of a line defined by two points: (x1, y1) and (x2, y2)
// Slope is floored because the return type is int.

int slope (int x1, int y1, int x2, int y2) {
	int num = y2 - y1;
	int den = x2 - x1;
	return num / den;
}

int main () {
	int s = slope (0, 0, 3, 6);
	printf("%d", s);
	return s;
}