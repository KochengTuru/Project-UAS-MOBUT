<?php
require_once(__DIR__ . "/../config/db.php");
require_once(__DIR__ . "/../config/response.php");

$id = intval($_GET["id"] ?? 0);
if ($id <= 0) fail("id wajib", 400);

try {
  $stmt = $pdo->prepare("SELECT id, title, content, image_url, created_at
                         FROM articles
                         WHERE id=? LIMIT 1");
  $stmt->execute([$id]);
  $row = $stmt->fetch(PDO::FETCH_ASSOC);

  if (!$row) fail("Artikel tidak ditemukan", 404);

  ok($row, "Detail artikel");
} catch (Exception $e) {
  fail("Gagal mengambil detail", 500);
}
