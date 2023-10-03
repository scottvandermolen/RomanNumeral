<%@ CodePage=65001 Language="VBScript"%>
<% Option Explicit %>
<!--#include file="RomanNumeral.class.asp"-->
<%
	' Ensure that UTF-8 encoding is used instead of Windows-1252
	Session.CodePage = 65001
	Response.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.ContentType = "text/html"
	
	' Creates a Roman numeral from an Arabic number.
	' 
	' @param input The desired value of the Roman numeral
	' @param expected The expected Roman numeral.
	' @return boolean Whether the result matched the expectation.
	function testRomanValue(input, expected)
		dim testNumeral
		set testNumeral = new RomanNumeral
		testNumeral.value = input
		
		dim actual
		actual = testNumeral.romanValue
		
		dim result
		dim resultText
		if actual = expected then
			result = true
			resultText = "successful"
		else
			result = false
			resultText = "failed"
		end if
		
		Response.Write "Unit Test: romanValue" & vbCrLf
		Response.Write "Input:     " & input & vbCrLf
		Response.Write "Expected:  " & expected & vbCrLf
		Response.Write "Actual:    " & actual & vbCrLf
		Response.Write "Result:    Test " & resultText &  "!" & vbCrLf & vbCrLf
		
		testRomanValue = result
		set testNumeral = nothing
	end function
	
	' Creates a Roman numeral from a string and checks the Arabic value.
	' 
	' @param input The desired value of the Roman numeral
	' @param expected The expected Roman numeral.
	' @return boolean Whether the result matched the expectation.
	function testArabicValue(input, expected)
		dim testNumeral
		set testNumeral = new RomanNumeral
		testNumeral.value = input
		
		dim actual
		actual = testNumeral.arabicValue
		
		dim result
		dim resultText
		if actual = expected then
			result = true
			resultText = "successful"
		else
			result = false
			resultText = "failed"
		end if
		
		Response.Write "Unit Test: arabicValue" & vbCrLf
		Response.Write "Input:     " & input & vbCrLf
		Response.Write "Expected:  " & expected & vbCrLf
		Response.Write "Actual:    " & actual & vbCrLf
		Response.Write "Result:    Test " & resultText &  "!" & vbCrLf & vbCrLf
		
		testArabicValue = result
		set testNumeral = nothing
	end function
	
	' Tests addition
	'
	' @param firstValue The initial value of the Roman numeral.
	' @param secondValue The value to add to the Roman numeral.
	' @param expected The expected result of the addition.
	' @return boolean Whether the result matched the expectation.
	function testAddition(firstValue, secondValue, expected)
		dim testNumeral
		set testNumeral = new RomanNumeral
		testNumeral.value = firstValue
		testNumeral.Add(secondValue)
		
		dim actual
		actual = testNumeral.romanValue
		
		dim result
		dim resultText
		if actual = expected then
			result = true
			resultText = "successful"
		else
			result = false
			resultText = "failed"
		end if
		
		Response.Write "Unit Test: Add()" & vbCrLf
		Response.Write "Input:     " & firstValue & " + " & secondValue & vbCrLf
		Response.Write "Expected:  " & expected & vbCrLf
		Response.Write "Actual:    " & actual & vbCrLf
		Response.Write "Result:    Test " & resultText &  "!" & vbCrLf & vbCrLf
		
		testAddition = result
		set testNumeral = nothing
	end function
	
	' Create an HTML container for our output.
	Response.Write "<!DOCTYPE html>" & vbCrLf
	Response.Write "<html lang=""en"">" & vbCrLf
	Response.Write "<meta http-equiv=""Content-Type"" content=""text/html;charset=UTF-8"" />" & vbCrLf
	Response.Write "<body>" & vbCrLf
	
	' Display code header
	Response.Write "<pre>"
	Response.Write "/***************************************************************************************\" & vbCrLf
	Response.Write "| ASP Roman Numeral Class Unit Tests                                                    |" & vbCrLf
	Response.Write "|                                                                                       |" & vbCrLf
	Response.Write "| Copyright (c) 2023, Scott Vander Molen; some rights reserved.                         |" & vbCrLf
	Response.Write "|                                                                                       |" & vbCrLf
	Response.Write "| This work is licensed under a Creative Commons Attribution 4.0 International License. |" & vbCrLf
	Response.Write "| To view a copy of this license, visit https://creativecommons.org/licenses/by/4.0/    |" & vbCrLf
	Response.Write "|                                                                                       |" & vbCrLf
	Response.Write "\***************************************************************************************/" & vbCrLf
	Response.Write "</pre>"
	
	' Run unit tests
	Response.Write "<pre>"
	
	dim test1
	test1 = testRomanValue(2023, "MMXXIII")
	
	dim test2
	test2 = testArabicValue("MMXXIII", 2023)
	
	dim test3
	test3 = testRomanValue(1.5, "IS")
	
	dim test4
	test4 = testArabicValue("IS", 1.5)
	
	dim test5
	test5 = testRomanValue(9876, "M<span style=""text-decoration: overline"">X</span>DCCCLXXVI")
	
	dim test6
	test6 = testRomanValue(98765, "<span style=""text-decoration: overline"">XCV</span>MMMDCCLXV")
	
	dim test7
	test7 = testRomanValue(987654, "<span style=""text-decoration: overline"">CMLXXXV</span>MMDCLIV")
	
	dim test8
	test8 = testAddition("IV", "VI", "X")
	
	Response.Write "</pre>" & vbCrLf
	
	' Close the HTML container.
	Response.Write "</body>" & vbCrLf
	Response.Write "</html>"
%>
