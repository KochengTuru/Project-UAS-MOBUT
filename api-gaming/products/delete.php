<?php
require_once("../config/db.php");
require_once("../config/response.php");

$id = intval($_POST["id"] ?? 0);
if ($id <= 0) fail("ID wajib");

$stmt = $pdo->prepare("DELETE FROM products WHERE id=?");
$stmt->execute([$id]);

ok([], "Produk berhasil dihapus");
