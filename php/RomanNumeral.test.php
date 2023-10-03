<?php
	/**
	* PHP Roman Numeral Class Unit Tests
	* 
	* Copyright (c) 2023, Scott Vander Molen; some rights reserved.
	* 
	* This work is licensed under a Creative Commons Attribution 4.0 International License.
	* To view a copy of this license, visit https://creativecommons.org/licenses/by/4.0/
	* 
	* @author  Scott Vander Molen
	* @version 2.0
	* @since   2023-10-02
	*/
	
	// Change debugmode to true if you need to see error messages.
	$debugmode = false;
	if ($debugmode)
	{
		// Allow the display of errors during debugging.
		ini_set('display_errors', 1);
		ini_set('display_startup_errors', 1);
		error_reporting(E_ALL);
	}
	
	echo "<pre>";
	echo "/***************************************************************************************\\\n";
	echo "| PHP RomanNumeral Class Unit Tests                                                     |\n";
	echo "|                                                                                       |\n";
	echo "| Copyright (c) 2023, Scott Vander Molen; some rights reserved.                         |\n";
	echo "|                                                                                       |\n";
	echo "| This work is licensed under a Creative Commons Attribution 4.0 International License. |\n";
	echo "| To view a copy of this license, visit https://creativecommons.org/licenses/by/4.0/    |\n";
	echo "|                                                                                       |\n";
	echo "\***************************************************************************************/\n";
	echo "</pre>";

	include 'RomanNumeral.class.php';
	use ScottVM\RomanNumeral as RomanNumeral;
	
	if (!class_exists('ScottVM\RomanNumeral'))
	{
		die('Could not find RomanNumeral class! Did you set the path correctly?');
	}
	
	/*
	* Creates a Roman numeral from an Arabic number.
	* 
	* @param input The desired value of the Roman numeral
	* @param expected The expected Roman numeral.
	* @return boolean Whether the result matched the expectation.
	*/
	function testRomanValue($input, $expected)
	{
		$testNumeral = new RomanNumeral();
		$testNumeral->set_value($input);
		
		$actual = $testNumeral->get_value_roman();
		$result = $actual == $expected;
		
		echo "Unit Test: get_value_roman()\n";
		echo "Input:     " . $input . "\n";
		echo "Expected:  " . $expected . "\n";
		echo "Actual:    " . $actual . "\n";
		echo "Result:    Test " . ($result ? "successful" : "failed") . "!\n\n";
		
		return $result;
	}
	
	/*
	* Creates a Roman numeral from a string and checks the Arabic value.
	* 
	* @param input The desired value of the Roman numeral
	* @param expected The expected Roman numeral.
	* @return boolean Whether the result matched the expectation.
	*/
	function testArabicValue($input, $expected)
	{
		$testNumeral = new RomanNumeral();
		$testNumeral->set_value($input);
		
		$actual = $testNumeral->get_value_arabic();
		$result = $actual == $expected;
		
		echo "Unit Test: get_value_arabic()\n";
		echo "Input:     " . $input . "\n";
		echo "Expected:  " . $expected . "\n";
		echo "Actual:    " . $actual . "\n";
		echo "Result:    Test " . ($result ? "successful" : "failed") . "!\n\n";
		
		return $result;
	}
	
	/*
	* Tests addition
	*
	* @param firstValue The initial value of the Roman numeral.
	* @param secondValue The value to add to the Roman numeral.
	* @param expected The expected result of the addition.
	* @return boolean Whether the result matched the expectation.
	*/
	function testAddition($firstValue, $secondValue, $expected)
	{
		$testNumeral = new RomanNumeral();
		$testNumeral->set_value($firstValue);
		$testNumeral->add($secondValue);
		
		$actual = $testNumeral->get_value_roman();
		$result = $actual == $expected;
		
		echo "Unit Test: add()\n";
		echo "Input:     " . $firstValue . " + " . $secondValue . "\n";
		echo "Expected:  " . $expected . "\n";
		echo "Actual:    " . $actual . "\n";
		echo "Result:    Test " . ($result ? "successful" : "failed") . "!\n\n";
		
		return $result;
	}
	
	echo "<pre>";
	$test1 = testRomanValue(2023, "MMXXIII");
	$test2 = testArabicValue("MMXXIII", 2023);
	$test3 = testRomanValue(1.5, "IS");
	$test4 = testArabicValue("IS", 1.5);
	$test5 = testRomanValue(9876, "M<span style=\"text-decoration: overline\">X</span>DCCCLXXVI");
	$test6 = testRomanValue(98765, "<span style=\"text-decoration: overline\">XCV</span>MMMDCCLXV");
	$test7 = testRomanValue(987654, "<span style=\"text-decoration: overline\">CMLXXXV</span>MMDCLIV");
	$test8 = testAddition("IV", "VI", "X");
	echo "</pre>";
?>
