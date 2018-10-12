module namespace loanSummary = 'loanSummary';

import module namespace paths = 'paths' at '/APPLICATIONS/bmoempower/resources/xqueries/commonModules/paths.xqy';
import module namespace common = 'common' at '/APPLICATIONS/bmoempower/resources/xqueries/commonModules/common.xqy';
import module namespace empowerCommon = 'empowerCommon' at '/APPLICATIONS/bmoempower/resources/xqueries/commonModules/empowerCommon.xqy';

declare function loanSummary:getloanSummaryResults(
    $loanNumber as xs:string
) { 
	let $BORRINFO := for $rec in doc('/DATA/bmoempower/Collection/BORRINFO')/*/*[LNKEY = $loanNumber] order by $rec/WHICHBORR return $rec
	let $PROPINFO := doc('/DATA/bmoempower/Collection/PROPINFO')/*/*[LNKEY = $loanNumber]
	let $CURRADDR := doc('/DATA/bmoempower/Collection/CURRADDR')/*/*[LNKEY = $loanNumber]
	let $TRANSUMM := doc('/DATA/bmoempower/Collection/TRANSUMM')/*/*[LNKEY = $loanNumber]
	let $MTGTERMS := doc('/DATA/bmoempower/Collection/MTGTERMS')/*/*[LNKEY = $loanNumber]
	let $CODES := doc('/DATA/bmoempower/Collection/CODES')/*/*[LNKEY = $loanNumber]
	let $UCODES := doc('/DATA/bmoempower/Collection/UCODES')/*/*[LNKEY = $loanNumber]
	let $U_PRICESETUP := doc('/DATA/bmoempower/Collection/U_PRICESETUP')/*/*[LNKEY = $loanNumber]
	let $RATIOS := doc('/DATA/bmoempower/Collection/RATIOS')/*/*[LNKEY = $loanNumber]
	let $INTRVIEW := doc('/DATA/bmoempower/Collection/INTRVIEW')/*/*[LNKEY = $loanNumber]
	let $TBD := "TBD"

	return
       <results>
		<accountInfo>
			<borrowers>{$BORRINFO}</borrowers> { $PROPINFO }
		</accountInfo>
            	<loanSummarySection>
			<field><name>Primary Borrower</name>	<value>	{concat($BORRINFO[WHICHBORR=1]/BORR_FIRST, " ", 
										$BORRINFO[WHICHBORR=1]/BORR_MIDDLE, " ", 
										$BORRINFO[WHICHBORR=1]/BORR_LAST
										)
								   	}
								</value></field>
			<field><name>Borrower Current Address</name>	<value>	{concat	(	$BORRINFO[WHICHBORR=1]/BORR_HOUSENUM, ", ", 
												$CURRADDR[WHICHBORR=1]/BORR_ADDR, ", ", 
												$BORRINFO[WHICHBORR=1]/BORR_APTNUM, ", ", 
												$CURRADDR[WHICHBORR=1]/BORR_ADDR2, ", ", 
												$CURRADDR[WHICHBORR=1]/BORR_CSZ
											)
										}
									</value></field>
			<field><name>Borrower Mailing Address</name>	<value>	{concat	(	$CURRADDR[WHICHBORR=1]/MAILINGSTREET,", ",
												$CURRADDR[WHICHBORR=1]/MAILINGSTREET2,", ",
												$CURRADDR[WHICHBORR=1]/MAILINGCSZ
											)
										}
									</value></field>
			<field><name>Underwriter comments from 1008</name><value>{$TRANSUMM/UNDERWRITER_COMENT}</value></field>
			<field><name>Loan amount</name><value>{common:empowerCurrency($MTGTERMS/PRINAMT/text())}</value></field>
			<field><name>Loan Type</name><value>{$TBD}</value></field>
			<field><name>Loan Term</name><value>{$UCODES/CODE39D}</value></field>
			<field><name>Appraised Value</name><value>{common:empowerCurrency($MTGTERMS/APPRAISEDVAL/text())}</value></field>
			<field><name>LTV</name><value>{common:empowerPercentage($MTGTERMS/LTV/text())}</value></field>
			<field><name>Occupancy Type</name><value>{$CODES/OCCD}</value></field>
			<field><name>Loan purpose</name><value>{$CODES/LPURPD}</value></field>
			<field><name>Credit Score</name><value>{$U_PRICESETUP/LOWMIDSCORE}</value></field>
			<field><name>Note Rate</name><value>{common:empowerPercentage($MTGTERMS/INTRATE/text())}</value></field>
			<field><name>Total Obligations/Income</name><value>{common:empowerPercentage($RATIOS/DEBT_RATIO/text())}</value></field>
			<field><name>Banker/Originator</name><value>{$INTRVIEW/INT_NAME} </value></field>           	
		</loanSummarySection>
        </results>
};


