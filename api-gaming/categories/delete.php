<?php
require_once("../config/db.php");
require_once("../config/response.php");
require_once(__DIR__ . "/../config/auth.php");
require_admin();


$id = intval($_POST["id"] ?? 0);
if ($id <= 0) fail("ID wajib diisi");

try {
  $stmt = $pdo->prepare("DELETE FROM categories WHERE id=?");
  $stmt->execute([$id]);
  ok([], "Kategori berhasil dihapus");
} catch (Exception $e) {
  fail("Kategori dipakai produk (tidak bisa dihapus)", 409);
}
