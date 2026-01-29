<?php
require_once(__DIR__ . "/../config/db.php");
require_once(__DIR__ . "/../config/response.php");
require_once(__DIR__ . "/../config/auth.php");
require_login();

$user_id = intval($_POST["user_id"] ?? 0);
$product_id = intval($_POST["product_id"] ?? 0);
$qty = intval($_POST["qty"] ?? 1);
if ($qty <= 0) $qty = 1;

if ($user_id <= 0 || $product_id <= 0) fail("user_id & product_id wajib");

$stmt = $pdo->prepare("SELECT price FROM products WHERE id=? LIMIT 1");
$stmt->execute([$product_id]);
$p = $stmt->fetch(PDO::FETCH_ASSOC);
if (!$p) fail("Produk tidak ditemukan", 404);

$total = intval($p["price"]) * $qty;

$stmt = $pdo->prepare("INSERT INTO orders(user_id, product_id, qty, total_price) VALUES(?,?,?,?)");
$stmt->execute([$user_id, $product_id, $qty, $total]);

ok([], "Pembelian tersimpan");
