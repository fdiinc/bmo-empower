module namespace empowerCommon = 'empowerCommon';

import module namespace paths = 'paths' at '/APPLICATIONS/bmoempower/resources/xqueries/commonModules/paths.xqy';
import module namespace common = 'common' at '/APPLICATIONS/bmoempower/resources/xqueries/commonModules/common.xqy';



declare function empowerCommon:getAccountHeaderSection($loan_number as xs:string) as element(accountHeaderSection) {

    let $accountHeaderSection :=
        <accountHeaderSection>
            <account_number>{$loan_number}</account_number>
        </accountHeaderSection>
        
    return $accountHeaderSection
};
