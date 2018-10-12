module namespace common = 'common';


declare function common:formatNode($thisNode, $nodeName as xs:string, $type)

{ (: type is "currency" or "date" :)
	let $rowname :=  element {name($thisNode)} {
	
	for $node in $thisNode//*
		return
		if (name($node) = $nodeName) 
		then 
			if ($type = 'currency')
			then
				element {name($node)} {common:format-number(xs:decimal($node/text()), '$#,###.00') }
			else
			if ($type = 'date')
			then
				element {name($node)} {common:empowerDate($node) }
				
			else 
				
			if ($type = 'boolean')
			then
				element {name($node)} { if ($node/text() = '1') then "Y" else "N" }
				
			else 
				$node
			
		else $node
	}
	return $rowname
};


declare function common:XMLToCSV(
	$node
) {
    concat(
        string-join(
            for $col in distinct-values($node/*/name()) return $col, ',')
        , '&#10;',
        string-join(
            for $row in $node
            return
                string-join(
                    for $col in distinct-values($node/*/name())
                    return concat('', $row/*[name() = $col]/text())
                , ',')
        , '&#10;')
    )
};

declare function common:roundDecimal(
	$value
) {
	let $result := xs:string(xs:decimal(round(number($value) * 100) div 100))
	return
		if (not(contains($result, '.')))
			then concat($result, '.00')
		else if (not(matches($result, '.*\.\d{2}')))
			then concat($result, '0')
		else $result
};

declare function common:roundDecimal2(
	$value
) {
	xs:decimal(round(number($value) * 100) div 100)
};

declare function common:standardizeDate(
	$date as xs:string*
) {
	common:trim(
		if (matches($date, "\d{4}-\d{2}-\d{2}")) (: yyyy-mm-dd (correct format) :)
			then $date
		else if (matches($date, "\d{2}-\d{2}-\d{4}")) (: mm-dd-yyyy :)
			then replace($date, "(\d{2})-(\d{2})-(\d{4})", "$3-$1-$2")
		else if (matches(upper-case($date), "^(\d)-(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)-(\d{2})")) (: dd-mmm-yy HH.MM.SS.sssssssss AM :)
			then
				let $out := common:replaceMonths(replace(upper-case($date), "^(\d)-(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)-(\d{2})", "$3-$2-0$1"))
				return if (compare(substring($out, 1, 2), '17') le 0)
					then concat("20", $out)
					else concat("19", $out)
		else if (matches(upper-case($date), "^(\d{2})-(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)-(\d{2})")) (: dd-mmm-yy HH.MM.SS.sssssssss AM :)
			then
				let $out := common:replaceMonths(replace(upper-case($date), "^(\d{2})-(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)-(\d{2})", "$3-$2-$1"))
				return if (compare(substring($out, 1, 2), '17') le 0)
					then concat("20", $out)
					else concat("19", $out)
		else if (matches($date, "^(\d{1,2})/(\d{1,2})/(\d{4})")) (: m/d/yyyy :)
			then replace(replace(replace($date, "^(\d)/(\d{1,2})/(\d{4})", "0$1/$2/$3"), "(\d{2})/(\d)/(\d{4})", "$1/0$2/$3"), "(\d{2})/(\d{2})/(\d{4})", "$3-$1-$2")
		else
			$date
	)
};


declare function common:empowerCurrency(
	$value as xs:string*
) {
	let $value := if ($value = "" or empty($value) ) then '0' else $value

	return common:format-number(xs:decimal($value), '$#,###.00')
};

declare function common:empowerPercentage(
	$value as xs:string*
) {

	common:format-number(xs:decimal($value), '###.0%')
};


declare function common:empowerBoolean(
	$value as xs:string*
) {

	if ($value = '1') then "Y" else "N" 
};


declare function common:empowerDate(
	$date as xs:string*
) {
	let $formattedDate := 
	common:trim(
		if (matches($date, "\d{4}-\d{2}-\d{2}")) (: yyyy-mm-dd :)
			then replace($date, "(\d{4})-(\d{2})-(\d{2})", "$2/$3/$1")
		else if (matches($date, "\d{2}-\d{2}-\d{4}")) (: mm-dd-yyyy :)
			then replace($date, "(\d{2})-(\d{2})-(\d{4})", "$1/$2/$3")
		else if (matches(upper-case($date), "^(\d{2})-(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)-(\d{2})")) (: dd-mmm-yy HH.MM.SS.sssssssss AM :)
			then
				let $out := common:replaceMonths(replace(upper-case($date), "^(\d{2})-(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)-(\d{2})", "$2/$1/$3"))
				return if (compare(substring($out, 1, 2), '17') le 0)
					then concat(substring($out, 1, 6),"20", substring($out, 7))
					else concat(substring($out, 1, 6),"19", substring($out, 7))
		else if (matches($date, "^(\d{1,2})/(\d{1,2})/(\d{4})")) (: m/d/yyyy :)
			then replace(replace(replace($date, "^(\d)/(\d{1,2})/(\d{4})", "0$1/$2/$3"), "(\d{2})/(\d)/(\d{4})", "$1/0$2/$3"), "(\d{2})/(\d{2})/(\d{4})", "$1/$2/$3")
		else
			$date
	)
	return substring ($formattedDate,1, 10)
};


declare function common:empowerDateTime(
	$date as xs:string*
) {
	let $formattedDate := 
	common:trim(
		if (matches($date, "\d{4}-\d{2}-\d{2}")) (: yyyy-mm-dd :)
			then replace($date, "(\d{4})-(\d{2})-(\d{2})", "$2/$3/$1")
		else if (matches($date, "\d{2}-\d{2}-\d{4}")) (: mm-dd-yyyy :)
			then replace($date, "(\d{2})-(\d{2})-(\d{4})", "$1/$2/$3")
		else if (matches(upper-case($date), "^(\d{2})-(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)-(\d{2})")) (: dd-mmm-yy HH.MM.SS.sssssssss AM :)
			then
				let $out := common:replaceMonths(replace(upper-case($date), "^(\d{2})-(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)-(\d{2})", "$2/$1/$3"))
				return if (compare(substring($out, 1, 2), '17') le 0)
					then concat(substring($out, 1, 6),"20", substring($out, 7))
					else concat(substring($out, 1, 6),"19", substring($out, 7))
		else if (matches($date, "^(\d{1,2})/(\d{1,2})/(\d{4})")) (: m/d/yyyy :)
			then replace(replace(replace($date, "^(\d)/(\d{1,2})/(\d{4})", "0$1/$2/$3"), "(\d{2})/(\d)/(\d{4})", "$1/0$2/$3"), "(\d{2})/(\d{2})/(\d{4})", "$1/$2/$3")
		else
			$date
	)
	return replace ($formattedDate,'T', ' ')
};

declare function common:stripNumberPart(
	$dec as xs:string
) {
	replace($dec, "^[\+\-]?0*(.*)$", "$1")
};

declare function common:truncateDecimal(
	$dec as xs:string
) {
	replace($dec, "^([^\.]?\.?[^\.]{2,1,0})\d*", "$1")
};

declare function common:fts(
	$column as xs:string,
	$value as xs:string
) {
	if (string-length($value) gt 0)
		then concat($column, ' contains text ".*', common:trim($value), '.*" using wildcards')
	else ()
};

declare function common:trim(
	$str as xs:string*
) {
	if (count($str) gt 0)
		then replace(replace($str, "^\s+", ""), "\s+$", "")
	else $str
};

declare function common:outerJoin(
	$join as xs:string
) {
	concat('(let $result := ', $join, ' return if (empty($result)) then <EMPTY /> else $result)')
};

declare function common:ifIfCase(
	$case as xs:string*,
	$then as xs:string,
	$else as xs:string
) {
	if (count($case) = 0)
		then $then
	else
		concat(
			'if (', string-join($case, ') and ('), ')',
			' then', $then,
			'else ', $else
		)
};

declare function common:getExtention(
	$mime-type
) as xs:string {
	switch ($mime-type)
	case "application/pdf" return ".PDF"
	case "application/octet-stream" return ".MSG"
	case "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" return ".XLSX"
	case "application/vnd.ms-excel" return ".XLS" (: or .CSV :)
	case "application/vnd.ms-outlook" return ".MSG"
	case "application/vnd.ms-excel.sheet.macroenabled.12" return ".XLSM"
	case "application/vnd.openxmlformats-officedocument.wordprocessingml.document" return ".DOCX"
	case "application/msword" return ".DOC"
	case "application/PDF" return ".PDF"
	case "application/vnd.ms-powerpoint" return ""
	case "application/vnd.ms-excel.sheet.macroEnabled.12" return ".XLSM"
	case "text/plain" return ".TXT"
	case "application/vnd.openxmlformats-officedocument.presentationml.presentation" return ".PPTX"
	case "message/rfc822" return ".MHT"
	case "application/vnd.openxmlformats-officedocument.wordprocessingml.template" return ""
	case "application/x-zip-compressed" return ""
	case "application/excel" return ".XLS"
	case "application/powerpoint" return ".PPT"
	case "image/tiff" return ""
	case "application/x-compressed" return ".ZIP"
	default return ""
};


declare function common:replaceMonths(
	$date
) as xs:string {
	replace(
	replace(
	replace(
	replace(
	replace(
	replace(
	replace(
	replace(
	replace(
	replace(
	replace(
	replace(
		$date
	, "JAN", "01")
	, "FEB", "02")
	, "MAR", "03")
	, "APR", "04")
	, "MAY", "05")
	, "JUN", "06")
	, "JUL", "07")
	, "AUG", "08")
	, "SEP", "09")
	, "OCT", "10")
	, "NOV", "11")
	, "DEC", "12")
};

declare function common:dbDateToComparableDate(
	$date
) as xs:string {
	replace(
	replace(
	replace(
	replace(
	replace(
	replace(
	replace(
	replace(
	replace(
	replace(
	replace(
	replace(
		replace($date/text(), "(\d{2})-([a-zA-Z]{3})-(\d{2})", "$3-$2-$1")
	, "JAN", "01")
	, "FEB", "02")
	, "MAR", "03")
	, "APR", "04")
	, "MAY", "05")
	, "JUN", "06")
	, "JUL", "07")
	, "AUG", "08")
	, "SEP", "09")
	, "OCT", "10")
	, "NOV", "11")
	, "DEC", "12")
};

declare function common:toComparableDateDBDate(
	$date
) {
	replace(
	replace(
	replace(
	replace(
	replace(
	replace(
	replace(
	replace(
	replace(
	replace(
	replace(
	replace(
		substring($date/text(), 3, 8)
	, "-JAN-", "-01-")
	, "-FEB-", "-02-")
	, "-MAR-", "-03-")
	, "-APR-", "-04-")
	, "-MAY-", "-05-")
	, "-JUN-", "-06-")
	, "-JUL-", "-07-")
	, "-AUG-", "-08-")
	, "-SEP-", "-09-")
	, "-OCT-", "-10-")
	, "-NOV-", "-11-")
	, "-DEC-", "-12-")
};

declare function common:paddPlusZero(
	$input,
	$length
) {
	if (starts-with($input, '+'))
		then $input
	else
		concat(
			'+',
			string-join(
				for $i in (string-length($input) to $length - 1)
					return '0'
			, ''),
			$input
		)
};

declare function common:for(
	$input as xs:string*
) as xs:string {
	if (count($input) gt 0)
		then 
			concat(
				'for',
				string-join(
					$input,
					' , '
				)
			)
	else ''
};

declare function common:return(
	$nodeName as xs:string,
	$input as xs:string*
) as xs:string {
	if (count($input) gt 0)
		then 
			concat(
				'return <', $nodeName, ' ',
				string-join(
					$input,
					' '
				),
				'>'
			)
	else ''
};

declare function common:whereClause(
	$input as xs:string*
) as xs:string {
	if (count($input) gt 0)
		then 
			concat(
				'[',
				string-join(
					$input,
					' and '
				),
				']'
			)
	else ''
};

declare function common:stripPlusZero(
	$input
) {
	common:stripPlusZero($input, ())
};

declare function common:formatDate(
	$date as xs:string?
) as xs:string {
	if (not($date = "")) then replace($date, 'T', ' ' ) else ()
};

declare function common:stripPlusZero(
	$input,
	$ignore as xs:string*
) {
	if ($input instance of xs:untypedAtomic)
		then
			let $result := replace($input, '^\+0+(?!\.)', '')
			return
				if (string-length($result) = 0 and not(string-length($input) = 0))
						then '0'
					else
						$result
	else
		for $output in $input
			return
				if (count($output/*) = 0)
					then
						if ($output/name() = $ignore)
							then $output
						else
							let $result := replace($output, '^\+0+(?!\.)', '')
							return
								element {$output/name()} {
									for $attr in $output/@*
										return attribute {$attr/name()} {common:stripPlusZero($attr/data())},
									if (string-length($result) = 0 and not(string-length($output) = 0))
										then '0'
									else
										$result
								}
				else
					element {$output/name()} {
						for $attr in $output/@*
							return attribute {$attr/name()} {common:stripPlusZero($attr/data())},
						common:stripPlusZero($output/*, $ignore)
					}
};

declare function common:addCommas(
	$dec as xs:string
) {
	codepoints-to-string(reverse(string-to-codepoints(replace(codepoints-to-string(reverse(string-to-codepoints($dec))), '(\d{3})(?=\d)', '$1,'))))
};

(: These are examples of the formats for the format-number function
<tests>
    <test>
        <code>local:format-number(12345678.9, '$#,###.00')</code>
        <xquery-result>{local:format-number(12345678.9, '$#,###.00')}</xquery-result>
        <xslt-result>$12,345,678.90</xslt-result>
    </test>
    <test>
        <code>local:format-number(-12345678.9, '#,###.00')</code>
        <xquery-result>{local:format-number(-12345678.9, '#,###.00')}</xquery-result>
        <xslt-result>-12,345,678.90</xslt-result>
    </test>
    <test>
        <code>local:format-number(12345.67,'00000000.00')</code>
        <xquery-result>{local:format-number(12345.67,'00000000.00')}</xquery-result>
        <xslt-result>00012345.67</xslt-result>
    </test>
    <test>
        <code>local:format-number(12345.67,'0,000.0000;-000,000.00')</code>
        <xquery-result>{local:format-number(12345.67,'0,000.0000;-000,000.00')}</xquery-result>
        <xslt-result>12,345.6700</xslt-result>
    </test>
    <test>
        <code>local:format-number(-12345.67,'0,000.0000;-000,000.00')</code>
        <xquery-result>{local:format-number(-12345.67,'0,000.0000;-000,000.00')}</xquery-result>
        <xslt-result>-012,345.67</xslt-result>
    </test>
    <test>
        <code>local:format-number(12345.67,',000')</code>
        <xquery-result>{local:format-number(12345.67,',000')}</xquery-result>
        <xslt-result>12,346</xslt-result>
    </test>
    <test>
        <code>local:format-number(12345.67,'$,000')</code>
        <xquery-result>{local:format-number(12345.67,'$,000')}</xquery-result>
        <xslt-result>$12,346</xslt-result>
    </test>
</tests>
:)

declare variable $common:decimalDecimalSeparator := ".";
declare variable $common:decimalGroupSeparator := ",";
declare variable $common:decimalZeroDigit := "0";
declare variable $common:decimalDigit := "#";
declare variable $common:decimalFormatPercent := "%";

declare variable $common:decimalGroupSeparatorCode := string-to-codepoints($common:decimalGroupSeparator)[1];
declare variable $common:decimalZeroDigitCode := string-to-codepoints($common:decimalZeroDigit)[1];
declare variable $common:decimalDigitCode := string-to-codepoints($common:decimalDigit)[1];

declare function common:format-number($inputNumber as xs:decimal, $inputFormat as xs:string) as xs:string
{
    let $patterns := tokenize($inputFormat, ";")  (: handle negative pattern :)
    let $format := if (count($patterns) = 1) then $inputFormat else if ($inputNumber > 0) then $patterns[1] else $patterns[2]
    (: if there is a pattern for negative numbers, let it handle the negative sign  :)
    let $number1 as xs:decimal := if (count($patterns) = 1) then $inputNumber else if ($inputNumber > 0) then $inputNumber else -($inputNumber)
    (: if the pattern doesn't include a decimal separator, round the number :)
    let $number as xs:decimal := if(contains($format, $common:decimalDecimalSeparator)) then $number1 else round($number1)
    let $strNumber := string(
                        if (ends-with($format, $common:decimalFormatPercent)) then $number*100 else $number
                    )
    let $decimalPart := codepoints-to-string(
                            common:format-number-decimal(
                                string-to-codepoints( substring-after($strNumber, '.') ),
                                string-to-codepoints( substring-after($format, $common:decimalDecimalSeparator) )
                            )
                        )
    let $integerPart := codepoints-to-string(
                            common:format-number-integer(
                                reverse(
                                    string-to-codepoints(
                                        if(starts-with($strNumber, "0.")) then
                                            ""
                                        else
                                            if( contains($strNumber, '.') ) then 
												substring-before($strNumber, '.') 
											else 
												$strNumber
                                    )
                                ),
                                reverse(
                                    string-to-codepoints(
                                        if( contains($format, $common:decimalDecimalSeparator) ) then 
											substring-before($format, $common:decimalDecimalSeparator) 
										else 
											$format
                                    )
                                ),
                                0, -1
                            )
                        )
    return
        if (string-length($decimalPart) > 0) then
            concat($integerPart, $common:decimalDecimalSeparator, $decimalPart) 
        else
            $integerPart
};
declare function common:format-number-decimal($number as xs:integer*, $format as xs:integer*) as xs:integer*
{
    if ($format[1] = $common:decimalDigitCode or $format[1] = $common:decimalZeroDigitCode) then
        if (count($number) > 0) then
            ($number[1], common:format-number-decimal(subsequence($number, 2), subsequence($format, 2)))
        else
            if ($format[1] = $common:decimalDigitCode) then () else ($format[1], common:format-number-decimal((), subsequence($format, 2)))
    else
        if (count($format) > 0) then
            ($format[1], common:format-number-decimal($number, subsequence($format, 2)))
        else
            ()
};
declare function common:format-number-integer($number as xs:integer*, $format as xs:integer*, $thousandsCur as xs:integer, $thousandsPos as xs:integer) as xs:integer*
{
    if( $thousandsPos > 0 and $thousandsPos = $thousandsCur and count($number) > 0) then
        (common:format-number-integer($number, $format, 0, $thousandsCur), $common:decimalGroupSeparatorCode)
    else
        if ($format[1] = $common:decimalDigitCode or $format[1] = $common:decimalZeroDigitCode) then
            if (count($number) > 0) then
                (common:format-number-integer(subsequence($number, 2), subsequence($format, 2), $thousandsCur+1, $thousandsPos), $number[1])
            else if ($format[1] = $common:decimalDigitCode) then
                (common:format-number-integer((), subsequence($format, 2), $thousandsCur+1, $thousandsPos))
            else
                (common:format-number-integer((), subsequence($format, 2), $thousandsCur+1, $thousandsPos), $format[1])
        else
            if (count($format) > 0) then
                if ($format[1] = $common:decimalGroupSeparatorCode) then
                    if (count($number) = 0 and $format[2] != $common:decimalZeroDigitCode) then
                        (common:format-number-integer($number, subsequence($format, 2), 0, $thousandsCur))
                    else
                        (common:format-number-integer($number, subsequence($format, 2), 0, $thousandsCur), $format[1])
                else (: some other character :)
                    if (count($number) > 0) then (: digits come first of any other character in $format :)
                        (common:format-number-integer(subsequence($number, 2), $format, $thousandsCur+1, $thousandsPos), $number[1])
                    else
                        (common:format-number-integer($number, subsequence($format, 2), $thousandsCur+1, $thousandsPos), $format[1])
            else
                if (count($number) > 0) then
                    (common:format-number-integer(subsequence($number, 2), $format, $thousandsCur+1, $thousandsPos), $number[1])
                else
                    ()
};


