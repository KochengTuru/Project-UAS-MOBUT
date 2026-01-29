<?php
require_once(__DIR__ . "/../config/db.php");
require_once(__DIR__ . "/../config/response.php");
require_once(__DIR__ . "/../config/auth.php");
require_admin();

$sql = "SELECT o.id, o.qty, o.total_price, o.created_at,
               u.name AS user_name, u.email,
               p.name AS product_name
        FROM orders o
        JOIN users u ON u.id = o.user_id
        JOIN products p ON p.id = o.product_id
        ORDER BY o.id DESC";
$rows = $pdo->query($sql)->fetchAll(PDO::FETCH_ASSOC);

ok($rows, "Semua riwayat pembelian");
