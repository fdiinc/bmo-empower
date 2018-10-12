(:
	Common XQuery functions for DDS.

	DO NOT MODIFY
	
	this file is part of the DDS framework and changes will be lose on DDS upgrade.
:)
module namespace core-common = 'core-common';

declare function core-common:fts(
	$column as xs:string,
	$value as xs:string
) {
	if (string-length($value) gt 0)
		then concat($column, ' contains text ".*', core-common:trim($value), '.*" using wildcards')
	else ()
};

declare function core-common:trim(
	$str as xs:string
) {
	replace(replace($str, "^\s+", ""), "\s+$", "")
};

declare function core-common:outerJoin(
	$join as xs:string
) {
	concat('(let $result := ', $join, ' return if (empty($result)) then <EMPTY /> else $result)')
};

declare function core-common:ifIfCase(
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

declare function core-common:getExtention(
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


declare function core-common:replaceMonths(
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
		$date/text()
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

declare function core-common:dbDateToComparableDate(
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

declare function core-common:toComparableDateDBDate(
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

declare function core-common:paddPlusZero(
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

declare function core-common:whereClause(
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

declare function core-common:stripPlusZero(
	$input
) {
	core-common:stripPlusZero($input, ())
};

declare function core-common:stripPlusZero(
	$input,
	$ignore as xs:string*
) {
	if ($input instance of xs:untypedAtomic)
		then
			let $result := replace($input, '^\+0+', '')
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
							let $result := replace($output, '^\+0+', '')
							return
								element {$output/name()} {
									if (string-length($result) = 0 and not(string-length($output) = 0))
										then '0'
									else
										$result
								}
				else
					element {$output/name()} {core-common:stripPlusZero($output/*, $ignore)}
};

(: build where clause components from partial strings :)
declare function core-common:addClause($whereClause as xs:string, $value as xs:string*, $expr as xs:string) as xs:string {
    
    let $expr := concat("(", $expr, ")")
    return
        if (empty($value) or $value = '' or normalize-space($value) = '') then
            $whereClause
        else if ($whereClause = "") then 
            $expr
        else 
            concat($whereClause, " and ", $expr)
};

(: build contains where clause components from partial strings :)
declare function core-common:addContainsClause($whereClause as xs:string, $var as xs:string?, $elemPath as xs:string) as xs:string {

     if (empty($var) or $var = "")
        then $whereClause
    else if ($whereClause = "" or empty($whereClause)) 
        then concat($elemPath, " contains text &apos;.*", $var, ".* &apos; using wildcards")
    else concat($whereClause, " and ", $elemPath, " contains text &apos;.*", $var, ".* &apos; using wildcards")
};

(: build contains where clause components from partial strings, or'd together' :)
declare function core-common:addOrContainsClause($whereClause as xs:string, $var as xs:string?, $elemPath as xs:string) as xs:string {

      if (empty($var) or $var = "")
        then $whereClause
    else if ($whereClause = "" or empty($whereClause)) 
        then concat($elemPath, " contains text &apos;.*", $var, ".* &apos; using wildcards")
    else concat($whereClause, " or ", $elemPath, " contains text &apos;.*", $var, ".* &apos; using wildcards")
};

(: build range where clause component :)
declare function core-common:addRangeClause(
    $whereClause as xs:string, $fromStr as xs:string, $toStr as xs:string, $elementName as xs:string) as xs:string {

    if (empty($fromStr) or empty($toStr) or ($fromStr = '') or ($toStr = '')
        or normalize-space($fromStr) = '' or normalize-space($toStr) = '')
    then $whereClause
    else
        if ($whereClause = '')
        then concat($elementName, "[. >= '", $fromStr, "' and . <= '", $toStr, "'] ")
        else concat($whereClause, " and ", $elementName, "[. >= '", $fromStr, "' and . <= '", $toStr, "'] ")
};

(: convert dates like yyyymmddhhmmss or yyyymmddhhmm or yyyymmdd to yyyy-mm-dd hh:mm:ss style format :)
declare function core-common:date14readable($dateString as xs:string) as xs:string {

    (: assume we always have at least yyyymmdd :)
    let $result := concat(substring($dateString, 1, 4), '-', substring($dateString, 5, 2), '-', substring($dateString, 7, 2))

    let $hour := substring($dateString, 9, 2)
    let $min := substring($dateString, 11, 2)
    (: assume we don't have yyyymmddhh - if hours exist, will have minutes :)
    let $result := if (empty($hour) or ($hour = ''))
        then $result
        else concat($result, ' ', $hour, ':', $min)

    let $sec := substring($dateString, 13, 2)
    let $result := if (empty($sec) or ($sec = ''))
        then $result
        else concat($result, ':', $sec)
    return $result
};

(: get a count based subsequence from a provided query :)
declare function core-common:getQuerySubsequence($query as item()*, $first as xs:string, $last as xs:string) as element()? {

    let $count := count($query)
    let $listcount := if ($last = '-1')
        then ($count + 1)
        else ($last cast as xs:integer - $first cast as xs:integer) + 1
    return  <results total='{ $count }'> {
        for $elem in subsequence($query, $first cast as xs:integer, $listcount) return $elem
    } </results>
};

declare function core-common:escapeWildcard($target) as xs:string {

    let $target := replace($target, "\.", "\\.")
    let $target := replace($target, "\?", "\\?")
    let $target := replace($target, "\*", "\\*")
    let $target := replace($target, "\+", "\\+")
    let $target := replace($target, "\{", "\\{.")
    return $target
};

declare function core-common:addCustomClause($whereClause as xs:string, $var as xs:string*, $expr as xs:string) as xs:string {
    if (empty($var) or $var = "")
        then $whereClause
    else if ($whereClause = "") 
        then $expr
    else concat($whereClause, " and ", $expr)
};

declare function core-common:addDateRangeClause($whereClause as xs:string, $dateFrom as xs:string*, $dateTo as xs:string*, $elemPath as xs:string) as xs:string {

    let $dateClause := 
        if((empty($dateFrom) or $dateFrom = '') and (empty($dateTo) or $dateTo = '')) (: Both Empty :)
            then $whereClause
        else if(empty($dateFrom) or $dateFrom = '') (: Only Date To, Exact :)
            then core-common:addCustomClause($whereClause, $dateTo, concat($elemPath, " = ", replace($dateTo, '-', ''), " "))
        else if(empty($dateTo) or $dateTo = '') (: Only Date From, Exact :)
            then core-common:addCustomClause($whereClause, $dateFrom, concat($elemPath, " = ", replace($dateFrom, '-', ''), " "))
        else (: Both Populated, Range :)
            let $whereClause := core-common:addCustomClause($whereClause, $dateFrom, concat($elemPath, " &gt;= ", replace($dateFrom, '-', ''), " "))
            let $whereClause := core-common:addCustomClause($whereClause, $dateTo, concat($elemPath, " &lt;= ", replace($dateTo, '-', ''), " "))
            return $whereClause

    return $dateClause
};
