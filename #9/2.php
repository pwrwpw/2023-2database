<?php
// for correct error message outputs
putenv("NLS_LANG=KOREAN_KOREA.AL32UTF8");

print '<style>
    .movie-table {
        background-color: black;
        border-collapse: collapse;
        width: 40%;
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

$studio_info = oci_parse($conn,
   "SELECT s.name AS NAME, COUNT(m.studioname) AS movie_count
    FROM studio s, movie m
    WHERE s.name = m.studioname
    GROUP BY s.name
    ORDER BY s.name"
);

if (!$studio_info) {
    p_error("SQL Parsing Failed...");
}

if (!oci_execute($studio_info)) {
    p_error("Execution Failed...");
}

print '<table class="movie-table">';
print '<tr><th>영화사<th>제작한 영화수</tr>';

while ($row = oci_fetch_array($studio_info)) {
    $studioName = $row["NAME"];
    $produceCount = $row["MOVIE_COUNT"];

    print "<tr>";
    print "<td><a target='_blank' href='2_1.php?studioName={$studioName}'>$studioName</a></td>";
    print "<td align='center'><a target='_blank' href='2_2.php?studioName={$studioName}'>$produceCount</a></td>";
    print "</tr>\n";
}

print "</table>\n";

oci_free_statement($mv_info);
oci_close($conn);
?>