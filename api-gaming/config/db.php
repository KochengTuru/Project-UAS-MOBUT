<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

$DB_HOST = "localhost";
$DB_NAME = "tifj4825_db_gaming";
$DB_USER = "tifj4825_salgita";
$DB_PASS = "@085591460986";

try {
  $pdo = new PDO(
    "mysql:host=$DB_HOST;dbname=$DB_NAME;charset=utf8mb4",
    $DB_USER,
    $DB_PASS,
    [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
  );
} catch (Exception $e) {
  echo json_encode([
    "success" => false,
    "message" => "DB connection failed",
    "error" => $e->getMessage()
  ]);
  exit;
}
