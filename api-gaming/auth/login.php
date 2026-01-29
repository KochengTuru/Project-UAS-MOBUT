<?php
require_once(__DIR__ . "/../config/db.php");
require_once(__DIR__ . "/../config/response.php");

if ($_SERVER["REQUEST_METHOD"] !== "POST") fail("Gunakan metode POST", 405);

$email = trim($_POST["email"] ?? "");
$password = $_POST["password"] ?? "";

if ($email === "" || $password === "") fail("Email & password wajib diisi");

$stmt = $pdo->prepare("SELECT id,name,email,role,password_hash FROM users WHERE email=? LIMIT 1");
$stmt->execute([$email]);
$user = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$user) fail("Akun tidak ditemukan", 404);
if (!password_verify($password, $user["password_hash"])) fail("Password salah", 401);

unset($user["password_hash"]);
ok($user, "Login berhasil");
