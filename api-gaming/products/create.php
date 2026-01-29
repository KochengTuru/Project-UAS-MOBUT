<?php
require_once("../config/db.php");
require_once("../config/response.php");

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

if ($category_id <= 0 || $name === "") fail("Kategori & nama wajib");

$stmt = $pdo->prepare("INSERT INTO products(category_id,name,price,stock,image_url,description)
                       VALUES(?,?,?,?,?,?)");
$stmt->execute([$category_id, $name, $price, $stock, $image_url, $description]);

ok([], "Produk berhasil ditambahkan");
