-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1
-- Час створення: Лис 26 2024 р., 13:45
-- Версія сервера: 10.4.32-MariaDB
-- Версія PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База даних: `lab5db`
--

-- --------------------------------------------------------

--
-- Структура таблиці `customer`
--

CREATE TABLE `customer` (
  `customer_id` int(11) NOT NULL,
  `customer_profile` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `customer_employee`
--

CREATE TABLE `customer_employee` (
  `customer_id` int(11) DEFAULT NULL,
  `employee_id` int(11) DEFAULT NULL,
  `service_request` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `employee`
--

CREATE TABLE `employee` (
  `employee_id` int(11) NOT NULL,
  `employee_info` text DEFAULT NULL,
  `request_form` text DEFAULT NULL,
  `service_manager_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп даних таблиці `employee`
--

INSERT INTO `employee` (`employee_id`, `employee_info`, `request_form`, `service_manager_id`) VALUES
(1, 'Інформація про робітника', 'Форма запиту', 1),
(2, 'Інформація про робітника', 'Форма запиту', 2);

-- --------------------------------------------------------

--
-- Структура таблиці `order`
--

CREATE TABLE `order` (
  `order_id` int(11) NOT NULL,
  `order_info` text DEFAULT NULL,
  `employee_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп даних таблиці `order`
--

INSERT INTO `order` (`order_id`, `order_info`, `employee_id`, `created_at`) VALUES
(1, 'firstorder', 1, '2024-11-26 12:40:46'),
(10, 'second', 2, '2024-11-26 12:40:46');

-- --------------------------------------------------------

--
-- Структура таблиці `order_info`
--

CREATE TABLE `order_info` (
  `order_info_id` int(11) NOT NULL,
  `order_id` int(11) DEFAULT NULL,
  `is_ready` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `postoffice`
--

CREATE TABLE `postoffice` (
  `post_office_id` int(11) NOT NULL,
  `order_list` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `servicemanager`
--

CREATE TABLE `servicemanager` (
  `service_manager_id` int(11) NOT NULL,
  `service_info` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Дамп даних таблиці `servicemanager`
--

INSERT INTO `servicemanager` (`service_manager_id`, `service_info`) VALUES
(1, 'Менеджер сервісу'),
(2, 'Менеджер сервісу');

-- --------------------------------------------------------

--
-- Структура таблиці `shipment`
--

CREATE TABLE `shipment` (
  `shipment_id` int(11) NOT NULL,
  `processed_order` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Індекси збережених таблиць
--

--
-- Індекси таблиці `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`customer_id`);

--
-- Індекси таблиці `customer_employee`
--
ALTER TABLE `customer_employee`
  ADD KEY `customer_id` (`customer_id`),
  ADD KEY `employee_id` (`employee_id`);

--
-- Індекси таблиці `employee`
--
ALTER TABLE `employee`
  ADD PRIMARY KEY (`employee_id`),
  ADD KEY `service_manager_id` (`service_manager_id`);

--
-- Індекси таблиці `order`
--
ALTER TABLE `order`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `idx_order_info` (`order_info`(768)),
  ADD KEY `idx_employee_id` (`employee_id`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- Індекси таблиці `order_info`
--
ALTER TABLE `order_info`
  ADD PRIMARY KEY (`order_info_id`),
  ADD KEY `order_id` (`order_id`);

--
-- Індекси таблиці `postoffice`
--
ALTER TABLE `postoffice`
  ADD PRIMARY KEY (`post_office_id`),
  ADD KEY `order_list` (`order_list`);

--
-- Індекси таблиці `servicemanager`
--
ALTER TABLE `servicemanager`
  ADD PRIMARY KEY (`service_manager_id`);

--
-- Індекси таблиці `shipment`
--
ALTER TABLE `shipment`
  ADD PRIMARY KEY (`shipment_id`),
  ADD KEY `processed_order` (`processed_order`);

--
-- AUTO_INCREMENT для збережених таблиць
--

--
-- AUTO_INCREMENT для таблиці `order`
--
ALTER TABLE `order`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Обмеження зовнішнього ключа збережених таблиць
--

--
-- Обмеження зовнішнього ключа таблиці `customer_employee`
--
ALTER TABLE `customer_employee`
  ADD CONSTRAINT `customer_employee_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`),
  ADD CONSTRAINT `customer_employee_ibfk_2` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`employee_id`);

--
-- Обмеження зовнішнього ключа таблиці `employee`
--
ALTER TABLE `employee`
  ADD CONSTRAINT `employee_ibfk_1` FOREIGN KEY (`service_manager_id`) REFERENCES `servicemanager` (`service_manager_id`);

--
-- Обмеження зовнішнього ключа таблиці `order`
--
ALTER TABLE `order`
  ADD CONSTRAINT `order_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`employee_id`);

--
-- Обмеження зовнішнього ключа таблиці `order_info`
--
ALTER TABLE `order_info`
  ADD CONSTRAINT `order_info_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `order` (`order_id`);

--
-- Обмеження зовнішнього ключа таблиці `postoffice`
--
ALTER TABLE `postoffice`
  ADD CONSTRAINT `postoffice_ibfk_1` FOREIGN KEY (`order_list`) REFERENCES `employee` (`employee_id`);

--
-- Обмеження зовнішнього ключа таблиці `shipment`
--
ALTER TABLE `shipment`
  ADD CONSTRAINT `shipment_ibfk_1` FOREIGN KEY (`processed_order`) REFERENCES `order` (`order_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
