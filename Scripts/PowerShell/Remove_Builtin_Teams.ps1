# This command removes the built-in/personal version of MS Teams that commonly confuses end users.
Get-AppxPackage "*Teams*" -AllUsers | Remove-AppPackage -AllUsers
