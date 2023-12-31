# Get JSON data from the clipboard as a single string
$jsonData = Get-Clipboard -Raw

# Convert JSON to PowerShell objects
$vertices = ($jsonData | ConvertFrom-Json)

# Define the scaling factor
$sF = 10  # You can adjust this value based on your needs

# Convert vertices to the desired format
$convertedVertices = foreach ($vertex in $vertices) {
    "({0}) * sF, ({1}) * sF," -f $vertex.x, $vertex.y
}

# Join the converted vertices into a single string
$outputText = $convertedVertices -join "`r`n"

# Display the result
$outputText