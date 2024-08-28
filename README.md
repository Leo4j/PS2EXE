# PS2EXE

Lighter version of [PS2EXE](https://github.com/MScholtes/PS2EXE)

```
iex(new-object net.webclient).downloadstring('https://raw.githubusercontent.com/Leo4j/PS2EXE/main/PS2EXE.ps1')
```

```
$script = Get-Content -Path c:\Users\User\Desktop\script.ps1 -Raw
```

```
$script = @'
<your script here>
'@
```

```
PS2EXE -content $script -outputFile C:\Users\User\Desktop\script.exe
```
