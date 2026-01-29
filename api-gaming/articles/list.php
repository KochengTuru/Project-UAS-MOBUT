<?php
require_once(__DIR__ . "/../config/db.php");
require_once(__DIR__ . "/../config/response.php");

try {
  $rows = $pdo->query("
    SELECT id, title, body, image_url, created_at
    FROM articles
    ORDER BY id DESC
  ")->fetchAll(PDO::FETCH_ASSOC);

  ok($rows, "List artikel");
} catch (Exception $e) {
  fail("Gagal mengambil artikel", 500, ["debug" => $e->getMessage()]);
}
