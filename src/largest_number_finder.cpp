/*
 * largest_number_finder.cpp
 * ----------------------------------------------------------------------------
 * Finds the largest of a stream of numbers using a sentinel-controlled
 * do-while loop.
 *
 *   - The user keeps entering numbers; entering a NEGATIVE number ends input.
 *   - A running maximum starts at -1e9 and is updated whenever a larger
 *     value is read.
 *   - The terminating negative number is also compared against the running
 *     maximum before the loop condition is tested (see README for the
 *     consequences).
 *
 * Build : g++ -std=c++17 -Wall -Wextra -pedantic -o bin/largest_number_finder src/largest_number_finder.cpp
 * Run   : ./bin/largest_number_finder
 * ----------------------------------------------------------------------------
 */
#include <iostream>
using namespace std;

int main() {
    double largestNumber = -1e9; // Initialize to negative infinity
    double num;

    cout << "Enter numbers (enter a negative number to stop):\n";
    do {
        cin >> num;
        if (num > largestNumber) {
            largestNumber = num;
        }
    } while (num >= 0);

    cout << "Largest number: " << largestNumber << endl;

    return 0;
}
