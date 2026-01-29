<?php
require_once("../config/db.php");
require_once("../config/response.php");

$id = intval($_POST["id"] ?? 0);
$category_id = intval($_POST["category_id"] ?? 0);
$name = trim($_POST["name"] ?? "");
$price = intval($_POST["price"] ?? 0);
$stock = intval($_POST["stock"] ?? 0);

// cek harus angka murni (tanpa huruf)
if (!ctype_digit(strval($price)) || intval($price) <= 0) {
  fail("Harga harus angka dan lebih dari 0", 400);
}
if (!ctype_digit(strval($stock)) || intval($stock) < 0) {
  fail("Stok harus angka (minimal 0)", 400);
}


$image_url = trim($_POST["image_url"] ?? "");
$description = trim($_POST["description"] ?? "");

if ($id <= 0 || $category_id <= 0 || $name === "") fail("ID, kategori, nama wajib");

$stmt = $pdo->prepare("UPDATE products
  SET category_id=?, name=?, price=?, stock=?, image_url=?, description=?
  WHERE id=?");
$stmt->execute([$category_id, $name, $price, $stock, $image_url, $description, $id]);

ok([], "Produk berhasil diupdate");
