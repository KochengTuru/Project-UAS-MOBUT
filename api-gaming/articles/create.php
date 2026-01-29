<?php
require_once(__DIR__ . "/../config/db.php");
require_once(__DIR__ . "/../config/response.php");
require_once(__DIR__ . "/../config/auth.php");
require_admin();

$title = trim($_POST["title"] ?? "");
$body  = trim($_POST["body"] ?? "");
$image = trim($_POST["image_url"] ?? "");

if ($title === "" || $body === "") {
  fail("Judul dan isi artikel wajib diisi", 400);
}

try {
  $stmt = $pdo->prepare(
    "INSERT INTO articles (title, body, image_url) VALUES (?,?,?)"
  );
  $stmt->execute([$title, $body, $image]);

  ok([], "Artikel berhasil ditambahkan");
} catch (Exception $e) {
  fail("Gagal menambahkan artikel", 500, ["debug" => $e->getMessage()]);
}
