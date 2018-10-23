# WohnungsJob

## Installation
  * Use Ruby 2.4.1

### On Linux

Use `bundle install --without mac`

### On MacOS

User `bundle install --without linux`

### On Windows
  * Install RubyInstaller for [32-Bit](https://github.com/oneclick/rubyinstaller2/releases/download/rubyinstaller-2.4.4-2/rubyinstaller-devkit-2.4.4-2-x86.exe) or for [64-Bit](https://github.com/oneclick/rubyinstaller2/releases/download/rubyinstaller-2.4.4-2/rubyinstaller-devkit-2.4.4-2-x64.exe) with DevKit for Version 2.4.4
  * Install MSYS with RubyInstaller
  * execute `ridk install` and don't specify any options; just press Enter
  * Then open Windows PowerShell and execute `Install-Module -Name BurntToast`
  * In the PowerShell, execute `Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser` and also ` Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope LocalMachine`
  * Remember to install Make [here](http://gnuwin32.sourceforge.net/downlinks/make.php)
  * Afterwards, add Make to your PATH: `"C:\Program Files (x86)\GnuWin32\bin"`
  * Then install bundler with `gem install bundler`
  * Finally, execute `bundle install --without mac, linux`
  * The last step is to create a file in your user-directory (C:\Users\<your-user-name>) named `WohnungsSuche.bat` with this content:
  ```SHELL
  cd wohnungs-job
  rake wg:job
  ```
  You can then press Windows-Key + R and type in the following command `cmd /k WohnungsSuche.bat` and press Enter. Done!

## Execution
  * Execute using `bundle exec rake wg:job`
