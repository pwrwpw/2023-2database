<?php
function p_error()
{
    $e = oci_error();
    print htmlentities($e['message']);
    exit;
}

print '<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">';

$title = $_POST['m_title'] ?: "";
$range_start = $_POST['range_start'];
$range_end = $_POST['range_end'];
$born_year = $_POST['born_year'];
$actor_gender = $_POST['actor_gender'];
$isLike = isset($_POST['isLike']);

$where = "";

if (!empty($title)) {
    $title = str_replace(["%", "'", "_"], ["\%", "''", "\_"], $title);

    if ($isLike) {
        $where .= " AND lower(m.title) LIKE lower('%$title%') ESCAPE '\\'";
    } else {
        $where .= " AND lower(m.title) = lower('$title')";
    }
}


if (!empty($range_start)){
    $where .= " AND length >= '$range_start'";
}
if (!empty($range_end)){
    $where .= " AND length <= '$range_end'";
}

if(!empty($actor_gender) || !empty($born_year)){
    $where .= " AND (title,year) in (SELECT movietitle,movieyear FROM moviestar,starsin WHERE starname = name";
    if (!empty($born_year)) {
        $where .= " AND birthdate >= '$born_year-01-01'";
    }
    if(!empty($actor_gender)){
        $where .= " AND gender = '$actor_gender'";
    }
    $where .= ")";
}
$conn = oci_connect("db2018742029", "db77550542", "localhost/course");
if (!$conn) p_error();

$query = "SELECT m.title, m.year, me.name AS p_name, s.name AS studio_name, s.address
          FROM movie m, studio s, movieexec me
          WHERE m.studioname = s.name AND m.producerno = me.certno" . $where . " ORDER BY m.title, m.year";
$stmt = oci_parse($conn, $query);

if (!$stmt) p_error();

if (!oci_execute($stmt)) p_error();

print '<table class="table table-bordered table-hover table-striped">';
print '<thead class="thead-dark"><tr><th>영화 제목</th><th>개봉년도</th><th>제작자이름</th><th>영화사이름</th><th>영화사주소</th></tr></thead>';
print '<tbody>';
while ($row = oci_fetch_array($stmt, OCI_ASSOC+OCI_RETURN_NULLS)) {
    print '<tr>';
    foreach ($row as $key => $item) {
       if ($key == 'TITLE' && $isLike) {
            $item = htmlspecialchars($item, ENT_QUOTES); // HTML 특수 문자를 변환
            $title = str_replace("''", "&#039;", $title);
            
            $highlighted = preg_replace("/($title)/i", "<span style='background-color:yellow; color: #002b36;'>$1</span>", $item);
            print "<td>$highlighted</td>";
        } else {
            print "<td>" . ($item !== null ? htmlspecialchars($item, ENT_QUOTES) : "&nbsp;") . "</td>";
        }
    }
    print '</tr>';
}

print '</tbody></table>';

oci_free_statement($stmt);
oci_close($conn);
?>