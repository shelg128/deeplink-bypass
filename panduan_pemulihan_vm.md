# Panduan Pemulihan VM Terkunci (Bypass Proteksi DeepLink)

> [!IMPORTANT]
> **Tenang dan Jangan Panik.** 
> File-file penting Anda di dalam VM **aman dan tidak hilang**. Proteksi DeepLink (`rent_protect`) hanya membatasi program yang boleh dijalankan (*RestrictRun*) dan menyembunyikan desktop. Kebijakan ini **tidak menghapus data Anda**. 
> 
> *Jangan melakukan "Reinstall OS" or "Rebuild VM" di dashboard provider jika Anda memiliki data penting yang belum dibackup, karena proses tersebut akan menghapus seluruh data Anda. Gunakan metode bypass di bawah ini terlebih dahulu.*

---

## Metode 1: Bypass Menggunakan Steam Library (Skenario Utama)
Metode ini memanfaatkan hak akses Steam untuk meluncurkan Command Prompt (CMD) yang sudah disamarkan namanya.

### Langkah 1: Samarkan CMD di Steam
1. Buka aplikasi **Steam** di VM Anda.
2. Di pojok kiri bawah jendela Steam, klik **Add a Game** (Tambah Game) -> pilih **Add a Non-Steam Game...** (Tambah Game Non-Steam).
3. Klik tombol **Browse** (Telusuri). Jendela penjelajah file Windows akan terbuka.
4. Pada kolom alamat di atas atau navigasi folder, buka folder: 
   `C:\Windows\System32`
5. Cari file **`cmd.exe`**. 
6. **Klik kanan** pada `cmd.exe` tersebut, lalu pilih **Copy** (Salin).
7. Navigasikan ke folder lain yang bisa Anda akses (misalnya folder **Downloads** atau **Documents**).
8. Klik kanan di area kosong di dalam folder tersebut, lalu pilih **Paste** (Tempel).
9. **Klik kanan** pada file `cmd` hasil salinan di folder Downloads/Documents tersebut, pilih **Rename** (Ubah nama), lalu ubah namanya menjadi:
   `chrome.exe` (atau `steam.exe`)
   *(Nama ini digunakan karena kedua program ini diizinkan berjalan oleh sistem).*
10. Masih di jendela telusuri Steam, pilih file **`chrome.exe`** (CMD samaran) yang ada di folder Downloads/Documents tersebut, lalu klik **Open** (Buka).
11. Klik tombol **Add Selected Programs** (Tambah Program Terpilih) pada jendela Steam.

### Langkah 2: Jalankan CMD dan Tempel Perintah Satu-Baris
1. Buka tab **Library** (Perpustakaan) di Steam Anda.
2. Cari program baru bernama **`chrome`** (atau `steam` sesuai nama yang Anda berikan tadi).
3. Klik tombol **Play** (Mainkan).
4. Jendela Command Prompt (CMD) akan terbuka.
5. **Salin dan Tempel (Paste)** perintah satu-baris berikut ke dalam jendela CMD, lalu tekan **Enter**:

```cmd
reg delete "HKCU\Software\Policies" /f & reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies" /f & cd /d "C:\Program Files (x86)\DeepLink\rent_protect" & call restore.bat & taskkill /F /IM explorer.exe & start explorer.exe
```

*Perintah di atas akan secara otomatis menghapus blokir registry, masuk ke folder DeepLink, menyalin kebijakan pemulihan, mematikan explorer yang terkunci, dan langsung memunculkan kembali Taskbar/Desktop Anda.*

---

## Metode 2: Menggunakan File Manager 7-Zip atau WinRAR (Jika Copy-Paste Windows Diblokir)
Jika Anda tidak bisa melakukan klik kanan atau copy-paste di jendela pencarian file Windows/Steam, Anda bisa menggunakan file manager bawaan program pengarsipan (seperti **7-Zip** atau **WinRAR**) yang biasanya terpasang pada VM.

1. Buka aplikasi **7-Zip File Manager** atau **WinRAR**.
   *(Jika aplikasi tersebut diblokir, salin aplikasinya ke folder lain dan ganti namanya menjadi `chrome.exe` agar bisa dibuka).*
2. Di dalam kolom alamat atas program 7-Zip/WinRAR, ketik `C:\Windows\System32` lalu tekan Enter.
3. Cari file **`cmd.exe`**.
4. Klik file `cmd.exe` tersebut, lalu tekan tombol **Ctrl + C** di keyboard (untuk menyalin).
5. Navigasikan alamatnya ke folder lain (seperti `C:\Users\Username\Downloads`).
6. Tekan tombol **Ctrl + V** untuk menempelkan file `cmd.exe`.
7. Klik kanan file hasil paste tersebut di dalam 7-Zip/WinRAR (atau tekan tombol **F2**), lalu ganti namanya menjadi **`chrome.exe`** atau **`steam.exe`**.
8. Klik dua kali file `chrome.exe` (CMD samaran) tersebut **langsung dari dalam program 7-Zip/WinRAR** untuk menjalankannya.
9. Setelah CMD terbuka, tempelkan perintah satu-baris yang sama pada **Metode 1 Langkah 2** di atas.

---

## Metode 3: Membuat Script Pemulih (.vbs) Lewat Console Chrome (Jika Steam Tidak Bisa Digunakan)
Jika Steam tidak terinstal atau menu Add Non-Steam Game diblokir, Anda bisa menggunakan VBScript yang dibuat langsung menggunakan console browser Chrome. Kami menyediakan **dua versi** script sesuai keinginan Anda:

### Versi A: Langsung Munculkan Explorer (Tanpa Reboot VM)
Script ini akan membersihkan proteksi, mematikan sisa proses pembatasan, dan **langsung membuka kembali Taskbar, Desktop, dan File Explorer Anda secara instan** tanpa perlu merestart VM.

1. Buka **Google Chrome** di VM Anda.
2. Tekan tombol **F12** (atau **Ctrl + Shift + I**) -> klik tab **Console**.
3. Salin dan tempel (paste) kode di bawah ini ke dalam Console, lalu tekan **Enter**:

```javascript
const code = `If Not WScript.Arguments.Named.Exists("elevate") Then
CreateObject("Shell.Application").ShellExecute "wscript.exe", """" & WScript.ScriptFullName & """ /elevate", "", "runas", 1
WScript.Quit
End If
On Error Resume Next
Set fso = CreateObject("Scripting.FileSystemObject")
Set shl = CreateObject("WScript.Shell")
source = "C:\\\\Program Files (x86)\\\\DeepLink\\\\rent_protect\\\\nopolicy\\\\GroupPolicy"
target = "C:\\\\Windows\\\\System32\\\\GroupPolicy"
fso.CopyFolder source, target, True
shl.RegDelete "HKCU\\\\Software\\\\Policies\\\\"
shl.RegDelete "HKCU\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Policies\\\\"
shl.RegDelete "HKLM\\\\Software\\\\Policies\\\\"
shl.Run "taskkill /F /IM explorer.exe", 0, True
WScript.Sleep 1000
shl.Run "explorer.exe", 1, False
MsgBox "Restored! Explorer has been restarted.", 64, "DeepLink Restore"`;

const blob = new Blob([code], {type: 'text/plain'});
const url = URL.createObjectURL(blob);
const a = document.createElement('a');
a.href = url;
a.download = 'restore_explorer.vbs';
document.body.appendChild(a);
a.click();
document.body.removeChild(a);
```
4. Chrome akan mengunduh file bernama **`restore_explorer.vbs`**. Double-click file tersebut di folder Downloads, lalu pilih **Yes** pada UAC. Desktop akan langsung muncul kembali!

### Versi B: Otomatis Restart VM (Sangat Bersih)
Script ini akan membersihkan proteksi dan **langsung memaksa VM melakukan restart/reboot** dalam 0 detik untuk memastikan seluruh kebijakan bersih dimuat kembali secara sempurna.

1. Buka **Google Chrome** di VM Anda.
2. Tekan tombol **F12** (atau **Ctrl + Shift + I**) -> klik tab **Console**.
3. Salin dan tempel (paste) kode di bawah ini ke dalam Console, lalu tekan **Enter**:

```javascript
const code = `If Not WScript.Arguments.Named.Exists("elevate") Then
CreateObject("Shell.Application").ShellExecute "wscript.exe", """" & WScript.ScriptFullName & """ /elevate", "", "runas", 1
WScript.Quit
End If
On Error Resume Next
Set fso = CreateObject("Scripting.FileSystemObject")
Set shl = CreateObject("WScript.Shell")
source = "C:\\\\Program Files (x86)\\\\DeepLink\\\\rent_protect\\\\nopolicy\\\\GroupPolicy"
target = "C:\\\\Windows\\\\System32\\\\GroupPolicy"
fso.CopyFolder source, target, True
shl.RegDelete "HKCU\\\\Software\\\\Policies\\\\"
shl.RegDelete "HKCU\\\\Software\\\\Microsoft\\\\Windows\\\\CurrentVersion\\\\Policies\\\\"
shl.RegDelete "HKLM\\\\Software\\\\Policies\\\\"
shl.Run "shutdown /r /t 0 /f", 0, True`;

const blob = new Blob([code], {type: 'text/plain'});
const url = URL.createObjectURL(blob);
const a = document.createElement('a');
a.href = url;
a.download = 'restore_restart.vbs';
document.body.appendChild(a);
a.click();
document.body.removeChild(a);
```
4. Chrome akan mengunduh file bernama **`restore_restart.vbs`**. Double-click file tersebut di folder Downloads, lalu pilih **Yes** pada UAC. VM akan langsung merestart secara otomatis.

---

## Metode 4: Memaksa Booting ke WinRE (Langkah Darurat Terakhir)
Jika Anda tidak bisa mengakses sistem Windows sama sekali namun masih bisa membuka dashboard web penyedia VM:

1. Buka **Web VNC Console** pada dashboard penyedia sewa VM Anda.
2. Klik tombol **Reset** / **Force Restart** pada dashboard web tersebut sebanyak **3 kali berturut-turut** sesaat setelah logo pemuatan Windows muncul.
3. Windows akan mendeteksi kegagalan booting dan masuk ke mode **Automatic Repair (WinRE)**.
4. Di layar biru VNC tersebut, pilih **Troubleshoot** -> **Advanced Options** -> **Command Prompt**.
5. Hapus folder kebijakan pemblokiran dengan mengetik perintah berikut di CMD WinRE:
   ```cmd
   rd /s /q C:\Windows\System32\GroupPolicy
   rd /s /q C:\Windows\System32\GroupPolicyUsers
   ```
   *(Ganti huruf drive `C:` dengan `D:` jika folder tidak ditemukan).*
6. Ketik `exit` lalu klik **Continue** untuk boot kembali ke Windows secara normal.
