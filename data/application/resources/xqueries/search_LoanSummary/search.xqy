module namespace loanSummarySearch = 'loanSummarySearch';


import module namespace core-common = 'core-common' at '/APPLICATIONS/bmoempower/resources/xqueries/commonModules/core-common.xqy';
import module namespace paths = 'paths' at '/APPLICATIONS/bmoempower/resources/xqueries/commonModules/paths.xqy';
import module namespace common = 'common' at '/APPLICATIONS/bmoempower/resources/xqueries/commonModules/common.xqy';

declare function loanSummarySearch:getLoanSummarySearchResults(
	$currentuser as xs:string,
	$first as xs:string,
	$last as xs:string,
	$input as xs:string
) as element(results) {
	let $data := trace(parse-xml($input)/data, "$data")

	let $loanNumber := $data/loanNumber/text()
	let $borr_last := $data/borr_last/text()
	let $borr_first := $data/borr_first/text()
	let $prop_addr := $data/prop_addr/text()
	let $prop_city := $data/prop_city/text()
	let $prop_state := $data/prop_state/text()
	let $prop_zip := $data/prop_zip/text()
	let $ssn_or_tin := $data/ssn_or_tin/text()
	let $originatorBanker := $data/originatorBanker/text()

	let $isBankerSearch :=
		string-length($originatorBanker) gt 0

	let $isPropSearch := 
		string-length($prop_addr) gt 0
		or string-length($prop_city) gt 0
		or string-length($prop_state) gt 0
		or string-length($prop_zip) gt 0


	let $isBorrSearch :=
		string-length($loanNumber) gt 0
		or string-length($borr_last) gt 0
		or string-length($borr_first) gt 0
		or string-length($ssn_or_tin) gt 0



	let $borrinfoStart := concat(
		"$bi  in doc('", $paths:BORRINFO, "')/*/*",
			core-common:whereClause((
				if (string-length($loanNumber) gt 0)
					then concat("LNKEY = '", $loanNumber, "'")
					else (),
				if (string-length($borr_last) gt 0)
					then concat("BORR_LAST contains text '.*", $borr_last, ".*' using wildcards")
					else (),
				if (string-length($borr_first) gt 0)
					then concat("BORR_FIRST contains text '.*", $borr_first, ".*'using wildcards")
					else (),
				if (string-length($ssn_or_tin) gt 0)
					then concat("BORR_SSN contains text '.*", $ssn_or_tin, ".*' using wildcards")
					else (),
				if (string-length($ssn_or_tin) gt 0)
					then concat("BORR_SSN contains text '.*", $ssn_or_tin, ".*' using wildcards")
					else ()
			)))


	let $propinfoJoin := concat(
		"$prop ", if (not ($isPropSearch)) then " allowing empty " else () ,"in doc('", $paths:PROPINFO, "')/*/*",
			core-common:whereClause((
				if ($isBorrSearch)
					then "LNKEY = $bi/LNKEY"
				else (),
				if (string-length($prop_addr) gt 0)
					then concat("PROP_ADDR contains text '.*", $prop_addr, ".*'using wildcards")
					else (),
				if (string-length($prop_city) gt 0)
					then concat("PROP_CITY contains text '.*", $prop_city, ".*'using wildcards")
					else (),
				if (string-length($prop_state) gt 0)
					then concat("PROP_STATE contains text '", $prop_state, "'")
					else (),
				if (string-length($prop_zip) gt 0)
					then concat("PROP_ZIP = '", $prop_zip, "'")
					else ()
			))
			)


	let $bankerinfoJoin := concat(
		"$banker ", if (not ($isBankerSearch)) then " allowing empty " else () ," in doc('", $paths:INTRVIEW, "')/*/*",
			core-common:whereClause((
				if (not($isBankerSearch) or $isBorrSearch or $isPropSearch)
					then "LNKEY = $bi/LNKEY"
				else (),
				if ($isBankerSearch)
					then concat("INT_NAME contains text '.*", $originatorBanker, ".*'using wildcards")
					else ()
			))
			)

		

	let $query := concat(
		"for ",
		if ($isBorrSearch)
			then concat($borrinfoStart, ", ", $propinfoJoin, ", ", $bankerinfoJoin, "(:BORRSEARCH:)")
		else if ($isPropSearch)
			then concat(
			$propinfoJoin,  ", ", 
			"$bi in doc('", $paths:BORRINFO, "')/*/*[LNKEY = $prop/LNKEY]",  ", ",
			$bankerinfoJoin, "(:PROPSEARCH:)"	
			)
		else if ($isBankerSearch and not($isBorrSearch or $isPropSearch))
			then concat(
			$bankerinfoJoin,  ", ",
			"$bi in doc('", $paths:BORRINFO, "')/*/*[LNKEY = $banker/LNKEY]",  ", ", 
			"$prop in doc('", $paths:PROPINFO, "')/*/*[LNKEY = $banker/LNKEY]" , "(:BANKERSEARCH:)"
			)
		else concat(
			$propinfoJoin,  ", ", 
			"$bi in doc('", $paths:BORRINFO, "')/*/*[LNKEY = $prop/LNKEY]",  ", ",
			$bankerinfoJoin, "(:DEFAULTSEARCH:)"
			)
		, 

		" order by $bi/BORR_LAST, $bi/BORR_FIRST",
		" return <r>{($bi, $prop, $banker)}</r>")

	let $results :=
		xhive:evaluate(trace($query, 'loanSummarySearchQuery'))

	let $count := count($results)

	let $listcount := if ($last = '-1')
		then ($count + 1)
		else ($last cast as xs:integer - $first cast as xs:integer) + 1

				(: loan_number="{$result/BORRINFO-ROW/LNKEY}" :)
	return  
	<results total='{$count}' hideDetailsPane='false'>{  ( 
		for $result in subsequence($results, $first cast as xs:integer, $listcount)
			 
			return <result
				type="trans_loanSummary"
				loan_number="{$result/BORRINFO-ROW/LNKEY}"
				which_borrower="{$result/BORRINFO-ROW/WHICHBORR}"
				borrower_ssn_or_tin="{$result/BORRINFO-ROW/BORR_SSN}"
				borrower_first_name="{$result/BORRINFO-ROW/BORR_FIRST}"
				borrower_middle_name="{$result/BORRINFO-ROW/BORR_MIDDLE}"
				borrower_last_name="{$result/BORRINFO-ROW/BORR_LAST}"
				aka="{$result/BORRINFO-ROW/BORR_AKA}"
				borrower_age="{$result/BORRINFO-ROW/BORR_AGE}"
				house_number="{$result/BORRINFO-ROW/BORR_HOUSENUM}"
				borrower_birth_date="{common:empowerDate($result/BORRINFO-ROW/BORR_BIRTHDATE)}"
				borrower_position_title_or_type_of_business="{$result/BORRINFO-ROW/BORR_BUSTITLE}"
				e-mail_address="{$result/BORRINFO-ROW/BORR_EMAIL}"
				borrower_suffix="{$result/BORRINFO-ROW/BORR_GEN}"
				borrower_full_name="{$result/BORRINFO-ROW/BORR_NAME}"
				borrower_phone_number="{$result/BORRINFO-ROW/BORR_PHONE}"
				borrower_is_entity="{$result/BORRINFO-ROW/NONPERSONBORRFLAG}"
				borrower_other_phone="{$result/BORRINFO-ROW/OTHER_PHONE}"
				property_addr="{$result/PROPINFO-ROW/PROP_ADDR}"
				property_addr2="{$result/PROPINFO-ROW/PROP_ADDR2}"
				property_city="{$result/PROPINFO-ROW/PROP_CITY}"
				property_state="{$result/PROPINFO-ROW/PROP_STATE}"
				property_zip="{$result/PROPINFO-ROW/PROP_ZIP}"
				property_county="{$result/PROPINFO-ROW/PROP_COUNTY}"
				int_name="{doc( $paths:INTRVIEW)/*/INTRVIEW-ROW[LNKEY=$result/BORRINFO-ROW/LNKEY]/INT_NAME}"
			/>

	)}</results>
};
 
 
