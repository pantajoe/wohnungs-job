# WohnungsJob

## Installation
  * Use Ruby 2.4.1

### On Linux

Use `bundle install --without mac, windows`

### On MacOS

User `bundle install --without linux, windows`

### On Windows
  * Install RubyInstaller for [32-Bit](https://github.com/oneclick/rubyinstaller2/releases/download/rubyinstaller-2.4.4-2/rubyinstaller-devkit-2.4.4-2-x86.exe) or for [64-Bit](https://github.com/oneclick/rubyinstaller2/releases/download/rubyinstaller-2.4.4-2/rubyinstaller-devkit-2.4.4-2-x64.exe) with DevKit for Version 2.4.4
  * Install MSYS with RubyInstaller
  * execute `ridk install` and don't specify any options; just press Enter
  * Make sure, you have Python 3.6.5 installed; otherwise install it either for [64-Bit](https://www.python.org/ftp/python/3.6.5/python-3.6.5-amd64.exe) or for [32-Bit](https://www.python.org/ftp/python/3.6.5/python-3.6.5.exe)
  * Install the necessary libraries with `pip install pywin32` and `pip install win10toast`
  * Execute win32 post-install script with: `python %LocalAppData%\Programs\Python\Python36-32\Scripts\pywin32_postinstall.py -install`
  * Then execute `set RUBY_DLL_PATH=%PATH%`
  * Remember to install Make [here](http://gnuwin32.sourceforge.net/downlinks/make.php)
  * Afterwards, add Make to your PATH: `"C:\Program Files (x86)\GnuWin32\bin"`
  * Then install bundler with `gem install bundler`
  * Finally, execute `bundle install --without mac, linux`
  * The last step is to create a file in your user-directory (C:\Users\<your-user-name>) named `WohnungsSuche.bat` with this content:
  ```SHELL
  python C:\Users\<your-user-name>\AppData\Local\Programs\Python\Python36\Scripts\pywin32_postinstall.py -install
  cd wohnungs-job
  set RUBY_DLL_PATH=%PATH%
  rake wg:job
  ```
  You can then press Windows-Key + R and type in the following command `cmd /k WohnungsSuche.bat` and press Enter. Done!

## Execution
  * Execute using `bundle exec rake wg:job`
