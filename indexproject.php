<?php
// Enable error display for debugging
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// Database connection
$host = "localhost";
$user = "laptopuser";
$password = "1318072007";
$database = "lab5db";

$conn = new mysqli($host, $user, $password, $database);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Add order
if (isset($_POST['add_order'])) {
    $order_info = $conn->real_escape_string($_POST['order_info']);
    $employee_id = intval($_POST['employee_id']);

    $stmt = $conn->prepare("INSERT INTO `order` (order_info, employee_id) VALUES (?, ?)");
    $stmt->bind_param("si", $order_info, $employee_id);
    $stmt->execute();
    $stmt->close();
    header("Location: indexproject.php");
    exit();
}

// Delete order
if (isset($_GET['delete_order'])) {
    $order_id = intval($_GET['delete_order']);

    $stmt = $conn->prepare("DELETE FROM `order` WHERE order_id = ?");
    $stmt->bind_param("i", $order_id);
    $stmt->execute();
    $stmt->close();
    header("Location: indexproject.php");
    exit();
}

// Update order
if (isset($_POST['update_order'])) {
    $order_id = intval($_POST['order_id']);
    $order_info = $conn->real_escape_string($_POST['order_info']);
    $employee_id = intval($_POST['employee_id']);

    $stmt = $conn->prepare("UPDATE `order` SET order_info = ?, employee_id = ? WHERE order_id = ?");
    $stmt->bind_param("sii", $order_info, $employee_id, $order_id);
    $stmt->execute();
    $stmt->close();
    header("Location: indexproject.php");
    exit();
}
// Пошук замовлень
if (isset($_GET['search_query'])) {
    $search_query = $conn->real_escape_string($_GET['search_query']);

    $stmt = $conn->prepare("SELECT * FROM `order` WHERE order_info LIKE ?");
    $search_term = "%{$search_query}%";
    $stmt->bind_param("s", $search_term);
    $stmt->execute();
    $result = $stmt->get_result();
} else {
    // Відображення всіх замовлень, якщо немає пошуку
    $result = $conn->query("SELECT * FROM `order`");
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Postal Office Management</title>
    <style>
        body { font-family: Arial, sans-serif; }
        .nav-button { margin: 10px; padding: 10px; background-color: #4CAF50; color: white; border: none; cursor: pointer; }
        .form-container { margin-top: 20px; }
        table { width: 100%; border-collapse: collapse; }
        table, th, td { border: 1px solid black; }
        th, td { padding: 10px; text-align: center; }
    </style>
</head>
<body>
    <h1>Postal Office Management System</h1>
    <img src="4-1920x1080-382d854384bb5eae3f40cde96726be82.webp" alt="Database Schema" style="width: 100%;">

    <div class="form-container">
        <h2>Add Order</h2>
        <form method="POST" action="indexproject.php">
            <input type="text" name="order_info" placeholder="Order Info" required>
            <input type="number" name="employee_id" placeholder="Employee ID" required>
            <button type="submit" name="add_order" class="nav-button">Add Order</button>
        </form>
    </div>

    <h2>Order List</h2>
<table>
    <tr>
        <th>Order ID</th>
        <th>Order Info</th>
        <th>Employee ID</th>
        <th>Actions</th>
    </tr>
    <?php
    while ($row = $result->fetch_assoc()) {
        $escaped_order_info = htmlspecialchars($row['order_info']);
        echo "<tr>
            <td>{$row['order_id']}</td>
            <td>{$escaped_order_info}</td>
            <td>{$row['employee_id']}</td>
            <td>
                <a href='?edit_order={$row['order_id']}'>Edit</a> | 
                <a href='?delete_order={$row['order_id']}' onclick='return confirm(\"Are you sure?\")'>Delete</a>
            </td>
        </tr>";
    }
    ?>
</table>

    <?php
    // Edit order form
    if (isset($_GET['edit_order'])) {
        $order_id = intval($_GET['edit_order']);
        $edit_result = $conn->prepare("SELECT * FROM `order` WHERE order_id = ?");
        $edit_result->bind_param("i", $order_id);
        $edit_result->execute();
        $edit_row = $edit_result->get_result()->fetch_assoc();
        $edit_result->close();
    ?>
    <div class="form-container">
        <h2>Edit Order</h2>
        <form method="POST" action="indexproject.php">
            <input type="hidden" name="order_id" value="<?php echo $edit_row['order_id']; ?>">
            <input type="text" name="order_info" value="<?php echo htmlspecialchars($edit_row['order_info']); ?>" required>
            <input type="number" name="employee_id" value="<?php echo $edit_row['employee_id']; ?>" required>
            <button type="submit" name="update_order" class="nav-button">Update Order</button>
        </form>
    </div>
    <?php } ?>
<div class="form-container">
    <h2>Search Orders</h2>
    <form method="GET" action="indexproject.php">
        <input type="text" name="search_query" placeholder="Search by Order Info" required>
        <button type="submit" class="nav-button">Search</button>
    </form>
</div>
</body>
</html>
<?php $conn->close(); ?>