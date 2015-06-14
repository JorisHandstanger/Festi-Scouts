<?php

require_once WWW_ROOT. "dao" .DIRECTORY_SEPARATOR. 'UserDAO.php';
require_once WWW_ROOT. "dao" .DIRECTORY_SEPARATOR. 'BadgesDAO.php';

$UserDAO = new UserDAO();
$BadgesDAO = new BadgesDAO();

$app->get('/users/?',function() use ($UserDAO){
  header("Content-Type: application/json");
  echo json_encode($UserDAO->selectAll(), JSON_NUMERIC_CHECK);
  exit();
});

$app->get('/badges/?',function() use ($BadgesDAO){
  header("Content-Type: application/json");
  echo json_encode($BadgesDAO->selectAll(), JSON_NUMERIC_CHECK);
  exit();
});

$app->get('/badges/:id/?',function($id) use ($BadgesDAO){
  header("Content-Type: application/json");
  echo json_encode($BadgesDAO->selectByUserId($id), JSON_NUMERIC_CHECK);
  exit();
});

$app->get('/users/:totem/?', function($totem) use ($UserDAO){
    header("Content-Type: application/json");
    if($UserDAO->selectByTotem($totem)){
    	echo json_encode(true);
    }else{
    	echo json_encode(false);
    };
    exit();
});

$app->get('/totem/get/?', function() use ($UserDAO){
    header("Content-Type: application/json");
    echo json_encode($UserDAO->getTotem(), JSON_NUMERIC_CHECK);
    exit();
});

$app->post('/users/?', function() use ($app, $UserDAO){
    header("Content-Type: application/json");
    $post = $app->request->post();
    if(empty($post)){
        $post = (array) json_decode($app->request()->getBody());
    }
    echo json_encode($UserDAO->insert($post), JSON_NUMERIC_CHECK);
    exit();
});

$app->delete('/users/:id/?', function($id) use ($UserDAO){
    header("Content-Type: application/json");
    echo json_encode($UserDAO->delete($id));
    exit();
});
// DELETE  /users/1
