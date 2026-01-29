<?php
require_once("../config/db.php");
require_once("../config/response.php");

$rows = $pdo->query("SELECT id,name,created_at FROM categories ORDER BY id DESC")->fetchAll(PDO::FETCH_ASSOC);
ok($rows, "List kategori");
