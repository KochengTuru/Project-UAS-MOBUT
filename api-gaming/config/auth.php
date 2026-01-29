<?php
require_once(__DIR__ . "/db.php");
require_once(__DIR__ . "/response.php");

/**
 * Cara cek admin yang lebih benar:
 * - Flutter mengirim user_id
 * - Server cek role user_id di database
 * (Masih sederhana tapi memenuhi kebutuhan tugas "admin-only")
 */
function require_admin() {
  global $pdo;

  $user_id = intval($_POST["user_id"] ?? $_GET["user_id"] ?? 0);
  if ($user_id <= 0) fail("user_id wajib", 401);

  $stmt = $pdo->prepare("SELECT role FROM users WHERE id=? LIMIT 1");
  $stmt->execute([$user_id]);
  $u = $stmt->fetch(PDO::FETCH_ASSOC);

  if (!$u) fail("User tidak valid", 401);
  if ($u["role"] !== "admin") fail("Akses ditolak: khusus admin", 403);
}

function require_login() {
  global $pdo;

  $user_id = intval($_POST["user_id"] ?? $_GET["user_id"] ?? 0);
  if ($user_id <= 0) fail("user_id wajib", 401);

  $stmt = $pdo->prepare("SELECT id FROM users WHERE id=? LIMIT 1");
  $stmt->execute([$user_id]);
  $u = $stmt->fetch(PDO::FETCH_ASSOC);

  if (!$u) fail("User tidak valid", 401);
}
