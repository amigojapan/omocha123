<?php
    error_reporting(E_ALL);
    ini_set('display_errors', 1);
    
    $dir    = 'omocha123files';
    $files = scandir($dir);
    $first=true;
    foreach ($files as $file) {
        if($file=="." or $file=="..") {
            continue;
        }
        if ($first) {
            echo $file;
            $first=false;
        } else {
            echo ",". $file;
        }
    }
    // sotored directory: /var/www/html/amjp/omocha123/omocha123files
?>