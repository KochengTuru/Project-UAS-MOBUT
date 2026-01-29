<?php
require_once("../config/db.php");
require_once("../config/response.php");

$category_id = intval($_GET["category_id"] ?? 0);

$sql = "SELECT p.id, p.name, p.price, p.stock, p.image_url, p.description,
               c.name AS category_name, p.category_id
        FROM products p
        JOIN categories c ON c.id = p.category_id";

$params = [];
if ($category_id > 0) {
  $sql .= " WHERE p.category_id = ?";
  $params[] = $category_id;
}

$sql .= " ORDER BY p.id DESC";

$stmt = $pdo->prepare($sql);
$stmt->execute($params);
$rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

ok($rows, "List produk");
