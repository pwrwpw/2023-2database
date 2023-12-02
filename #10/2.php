<?php

function p_error()
{
    $e = oci_error();
    print htmlentities($e['message']);
    exit;
}
print '<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">';

$conn = oci_connect("db2018742029", "db77550542", "localhost/course");
if (!$conn)
    p_error();

$stmt = oci_parse($conn, "SELECT name, address addr, certno FROM movieexec ORDER BY 1");
if (!$stmt)
    p_error();
if (!oci_execute($stmt))
    p_error();


    print '<style>
    .table-responsive {
        margin: 0 auto;
        max-width: 80%;
    }
    .text-muted {
        color: #ff69b4 !important;
    }
    .centered-cell {
        text-align: center;
        vertical-align: middle;
    }
    .custom-table {
        background-color: #f2f2f2;
        border-collapse: collapse;
        width: 100%;
    }
    .custom-table th {
        background-color: #50BCDF;
        color: white;
        padding: 12px 15px;
        text-align: center;
    }
    .custom-table td {
        padding: 8px 10px;
        border-bottom: 1px solid #ddd;
    }
    .custom-table tr:hover {background-color: #ddd;}
  </style>';
print "<div class='table-responsive'>";
print "<table class='custom-table'>\n";
print "<thead>";
print "<tr> <th> 순번 </th> <th> 이름 </th> <th> 주소 </th> <th> 영화사 </th> <th> 제작 영화 </th> <th> 출연 영화 </th> </tr>\n";
print "</thead>";
print "<tbody>";

$nrows = oci_fetch_all($stmt, $row, 0, -1, OCI_FETCHSTATEMENT_BY_ROW);

if ($nrows > 0) {
    for ($i = 0; $i < $nrows; $i++) {
        $name = $row[$i]['NAME'];
        $certno   = $row[$i]['CERTNO'];
        $cnt  = $i + 1;
        
        // SQL statements and execution for studio name
        $st_stmt = oci_parse($conn, "SELECT name FROM studio WHERE presno = $certno");
        if (!$st_stmt)
            p_error();
        if (!oci_execute($st_stmt))
            p_error();
        $r     = oci_fetch_array($st_stmt);
        $std_n = $r[0];
        
        if ($std_n == '') {
            $std_n = "<span class='text-center text-danger font-weight-bold'>없음</span>";
        }
        
        // SQL statements and execution for produced movies
        $prod_stmt = oci_parse($conn, "SELECT count(*) FROM movie WHERE producerno = $certno");
        if (!$prod_stmt)
            p_error();
        if (!oci_execute($prod_stmt))
            p_error();
        $p  = oci_fetch_array($prod_stmt);
        $prod_n = $p[0];
        
        // SQL statements and execution for appeared movies
        $act_stmt = oci_parse($conn, "SELECT count(*) FROM starsin WHERE starname = '$name'");
        if (!$act_stmt)
            p_error();
        if (!oci_execute($act_stmt))
            p_error();
        $a  = oci_fetch_array($act_stmt);
        $act_n = $a[0];
        
        if ($prod_n == 0) {
            if ($act_n == 0) {
                print "<tr> 
                        <td class='text-center' style='vertical-align: middle;'>$cnt</td>
                        <td class='text-center' style='vertical-align: middle;'>$name</td>
                        <td class='text-center' style='vertical-align: middle;'>{$row[$i]['ADDR']}</td>
                        <td class='text-center' style='vertical-align: middle;'>$std_n</td>
                        <td class='text-center text-danger font-weight-bold' style='vertical-align: middle;'>없음</td>
                        <td class='text-center text-danger font-weight-bold' style='vertical-align: middle;'>없음</td>
                      </tr>\n";
            } else {
                $act_stmt = oci_parse($conn, "SELECT movietitle itt, movieyear iyy FROM starsin WHERE starname = '$name' ORDER BY 2,1");
                if (!$act_stmt)
                    p_error();
                if (!oci_execute($act_stmt))
                    p_error();
                $a_cnt = oci_fetch_all($act_stmt, $a_rows, null, null, OCI_FETCHSTATEMENT_BY_ROW);
                
                foreach ($a_rows as $k => $a_row) {
                    if ($k == 0) {
                        print "<tr>
                                <td rowspan='$a_cnt' class='text-center' style='vertical-align: middle;'>$cnt</td>
                                <td rowspan='$a_cnt' class='text-center' style='vertical-align: middle;'>$name</td>
                                <td rowspan='$a_cnt' class='text-center' style='vertical-align: middle;'>{$row[$i]['ADDR']}</td>
                                <td rowspan='$a_cnt' class='text-center' style='vertical-align: middle;'>$std_n</td>
                                <td rowspan='$a_cnt' class='text-center text-danger font-weight-bold' style='vertical-align: middle;'>없음</td>
                                <td class='text-center' style='vertical-align: middle;'><span class='text-dark font-weight-bold'>{$a_row['ITT']}<span class='text-muted ml-2'> ({$a_row['IYY']})</span></td>
                              </tr>\n";
                    } else {
                        print "<tr>
                                <td class='text-center' style='vertical-align: middle;'><span class='text-dark font-weight-bold'>{$a_row['ITT']}</span><span class='text-muted ml-2'> ({$a_row['IYY']})</span></td>
                              </tr>\n";
                    }
                }
            }
        } else {
            if ($act_n == 0) {
                $prod_stmt = oci_parse($conn, "SELECT title ptt, year pyy FROM movie WHERE producerno = $certno ORDER BY 2,1");
                if (!$prod_stmt)
                    p_error();
                if (!oci_execute($prod_stmt))
                    p_error();
                $p_cnt = oci_fetch_all($prod_stmt, $p_rows, null, null, OCI_FETCHSTATEMENT_BY_ROW);
                
                foreach ($p_rows as $j => $p_row) {
                    if ($j == 0) {
                        print "<tr>
                                <td rowspan='$p_cnt' class='text-center' style='vertical-align: middle;'>$cnt</td>
                                <td rowspan='$p_cnt' class='text-center' style='vertical-align: middle;'>$name</td>
                                <td rowspan='$p_cnt' class='text-center' style='vertical-align: middle;'>{$row[$i]['ADDR']}</td>
                                <td rowspan='$p_cnt' class='text-center' style='vertical-align: middle;'>$std_n</td>
                                <td class='text-center' style='vertical-align: middle;'><span class='text-dark font-weight-bold'>{$p_row['PTT']}</span><span class='text-muted ml-2'>({$p_row['PYY']})</span></td>
                                <td rowspan='$p_cnt' class='text-center text-danger font-weight-bold' style='vertical-align: middle;'>없음</td>
                              </tr>\n";
                    } else {
                        print "<tr>
                               <td class='text-center' style='vertical-align: middle;'><span class='text-dark font-weight-bold'>{$p_row['PTT']}</span><span class='text-muted ml-2'>({$p_row['PYY']})</span></td>
                               </tr>\n";
                    }
                }
            } else {
                $act_stmt = oci_parse($conn, "select movietitle att, movieyear ayy from starsin where starname = '$name' order by 2,1");
                if (!$act_stmt)
                    p_error();
                if (!oci_execute($act_stmt))
                    p_error();
                $a_cnt = oci_fetch_all($act_stmt, $a_rows, null, null, OCI_FETCHSTATEMENT_BY_ROW);
                
                
                $prod_stmt = oci_parse($conn, "select title ptt, year pyy from movie where producerno = $certno order by 2,1");
                if (!$prod_stmt)
                    p_error();
                if (!oci_execute($prod_stmt))
                    p_error();
                $p_cnt = oci_fetch_all($prod_stmt, $p_rows, null, null, OCI_FETCHSTATEMENT_BY_ROW);
                
                $mv_cnt = $p_cnt * $a_cnt;
                $ic     = 0;
                $pc     = 0;
                for ($j = 0; $j < $mv_cnt; $j++) {
                    print "<tr>";
                    if ($j == 0) {
                        print "<td rowspan='$mv_cnt' class='text-center' style='vertical-align: middle;'>$cnt</td>
                              <td rowspan='$mv_cnt'  class='text-center' style='vertical-align: middle;'>$name</td>
                              <td rowspan='$mv_cnt'  class='text-center' style='vertical-align: middle;'>{$row[$i]['ADDR']}</td>
                              <td rowspan='$mv_cnt'  class='text-center' style='vertical-align: middle;'>$std_n</td>
                              <td rowspan='$a_cnt'   class='text-center' style='vertical-align: middle;'><span class='text-dark font-weight-bold'>{$p_rows[$ic]['PTT']}</span><span class='text-muted ml-2'> ({$p_rows[$ic]['PYY']})</span></td>";
                        $ic++;
                        print "<td rowspan='$p_cnt'class='text-center' style='vertical-align: middle;'><span class='text-dark font-weight-bold'>{$a_rows[$pc]['ATT']}</span><span class='text-muted ml-2'> ({$a_rows[$pc]['AYY']})</span></td>";
                        $pc++;
                    } else if ($j % $a_cnt == 0) {
                        print "<td rowspan='$a_cnt'class='text-center' style='vertical-align: middle;'><span class='text-dark font-weight-bold'>{$p_rows[$ic]['PTT']}</span><span class='text-muted ml-2'> ({$p_rows[$ic]['PYY']})</span></td>";
                        $ic++;
                    } else if ($j % $p_cnt == 0) {
                        print "<td rowspan='$p_cnt' class='text-center' style='vertical-align: middle;'><span class='text-dark font-weight-bold'>{$a_rows[$pc]['ATT']}</span><span class='text-muted ml-2'> ({$a_rows[$pc]['AYY']})</span></td>";
                        $pc++;
                    }
                    print "</tr>\n";
                }
            }
        }
    }
} else {
    print "<td colspan=3>No Data Found";
}
print "</TABLE>\n";

oci_free_statement($stmt);
oci_close($conn);
?>