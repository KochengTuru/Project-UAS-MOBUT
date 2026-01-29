<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

require_once("../config/db.php");
require_once("../config/response.php");

if ($_SERVER["REQUEST_METHOD"] !== "POST") {
  fail("Gunakan metode POST", 405);
}

$name = trim($_POST["name"] ?? "");

$email = trim($_POST["email"] ?? "");
if (!preg_match('/^[A-Za-z0-9._%+\-]+@gmail\.com$/', $email)) {
  fail("Email harus format gmail, contoh: contoh@gmail.com", 400);
}


$password = $_POST["password"] ?? "";

if ($name === "" || $email === "" || $password === "") fail("Semua field wajib diisi");

$hash = password_hash($password, PASSWORD_BCRYPT);

try {
  $stmt = $pdo->prepare("INSERT INTO users(name,email,password_hash) VALUES(?,?,?)");
  $stmt->execute([$name, $email, $hash]);
  ok([], "Register berhasil");
} catch (Exception $e) {
  // tampilkan detail error untuk debug (sementara)
  fail("Register error: " . $e->getMessage(), 500);
}
