<?php
require_once("../config/db.php");
require_once("../config/response.php");
require_once(__DIR__ . "/../config/auth.php");
require_admin();

$name = trim($_POST["name"] ?? "");
if ($name === "") fail("Nama kategori wajib diisi");

$stmt = $pdo->prepare("INSERT INTO categories(name) VALUES(?)");
$stmt->execute([$name]);

ok([], "Kategori berhasil ditambahkan");
