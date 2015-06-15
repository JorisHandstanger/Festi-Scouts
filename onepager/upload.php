<?php
	define('DS', DIRECTORY_SEPARATOR);
	define('WWW_ROOT', dirname(__FILE__) . DS);

	$userId = $_POST['userId'];
	$badgeId = $_POST['badgeId'];

	$path = WWW_ROOT . 'uploads' . DS ;
	$fileName   = $_FILES['file']['name'];

	$extension = end(explode(".", $fileName));

	$newname = $userId.'_'.$badgeId.'.'.$extension;
	$uploadfile = $path . $newname;

	if (move_uploaded_file($_FILES['file']['tmp_name'], $uploadfile)) {
		echo "/".$uploadfile;
	} else {
		echo "ERROR";
	}
?>
