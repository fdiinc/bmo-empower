module namespace depositDetails = 'depositDetails';

import module namespace paths = 'paths' at '/APPLICATIONS/bmoempower/resources/xqueries/commonModules/paths.xqy';
import module namespace common = 'common' at '/APPLICATIONS/bmoempower/resources/xqueries/commonModules/common.xqy';
import module namespace empowerCommon = 'empowerCommon' at '/APPLICATIONS/bmoempower/resources/xqueries/commonModules/empowerCommon.xqy';

declare function depositDetails:getDepositDetailsResults(
    $loanNumber as xs:string
) { 
	let $borrowerInfo := for $rec in doc('/DATA/bmoempower/Collection/BORRINFO')/*/*[LNKEY = $loanNumber] order by $rec/WHICHBORR return $rec
	let $propInfo := doc('/DATA/bmoempower/Collection/PROPINFO')/*/*[LNKEY = $loanNumber]
	let $depositInfo := doc('/DATA/bmoempower/Collection/U_GL_DEPOSITS')/*/*[LNKEY = $loanNumber]


	return
       <results>
		<accountInfo>
			<borrowers>{$borrowerInfo}</borrowers> { $propInfo }
		</accountInfo>
            	<depositsSection>
			<U_GL_DEPOSITS-ROW>
			<APP_DEP_AMT>{common:empowerCurrency($depositInfo/APP_DEP_AMT)}</APP_DEP_AMT>
			<APP_DEP_CONFIRMED>{common:empowerBoolean($depositInfo/APP_DEP_CONFIRMED)}</APP_DEP_CONFIRMED>
			<APP_DEP_CONFIRMED_DT>{common:empowerDate($depositInfo/APP_DEP_CONFIRMED_DT)}</APP_DEP_CONFIRMED_DT>
			<APP_DEP_REVERSED>{common:empowerBoolean($depositInfo/APP_DEP_REVERSED)}</APP_DEP_REVERSED>
			<APP_DEP_REVERSED_AMT>{common:empowerCurrency($depositInfo/APP_DEP_REVERSED_AMT)}</APP_DEP_REVERSED_AMT>
			<APP_LASTPD_DT>{common:empowerDate($depositInfo/APP_LASTPD_DT)}</APP_LASTPD_DT>
			<LOCK_DEP_AMT>{common:empowerCurrency($depositInfo/LOCK_DEP_AMT)}</LOCK_DEP_AMT>
			<LOCK_DEP_CONFIRMED>{common:empowerBoolean($depositInfo/LOCK_DEP_CONFIRMED)}</LOCK_DEP_CONFIRMED>
			<LOCK_DEP_CONFIRMED_DT>{common:empowerDate($depositInfo/LOCK_DEP_CONFIRMED_DT)}</LOCK_DEP_CONFIRMED_DT>
			<LOCK_DEP_REVERSED>{common:empowerBoolean($depositInfo/LOCK_DEP_REVERSED)}</LOCK_DEP_REVERSED>
			<LOCK_DEP_REVERSED_AMT>{common:empowerCurrency($depositInfo/LOCK_DEP_REVERSED_AMT)}</LOCK_DEP_REVERSED_AMT>
			<LOCK_LASTPD_DT>{common:empowerDate($depositInfo/LOCK_LASTPD_DT)}</LOCK_LASTPD_DT>
			<MISC1_DEP_AMT>{common:empowerCurrency($depositInfo/MISC1_DEP_AMT)}</MISC1_DEP_AMT>
			<MISC1_DEP_DESC>{$depositInfo/MISC1_DEP_DESC}</MISC1_DEP_DESC>
			<MISC1_DEP_CONFIRMED>{common:empowerBoolean($depositInfo/MISC1_DEP_CONFIRMED)}</MISC1_DEP_CONFIRMED>
			<MISC1_DEP_CONFIRMED_DT>{common:empowerDate($depositInfo/MISC1_DEP_CONFIRMED_DT)}</MISC1_DEP_CONFIRMED_DT>
			<MISC1_DEP_REVERSED>{common:empowerBoolean($depositInfo/MISC1_DEP_REVERSED)}</MISC1_DEP_REVERSED>
			<MISC1_DEP_REVERSED_AMT>{common:empowerCurrency($depositInfo/MISC1_DEP_REVERSED_AMT)}</MISC1_DEP_REVERSED_AMT>
			<MISC1_LASTPD_DT>{common:empowerDate($depositInfo/MISC1_LASTPD_DT)}</MISC1_LASTPD_DT>
			<MISC2_DEP_DESC>{$depositInfo/MISC2_DEP_DESC}</MISC2_DEP_DESC>
			<MISC2_DEP_AMT>{common:empowerCurrency($depositInfo/MISC2_DEP_AMT)}</MISC2_DEP_AMT>
			<MISC2_DEP_CONFIRMED>{common:empowerBoolean($depositInfo/MISC2_DEP_CONFIRMED)}</MISC2_DEP_CONFIRMED>
			<MISC2_DEP_CONFIRMED_DT>{common:empowerDate($depositInfo/MISC2_DEP_CONFIRMED_DT)}</MISC2_DEP_CONFIRMED_DT>
			<MISC2_DEP_REVERSED>{common:empowerBoolean($depositInfo/MISC2_DEP_REVERSED)}</MISC2_DEP_REVERSED>
			<MISC2_DEP_REVERSED_AMT>{common:empowerCurrency($depositInfo/MISC2_DEP_REVERSED_AMT)}</MISC2_DEP_REVERSED_AMT>
			<MISC2_LASTPD_DT>{common:empowerDate($depositInfo/MISC2_LASTPD_DT)}</MISC2_LASTPD_DT>
			<MISC3_DEP_DESC>{$depositInfo/MISC3_DEP_DESC}</MISC3_DEP_DESC>
			<MISC3_DEP_AMT>{common:empowerCurrency($depositInfo/MISC3_DEP_AMT)}</MISC3_DEP_AMT>
			<MISC3_DEP_CONFIRMED>{common:empowerBoolean($depositInfo/MISC3_DEP_CONFIRMED)}</MISC3_DEP_CONFIRMED>
			<MISC3_DEP_CONFIRMED_DT>{common:empowerDate($depositInfo/MISC3_DEP_CONFIRMED_DT)}</MISC3_DEP_CONFIRMED_DT>
			<MISC3_DEP_REVERSED>{common:empowerBoolean($depositInfo/MISC3_DEP_REVERSED)}</MISC3_DEP_REVERSED>
			<MISC3_DEP_REVERSED_AMT>{common:empowerCurrency($depositInfo/MISC3_DEP_REVERSED_AMT)}</MISC3_DEP_REVERSED_AMT>
			<MISC3_LASTPD_DT>{common:empowerDate($depositInfo/MISC3_LASTPD_DT)}</MISC3_LASTPD_DT>	
			<TOTAL_APP_DEPOSIT_OUT>{common:empowerCurrency($depositInfo/TOTAL_APP_DEPOSIT_OUT)}</TOTAL_APP_DEPOSIT_OUT>
			<DISPOSITIONED_MONEY>{common:empowerCurrency($depositInfo/DISPOSITIONED_MONEY)}</DISPOSITIONED_MONEY>
			</U_GL_DEPOSITS-ROW>		
            	</depositsSection>
        </results>
};


