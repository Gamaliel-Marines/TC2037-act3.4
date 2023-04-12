/*
==============================================
    ||Gamaliel Marines Olvera A01708746 ||
==============================================
*/

// This program asks the user to input the lower and upper limits of the integral, 
// as well as the number of intervals to use for the trapezoidal rule. It then calculates 
// the width of each interval and uses a loop to calculate the sum of the function at the 
// midpoints of each interval. Finally, it uses the trapezoidal rule formula to calculate 
// the result of the integral and displays it to the user.

// Note that you'll need to modify the Function method to use the function you want to integrate.

using System;

class Program
{
    static void Main(string[] args)
    {
        Console.WriteLine("Enter the lower limit of the integral:");
        double lowerLimit = double.Parse(Console.ReadLine());

        Console.WriteLine("Enter the upper limit of the integral:");
        double upperLimit = double.Parse(Console.ReadLine());

        Console.WriteLine("Enter the number of intervals:");
        int intervals = int.Parse(Console.ReadLine());

        double intervalWidth = (upperLimit - lowerLimit) / intervals;
        double sum = 0;

        for (int i = 1; i < intervals; i++)
        {
            double x = lowerLimit + i * intervalWidth;
            sum += Function(x);
        }

        double result = intervalWidth * (0.5 * (Function(lowerLimit) + Function(upperLimit)) + sum);
        Console.WriteLine("The result of the integral is: " + result);
    }

    static double Function(double x)
    {
        // Insert the function you want to integrate here
        return x * x;
    }
}
