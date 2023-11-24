<?php
// for correct error message outputs
putenv("NLS_LANG=KOREAN_KOREA.AL32UTF8");

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

function p_error($e_message) {
    print "<font color=red>".$e_message."</font><br>";
    $e = oci_error();
    print htmlentities($e['message']);
    exit();
}

if (!($conn = oci_connect("db2018742029","db77550542", "localhost/course"))) {
    p_error("Connection Failed ...");
}

$mv_info = oci_parse($conn,
   "SELECT m.title, m.year AS year, m.length, 
       producer.name AS producer_name, 
       president.name AS president_name
    FROM movie m, movieexec producer, studio s, movieexec president
    WHERE m.producerNo = producer.certNo
         AND m.studioname = s.name
         AND s.presNo = president.certNo
    ORDER BY year, length"
);

if (!$mv_info) {
    p_error("SQL Parsing Failed...");
}

if (!oci_execute($mv_info)) {
    p_error("Execution Failed...");
}

print '<table class="movie-table">';
print '<tr><th>제목<th>년도<th>상영시간<th>제작자<th>영화사 사장<th>출연 배우 수<th>출연배우진</tr>';

while ($row = oci_fetch_array($mv_info)) {
    $movieTitle = $row["TITLE"];
    $movieYear = $row["YEAR"];
    $length = $row["LENGTH"];
    $producer = $row["PRODUCER_NAME"];
    $president = $row["PRESIDENT_NAME"]; 

    $cnt_stmt = oci_parse($conn, "SELECT COUNT(*) AS cnt FROM starsin WHERE movieTitle = :movieTitle AND movieYear = :movieYear");
    oci_bind_by_name($cnt_stmt, ":movieTitle", $movieTitle);
    oci_bind_by_name($cnt_stmt, ":movieYear", $movieYear);

    if (!$cnt_stmt) {
        p_error("SQL Parsing Failed...");
    }
    if (!oci_execute($cnt_stmt)) {
        p_error("Execution Failed...");
    }

    $st_info = oci_parse($conn, "SELECT starname FROM starsin,MovieStar WHERE movieTitle = :movieTitle AND movieYear = :movieYear AND starName = name order by birthdate desc");
    oci_bind_by_name($st_info, ":movieTitle", $movieTitle);
    oci_bind_by_name($st_info, ":movieYear", $movieYear);
    
    if (!$st_info) {
        p_error("SQL Parsing Failed...");
    }
    if (!oci_execute($st_info)) {
        p_error("Execution Failed...");
    }

    $starNames = "";
    while ($starname_row = oci_fetch_array($st_info)) {
        $starNames .= $starname_row["STARNAME"] . ", ";
    }

    // 마지막 콤마 제거
    $starNames = rtrim($starNames, ", ");

    // 각 이름 뒤에 <br> 태그 추가
    $starNames = str_replace(", ", ", <br>", $starNames);

    // 마지막 <br> 태그 제거
    $starNames = rtrim($starNames, "<br>");


    $cnt_row = oci_fetch_array($cnt_stmt);
    $cnt = $cnt_row["CNT"];

    $movieYearFormatted = $movieYear.'년';
    $lengthFormatted = $length.'분';
    $cntFormatted = $cnt.'명';
    if($cnt == 0){
        $cntFormatted = '정보없음';
        $starNames = '정보없음';
    }

    print "<tr>";
    print "<td>$movieTitle</td><td align='center'>$movieYearFormatted</td><td align='right'>$lengthFormatted</td><td>$producer</td><td>$president</td><td align='right'>$cntFormatted</td><td>$starNames</td>";
    print "</tr>\n";
}
print "</table>\n";

oci_free_statement($mv_info);
oci_close($conn);
?>
