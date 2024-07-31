############################################################################################################################################
# This file was converted from the repository https://github.com/AlexeyALeonov/success_rate to output HTML instead of text.
# I only take credit for the HTML output, Alexey created the logic behind all of this
# Thanks to Alexey for creating the Powershell success rate script
############################################################################################################################################

$log = Get-Content "C:\Program Files\Storj\Storage Node\storagenode.log"

$auditsSuccess = ($log | Select-String GET_AUDIT | Select-String downloaded).Count

$auditsFailed = ($log | Select-String GET_AUDIT | Select-String failed | Select-String exist -NotMatch).Count

$auditsFailedCritical = ($log | Select-String GET_AUDIT | Select-String failed | Select-String exist).Count

if (($auditsSuccess + $auditsFailed + $auditsFailedCritical) -ge 1) {
    $audits_failed_ratio = $auditsFailed / ($auditsSuccess + $auditsFailed + $auditsFailedCritical) * 100
    $audits_critical_ratio = $auditsFailedCritical / ($auditsSuccess + $auditsFailed + $auditsFailedCritical) * 100
    $audits_success_ratio = $auditsSuccess / ($auditsSuccess + $auditsFailed + $auditsFailedCritical) * 100
} else {
    $audits_failed_ratio = 0.00
    $audits_critical_ratio = 0.00
    $audits_success_ratio = 0.00
}

$storj_stats = "<tr>"
$storj_stats += "<th>Audit</th>"
$storj_stats += "<td>" + $auditsFailedCritical + "</td>"
$storj_stats += "<td>{0:N}%</td>" -f $audits_critical_ratio
$storj_stats += "<td>" + $auditsFailed + "</td>"
$storj_stats += "<td>{0:N}%</td>" -f $audits_failed_ratio
$storj_stats += "<td>" + $auditsSuccess + "</td>"
$storj_stats += "<td>{0:N}%</td>" -f $audits_success_ratio

$storj_stats += "</tr>"
$storj_stats += "<tr>"
$storj_stats += "<th>Download</th>"

$dl_success = ($log | Select-String '"GET"' | Select-String downloaded).Count

$dl_canceled = ($log | Select-String '"GET"' | Select-String canceled).Count

$dl_failed = ($log | Select-String '"GET"' | Select-String failed).Count

if (($dl_success + $dl_failed + $dl_canceled) -ge 1) {
    $dl_failed_ratio = $dl_failed / ($dl_success + $dl_failed + $dl_canceled) * 100
    $dl_canceled_ratio = $dl_canceled / ($dl_success + $dl_failed + $dl_canceled) * 100
    $dl_ratio = $dl_success / ($dl_success + $dl_failed + $dl_canceled) * 100
} else {
    $dl_failed_ratio = 0.00
    $dl_canceled_ratio = 0.00
    $dl_ratio = 0.00
}

$storj_stats += "<td>" + $dl_failed + "</td>"
$storj_stats += "<td>{0:N}%</td>" -f $dl_failed_ratio
$storj_stats += "<td>" + $dl_canceled + "</td>"
$storj_stats += "<td>{0:N}%</td>" -f $dl_canceled_ratio
$storj_stats += "<td>" + $dl_success + "</td>"
$storj_stats += "<td>{0:N}%</td>" -f $dl_ratio

$storj_stats += "</tr>"
$storj_stats += "<tr>"
$storj_stats += "<th>Upload</th>"

$put_success = ($log | Select-String '"PUT"' | Select-String uploaded).Count

$put_rejected = ($log | Select-String '"PUT"' | Select-String rejected).Count

$put_canceled = ($log | Select-String '"PUT"' | Select-String canceled).Count

$put_failed = ($log | Select-String '"PUT"' | Select-String failed).Count

if (($put_success + $put_rejected + $put_failed + $put_canceled) -ge 1) {
    $put_failed_ratio = $put_failed / ($put_success + $put_rejected + $put_failed + $put_canceled) * 100
    $put_canceled_ratio = $put_canceled / ($put_success + $put_rejected + $put_failed + $put_canceled) * 100
    $put_accept_ratio = ($put_success + $put_canceled + $put_failed) / ($put_success + $put_rejected + $put_failed + $put_canceled) * 100
    $put_ratio = $put_success / ($put_success + $put_rejected + $put_failed + $put_canceled) * 100
} else {
    $put_failed_ratio = 0.00
    $put_canceled_ratio = 0.00
    $put_accept_ratio = 0.00
    $put_ratio = 0.00
}


$storj_stats += "<td>" + $put_failed + "</td>"
$storj_stats += "<td>{0:N}%</td>" -f $put_failed_ratio
$storj_stats += "<td>" + $put_canceled + "</td>"
$storj_stats += "<td>{0:N}%</td>" -f $put_canceled_ratio
$storj_stats += "<td>" + $put_success + "</td>"
$storj_stats += "<td>{0:N}%</td>" -f $put_ratio


$get_repair_success = ($log | Select-String GET_REPAIR | Select-String downloaded).Count

$get_repair_canceled = ($log | Select-String GET_REPAIR | Select-String canceled).Count

$get_repair_failed = ($log | Select-String GET_REPAIR | Select-String failed).Count

if (($get_repair_success + $get_repair_failed + $get_repair_canceled) -ge 1) {
    $get_repair_failed_ratio = $get_repair_failed / ($get_repair_success + $get_repair_failed + $get_repair_canceled) * 100
    $get_repair_canceled_ratio = $get_repair_canceled / ($get_repair_success + $get_repair_failed + $get_repair_canceled) * 100
    $get_repair_ratio = $get_repair_success / ($get_repair_success + $get_repair_failed + $get_repair_canceled) * 100
} else {
    $get_repair_failed_ratio = 0.00
    $get_repair_canceled_ratio = 0.00
    $get_repair_ratio = 0.00
}

$storj_stats += "</tr>"
$storj_stats += "<tr>"
$storj_stats += "<th>Repair Download</th>"


$storj_stats += "<td>" + $get_repair_failed + "</td>"
$storj_stats += "<td>{0:N}%</td>" -f $get_repair_failed_ratio
$storj_stats += "<td>" + $get_repair_canceled + "</td>"
$storj_stats += "<td>{0:N}%</td>" -f $get_repair_canceled_ratio
$storj_stats += "<td>" + $get_repair_success + "</td>"
$storj_stats += "<td>{0:N}%</td>" -f $get_repair_ratio

$storj_stats += "</tr>"
$storj_stats += "<tr>"
$storj_stats += "<th>Repair Upload</th>"

$put_repair_success = ($log | Select-String PUT_REPAIR | Select-String uploaded).Count

$put_repair_canceled = ($log | Select-String PUT_REPAIR | Select-String canceled).Count

$put_repair_failed = ($log | Select-String PUT_REPAIR | Select-String failed).Count

if (($put_repair_success + $put_repair_failed + $put_repair_canceled) -ge 1) {
    $put_repair_failed_ratio = $put_repair_failed / ($put_repair_success + $put_repair_failed + $put_repair_canceled) * 100
    $put_repair_canceled_ratio = $put_repair_canceled / ($put_repair_success + $put_repair_failed + $put_repair_canceled) * 100
    $put_repair_ratio = $put_repair_success / ($put_repair_success + $put_repair_failed + $put_repair_canceled) * 100
} else {
    $put_repair_failed_ratio = 0.00
    $put_repair_canceled_ratio = 0.00
    $put_repair_ratio = 0.00
}

$storj_stats += "<td>" + $put_repair_failed + "</td>"
$storj_stats += "<td>{0:N}%</td>" -f $put_repair_failed_ratio
$storj_stats += "<td>" + $put_repair_canceled + "</td>"
$storj_stats += "<td>{0:N}%</td>" -f $put_repair_canceled_ratio
$storj_stats += "<td>" + $put_repair_success + "</td>"
$storj_stats += "<td>{0:N}%</td>" -f $put_repair_ratio
$storj_stats += "</tr>"

write $($storj_stats) | Out-File -FilePath D:\wwwroot\crypto\storjsuccess.txt -Force

#Now that we got all the stats for the day, wipe the logs!
Clear-Content -LiteralPath "C:\Program Files\Storj\Storage Node\storagenode.log" -Force
