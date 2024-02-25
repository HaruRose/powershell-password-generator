# Password Generation Function
Function Generate-Password {
    Param(
        [Switch]$UpperCase,
        [Switch]$LowerCase,
        [Switch]$Digits,
        [int] $Length = 7, 
        [int] $Count = 1
    )

    $Passwords = @()
    $CharArray = @()

    # Building Char Arrays (ASCII Decimal to Char) 
    $UpperCaseCharArray = (66..72)+(74..75)+(77..90) | ForEach-Object {[char]$_} # Exclude I and L
    $LowerCaseCharArray = (97..104)+(106..107)+(109..122) | ForEach-Object {[char]$_} # Exclude i and l
    $DigitsCharArray = (50..57) | ForEach-Object {[char]$_} # Exclude 0 and 1
    
    # User Selection
    if ($UpperCase)  {$CharArray += $UpperCaseCharArray}
    if ($LowerCase)  {$CharArray += $LowerCaseCharArray}
    if ($Digits)     {$CharArray += $DigitsCharArray}

    # If no character type is selected, display an error message and stop the function
    if ($CharArray.Count -eq 0) {
        $Result.Items.Clear()
        $Result.Items.Add("Error: At least one character type must be selected.")
        return
    }

    For ($i=0 ; $i -lt $Count; $i++) {
        $Password = -join (Get-Random -Count $Length -InputObject $CharArray)
        # Ensure the last character is not a number or special character
        while ($Password[-1] -match "\d") {
            $Password = $Password.Substring(0, $Password.Length - 1) + (Get-Random -Count 1 -InputObject $CharArray)
        }
        $Passwords += $Password
    }

    $Passwords 
}

# GUI Script
Add-Type -AssemblyName PresentationFramework

# XAML Definition
[xml]$MainForm = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="Open-Source Password Generator by github.com/HaruRose" Height="300" Width="290" Background="White" Foreground="Black" ResizeMode="NoResize" WindowStartupLocation="CenterScreen">
    <Grid>
        <GroupBox Name="ParametersBox" Header="Parameters" HorizontalAlignment="Center" VerticalAlignment="Top" Margin="5,0,5,0">
            <StackPanel Orientation="Vertical" Height="52" VerticalAlignment="Top" Margin="10,5,10,5">
                <StackPanel Orientation="Horizontal" Height="26" Margin="0,0,0,0" HorizontalAlignment="Center">
                    <Label Name="lbl_length" Content="Length" Width="50" Padding="0,5" HorizontalContentAlignment="Left" ToolTip="Password Length"/>
                    <TextBox Name="Length" Width="55" Height="26" Text="8" TextWrapping="NoWrap" VerticalContentAlignment="Center" ToolTip="Password Length"/>
                    <Label Name="lbl_count" Content="Count" Padding="10,5"  Width="55" Height="26" HorizontalContentAlignment="Right" ToolTip="Number of different passwords to generate"/>
                    <TextBox Name="Count" Width="55" Height="26" Text="10" TextWrapping="NoWrap" VerticalContentAlignment="Center" ToolTip="Number of different passwords to generate"/>
                </StackPanel>
                <StackPanel Orientation="Horizontal" Height="15" Margin="0,10,0,0" HorizontalAlignment="Center">
                    <CheckBox Name="UpperCase" Content="A-Z" VerticalAlignment="Top" Height="15" Width="56" IsChecked="True" />
                    <CheckBox Name="LowerCase" Content="a-z" VerticalAlignment="Top" Height="15" Width="56" IsChecked="True"/>
                    <CheckBox Name="Digits" Content="0-9"  VerticalAlignment="Top" Height="15"  Width="56" IsChecked="True"/>
                </StackPanel>
            </StackPanel>
        </GroupBox>
        <Button Name="Generate" Content="Generate" Margin="10,90,10,0" VerticalAlignment="Top" Height="20"/>
        <ListBox Name="Result" Margin="10,120,10,10" Padding="5,2" Background="#FF363636" Foreground="White" ScrollViewer.VerticalScrollBarVisibility="Auto" />
    </Grid>
</Window>
"@

# Create Main Window
$XmlNodeReader = New-Object System.Xml.XmlNodeReader $MainForm
$MainWindow = [System.Windows.Markup.XamlReader]::Load($XmlNodeReader)

#Find all elements
$Generate = $MainWindow.FindName("Generate")
$Result = $MainWindow.FindName("Result")
$Length = $MainWindow.FindName("Length")
$Count = $MainWindow.FindName("Count")
$UpperCase = $MainWindow.FindName("UpperCase")
$LowerCase = $MainWindow.FindName("LowerCase")
$Digits = $MainWindow.FindName("Digits")

# Load settings from a hidden JSON file
$SettingsFile = ".\PasswordGeneratorSettings.json"
if (Test-Path $SettingsFile) {
    $Settings = Get-Content $SettingsFile | ConvertFrom-Json
    $Length.Text = $Settings.Length
    $Count.Text = $Settings.Count
    $UpperCase.IsChecked = $Settings.UpperCase
    $LowerCase.IsChecked = $Settings.LowerCase
    $Digits.IsChecked = $Settings.Digits
}

#Add OnClick Click Event to the "Generate" Button
$Generate.Add_Click({
    $Result.Items.Clear()
    $Passwords = Generate-Password -UpperCase:$UpperCase.IsChecked -LowerCase:$LowerCase.IsChecked -Digits:$Digits.IsChecked -Length $Length.Text -Count $Count.Text
    $Passwords | ForEach-Object { $Result.Items.Add($_) }
})

# Automatically copy the selected password to the clipboard
$Result.Add_SelectionChanged({
    $clipText = $Result.SelectedItem
    Set-Clipboard -Value $clipText
})

# Automatically generate passwords when the window is loaded
$MainWindow.Add_Loaded({
    $Result.Items.Clear()
    $Passwords = Generate-Password -UpperCase:$UpperCase.IsChecked -LowerCase:$LowerCase.IsChecked -Digits:$Digits.IsChecked -Length $Length.Text -Count $Count.Text
    $Passwords | ForEach-Object { $Result.Items.Add($_) }
})

# Save settings to a hidden JSON file when the window is closed
$MainWindow.Add_Closing({
    $Settings = @{
        Length = $Length.Text
        Count = $Count.Text
        UpperCase = $UpperCase.IsChecked
        LowerCase = $LowerCase.IsChecked
        Digits = $Digits.IsChecked
    }
    $Settings | ConvertTo-Json | Set-Content $SettingsFile -Force
    attrib +h $SettingsFile
})

$MainWindow.ShowDialog() | Out-Null
