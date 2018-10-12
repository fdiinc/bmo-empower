module namespace auditlog = 'auditlog';

import module namespace core-common = 'core-common' at '/APPLICATIONS/bmoempower/resources/xqueries/commonModules/core-common.xqy';

declare variable $auditlog:basepath := '/DATA/bmoempower/Collection/AuditTrail';

(: search for audit entries :)
declare function auditlog:getAuditLogSearchResults(
    $currentuser as xs:string,
    $first as xs:string,
    $last as xs:string,
    $input as xs:string
) as element(results) {

    let $inputDoc := xhive:parse($input)
    let $inputData := $inputDoc/data
    let $userId := $inputData/userId
    let $fromDate := $inputData/fromDate
    let $toDate := $inputData/toDate
    let $filterAudits := $inputData/filterAudits

    let $wClause := core-common:addClause("", "", "")
    let $wClause := core-common:addClause($wClause, $userId, concat("user = '", $userId, "' "))
    let $wClause := core-common:addRangeClause($wClause, $fromDate, concat($toDate, 'T99:99:99'), 'time')
    let $wClause := if ($wClause != "") then concat('[',$wClause,']') else $wClause

    let $queryString := concat("for $elem in doc('", $auditlog:basepath, "')/auditEntries/auditEntry", $wClause, " return $elem")

    let $init-query := xhive:evaluate(trace($queryString, "========>"))

    let $main-query :=
        if ( $filterAudits  = 'archive' ) then
            $init-query[searchConfiguration != 'auditLogDetails' and searchConfiguration != 'searchAuditLogs' and searchConfiguration != 'login' and searchConfiguration != 'logout']
        else if ( $filterAudits  = 'audit' ) then
            $init-query[searchConfiguration = 'auditLogDetails' or searchConfiguration = 'searchAuditLogs']
        else if ( $filterAudits  = 'login' ) then
            $init-query[searchConfiguration = 'login' or searchConfiguration = 'logout']
        else
             $init-query
     
     let $count := count($main-query)
     let $listcount := if ($last = '-1')
        then ($count + 1)
        else ($last cast as xs:integer - $first cast as xs:integer) + 1

    let $paginatedResults := 
        for $elem in subsequence($main-query, $first cast as xs:integer, $listcount)
        return <result
            user='{$elem/user}'
            eventTime = '{fn:substring(data($elem/time),6,2)}/{fn:substring(data($elem/time),9,2)}/{fn:substring(data($elem/time),1,4)} {fn:substring(data($elem/time),12,8)}'
            dateTime = '{$elem/time}'
            searchConfiguration='{$elem/searchConfiguration}'
            userLastName='{$elem/data/lastName}'
            userFirstName = '{$elem/data/firstName}'
            type='trans_auditLogDetails'
            title='Search Request Details'/>

    return <results total='{$count}'>{$paginatedResults}</results>
};
