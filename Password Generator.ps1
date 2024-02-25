Function Generate-Password {
    Param(
        [Switch]$UpperCase,
        [Switch]$LowerCase,
        [Switch]$Digits,
        [Switch]$SpecialChars,
        [Switch]$NoEndDigit,
        [Switch]$NoRepeat,
        [int] $Length = 7, 
        [int] $Count = 1
    )

    $Passwords = @()
    $CharArray = @()

    # Building Char Arrays (ASCII Decimal to Char) 
    $UpperCaseCharArray = if ($UpperCase) {(65..72)+(74..78)+(80..90) | ForEach-Object {[char]$_}} # Exclude I and O
    $LowerCaseCharArray = if ($LowerCase) {(97..107)+(109..122) | ForEach-Object {[char]$_}} # Exclude l and o
    $DigitsCharArray = if ($Digits) {(50..57) | ForEach-Object {[char]$_}} # Exclude 0 and 1
    $SpecialCharsCharArray = if ($SpecialChars) {(33..47)+(58..64)+(91..96)+(123..126) | ForEach-Object {[char]$_}} # Include all printable ASCII special characters

    # User Selection
    if ($UpperCase)  {$CharArray += $UpperCaseCharArray}
    if ($LowerCase)  {$CharArray += $LowerCaseCharArray}
    if ($Digits)     {$CharArray += $DigitsCharArray}
    if ($SpecialChars) {$CharArray += $SpecialCharsCharArray}

    # If no character type is selected, display an error message and stop the function
    if ($CharArray.Count -eq 0) {
        $Result.Items.Clear()
        $Result.Items.Add("Error: At least one character type must be selected.")
        return
    }

    # If "Don't end in 0-9 and Special" is selected but no letters are selected, display an error message and stop the function
    if ($NoEndDigit -and -not $UpperCase -and -not $LowerCase) {
        $Result.Items.Clear()
        $Result.Items.Add("Error: If 'Don't end in 0-9 and Special' is selected, at least one of 'A-Z' or 'a-z' must be selected.")
        return
    }

    For ($i=0 ; $i -lt $Count; $i++) {
        $Password = Get-Random -InputObject $CharArray
        for ($j=1; $j -lt $Length; $j++) {
            do {
                $nextChar = Get-Random -InputObject $CharArray
            } until (-not $NoRepeat -or $nextChar -ne $Password[-1])
            $Password += $nextChar
        }
        # Ensure the first and last characters are not a number or special character
        if ($NoEndDigit) {
            if ($Length -eq 1) {
                $Result.Items.Clear()
                $Result.Items.Add("Error: If 'Don't end in 0-9 and Special' is selected, 'Length' must be greater than 1.")
                return
            }
            while ($Password[-1] -match "\d" -or $Password[-1] -match "[\W]" -or $Password[0] -match "\d" -or $Password[0] -match "[\W]") {
                if ($UpperCase) {
                    $Password = (Get-Random -Count 1 -InputObject $UpperCaseCharArray) + $Password.Substring(1, $Password.Length - 2) + (Get-Random -Count 1 -InputObject $UpperCaseCharArray)
                } elseif ($LowerCase) {
                    $Password = (Get-Random -Count 1 -InputObject $LowerCaseCharArray) + $Password.Substring(1, $Password.Length - 2) + (Get-Random -Count 1 -InputObject $LowerCaseCharArray)
                }
            }
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
        Title="Open-Source Password Generator" Height="400" Width="290" Background="White" Foreground="Black" ResizeMode="NoResize" WindowStartupLocation="CenterScreen">
    <Grid>
 <GroupBox Name="ParametersBox" Header="github.com/HaruRose" HorizontalAlignment="Center" VerticalAlignment="Top" Margin="5,0,5,0" Height="200">
            <StackPanel Orientation="Vertical" Height="170" VerticalAlignment="Top" Margin="10,5,10,5">
                <StackPanel Orientation="Horizontal" Height="46" Margin="0,0,0,0" HorizontalAlignment="Center">
                    <Label Name="lbl_length" Content="Length" Width="50" Padding="0,5" HorizontalContentAlignment="Left" ToolTip="Password Length"/>
                    <TextBox Name="Length" Width="55" Height="26" Text="8" TextWrapping="NoWrap" VerticalContentAlignment="Center" ToolTip="Password Length"/>
                    <Label Name="lbl_count" Content="Count" Padding="10,5"  Width="55" Height="26" HorizontalContentAlignment="Right" ToolTip="Number of different passwords to generate"/>
                    <TextBox Name="Count" Width="55" Height="26" Text="10" TextWrapping="NoWrap" VerticalContentAlignment="Center" ToolTip="Number of different passwords to generate"/>
                </StackPanel>
                <StackPanel Orientation="Horizontal" Height="15" Margin="0,5,0,0" HorizontalAlignment="Center">
                    <CheckBox Name="UpperCase" Content="A-Z" VerticalAlignment="Top" Height="15" Width="56" IsChecked="True" />
                    <CheckBox Name="LowerCase" Content="a-z" VerticalAlignment="Top" Height="15" Width="56" IsChecked="True"/>
                    <CheckBox Name="Digits" Content="0-9"  VerticalAlignment="Top" Height="15"  Width="56" IsChecked="True"/>
                </StackPanel>
                <StackPanel Orientation="Horizontal" Height="15" Margin="0,5,0,0" HorizontalAlignment="Center">
                    <CheckBox Name="SpecialChars" Content="Special"  VerticalAlignment="Top" Height="15"  Width="56" IsChecked="True"/>
                </StackPanel>
                <StackPanel Orientation="Horizontal" Height="15" Margin="0,5,0,0" HorizontalAlignment="Center">
                    <CheckBox Name="NoEndDigit" Content="Don't end in 0-9 and Special"  VerticalAlignment="Top" Height="15"  Width="180" IsChecked="True"/>
                </StackPanel>
                <StackPanel Orientation="Horizontal" Height="15" Margin="0,5,0,0" HorizontalAlignment="Center">
                    <CheckBox Name="NoRepeat" Content="Don't repeat consecutively" VerticalAlignment="Top" Height="15" Width="180" IsChecked="True"/> <!-- Add this line -->
                </StackPanel>
            </StackPanel>
        </GroupBox>
 <Button Name="Generate" Content="Generate" Margin="10,150,10,0" VerticalAlignment="Top" Height="20" Width="80"/>
<ListBox Name="Result" Margin="15,180,15,15" Padding="5,2" Background="#FF363636" Foreground="White" ScrollViewer.VerticalScrollBarVisibility="Auto" Height="160">
            <ListBox.ItemContainerStyle>
                <Style TargetType="ListBoxItem">
                    <Style.Triggers>
                        <Trigger Property="IsSelected" Value="True">
                            <Setter Property="Foreground" Value="Orange"/>
                        </Trigger>
                    </Style.Triggers>
                </Style>
            </ListBox.ItemContainerStyle>
        </ListBox>
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
$SpecialChars = $MainWindow.FindName("SpecialChars")
$NoEndDigit = $MainWindow.FindName("NoEndDigit")
$NoRepeat = $MainWindow.FindName("NoRepeat")

# Create the settings file name based on the script name
$SettingsFile = ".\$($MyInvocation.MyCommand.Name -replace '\.[^.]*$', 'Settings.json')"


#Add OnClick Click Event to the "Generate" Button
$Generate.Add_Click({
    $Result.Items.Clear()
    $Passwords = Generate-Password -UpperCase:$UpperCase.IsChecked -LowerCase:$LowerCase.IsChecked -Digits:$Digits.IsChecked -SpecialChars:$SpecialChars.IsChecked -NoEndDigit:$NoEndDigit.IsChecked -NoRepeat:$NoRepeat.IsChecked -Length $Length.Text -Count $Count.Text
     $Passwords | ForEach-Object { $Result.Items.Add($_) }
})

# Automatically copy the selected password to the clipboard and change its color
$Result.Add_SelectionChanged({
    $clipText = $Result.SelectedItem
    Set-Clipboard -Value $clipText

    # Get the ListBoxItem that contains the selected content
    $selectedItem = $Result.ItemContainerGenerator.ContainerFromItem($Result.SelectedItem)
    if ($null -ne $selectedItem) {
        $selectedItem.Foreground = "Orange"
    }
})

# Automatically generate passwords when the window is loaded
$MainWindow.Add_Loaded({
    $Result.Items.Clear()
    $Passwords = Generate-Password -UpperCase:$UpperCase.IsChecked -LowerCase:$LowerCase.IsChecked -Digits:$Digits.IsChecked -SpecialChars:$SpecialChars.IsChecked -NoEndDigit:$NoEndDigit.IsChecked -NoRepeat:$NoRepeat.IsChecked -Length $Length.Text -Count $Count.Text
    $Passwords | ForEach-Object { $Result.Items.Add($_) }
})
if (Test-Path $SettingsFile) {
    $Settings = Get-Content $SettingsFile | ConvertFrom-Json
    $Length.Text = $Settings.Length
    $Count.Text = $Settings.Count
    $UpperCase.IsChecked = $Settings.UpperCase
    $LowerCase.IsChecked = $Settings.LowerCase
    $Digits.IsChecked = $Settings.Digits
    $SpecialChars.IsChecked = $Settings.SpecialChars
    $NoEndDigit.IsChecked = $Settings.NoEndDigit
    $NoRepeat.IsChecked = $Settings.NoRepeat
}
# Save settings to a hidden JSON file
function Save-Settings {
    $Settings = @{
        Length = $Length.Text
        Count = $Count.Text
        UpperCase = $UpperCase.IsChecked
        LowerCase = $LowerCase.IsChecked
        Digits = $Digits.IsChecked
        SpecialChars = $SpecialChars.IsChecked
        NoEndDigit = $NoEndDigit.IsChecked
        NoRepeat = $NoRepeat.IsChecked
    }
    $Settings | ConvertTo-Json | Set-Content $SettingsFile

    # Ensure the file is hidden
    Set-ItemProperty -Path $SettingsFile -Name Attributes -Value ([System.IO.FileAttributes]::Hidden)
}

# Then, call Save-Settings whenever a setting is modified
$Length.Add_TextChanged({Save-Settings})
$Count.Add_TextChanged({Save-Settings})
$UpperCase.Add_Click({Save-Settings})
$LowerCase.Add_Click({Save-Settings})
$Digits.Add_Click({Save-Settings})
$SpecialChars.Add_Click({Save-Settings})
$NoEndDigit.Add_Click({Save-Settings})
$NoRepeat.Add_Click({Save-Settings})


$MainWindow.ShowDialog() | Out-Null
