module namespace paymentDetails = 'paymentDetails';

import module namespace paths = 'paths' at '/APPLICATIONS/bmoempower/resources/xqueries/commonModules/paths.xqy';
import module namespace common = 'common' at '/APPLICATIONS/bmoempower/resources/xqueries/commonModules/common.xqy';
import module namespace empowerCommon = 'empowerCommon' at '/APPLICATIONS/bmoempower/resources/xqueries/commonModules/empowerCommon.xqy';

declare function paymentDetails:getPaymentDetailsResults(
    $loanNumber as xs:string
) { 
	let $borrowerInfo := for $rec in doc('/DATA/bmoempower/Collection/BORRINFO')/*/*[LNKEY = $loanNumber] order by $rec/WHICHBORR return $rec
	let $propInfo := doc('/DATA/bmoempower/Collection/PROPINFO')/*/*[LNKEY = $loanNumber]
	let $paymentInfo := doc('/DATA/bmoempower/Collection/U_GL_PAYMENTS')/*/*[LNKEY = $loanNumber]
	let $paymentContInfo := doc('/DATA/bmoempower/Collection/U_GL_PAYMENTSCONT')/*/*[LNKEY = $loanNumber]
	return
       <results>
		<accountInfo>
			<borrowers>{$borrowerInfo}</borrowers> { $propInfo }
		</accountInfo>
            	<paymentsSection>
			 	<U_GL_PAYMENTS-ROW>
					
					
					<APPR_AMT_PD>{common:empowerCurrency($paymentInfo/APPR_AMT_PD)}</APPR_AMT_PD>
					<APPR_CURR_BAL>{common:empowerCurrency($paymentInfo/APPR_CURR_BAL)}</APPR_CURR_BAL>
					<APPR_PD_CONFIRMED>{common:empowerBoolean($paymentInfo/APPR_PD_CONFIRMED)}</APPR_PD_CONFIRMED>
					<APPR_PD_CONFIRMED_DT>{common:empowerDate($paymentInfo/APPR_PD_CONFIRMED_DT)}</APPR_PD_CONFIRMED_DT> 
					<CREDIT_AMT_PD>{common:empowerCurrency($paymentInfo/CREDIT_AMT_PD)}</CREDIT_AMT_PD>
					<CREDIT_CURR_BAL>{common:empowerCurrency($paymentInfo/CREDIT_CURR_BAL)}</CREDIT_CURR_BAL>
					<CREDIT_PD_CONFIRMED>{common:empowerBoolean($paymentInfo/CREDIT_PD_CONFIRMED)}</CREDIT_PD_CONFIRMED>
					<CREDIT_PD_CONFIRMED_DT>{common:empowerDate($paymentInfo/CREDIT_PD_CONFIRMED_DT)}</CREDIT_PD_CONFIRMED_DT> 
					<FLOOD_AMT_PD>{common:empowerCurrency($paymentInfo/FLOOD_CURR_BAL)}</FLOOD_AMT_PD>
					<FLOOD_CURR_BAL>{common:empowerCurrency($paymentInfo/FLOOD_CURR_BAL)}</FLOOD_CURR_BAL>
					<FLOOD_PD_CONFIRMED>{common:empowerBoolean($paymentInfo/FLOOD_PD_CONFIRMED)}</FLOOD_PD_CONFIRMED>
					<FLOOD_PD_CONFIRMED_DT>{common:empowerDate($paymentInfo/FLOOD_PD_CONFIRMED_DT)}</FLOOD_PD_CONFIRMED_DT> 
					<INSP_AMT_PD>{common:empowerCurrency($paymentInfo/INSP_AMT_PD)}</INSP_AMT_PD>
					<INSP_CURR_BAL>{common:empowerCurrency($paymentInfo/INSP_CURR_BAL)}</INSP_CURR_BAL>
					<INSP_PD_CONFIRMED>{common:empowerBoolean($paymentInfo/INSP_PD_CONFIRMED)}</INSP_PD_CONFIRMED>
					<INSP_PD_CONFIRMED_DT>{common:empowerDate($paymentInfo/INSP_PD_CONFIRMED_DT)}</INSP_PD_CONFIRMED_DT> 
					<LOCK_REFUND_AMT>{common:empowerCurrency($paymentInfo/LOCK_REFUND_AMT)}</LOCK_REFUND_AMT>
					<LOCK_REFUND_CONFIRMED>{common:empowerBoolean($paymentInfo/LOCK_REFUND_CONFIRMED)}</LOCK_REFUND_CONFIRMED>
					<LOCK_RETURNED_AMT>{common:empowerCurrency($paymentInfo/LOCK_RETURNED_AMT)}</LOCK_RETURNED_AMT>
					<LOCK_RETURNED_CONFIRMED>{common:empowerBoolean($paymentInfo/LOCK_RETURNED_CONFIRMED)}</LOCK_RETURNED_CONFIRMED>
					<LOCK_RETURNED_CONFIRMED_DT>{common:empowerBoolean($paymentInfo/LOCK_RETURNED_CONFIRMED_DT)}</LOCK_RETURNED_CONFIRMED_DT>
					<LP_AMT_PD>{common:empowerCurrency($paymentInfo/LP_AMT_PD)}</LP_AMT_PD>
					<LP_CURR_BAL>{common:empowerCurrency($paymentInfo/LP_CURR_BAL)}</LP_CURR_BAL>
					<LP_PD_CONFIRMED>{common:empowerBoolean($paymentInfo/LP_PD_CONFIRMED)}</LP_PD_CONFIRMED>
					<LP_PD_CONFIRMED_DT>{common:empowerDate($paymentInfo/LP_PD_CONFIRMED_DT)}</LP_PD_CONFIRMED_DT> 
					<MISC1_FEE_PAYEE>{$paymentInfo/MISC1_FEE_PAYEE}</MISC1_FEE_PAYEE> 
					<MISC1_FEE_DESC>{$paymentInfo/MISC1_FEE_DESC}</MISC1_FEE_DESC> 
					<MISC1_FEE_GL_ACCOUNT>{$paymentInfo/MISC1_FEE_GL_ACCOUNT}</MISC1_FEE_GL_ACCOUNT> 
					<MISC1_COST_CENTER>{common:empowerBoolean($paymentInfo/MISC1_COST_CENTER)}</MISC1_COST_CENTER> 
					<MISC1_AMT_PD>{common:empowerCurrency($paymentInfo/MISC1_AMT_PD)}</MISC1_AMT_PD>
					<MISC1_CURR_BAL>{common:empowerCurrency($paymentInfo/MISC1_CURR_BAL)}</MISC1_CURR_BAL>
					<MISC1_FEE_AMT>{common:empowerCurrency($paymentInfo/MISC1_FEE_AMT)}</MISC1_FEE_AMT>
					<MISC1_INTERNAL_CHG>{common:empowerBoolean($paymentInfo/MISC1_INTERNAL_CHG)}</MISC1_INTERNAL_CHG>
					<MISC1_PD_CONFIRMED>{common:empowerBoolean($paymentInfo/MISC1_PD_CONFIRMED)}</MISC1_PD_CONFIRMED>
					<MISC1_PD_CONFIRMED_DT>{common:empowerDate($paymentInfo/MISC1_PD_CONFIRMED_DT)}</MISC1_PD_CONFIRMED_DT> 
					<MISC2_FEE_PAYEE>{$paymentInfo/MISC2_FEE_PAYEE}</MISC2_FEE_PAYEE> 
					<MISC2_FEE_DESC>{$paymentInfo/MISC2_FEE_DESC}</MISC2_FEE_DESC> 
					<MISC2_FEE_GL_ACCOUNT>{$paymentInfo/MISC2_FEE_GL_ACCOUNT}</MISC2_FEE_GL_ACCOUNT> 
					<MISC2_COST_CENTER>{common:empowerBoolean($paymentInfo/MISC2_COST_CENTER)}</MISC2_COST_CENTER> 
					<MISC2_AMT_PD>{common:empowerCurrency($paymentInfo/MISC2_AMT_PD)}</MISC2_AMT_PD>
					<MISC2_CURR_BAL>{common:empowerCurrency($paymentInfo/MISC2_CURR_BAL)}</MISC2_CURR_BAL>
					<MISC2_FEE_AMT>{common:empowerCurrency($paymentInfo/MISC2_FEE_AMT)}</MISC2_FEE_AMT>
					<MISC2_INTERNAL_CHG>{common:empowerBoolean($paymentInfo/MISC2_INTERNAL_CHG)}</MISC2_INTERNAL_CHG>
					<MISC2_PD_CONFIRMED>{common:empowerBoolean($paymentInfo/MISC2_PD_CONFIRMED)}</MISC2_PD_CONFIRMED>
					<MISC2_PD_CONFIRMED_DT>{common:empowerDate($paymentInfo/MISC2_PD_CONFIRMED_DT)}</MISC2_PD_CONFIRMED_DT>
					<MISC3_FEE_PAYEE>{$paymentInfo/MISC3_FEE_PAYEE}</MISC3_FEE_PAYEE> 
					<MISC3_FEE_DESC>{$paymentInfo/MISC3_FEE_DESC}</MISC3_FEE_DESC> 
					<MISC3_FEE_GL_ACCOUNT>{$paymentInfo/MISC3_FEE_GL_ACCOUNT}</MISC3_FEE_GL_ACCOUNT> 
					<MISC3_COST_CENTER>{common:empowerBoolean($paymentInfo/MISC3_COST_CENTER)}</MISC3_COST_CENTER> 
					<MISC3_AMT_PD>{common:empowerCurrency($paymentInfo/MISC3_AMT_PD)}</MISC3_AMT_PD>
					<MISC3_CURR_BAL>{common:empowerCurrency($paymentInfo/MISC3_CURR_BAL)}</MISC3_CURR_BAL>
					<MISC3_FEE_AMT>{common:empowerCurrency($paymentInfo/MISC3_FEE_AMT)}</MISC3_FEE_AMT>
					<MISC3_INTERNAL_CHG>{common:empowerBoolean($paymentInfo/MISC3_INTERNAL_CHG)}</MISC3_INTERNAL_CHG>
					<MISC3_PD_CONFIRMED>{common:empowerBoolean($paymentInfo/MISC3_PD_CONFIRMED)}</MISC3_PD_CONFIRMED>
					<MISC3_PD_CONFIRMED_DT>{common:empowerDate($paymentInfo/MISC3_PD_CONFIRMED_DT)}</MISC3_PD_CONFIRMED_DT>
					<PYMT1_AMT_PD>{common:empowerCurrency($paymentInfo/PYMT1_AMT_PD)}</PYMT1_AMT_PD>
					<PYMT1_CONFIRMED>{common:empowerBoolean($paymentInfo/PYMT1_CONFIRMED)}</PYMT1_CONFIRMED>
					<PYMT1_CONFIRMED_DT>{common:empowerDate($paymentInfo/PYMT1_CONFIRMED_DT)}</PYMT1_CONFIRMED_DT>
					<PYMT1_INCOME>{common:empowerCurrency($paymentInfo/PYMT1_INCOME)}</PYMT1_INCOME>
					<PYMT2_AMT_PD>{common:empowerCurrency($paymentInfo/PYMT2_AMT_PD)}</PYMT2_AMT_PD>
					<PYMT2_CONFIRMED>{common:empowerBoolean($paymentInfo/PYMT2_CONFIRMED)}</PYMT2_CONFIRMED>
					<PYMT2_CONFIRMED_DT>{common:empowerDate($paymentInfo/PYMT2_CONFIRMED_DT)}</PYMT2_CONFIRMED_DT>
					<PYMT2_INCOME>{common:empowerCurrency($paymentInfo/PYMT2_INCOME)}</PYMT2_INCOME>
					<PYMT3_AMT_PD>{common:empowerCurrency($paymentInfo/PYMT3_AMT_PD)}</PYMT3_AMT_PD>
					<PYMT3_CONFIRMED>{common:empowerBoolean($paymentInfo/PYMT3_CONFIRMED)}</PYMT3_CONFIRMED>
					<PYMT3_CONFIRMED_DT>{common:empowerDate($paymentInfo/PYMT3_CONFIRMED_DT)}</PYMT3_CONFIRMED_DT>
					<PYMT3_INCOME>{common:empowerCurrency($paymentInfo/PYMT3_INCOME)}</PYMT3_INCOME>
					<UW_AMT_PD>{common:empowerCurrency($paymentInfo/UW_AMT_PD)}</UW_AMT_PD>
					<UW_CURR_BAL>{common:empowerCurrency($paymentInfo/UW_CURR_BAL)}</UW_CURR_BAL>
					<UW_PD_CONFIRMED>{common:empowerBoolean($paymentInfo/UW_PD_CONFIRMED)}</UW_PD_CONFIRMED>
					<UW_PD_CONFIRMED_DT>{common:empowerDate($paymentInfo/UW_PD_CONFIRMED_DT)}</UW_PD_CONFIRMED_DT>

				</U_GL_PAYMENTS-ROW>
				<U_GL_PAYMENTSCONT>
				{for $row in $paymentContInfo
				return
					<U_GL_PAYMENTSCONT-ROW>
						<MISC_AMT_PAID>{common:empowerCurrency($row/MISC_AMT_PAID)}</MISC_AMT_PAID>
						<MISC_CURR_BAL>{common:empowerCurrency($row/MISC_CURR_BAL)}</MISC_CURR_BAL>
						<MISC_FEE_AMT>{common:empowerCurrency($row/MISC_FEE_AMT)}</MISC_FEE_AMT>
						<MISC_INTERNAL_CHG>{common:empowerBoolean($row/MISC_INTERNAL_CHG)}</MISC_INTERNAL_CHG>
						<MISC_PD_CONFIRMED>{common:empowerBoolean($row/MISC_PD_CONFIRMED)}</MISC_PD_CONFIRMED>
						<MISC_PD_CONFIRMED_DT>{common:empowerDate($row/MISC_PD_CONFIRMED_DT)}</MISC_PD_CONFIRMED_DT>
						<SENT_MISC_PM>{common:empowerDate($row/SENT_MISC_PM)}</SENT_MISC_PM>
						<MISC_FEE_PAYEE>{$row/MISC_FEE_PAYEE}</MISC_FEE_PAYEE> 
						<MISC_COST_CENTER>{common:empowerBoolean($row/MISC_COST_CENTER)}</MISC_COST_CENTER> 
						<MISC_FEE_GL_ACCOUNT>{$row/MISC_FEE_GL_ACCOUNT}</MISC_FEE_GL_ACCOUNT> 
						<MISC_FEE_DESC>{$row/MISC_FEE_DESC}</MISC_FEE_DESC> 
					</U_GL_PAYMENTSCONT-ROW>
				}
				</U_GL_PAYMENTSCONT>
			
            	</paymentsSection>
        </results>};


