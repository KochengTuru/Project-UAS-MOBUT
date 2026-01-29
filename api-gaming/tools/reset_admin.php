<?php
require_once("../config/db.php");

$pass = "admin123";
$hash = password_hash($pass, PASSWORD_BCRYPT);

$stmt = $pdo->prepare("UPDATE users SET password_hash=? WHERE email=?");
$stmt->execute([$hash, "admin@gmail.com"]);

echo "Password admin berhasil direset ke: admin123";
