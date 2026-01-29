<?php
require_once(__DIR__ . "/../config/db.php");
require_once(__DIR__ . "/../config/response.php");
require_once(__DIR__ . "/../config/auth.php");
require_admin();

$id    = intval($_POST["id"] ?? 0);
$title = trim($_POST["title"] ?? "");
$body  = trim($_POST["body"] ?? "");
$image = trim($_POST["image_url"] ?? "");

if ($id <= 0) fail("ID tidak valid", 400);
if ($title === "" || $body === "") {
  fail("Judul dan isi artikel wajib diisi", 400);
}

try {
  $stmt = $pdo->prepare(
    "UPDATE articles SET title=?, body=?, image_url=? WHERE id=?"
  );
  $stmt->execute([$title, $body, $image, $id]);

  ok([], "Artikel berhasil diupdate");
} catch (Exception $e) {
  fail("Gagal update artikel", 500, ["debug" => $e->getMessage()]);
}
