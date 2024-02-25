## How to use:

1.Select "generate-password.ps1"(above this text), right click, "save link as..."

2. Right click -> "Open with..."

3. More apps -> Look for another app on this PC.. Select powershell from powershell windows location (path in Windows 10: C:\Windows\System32\WindowsPowerShell\v1.0 ) & check "remember [..] for .ps1 files"


Fully open-source (un) secure password generator. 25 feb 24

Runs fully locally. The XAML is not a URL, is a "namespace identifier and doesn't involve any network access". 

Based code on https://github.com/asm-code/powershell-password-generator, heavily modified:

## Functions:

(Copied) Checkmarks for A-Z a-z 0-9.

Copying generated password by just selecting the password

Remembering settings and saving them in a .json file in the same folder.

Automatically generate passwords when app is loaded

Password never ends in special character or number(for Active Directory AD)

Checkmark for Special characters, checkmark for "Don't end with 0-9 and Special"

Passwords do not include hard to distinguish characters(0,O,o,I,l,1,0)

Checkmark & function for characters not to repeat or double.

Clicked passwords turn Orange. 

Various checks for scenarios that would crash the app(different checks - only selecting Numbers 0-9 and "dont end with 0-9", length, validity etc.. these were a pain to solve)

Function & checkmark for "Don't repeat consecutively".

Made into an executable
