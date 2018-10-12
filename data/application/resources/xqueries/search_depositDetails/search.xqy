module namespace depositDetailsSearch = 'depositDetailsSearch';

import module namespace core-common = 'core-common' at '/APPLICATIONS/bmoempower/resources/xqueries/commonModules/core-common.xqy';
import module namespace paths = 'paths' at '/APPLICATIONS/bmoempower/resources/xqueries/commonModules/paths.xqy';
import module namespace common = 'common' at '/APPLICATIONS/bmoempower/resources/xqueries/commonModules/common.xqy';

declare function depositDetailsSearch:getDepositDetailsResults(
	$currentuser as xs:string,
	$first as xs:string,
	$last as xs:string,
	$input as xs:string
) as element(results) {
	let $data := trace(parse-xml($input)/data, "$data")

	let $loanNumber := $data/loanNumber/text()


	return
	<results total='1'  hideSearchResultPane='true'
            launchFirstResultDetails='true'  title='Deposit Details'>
	
			 <result title='Deposit Details'
				loan_number="{$loanNumber}"
				type='trans_depositDetails'
				caca="stuff"
			/>
	</results>
};
 
