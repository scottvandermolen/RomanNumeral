<%
	' ASP Roman Numeral Class
	' 
	' Copyright (c) 2023, Scott Vander Molen; some rights reserved.
	' 
	' This work is licensed under a Creative Commons Attribution 4.0 International License.
	' To view a copy of this license, visit https://creativecommons.org/licenses/by/4.0/
	' 
	' @author  Scott Vander Molen
	' @version 2.0
	' @since   2023-10-02
	'
	' https://en.wikipedia.org/wiki/Roman_numerals
	class RomanNumeral
		' Value is stored as an Arabic floating point value.
		private m_value
		
		' Constructor
		private sub Class_Initialize()
			' Constructor does not support parameters, so nothing to do until the user provides a value.
		end sub
		
		' Set the value of the Roman numeral.
		' 
		' @param input The desired value of the Roman numeral; can be either a Roman numeral string or arabic number.
		public property let value(input)
			' Check what type of input we're getting.
			if isRoman(input) then
				' Convert Roman numeral to Arabic value and store in member variable.
				m_value = roman_to_arabic(input)
			elseif isNumeric(input) then
				' Store Arabic value in member variable without modification.
				m_value = input
			else
				' Unrecognized input. Throw error "type mismatch".
				Err.Raise 13
			end if
		end property
		
		' Get the Roman value of the numeral.
		'
		' @return string The Roman numeral.
		public property get romanValue
			romanValue = vinculum(arabic_to_roman(m_value))
		end property
		
		' Get the Arabic value of the numeral.
		'
		' @return double The Arabic number.
		public property get arabicValue
			arabicValue = m_value
		end property
		
		' Add value to the Roman numeral.
		' Mathematical operations are performed using Arabic values because it is much faster.
		'
		' @param input The value to add to the Roman numeral; can be either a Roman numeral string or arabic number.
		public sub Add(input)
			' Check what type of input we're getting.
			if isRoman(input) then
				' Convert Roman numeral to Arabic value and add to member variable.
				m_value = m_value + roman_to_arabic(input)
			elseif isNumeric(input) then
				' Add Arabic value to member variable without modification.
				m_value = m_value + input
			else
				' Unrecognized input. Throw error "type mismatch".
				Err.Raise 13
				exit sub
			end if
		end sub
		
		' Check whether a specified input is a valid Roman numeral or not.
		'
		' @param value The value to test for validity.
		' @return boolean Indication of validity.
		private function isRoman(value)
			' Set-up regular expression
			dim regEx
			set regEx = new RegExp
			
			' All Roman numerals plus viniculums are considered valid.
			with regEx
				.IgnoreCase = true
				.Global = true
				.Pattern = "[MDCLXVI¯]"
			end with
			
			' Test input against regular expression.
			if regEx.Test(value) then
				isRoman = true
			else
				isRoman = false
			end if
			
			set regEx = nothing
		end function
		
		' Convert unicode overline modifier to CSS.
		'
		' @param value A Roman numeral string which may contain unicode overlines.
		' @return string The CSS-styled equivalent of the Roman numeral string.
		private function vinculum(romanValue)
			dim result
			
			' Set-up regular expression
			dim regEx
			set regEx = new RegExp
			
			with regEx
				.IgnoreCase = true
				.Global = true
				.Pattern = "([MDCLXVI])¯"
			end with
			
			' Replace unicode overlines, if any exist.
			result = regEx.Replace(romanValue, "<span style=""text-decoration: overline"">$1</span>")
			
			' Condense adjacent viniculums to a single set of span tags, if any exist.
			result = Replace(result, "</span><span style=""text-decoration: overline"">", "")
			
			vinculum = result
			set regEx = nothing
		end function
		
		' Convert an Arabic number to a Roman numeral.
		'
		' @param arabicValue An Arabic number to be converted.
		' @return string The Roman numeral.
		private function arabic_to_roman(arabicValue)
			dim fractions
			dim ones
			dim tens
			dim hundreds
			dim thousands
			dim tenthousands
			dim hundredthousands
			
			' These lookup arrays contain all the valid Roman numerals.
			' The fractions array supports twelfths only. Other values will be rounded to the nearest twelfth.
			' For values greater than 3999, a viniculum is placed over the numeral to indicate multiplication by 1000.
			fractions = Array("", "•", "••", "•••", "••••", "•••••", "S", "S•", "S••", "S•••", "S••••", "S•••••", "I")
			ones = Array("", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX")
			tens = Array("", "X", "XX", "XXX", "XL", "L", "LX", "LXX", "LXXX", "XC")
			hundreds = Array("", "C", "CC", "CCC", "CD", "D", "DC", "DCC", "DCCC", "CM")
			thousands = Array("", "M", "MM", "MMM", "MV¯", "V¯", "V¯M", "V¯MM", "V¯MMM", "MX¯")
			tenthousands = Array("", "X¯", "X¯X¯", "X¯X¯X¯", "X¯L¯", "L¯", "L¯X¯", "L¯X¯X¯", "L¯X¯X¯X¯", "X¯C¯")
			hundredthousands = Array("", "C¯", "C¯C¯", "C¯C¯C¯", "C¯D¯", "D¯", "D¯C¯", "D¯C¯C¯", "D¯C¯C¯C¯", "C¯M¯")
			
			
			' Since the modulo operator rounds to the nearest integer, we will use the Int() function to force rounding down for now.
			dim remainder
			remainder = Int(arabicValue)
			
			' A string to build our result before returning it.
			dim result
			result = ""
			
			if remainder > 999999 then
				' Numbers in the millions should be represented by a three-sided box.
				' This is currently outside the scope of this class, so these values are rejected as being out of bounds.
				Err.Clear
				Err.Raise 9
				exit function
			elseif remainder = 0 then
				' About AD 725, the Venerable Bede or one of his colleagues used the letter N, the initial of nullae, to indicate zero.
				result = "N"
			else
				' With special cases out of the way, we can proceed.
				' Each digit is handled one-by-one and then subtracted from the remainder until nothing remains.
				result = result & hundredthousands((remainder - (remainder mod 100000)) / 100000)
				remainder = remainder - (remainder - (remainder mod 100000))
				result = result & tenthousands((remainder - (remainder mod 10000)) / 10000)
				remainder = remainder - (remainder - (remainder mod 10000))
				result = result & thousands((remainder - (remainder mod 1000)) / 1000)
				remainder = remainder - (remainder - (remainder mod 1000))
				result = result & hundreds((remainder - (remainder mod 100)) / 100)
				remainder = remainder - (remainder - remainder mod 100)
				result = result & tens((remainder - (remainder mod 10)) / 10)
				remainder = remainder - (remainder - remainder mod 10)
				result = result & ones((remainder - (remainder mod 1)) / 1)
				
				' Isolate any fractional value from the original number.
				remainder = arabicValue - Int(arabicValue)
				
				' Handling for fractions.
				if remainder > 0 then
					' Since Roman fractions are based on twelfths, the fractional remainder is multiplied by 12 and rounded up or down to the nearest twelfth.
					result = result & fractions(round(remainder * 12))
				end if
			end if
			
			arabic_to_roman = result
		end function
		
		' Expand subtractive notation in Roman numerals.
		' This is used to simplify conversion of Roman numerals to Arabic numbers.
		'
		' @param romanValue The Roman numeral to be expanded.
		' @return string The expanded version of the Roman numeral.
		private function roman_expand(romanValue)
			dim result
			result = romanValue
			
			result = replace(result, "CM", "DCCCC")
			result = replace(result, "CD", "CCCC")
			result = replace(result, "XC", "LXXXX")
			result = replace(result, "XL", "XXXX")
			result = replace(result, "IX", "VIIII")
			result = replace(result, "IV", "IIII")
			result = replace(result, "S", "••••••")
			
			roman_expand = result
		end function
		
		' Compress Roman numerals using subtractive notation.
		'
		' @param romanValue The Roman numeral to be compressed.
		' @return string The compressed Roman numeral in subtractive notation.
		private function roman_compress(romanValue)
			dim result
			result = romanValue
			
			result = replace(result, "DCCCC", "CM")
			result = replace(result, "CCCC", "CD")
			result = replace(result, "LXXXX", "XC")
			result = replace(result, "XXXX", "XL")
			result = replace(result, "VIIII", "IX")
			result = replace(result, "IIII", "IV")
			result = replace(result, "••••••", "S")
			
			roman_compress = result
		end function
		
		' Count the number of occurences of one string in another.
		'
		' @param haystack The string to be searched.
		' @param needle The string to search for.
		' @return integer The number of occurences of the needle in the haystack.
		private function InstrCount(haystack, needle)
			' Make sure the needle is propertly specified.
			if needle <> "" then
				' By converting the haystack into an array using the needle, the number of elements in the array will be equal to the number of occurences of the needle in the haystack.
				InstrCount = UBound(Split(haystack, needle))
			else
				' Needle not specified. Throw error "Invalid procedure call or argument"
				Err.Raise 5
			end if
		end function
		
		' Convert Roman numerals to Arabic numerals.
		'
		' @param romanValue The Roman numeral to be converted.
		' @return float The equivalent Arabic number. 
		private function roman_to_arabic(romanValue)
			dim result
			result = 0
			
			' Remove subtractive notation.
			dim expandedRomanValue
			expandedRomanValue = roman_expand(romanValue)
			
			' Calculate for each numeral.
			result = result + InstrCount(expandedRomanValue, "M") * 1000
			result = result + InstrCount(expandedRomanValue, "D") * 500
			result = result + InstrCount(expandedRomanValue, "C") * 100
			result = result + InstrCount(expandedRomanValue, "L") * 50
			result = result + InstrCount(expandedRomanValue, "X") * 10
			result = result + InstrCount(expandedRomanValue, "V") * 5
			result = result + InstrCount(expandedRomanValue, "I")
			result = result + InstrCount(expandedRomanValue, "•") / 12
			
			roman_to_arabic = result
		end function
	end class
%>