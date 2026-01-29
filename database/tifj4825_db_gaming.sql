-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jan 29, 2026 at 12:04 PM
-- Server version: 10.11.15-MariaDB-cll-lve
-- PHP Version: 8.4.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `tifj4825_db_gaming`
--

-- --------------------------------------------------------

--
-- Table structure for table `articles`
--

CREATE TABLE `articles` (
  `id` int(11) NOT NULL,
  `title` varchar(150) NOT NULL,
  `body` text NOT NULL,
  `image_url` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `articles`
--

INSERT INTO `articles` (`id`, `title`, `body`, `image_url`, `created_at`) VALUES
(1, 'Tips Memilih Mouse Gaming', 'Pilih sensor bagus, grip nyaman, dan DPI sesuai kebutuhan.', 'https://picsum.photos/600/300?1', '2026-01-22 03:32:55'),
(2, 'Mengenal Mechanical Keyboard', 'Switch linear/tactile/clicky punya feel berbeda.', 'https://picsum.photos/600/300?2', '2026-01-22 03:32:55'),
(3, 'teszttest', 'test', 'https://www.dbs.id/id/iwov-resources/images/blog/8-Ide-Kamar-Gaming-yang-Asyik-1404x630.jpg', '2026-01-22 14:31:28'),
(4, 'ssssswwwww', 'ssssssswwww', '', '2026-01-23 09:52:51'),
(5, 'test123', 'test123', 'https://plus.unsplash.com/premium_vector-1724312041532-ea6415aaf8c7?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1yZWxhdGVkfDR8fHxlbnwwfHx8fHw%3D', '2026-01-29 04:35:58');

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name` varchar(80) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`, `created_at`) VALUES
(1, 'Keyboard', '2026-01-22 03:32:55'),
(2, 'Mouse', '2026-01-22 03:32:55'),
(3, 'Monitor', '2026-01-22 03:32:55'),
(4, 'Headset', '2026-01-22 03:32:55'),
(5, 'PC', '2026-01-22 03:32:55');

-- --------------------------------------------------------

--
-- Table structure for table `chats`
--

CREATE TABLE `chats` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `sender` enum('user','admin') NOT NULL,
  `message` text NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `qty` int(11) NOT NULL DEFAULT 1,
  `total_price` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `user_id`, `product_id`, `qty`, `total_price`, `created_at`) VALUES
(1, 1, 1, 1, 100000, '2026-01-22 13:47:05'),
(2, 1, 1, 1, 100000, '2026-01-22 13:47:15'),
(3, 1, 1, 1, 100000, '2026-01-22 14:09:19'),
(4, 14, 3, 1, 10000000, '2026-01-25 05:49:47'),
(5, 15, 3, 1, 10000000, '2026-01-29 04:30:16'),
(6, 15, 1, 1, 100000, '2026-01-29 04:30:16');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `name` varchar(120) NOT NULL,
  `price` int(11) NOT NULL DEFAULT 0,
  `stock` int(11) NOT NULL DEFAULT 0,
  `image_url` text DEFAULT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `category_id`, `name`, `price`, `stock`, `image_url`, `description`, `created_at`) VALUES
(1, 3, 'ROG Strix Pulsar XG27AQNGV', 100000, 10, 'https://dlcdnwebimgs.asus.com/gain/EEE5E88C-D4DD-4563-A826-3C4E03531795/w717/h525/fwebp/w273', 'ROG Strix XG27ACMES-W Gaming Monitor – 27-inch 2560x1440, 255Hz OC (Above 144Hz), 0.3ms (min.), Fast IPS, Extreme Low Motion Blur Sync, USB Type-C, G-Sync compatible, DisplayWidget Center, tripod socket, HDR, Gaming AI', '2026-01-22 04:34:22'),
(3, 1, 'Keyboard Gaming JETEX KBX1 Series', 10000000, 10, 'https://jete.id/wp-content/uploads/2023/05/Deskripsi-Keyboard-Gaming-JETEX-KBX1-desc.jpg', 'mantap', '2026-01-25 05:48:46'),
(4, 3, 'ROG SWIFT 360Hz PG259QN', 100000, 5, 'https://dlcdnwebimgs.asus.com/gain/A5F4A546-2784-48CE-989A-56CA51CCB6C8/w717/h525/fwebp', 'monitor asus', '2026-01-29 04:41:38');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(120) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `role` enum('admin','user') NOT NULL DEFAULT 'user'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password_hash`, `created_at`, `role`) VALUES
(1, 'tester', 'tester@gmail.com', '$2y$10$PbeyQ09pbbFBqqzwyBXY9eXjMx8BXkpx1jfL89oInsOuJY7X1GZr.', '2026-01-22 04:30:08', 'user'),
(2, 'baim', 'baim@gmail.com', '$2y$10$C4Vru.SyycYqv/WUPNjVaeCUZQWFieGbD7FnPxfLSehPQaxhTenJm', '2026-01-22 12:53:16', 'user'),
(3, 'Admin', 'admin@gmail.com', '$2y$10$6T6iJggsRQkGTLN0SSQ3YeEdQ/V6EWDiV0sl0nVEmr2n1s2FSjPni', '2026-01-22 13:00:45', 'admin'),
(4, 'Admin', 'admins@gmail.com', 'admin123', '2026-01-22 13:00:45', 'admin'),
(9, '123', '@gmail.com', '$2y$10$w4nG9oX/V.HqfaLu3Cwt1uVVKqKPFFdtTwl6e6jjg8YTvWLUqOYGq', '2026-01-23 09:09:35', 'user'),
(10, 'yudha', 'yudha', '$2y$10$AiDMNR6xWgQBPKE.H2iAM.Ab/8btCTF22o/dgZy7jZ88PRgJX2bf.', '2026-01-23 09:50:28', 'user'),
(11, 'test', 'test@gmail.com', '$2y$10$dHv1o943JkOzdd/avXtAY.Lpm.RTJmQ5P9l5atgRJ2b5He9xHIaku', '2026-01-23 09:50:59', 'user'),
(12, 'adasdasd', 'contoh@gmail.com', '$2y$10$8DvO0NZWXZSa6INRwmtDl.D38aVM/ZpMJz4wOODdO8oDCJZy9GRcS', '2026-01-25 05:47:28', 'user'),
(14, 'test', 'test123@gmail.com', '$2y$10$rpxHN222oYPKfCdfzJIzHuiz7OY/SVQpCcW5K4FQUWKq3wxT1HzrW', '2026-01-25 05:49:27', 'user'),
(15, 'test345', 'test345@gmail.com', '$2y$10$LcBpf1zFaB1rw7OHrmGUC.RT7ry.QBs7oP1yRAaw7EbRvv4YrtSPi', '2026-01-29 04:28:35', 'user');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `articles`
--
ALTER TABLE `articles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `chats`
--
ALTER TABLE `chats`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `category_id` (`category_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `articles`
--
ALTER TABLE `articles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `chats`
--
ALTER TABLE `chats`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `chats`
--
ALTER TABLE `chats`
  ADD CONSTRAINT `chats_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
