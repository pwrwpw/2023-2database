<?php
function ProducerExists($conn, $sno) {
    $stmt = oci_parse($conn, "SELECT * FROM movieexec WHERE certno = :sno");
    if (!$stmt) {
        p_error("SQL Parsing Failed ...");
        return false;
    }

    oci_bind_by_name($stmt, ":sno", $sno);
    if (!oci_execute($stmt)) {
        p_error("Execution Failed ...", $stmt);
        return false;
    }

    return oci_fetch($stmt) ? true : false;
}

function StudioNameExists($conn, $sname) {
    $stmt = oci_parse($conn, "SELECT * FROM studio WHERE name = :sname");
    if (!$stmt) {
        p_error("SQL Parsing Failed ...");
        return false;
    }

    oci_bind_by_name($stmt, ":sname", $sname);
    if (!oci_execute($stmt)) {
        p_error("Execution Failed ...", $stmt);
        return false;
    }

    return oci_fetch($stmt) ? true : false;
}

function MovieExists($conn, $title, $year) {
    $stmt = oci_parse($conn, "SELECT * FROM movie WHERE title = :title AND year = :year");
    if (!$stmt) {
        p_error("SQL Parsing Failed ...");
        return false;
    }

    oci_bind_by_name($stmt, ":title", $title);
    oci_bind_by_name($stmt, ":year", $year);
    if (!oci_execute($stmt)) {
        p_error("Execution Failed ...", $stmt);
        return false;
    }

    return oci_fetch($stmt) ? true : false;
}

function p_error($message, $stmt = null) {
    print "<font color=red>" . $message . "</font><br>";
    if ($stmt) {
        $e = oci_error($stmt);
        print htmlentities($e['message']);
        if (isset($e['sqltext'])) {
            print htmlentities($e['sqltext']);
            print "<pre>";
            printf("%" . ($e['offset'] + 1) . "s", "^");
            print "</pre>";
        }
    }
    exit();
}

function handleInsert($conn, $title, $year, $length, $sno, $sname) {
    // 에러 메시지를 저장할 변수 초기화
    $errorMessages = [];

    // 필수 필드 검증
    if (empty($title)) {
        $errorMessages[] = "<p class='error'>영화 제목을 입력해야 합니다.";
    }
    
    if (empty($year)) {
        $errorMessages[] = "<p class='error'>영화 연도를 입력해야 합니다.";
    } elseif (!is_numeric($year) || $year <= 1900 || $year > 2023) {
        $errorMessages[] = "<p class='error'>올바른 연도를 입력하세요 (1901년부터 2023년까지 허용).";
    } elseif (MovieExists($conn, $title, $year)) {
        $errorMessages[] = "<b> Movie($title, $year) 튜플은 이미 존재합니다.</b>\n";
    }

    // 상영시간 검증 및 처리
    if (!isset($length) || ($length !== "" && (!is_numeric($length) || $length <= 50 || $length > 300))) {
        $errorMessages[] = "<p class='error'>상영시간은 50분 초과, 300분 이하만 가능합니다.";
    }

    if (!empty($sno) && (!is_numeric($sno) || $sno <= 0)) {
        $errorMessages[] = "<p class='error'>올바른 제작자 번호를 입력하세요.";
    } elseif (!empty($sno) && !ProducerExists($conn, $sno)) {
        $errorMessages[] = "<p class='error'><span style='background-color: yellow;'>{$sno}</span>번 제작자는 존재하지 않음";
    }

    // 영화사 이름의 유효성 검증
    if (!empty($sname) && !StudioNameExists($conn, $sname)) {
        $errorMessages[] = "<p class='error'><span style='background-color: yellow;'>{$sname}</span> 영화사는 존재하지 않음";
    }

    // 모든 에러 메시지 출력
    if (!empty($errorMessages)) {
        foreach ($errorMessages as $errorMessage) {
            print $errorMessage . "<br>";
        }
        return; // 에러가 있으므로 함수 종료
    }

    // 데이터베이스에 삽입하는 쿼리 실행
    $stmt = oci_parse($conn, "INSERT INTO movie(title, year, length, studioname, producerno) VALUES (:t, :y, :l, :s, :p)");
    if (!$stmt) {
        p_error("SQL Parsing Failed ...");
    }

    oci_bind_by_name($stmt, ":t", $title);
    oci_bind_by_name($stmt, ":y", $year);
    oci_bind_by_name($stmt, ":l", $length);
    oci_bind_by_name($stmt, ":s", $sname);
    oci_bind_by_name($stmt, ":p", $sno);

    if (!oci_execute($stmt)) {
        p_error("Execution Failed ...", $stmt);
    } else {
    print "<table border='1'>";
    print "<tr><td>제목 <td>연도 <td>상영시간 <td>영화사 <td>제작자 번호</tr>";
    print "<tr><td>$title <td>$year <td>$length <td>$sname <td>$sno</tr>";
    print "</table>";
}
}

function handleSearch($conn, $title, $year, $length, $sname, $sno) {
    // SQL WHERE 절 초기화
    $where = " WHERE 1=1 "; // 기본 조건

    // 제목 검증 및 처리
    if (!empty($title)) {
        $title = str_replace(["%", "'", "_"], ["\%", "''", "\_"], $title);
        $where .= " AND lower(title) LIKE lower('%$title%') ESCAPE '\\'";
    }
  
    // 에러 메시지를 저장할 배열 초기화
    $errorMessages = [];
    
    // 연도 검증 및 처리
    if (!empty($year)) {
        if (!is_numeric($year) || $year <= 1900 || $year > 2023) {
            $errorMessages[] = "<p class='error'>올바른 연도를 입력하세요 (1901년부터 2023년까지 허용).";
        }
        $where .= " AND year LIKE '%$year%'";
    }

    // 상영시간 검증 및 처리
    if (isset($length) && $length !== '') { // isset()과 빈 문자열 확인을 사용
        if (!is_numeric($length) || $length <= 0) {
            $errorMessages[] = "<p class='error'>올바른 상영시간을 입력하세요. (0 초과만 검색 가능)";
        } else {
            $where .= " AND length LIKE '%$length%'";
        }
    }

    // 영화사 이름 검증 및 처리
    if (!empty($sname)) {
        $where .= " AND lower(studioname) LIKE lower('%$sname%')";
    }

    // 제작자 번호 검증 및 처리
    if (!empty($sno)) {
        if (!is_numeric($sno)) {
            $errorMessages[] = "<p class='error'>제작자 번호는 숫자여야 합니다.";
        } else {
            $where .= " AND producerno = $sno";
        }
    }

    // 에러 메시지 출력
    if (!empty($errorMessages)) {
        foreach ($errorMessages as $errorMessage) {
            print $errorMessage . "<br>";
        }
        return;
    }

    // SQL 쿼리 실행
    $sql = "SELECT title, year, length, studioname, (SELECT name FROM movieexec WHERE certno = movie.producerno) AS producername FROM movie" . $where . " ORDER BY title, year";
    $stmt = oci_parse($conn, $sql);
    if (!$stmt) {
        p_error("SQL Parsing Failed ...");
        return;
    }

    if (!oci_execute($stmt)) {
        p_error("Execution Failed ...", $stmt);
        return;
    }
    // 결과 출력
    print "<form method='post' action='2.php' onsubmit='return validateForm()'>";
    print "<TABLE border=1 cellspacing=2>\n";
    print "<TR><TH> 제목 <TH> 연도 <TH> 상영시간 <TH> 영화사 <TH> 제작자 <TH> 삭제</TR>\n";
    $anyRowFound = false;
    while ($row = oci_fetch_array($stmt)) {
        $anyRowFound = true;
        $encodedTitle = htmlspecialchars($row['TITLE'], ENT_QUOTES);
        print "<TR>";
        print "<TD> {$encodedTitle} </TD>";
        print "<TD> {$row['YEAR']} </TD>";
        print "<TD> {$row['LENGTH']} </TD>";
        print "<TD> {$row['STUDIONAME']} </TD>";
        print "<TD> {$row['PRODUCERNAME']} </TD>";
        print "<TD> <input type='checkbox' name='titles[]' value='{$encodedTitle}'> </TD>";
        print "</TR>\n";
    }

    if (!$anyRowFound) {
        print "<tr><td colspan='6'>검색된 튜플 없음</td></tr>\n";
    }
    else {
        print "<tr> <td colspan='6'><input type='submit' name='submit' value='삭제'></tr>\n";
        print "</TABLE>\n";
        print "</form>";
    }

    oci_free_statement($stmt);
}

function handleUpdate($conn, $title, $year, $length, $sno, $sname) {
    // 에러 메시지를 저장할 변수 초기화
    $errorMessages = [];

    // 필수 필드 (제목과 연도) 검증
    if (empty($title) || empty($year)) {
        $errorMessages[] = "<p class='error'>영화 제목과 연도는 필수로 입력해야 합니다.";
    } elseif (!is_numeric($year) || $year <= 1900 || $year > 2023) {
        $errorMessages[] = "<p class='error'>올바른 연도를 입력하세요 (1901년부터 2023년까지 허용).";
    } elseif (!MovieExists($conn, $title, $year)) {
        $errorMessages[] = "<p class='error'>해당하는 영화가 데이터베이스에 존재하지 않습니다.";
    }

    // 상영시간 검증 및 처리
    if (!isset($length) || ($length !== "" && (!is_numeric($length) || $length <= 50 || $length > 300))) {
        $errorMessages[] = "<p class='error'>상영시간은 50분 초과, 300분 이하만 가능합니다.";
    }
    // 제작자 번호의 유효성 검증 및 존재 여부 확인
    if (!empty($sno) && (!is_numeric($sno) || $sno <= 0)) {
        $errorMessages[] = "<p class='error'>올바른 제작자 번호를 입력하세요.";
    } elseif (!empty($sno) && !ProducerExists($conn, $sno)) {
        $errorMessages[] = "<p class='error'><span style='background-color: yellow;'>{$sno}</span>번 제작자는 존재하지 않음";
    }

    // 영화사 이름의 유효성 검증
    if (!empty($sname) && !StudioNameExists($conn, $sname)) {
        $errorMessages[] = "<p class='error'><span style='background-color: yellow;'>{$sname}</span> 영화사는 존재하지 않음";
    }

    // 업데이트할 필드 설정
    $updates = [];
    if (!empty($length)) {
        $updates[] = "length = :length";
    }
    if (!empty($sno)) {
        $updates[] = "producerno = :sno";
    }
    if (!empty($sname)) {
        $updates[] = "studioname = :sname";
    }

    // 업데이트할 필드가 없는 경우 처리
    if (empty($updates)) {
        $errorMessages[] = "<p class='error'>업데이트할 정보를 입력해 주세요.";
    }

    // 모든 에러 메시지 출력
    if (!empty($errorMessages)) {
        foreach ($errorMessages as $errorMessage) {
            print $errorMessage . "<br>";
        }
        return; // 에러가 있으므로 함수 종료
    }

    // 업데이트 쿼리 준비
    $sql = "UPDATE movie SET " . implode(', ', $updates) . " WHERE title = :title AND year = :year";
    $stmt = oci_parse($conn, $sql);
    if (!$stmt) {
        p_error("SQL Parsing Failed ...");
        return;
    }

    // 바인드 변수 설정
    oci_bind_by_name($stmt, ":title", $title);
    oci_bind_by_name($stmt, ":year", $year);
    if (!empty($length)) {
        oci_bind_by_name($stmt, ":length", $length);
    }
    if (!empty($sno)) {
        oci_bind_by_name($stmt, ":sno", $sno);
    }
    if (!empty($sname)) {
        oci_bind_by_name($stmt, ":sname", $sname);
    }

    // 쿼리 실행
    if (!oci_execute($stmt)) {
        p_error("Execution Failed ...", $stmt);
        return;
    }
    
    // 업데이트된 데이터를 다시 조회
    $sql = "SELECT title, year, length, studioname, (SELECT name FROM movieexec WHERE certno = movie.producerno) AS producername FROM movie WHERE title = :title AND year = :year";
    $stmt = oci_parse($conn, $sql);
    oci_bind_by_name($stmt, ":title", $title);
    oci_bind_by_name($stmt, ":year", $year);
    
    if (!oci_execute($stmt)) {
        p_error("Execution Failed ...", $stmt);
        return;
    }

    // 결과 출력
    print "<TABLE border=1 cellspacing=2>\n";
    print "<TR><TH> 제목 <TH> 연도 <TH> 상영시간 <TH> 영화사 <TH> 제작자 </TR>\n";
    while ($row = oci_fetch_array($stmt)) {
        $encodedTitle = htmlspecialchars($row['TITLE'], ENT_QUOTES);
        print "<TR>";
        print "<TD> {$encodedTitle} </TD>";
        print "<TD> {$row['YEAR']} </TD>";
        print "<TD> {$row['LENGTH']} </TD>";
        print "<TD> {$row['STUDIONAME']} </TD>";
        print "<TD> {$row['PRODUCERNAME']} </TD>";
        print "</TR>\n";
    }
}

function handleDelete($conn, $titles) {
    // 삭제할 제목이 없는 경우
    if (empty($titles) || !is_array($titles)) {
        print '<p class="error">삭제할 영화 제목을 제공해야 합니다.</p>';
        return;
    }

    print "<table border='1'>";
    print "<tr><th colspan='2' style='background-color: blue; color: white; text-align: center; padding: 10px;'>삭제된 테이블</th></tr>";
    print "<tr><th>제목</th><th>연도</th></tr>";

    foreach ($titles as $title) {
        // 해당 영화의 연도를 조회하는 쿼리를 준비하고 실행합니다
        $year_query = oci_parse($conn, "SELECT year FROM movie WHERE title = :title");
        oci_bind_by_name($year_query, ":title", $title);
        if (!oci_execute($year_query)) {
            p_error("영화 연도 조회 실패...", $year_query);
        }
        $year_row = oci_fetch_array($year_query);
        $movieYear = $year_row['YEAR']; // 영화의 연도

        // 영화를 삭제하는 쿼리를 준비하고 실행합니다
        $delete_stmt = oci_parse($conn, "DELETE FROM movie WHERE title = :title");
        oci_bind_by_name($delete_stmt, ":title", $title);
        if (!oci_execute($delete_stmt)) {
            p_error("Execution Failed for title: $title", $delete_stmt);
        }

        // 삭제된 영화의 제목과 연도를 출력합니다
        print "<tr><td>" . htmlspecialchars($title) . "</td><td>" . htmlspecialchars($movieYear) . "</td></tr>";

        // 사용된 리소스 해제
        oci_free_statement($year_query);
        oci_free_statement($delete_stmt);
    }

    print "</table>";
}

$conn = oci_connect("db2018742029", "db77550542", "localhost/course");
if (!$conn) {
    p_error("Connection Failed ..");
}

$title  = $_POST["title"];
$year   = $_POST["year"];
$length = $_POST["length"];
$sno    = $_POST["producerNo"];
$sname  = $_POST["studioName"];
$submit = $_POST["submit"];

switch ($submit) {
    case "삽입":
        handleInsert($conn, $title, $year, $length, $sno, $sname);
        break;
    case "검색":
        handleSearch($conn, $title, $year, $length, $sname, $sno);
        break;
    case "갱신":
        handleUpdate($conn, $title, $year, $length, $sno, $sname);
        break;
    case "삭제":
        $titles = $_POST["titles"];
        handleDelete($conn, $titles);
        break;
}

print '<style>
    body {
        font-family: Arial, sans-serif;
    }
    table {
        border-collapse: collapse;
        width: 80%;
        margin: 20px auto;
    }
    table, th, td {
        border: 1px solid #ddd;
    }
    th, td {
        padding: 10px;
        text-align: center;
    }
    th {
        background-color: #f2f2f2;
    }
    tr:nth-child(even) {
        background-color: #f2f2f2;
    }
    .container {
        text-align: center;
        margin-top: 20px;
    }
    .error {
        color: red;
        font-weight: bold;
    }
</style>';
print "<script type='text/javascript'>
    function validateForm() {
        var checkboxes = document.querySelectorAll('input[name=\"titles[]\"]:checked');
        if (checkboxes.length == 0) {
            alert('삭제할 영화를 선택해주세요.');
            return false;
        }
        return true;
    }
</script>";
oci_close($conn);
?>
