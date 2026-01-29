<?php
require_once("../config/db.php");
require_once("../config/response.php");
require_once(__DIR__ . "/../config/auth.php");
require_admin();


$id = intval($_POST["id"] ?? 0);
$name = trim($_POST["name"] ?? "");

if ($id <= 0 || $name === "") fail("ID & nama wajib diisi");

$stmt = $pdo->prepare("UPDATE categories SET name=? WHERE id=?");
$stmt->execute([$name, $id]);

ok([], "Kategori berhasil diupdate");
