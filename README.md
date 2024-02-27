![image](https://github.com/HaruRose/powershell-password-generator/assets/161178913/41998291-3055-4eda-a168-01189dcf0a14)

## How to use:

1. Using the [executable: download location on "releases" tab, click here](https://github.com/HaruRose/powershell-password-generator/releases/tag/download) 

### or

1. Using the powershell: Left click on the above this text .ps1 file or [here at releases page](https://github.com/HaruRose/powershell-password-generator/releases/tag/download), copy-paste the code in a .ps1 file or "download raw code".

2. In Windows file explorer, right click file -> "Open with..." "Choose another app.."

3. More apps -> Look for another app on this PC.. Select powershell from powershell windows location (C:\Windows\System32\WindowsPowerShell\v1.0 ) & check "Always use this app [..] for .ps1 files"


## Functions:

Fully open-source (un) secure password generator. 

Fully local.( XAML is not a URL, is a "namespace identifier and doesn't involve any network access". )

(Copied) Checkmark:  A-Z, a-z, 0-9.

Remembering settings and saving them in a .json file in appdata - by default, in folder path %appdata%..


Checkmark: never ends in special character or number(for Active Directory AD).

Checkmark:: "Don't repeat consecutively" (double characters). 

Checkmark: Special characters, checkmark for "Don't end with 0-9 and Special".

Checkmark: Passwords do not include hard to distinguish characters(0,O,o,I,l,1,0).

Checkmark: Don't repeat/double the same character consecutively.

Clicked passwords turn Orange. 

Clicked passwords are automatically copied to the clipboard

Automatically generate passwords when starting the app.

Various checks for scenarios that would crash the app(different checks - only selecting Numbers 0-9 and "dont end with 0-9", length, validity, no more than 5000 passwords or characters - last one is so you don't freeze the application for no reason. These were a pain to solve.

### Now available as an executable(ps2exe), that *works*.

Based on https://github.com/asm-code/powershell-password-generator, heavily modified:
