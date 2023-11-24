<?php
// for correct error message outputs
//putenv("NLS_LANG=KOREAN_KOREA.AL32UTF8");
print '<style>
    .movie-table {
        background-color: black;
        border-collapse: collapse;
        width: 80%;
        font-family: Arial, sans-serif;
        border: 1px solid #ddd;
    }
    .movie-table th {
        background-color: black;
        color: white;
        padding: 10px;
        border: 1px solid #ddd;
    }
    .movie-table td {
        background-color: black;
        color: white;
        padding: 8px;
        border: 1px solid #ddd;
    }
</style>';


function p_error ($e_message) {
	print "<font color=red>".$e_message."</font><br>";
	$e = oci_error(); //에러 정보 가져오기
	print htmlentities($e['message']); //메시지만 출력
        exit();
}

if (!($conn = oci_connect("db2018742029","db77550542", "localhost/course"))) {
    p_error("Connection Failed ...");
}

$studioName = $_GET["studioName"];


if (!empty($studioName)){
    $studioName = str_replace("'", "''", $studioName);
}

$mv_info = oci_parse($conn, "SELECT s.name as studioName, s.address as studioAddress, me.name as presName, me.address as presAddress, networth
                            FROM studio s, movieexec me
                            WHERE s.name = :studioname and s.presno = me.certno");
oci_bind_by_name($mv_info, ":studioname", $studioName);

if (!$mv_info) {
    p_error("SQL Parsing Failed...");
}

if (!oci_execute($mv_info)) {
    p_error("Execution Failed...");
}
print '<table class="movie-table">';
print "<TR align=center><TH> 영화사의 이름 <TH> 영화사 주소 <TH> 사장 <TH> 사장의 주소 <TH> 재산 액수</TR>\n";

while ($row = oci_fetch_array($mv_info)) {
    print "<TR> <TD> $row[0] <TD> $row[1]<TD> $row[2]<TD> $row[3]<TD> $row[4]</TR>\n";
}
print "</TABLE>\n";

oci_free_statement($mv_info);
oci_close($conn);
?>