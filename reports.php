<?php
// Enable error display
ini_set('display_errors', 1);
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

// Handle report generation
$report_type = $_GET['report_type'] ?? '';
$report_data = [];

if ($report_type === 'orders_by_employee') {
    $stmt = $conn->prepare("SELECT employee_id, COUNT(*) as total_orders FROM `order` GROUP BY employee_id");
    $stmt->execute();
    $report_data = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
}

if ($report_type === 'orders_by_date') {
    $stmt = $conn->prepare("SELECT DATE(created_at) as order_date, COUNT(*) as total_orders FROM `order` GROUP BY order_date");
    $stmt->execute();
    $report_data = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reports - Postal Office Management</title>
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
    <h1>Generate Reports</h1>
    <form method="GET" action="reports.php">
        <label for="report_type">Select Report Type:</label>
        <select name="report_type" id="report_type" required>
            <option value="">--Select Report--</option>
            <option value="orders_by_employee">Orders by Employee</option>
            <option value="orders_by_date">Orders by Date</option>
        </select>
        <button type="submit" class="nav-button">Generate Report</button>
    </form>

    <?php if (!empty($report_data)) : ?>
        <h2>Report Results</h2>
        <table>
            <tr>
                <?php
                // Generate table headers dynamically
                foreach ($report_data[0] as $key => $value) {
                    echo "<th>" . ucfirst(str_replace('_', ' ', $key)) . "</th>";
                }
                ?>
            </tr>
            <?php
            // Generate table rows dynamically
            foreach ($report_data as $row) {
                echo "<tr>";
                foreach ($row as $value) {
                    echo "<td>" . htmlspecialchars($value) . "</td>";
                }
                echo "</tr>";
            }
            ?>
        </table>
    <?php endif; ?>
</body>
</html>
<?php $conn->close(); ?>