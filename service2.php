<?php

$host = "localhost";
$username = "quickfe2_admin";
$password = "AK&Elena2019!";
$dbname = "quickfe2_QuickFeed";

$link = mysqli_connect($host, $username, $password, $dbname);
$arr = array();

 if($link == true)
{
    //Displaying images from mysql 
    $select_image = "SELECT Image FROM Recipes";
    if (
    $sth = $link->query($select_image);
    $result=mysqli_fetch_array($sth);

    $var=mysqli_query($link,$select_image);

    echo "<table>";
        $desc = $row["Description"];

          echo "<tr>";//<td><b>$desc</b></td>";
          echo '<td><img src="data:image/jpeg;base64,'.base64_encode( $result['image'] ).'"/></td></tr>';
          echo "</table>";
}
else
{
    die("ERROR: Could not connect. " . mysqli_connect_error());
}


if($_SERVER['REQUEST_METHOD'] == "POST")
{
    $img = $_REQUEST['img'];
    $sql1 = "INSERT INTO images (image) VALUES ('$img')";
    if(mysqli_query($link, $sql1))
    {
        echo "Image added successfully.";
    } 
    else
    {
        echo "ERROR: Could not able to execute $sql1.mysqli_error($link)";
    }
}

mysqli_close($link);
?>
