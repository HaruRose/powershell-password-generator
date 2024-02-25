## How to use:

1. Using the [executable: Right click .exe above or this link, "save link as..."](https://github.com/HaruRose/powershell-password-generator/blob/5da1210393af9b697e81170eeec48588e0d1a840/Password%20Generator.exe)

### or

1. Using the powershell: right click, "Password Generator.ps1"(above this text), "save link as..."

2. In file explorer, right click file -> "Open with..."

3. More apps -> Look for another app on this PC.. Select powershell from powershell windows location (path in Windows 10: C:\Windows\System32\WindowsPowerShell\v1.0 ) & check "Always use this app [..] for .ps1 files"



## Functions:

Fully open-source (un) secure password generator. 

Fully local.( XAML is not a URL, is a "namespace identifier and doesn't involve any network access". )

(Copied) Checkmarks for A-Z a-z 0-9.

Copying generated password by just selecting (clicking) the password.

Remembering settings and saving them in a .json file in appdata - by default, in folder path %appdata%..

Automatically generate passwords when starting the app.

Password never ends in special character or number(for Active Directory AD).

Checkmark & function: "Don't repeat consecutively" (double characters). 

Checkmark for Special characters, checkmark for "Don't end with 0-9 and Special".

Passwords do not include hard to distinguish characters(0,O,o,I,l,1,0).

Clicked passwords turn Orange. 

Various checks for scenarios that would crash the app(different checks - only selecting Numbers 0-9 and "dont end with 0-9", length, validity etc.. these were a pain to solve)



### Now available as an executable(ps2exe), that *works*.

### Based on https://github.com/asm-code/powershell-password-generator, heavily modified:
