<?php
header("Content-Type: application/json; charset=UTF-8");

echo json_encode([
  "success" => true,
  "message" => "API Gaming aktif",
  "endpoints" => [
    "auth" => [
      "POST auth/register.php",
      "POST auth/login.php"
    ],
    "categories" => [
      "GET categories/list.php",
      "POST categories/create.php",
      "POST categories/update.php",
      "POST categories/delete.php"
    ],
    "products" => [
      "GET products/list.php",
      "GET products/detail.php?id=1",
      "POST products/create.php",
      "POST products/update.php",
      "POST products/delete.php"
    ],
    "articles" => [
      "GET articles/list.php"
    ]
  ]
]);
