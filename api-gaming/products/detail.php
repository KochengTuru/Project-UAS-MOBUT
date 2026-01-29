<?php
require_once("../config/db.php");
require_once("../config/response.php");

$id = intval($_GET["id"] ?? 0);
if ($id <= 0) fail("ID wajib");

$stmt = $pdo->prepare("SELECT * FROM products WHERE id=?");
$stmt->execute([$id]);
$row = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$row) fail("Produk tidak ditemukan", 404);
ok($row, "Detail produk");
