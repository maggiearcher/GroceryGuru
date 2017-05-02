<?php

// Create connection
$con=mysqli_connect("localhost","thepawsn_maggie","groceryguru17","thepawsn_items");
 
// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

if($_SERVER['REQUEST_METHOD']=='POST'){

    //getting values
    $UPC = $_POST["UPC"];
    $Stock = $_POST["Stock"];
    
    echo json_encode($UPC);
    echo json_encode($Stock);
    
$UPC = mysqli_real_escape_string($con,$UPC);
$Stock = mysqli_real_escape_string($con,$Stock);

	echo json_encode($UPC);
    echo json_encode($Stock);

$sql = "UPDATE Items SET Stock = '$Stock' WHERE UPC = '$UPC'";

if (mysqli_query($con, $sql)) {
    echo "Record updated successfully";
} else {
    echo "Error updating record: " . mysqli_error($con);
}

// Close connections
mysqli_close($con);

}

?>
