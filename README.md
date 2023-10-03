# Roman Numeral Class for PHP and ASP

A class for working with Roman numerals. Supports values up to 999,999 and fractional values in 1/12 increments.

## Project Status

No further development is planned.

## Installation

### PHP

Place RomanNumeral.class.php in any location on your web server. For additional security, you may wish to place it in a location that isn't directly accessible by users, though attempts to access the library directly will generate a 404 error.

The file RomanNumeral.test.php is not required in order to use the library and does not need to be placed on the web server unless you want to run unit tests.

### ASP Classic

Place RomanNumeral.class.asp in any location on your web server, or on another machine on the same network. For additional security, you may wish to place it in a location that isn't directly accessible by users.

Optionally, you may register the Windows Script Component by right-clicking on the file in Windows Explorer and choosing Register.

The file RomanNumeral.test.asp is not required in order to use the library and does not need to be placed on the web server unless you want to run unit tests.

## Usage

### PHP

```PHP
// Change the path if you're storing the library in a different folder.
include 'RomanNumeral.class.php';

// Feel free to alias the class so that you don't need to type my name every time you use it.
use ScottVM\RomanNumeral as RomanNumeral;

// Create a Roman numeral
$currentYear = new RomanNumeral();
$currentYear->set_value(2023);

// Displays 'MMXXIII'
echo $currentYear->get_roman_value();

// Displays 2023
echo $currentYear->get_arabic_value();

// Add 10 to the currentYear using Roman numerals.
$currentYear->add("X");

// Displays 'MMXXXIII'
echo $currentYear->get_roman_value();
```

### ASP Classic

```vbscript
<!--#include file="RomanNumeral.class.asp"-->
<%
' Create a Roman numeral
dim currentYear
set currentYear = new RomanNumeral
currentYear.value = 2023

' Displays 'MMXXIII'
Response.Write currentYear.romanValue

' Add 10 to the currentYear using Roman numerals.
currentYear.Add("X")

' Displays 'MMXXXIII'
Response.Write currentYear.romanValue
%>
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

See RomanNumeral.test.php or RomanNumeral.test.asp for unit tests.

## Authors

Version 1.0 written March 2008 by Scott Vander Molen

Version 1.1 written August 2008 by Scott Vander Molen - added support for large numbers

Version 1.2 written September 2010 by Scott Vander Molen and Keith Alexander - added validation function

Version 2.0 written October 2023 by Scott Vander Molen - conversion to class object, bug fix for fractional values, and improved support for large numbers

## License
This work is licensed under a [Creative Commons Attribution 4.0 International License](https://creativecommons.org/licenses/by/4.0/).
