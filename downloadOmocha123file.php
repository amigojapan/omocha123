<?php
    error_reporting(E_ALL);
    ini_set('display_errors', 1);
    
    $filename = $_POST['filename'];
    if (str_contains($filename, "/")) {
        die("error: filename can't contain /");
    }
    $dir    = 'omocha123files';
    $files = scandir($dir);
    //print_r($files1);
   
    // Check if the file exists in the array
    if (!in_array($filename, $files)) {
        die("error: filename does not exists");
    }
    
    // File path
    $filePath = $dir . "/" . $filename;

    $fileContents = @file_get_contents($filePath); // Suppress warnings

    if ($fileContents === false) {
        echo "Error: Unable to read the file.";
    } else {
        echo $fileContents;
    }
    // sotored directory: /var/www/html/amjp/omocha123/omocha123files
?>