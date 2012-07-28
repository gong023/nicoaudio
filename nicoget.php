<?php
require_once('/root/scripts/php/nicotest.php');

date_default_timezone_set('Asia/Tokyo');
$mongo = new Mongo('localhost:27017');
$db = $mongo->selectDB('nicosound');
$col_update = $db->update;
foreach ($col_update->find() as $key => $val) {
    if (! empty($val[0])) {
        $update[]= $val[0];
    }
}
$last_update = strtotime(max($update));

//$col_update->insert(array(date("Y-m-d g:i:s")));

$col_rank = $db->ranking;
$checked  = checkRank($col_rank, $last_update);

foreach ($checked as $key => $val) {
    getVideo($val['id'], $val['title']);
    sleep(10);
}


echo PHP_EOL.'end'.PHP_EOL;

function checkRank($col_rank, $last_update) {
    $checked = array();
    foreach ($col_rank->find() as $key => $val) {
        foreach ($val as $k2 => $v2) {
            if (is_array($v2) && isset($v2[0]['ctime']) 
                    && strtotime($v2[0]['ctime']) > $last_update) {
                $checked[] = $v2[0];
            }
        }
    }
    return $checked;
}

