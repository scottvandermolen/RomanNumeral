<?php
	namespace ScottVM; 
	
	/**
	* PHP Roman Numeral Class
	* 
	* Copyright (c) 2023, Scott Vander Molen; some rights reserved.
	* 
	* This work is licensed under a Creative Commons Attribution 4.0 International License.
	* To view a copy of this license, visit https://creativecommons.org/licenses/by/4.0/
	* 
	* @author  Scott Vander Molen
	* @version 2.0
	* @since   2023-10-02
	*
	* https://en.wikipedia.org/wiki/Roman_numerals
	*/
	
	// Change debugmode to true if you need to see error messages.
	$debugmode = false;
	if ($debugmode)
	{
		// Allow the display of error during debugging.
		ini_set('display_errors', 1);
		ini_set('display_startup_errors', 1);
		error_reporting(E_ALL);
	}
	else
	{
		// Display a 404 error if the user attempts to access this file directly.
		if (__FILE__ == $_SERVER['SCRIPT_FILENAME'])
		{
			header($_SERVER['SERVER_PROTOCOL'] . ' 404 Not Found');
			exit("<!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\r\n<html><head>\r\n<title>404 Not Found</title>\r\n</head><body>\r\n<h1>Not Found</h1>\r\n<p>The requested URL " . $_SERVER['SCRIPT_NAME'] . " was not found on this server.</p>\r\n</body></html>");
		}
	}
	
	class RomanNumeral
	{
		// Value is stored as an Arabic floating point number.
		private $m_value;
		
		/**
		* Set the value of the Roman numeral.
		* 
		* @param value The desired value of the Roman numeral; can be either a Roman numeral string or arabic number.
		*/
		public function set_value($value)
		{
			// Check what type of input we're getting.
			if ($this->is_roman($value))
			{
				// Convert Roman numeral to Arabic value and store in member variable.
				$this->m_value = $this->roman_to_arabic($value);
			}
			elseif (is_numeric($value))
			{
				// Store Arabic value in member variable without modification.
				$this->m_value = $value;
			}
			else
			{
				// Unrecognized input. Throw error "type mismatch".
				trigger_error('Type mismatch on set_value()!', E_USER_ERROR);
			}
		}
		
		/**
		* Get the Roman value of the numeral.
		*
		* @return string The Roman numeral.
		*/
		public function get_value_roman()
		{
			return $this->vinculum($this->arabic_to_roman($this->m_value));
			//return $this->arabic_to_roman($this->m_value);
		}
		
		/*
		* Get the Arabic value of the numeral.
		*
		* @return double The Arabic number.
		*/
		public function get_value_arabic()
		{
			return $this->m_value;
		}
		
		/*
		* Add value to the Roman numeral.
		* Mathematical operations are performed using Arabic values because it is much faster.
		*
		* @param input The value to add to the Roman numeral; can be either a Roman numeral string or arabic number.
		*/
		public function add($value)
		{
			// Check what type of input we're getting.
			if ($this->is_roman($value))
			{
				// Convert Roman numeral to Arabic value and add to member variable.
				$this->m_value += $this->roman_to_arabic($value);
			}
			elseif (is_numeric($value))
			{
				// Add Arabic value to member variable without modification.
				$this->m_value += $value;
			}
			else
			{
				// Unrecognized input. Throw error "type mismatch".
				trigger_error('Type mismatch on add()!', E_USER_ERROR);
			}
		}
		
		/*
		* Check whether a specified input is a valid Roman numeral or not.
		*
		* @param value The value to test for validity.
		* @return boolean Indication of validity.
		*/
		private function is_roman($value)
		{
			$pattern = "/[MDCLXVI¯]/";
			return preg_match($pattern, $value) == 1 ? true : false;
		}
		
		/*
		* Convert unicode overline modifier to CSS.
		*
		* @param value A Roman numeral string which may contain unicode overlines.
		* @return string The CSS-styled equivalent of the Roman numeral string.
		*/
		private function vinculum($romanValue)
		{
			$result = "";
			$pattern = "/([MDCLXVI])¯/";
			
			// Replace unicode overlines, if any exist.
			$result = preg_replace($pattern, "<span style=\"text-decoration: overline\">$1</span>", $romanValue);
			
			// Condense adjacent viniculums to a single set of span tags, if any exist.
			$result = str_replace("</span><span style=\"text-decoration: overline\">","", $result);
			
			return $result;
		}
		
		/*
		* Convert an Arabic number to a Roman numeral.
		*
		* @param arabicValue An Arabic number to be converted.
		* @return string The Roman numeral.
		*/
		private function arabic_to_roman($arabicValue)
		{
			$fractions = array("", "•", "••", "•••", "••••", "•••••", "S", "S•", "S••", "S•••", "S••••", "S•••••", "I");
			$ones = array("", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX");
			$tens = array("", "X", "XX", "XXX", "XL", "L", "LX", "LXX", "LXXX", "XC");
			$hundreds = array("", "C", "CC", "CCC", "CD", "D", "DC", "DCC", "DCCC", "CM");
			$thousands = array("", "M", "MM", "MMM", "MV¯", "V¯", "V¯M", "V¯MM", "V¯MMM", "MX¯");
			$tenthousands = array("", "X¯", "X¯X¯", "X¯X¯X¯", "X¯L¯", "L¯", "L¯X¯", "L¯X¯X¯", "L¯X¯X¯X¯", "X¯C¯");
			$hundredthousands = array("", "C¯", "C¯C¯", "C¯C¯C¯", "C¯D¯", "D¯", "D¯C¯", "D¯C¯C¯", "D¯C¯C¯C¯", "C¯M¯");
			
			$remainder = $arabicValue;
			$result = "";
			
			if ($remainder > 999999)
			{
				// Numbers in the millions should be represented by a three-sided box.
				// This is currently outside the scope of this class, so these values are rejected as being out of bounds.
				trigger_error('Value must be less than one million!', E_USER_ERROR);
			}
			elseif ($remainder == 0)
			{
				// About AD 725, the Venerable Bede or one of his colleagues used the letter N, the initial of nullae, to indicate zero.
				$result = "N";
			}
			else
			{
				// With special cases out of the way, we can proceed.
				// Each digit is handled one-by-one and then subtracted from the remainder until nothing remains.
				$result .= $hundredthousands[($remainder - ($remainder % 100000)) / 100000];
				$remainder -= $remainder - $remainder % 100000;
				$result .= $tenthousands[($remainder - ($remainder % 10000)) / 10000];
				$remainder -= $remainder - $remainder % 10000;
				$result .= $thousands[($remainder - ($remainder % 1000)) / 1000];
				$remainder -= $remainder - $remainder % 1000;
				$result .= $hundreds[($remainder - ($remainder % 100)) / 100];
				$remainder -= $remainder - $remainder % 100;
				$result .= $tens[($remainder - ($remainder % 10)) / 10];
				$remainder -= $remainder - $remainder % 10;
				$result .= $ones[($remainder - ($remainder % 1)) / 1];
				
				// Isolate any fractional value from the original number.
				$remainder = $arabicValue - floor($arabicValue);
				
				// Handling for fractions.
				if ($remainder > 0)
				{
					// Since Roman fractions are based on twelfths, the fractional remainder is multiplied by 12 and rounded up or down to the nearest twelfth.
					$result .= $fractions[round($remainder * 12)];
				}
			}
			
			return $result;
		}
		
		/*
		* Expand subtractive notation in Roman numerals.
		* This is used to simplify conversion of Roman numerals to Arabic numbers.
		*
		* @param romanValue The Roman numeral to be expanded.
		* @return string The expanded version of the Roman numeral.
		*/
		private function roman_expand($romanValue)
		{
			$result = $romanValue;
			$result = str_replace("CM", "DCCCC", $result);
			$result = str_replace("CD", "CCCC", $result);
			$result = str_replace("XC", "LXXXX", $result);
			$result = str_replace("XL", "XXXX", $result);
			$result = str_replace("IX", "VIIII", $result);
			$result = str_replace("IV", "IIII", $result);
			$result = str_replace("S", "••••••", $result);
			
			return $result;
		}
		
		/*
		* Compress Roman numerals using subtractive notation.
		*
		* @param romanValue The Roman numeral to be compressed.
		* @return string The compressed Roman numeral in subtractive notation.
		*/
		private function roman_compress($romanValue)
		{
			$result = $romanValue;
			$result = str_replace("DCCCC", "CM", $result);
			$result = str_replace("CCCC", "CD", $result);
			$result = str_replace("LXXXX", "XC", $result);
			$result = str_replace("XXXX", "XL", $result);
			$result = str_replace("VIIII", "IX", $result);
			$result = str_replace("IIII", "IV", $result);
			$result = str_replace("••••••", "S", $result);
			
			return $result;
		}
		
		/*
		* Convert Roman numerals to Arabic numerals.
		*
		* @param romanValue The Roman numeral to be converted.
		* @return float The equivalent Arabic number. 
		*/
		private function roman_to_arabic($romanValue)
		{
			$result = 0;
			
			// Remove subtractive notation.
			$expandedRomanValue = $this->roman_expand($romanValue);
			
			// Calculate for each numeral.
			$result += substr_count($expandedRomanValue, "M") * 1000;
			$result += substr_count($expandedRomanValue, "D") * 500;
			$result += substr_count($expandedRomanValue, "C") * 100;
			$result += substr_count($expandedRomanValue, "L") * 50;
			$result += substr_count($expandedRomanValue, "X") * 10;
			$result += substr_count($expandedRomanValue, "V") * 5;
			$result += substr_count($expandedRomanValue, "I");
			$result += substr_count($expandedRomanValue, "•") / 12;
			
			return $result;
		}
	}
?>