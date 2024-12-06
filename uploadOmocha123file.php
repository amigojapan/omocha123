<?php
    error_reporting(E_ALL);
    ini_set('display_errors', 1);
    
    $filename = $_POST['filename']  . ".omocha123";
    if (str_contains($filename, "/")) {
        die("error: filename can't contain /");
    }
    $dir    = 'omocha123files';
    $files = scandir($dir);
    //print_r($files1);
   
    // Check if the file exists in the array
    if (in_array($filename, $files)) {
        die("error: filename already exists");
    }
    $omocha123filecontents = $_POST['omocha123'];
    
    // File path
    $filePath = $dir . "/" . $filename;

    // Write the string to the file
    if (file_put_contents($filePath, $omocha123filecontents) !== false) {
        echo "File accepted";
    } else {
        die("error: could not write");
    }
    // sotored directory: /var/www/html/amjp/omocha123/omocha123files
?>