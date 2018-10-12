module namespace notepadSearch = 'notepadSearch';

import module namespace paths = 'paths' at '/APPLICATIONS/bmoempower/resources/xqueries/commonModules/paths.xqy';
import module namespace common = 'common' at '/APPLICATIONS/bmoempower/resources/xqueries/commonModules/common.xqy';

declare function notepadSearch:getNotepadSearchResults(
	$currentuser as xs:string,
	$first as xs:string,
	$last as xs:string,
	$input as xs:string
) as element(results) {
	let $data := trace(parse-xml($input)/data, "$data")

	let $loanNumber := $data/loanNumber/text()

	let $query := concat(
		"for $notepad in doc('", $paths:NOTEPAD, "')/*/*[LNKEY = '", $loanNumber, "'],",
		"$noteExp allowing empty in doc('", $paths:NOTEEXP, "')/*/*[LNKEY = $notepad/LNKEY and IDX = $notepad/IDX]",
		" order by $notepad/NOTEDATE",
		" return <r>{($notepad, $noteExp)}</r>")

	let $results :=
		xhive:evaluate(trace($query, 'notepadSearch'))

	let $count := count($results)

	let $listcount := if ($last = '-1')
		then ($count + 1)
		else ($last cast as xs:integer - $first cast as xs:integer) + 1

	return
	<results total='{$count}' hideDetailsPane='true'>{(
		for $result in subsequence($results, $first cast as xs:integer, $listcount) 
			return <result
				loan_number="{$result/NOTEPAD-ROW/LNKEY}"
				date="{common:empowerDateTime($result/NOTEPAD-ROW/NOTEDATE)}"
				initials="{$result/NOTEPAD-ROW/INITIALS}"
				category="{$result/NOTEPAD-ROW/CATEGORY}"
				comment="{$result/NOTEPAD-ROW/DESCRIPTION}"
				exp_notes="{$result/NOTEEXP-ROW/EXPNOTES}"
			/>
	)}</results>
};

