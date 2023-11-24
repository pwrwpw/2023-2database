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
        text-align: center;
        border: 1px solid #ddd;
    }
</style>';

function p_error($e_message) {
    print "<font color=red>".$e_message."</font><br>";
    $e = oci_error(); // 에러 정보 가져오기
    print htmlentities($e['message']); // 메시지만 출력
    exit();
}

if (!($conn = oci_connect("db2018742029", "db77550542", "localhost/course"))) {
    p_error("Connection Failed ...");
}

$studioName = $_GET["studioName"];

if (!empty($studioName)){
    $studioName = str_replace("'", "''", $studioName);
}

$mv_info = oci_parse($conn, "SELECT m.title, m.year,m.length, me.name as producerName
                            FROM movie m,movieexec me
                            where m.producerno = me.certno and studioname = :studioName
                            ORDER BY year,length,title");
oci_bind_by_name($mv_info, ":studioName", $studioName);

if (!$mv_info) {
    p_error("SQL Parsing Failed...");
}

if (!oci_execute($mv_info)) {
    p_error("Execution Failed...");
}

print '<table class="movie-table">';
print "<tr align=center><th>제목</th><th>개봉년도</th><th>상영시간</th><th>제작자 이름</th></tr>\n";

while ($row = oci_fetch_array($mv_info)) {
    $yearFormatted = $row['YEAR'].'년';
    $lengthFormatted = $row['LENGTH'].'분';
    print "<tr><td>{$row['TITLE']}</td><td>{$yearFormatted}</td><td>{$lengthFormatted}</td><td>{$row['PRODUCERNAME']}</td></tr>\n";
}
print "</table>\n";

oci_free_statement($mv_info);
oci_close($conn);
?>
