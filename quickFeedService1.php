<?php
    
    
    
    // Create connection
    
    // Host, user, password, and database name
    
    $con = mysqli_connect("localhost","quickfe2_admin","AK&Elena2019!","quickfe2_QuickFeed");
    
    
    // Check connection
    //If there is error then output to browser
    if (mysqli_connect_errno()) {
        echo "Failed to connect to MySQL: " . mysqli_connect_error();
    }
    
    
    
    $type = &_GET["type"]
    $uID = &_GET["uID"]
    $lifestyleID = &_GET["lifestyleID"]
    
    
    
    // This SQL statement selects ALL from the table 'Recipes'
    
    if($type == "pullRecipes"){
        $sql = "SELECT r.RecipeID, RecipeName, Calories, CookingTime, Cuisine, LifeStyleID FROM Recipes r join LifeStyle_Recipes l on r.RecipeID = l.RecipeID;";
        
    }elseif ($type == "insertUser"){
        $sql = "insert into Registration values ('$uID','$lifestyleID');";
    }
    
    

    // Check if there are results
    
    if ($result = mysqli_query($con, $sql)) {
        
        // If so, then create a results array and a temporary one
        
        // to hold the data
        
        $resultArray = array();
        
        $tempArray = array();
        
        
        
        // Loop through each row in the result set
        
        while ($row = $result->fetch_object()) {
            
            // Add each row into our results array
            
            $tempArray = $row;
            
            array_push($resultArray, $tempArray);
            
        }
        
        
        
        // Finally, encode the array to JSON and output the results
        
        echo json_encode($resultArray);
        
    }
    
    
    
    // Close connections
    
    mysqli_close($con);
