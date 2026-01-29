<?php
require_once(__DIR__ . "/../config/db.php");
require_once(__DIR__ . "/../config/response.php");
require_once(__DIR__ . "/../config/auth.php");
require_admin();

$id = intval($_POST["id"] ?? 0);
if ($id <= 0) fail("ID tidak valid", 400);

try {
  $stmt = $pdo->prepare("DELETE FROM articles WHERE id=?");
  $stmt->execute([$id]);

  ok([], "Artikel berhasil dihapus");
} catch (Exception $e) {
  fail("Gagal menghapus artikel", 500, ["debug" => $e->getMessage()]);
}
