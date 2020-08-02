# Wohnungs-Job

## Installation

- Use Ruby >=2.5
- To send emails with this job, you must set all the variables in the `.env.sample` in your `.env`

### On Linux

Install the library first: `sudo apt-get install libnotify1` (And if that does not work. Try `sudo apt-get install libnotify`)

Run `bundle install --without mac`

### On MacOS

Install terminal-notifier: `brew install terminal-notifier`

Run `bundle install --without linux`

### On Windows

- Install RubyInstaller for [32-Bit](https://github.com/oneclick/rubyinstaller2/releases/download/rubyinstaller-2.4.4-2/rubyinstaller-devkit-2.4.4-2-x86.exe) or for [64-Bit](https://github.com/oneclick/rubyinstaller2/releases/download/rubyinstaller-2.4.4-2/rubyinstaller-devkit-2.4.4-2-x64.exe) with DevKit for Version 2.4.4
- Install MSYS with RubyInstaller
- execute `ridk install` and don't specify any options; just press Enter
- Then open Windows PowerShell and execute `Install-Module -Name BurntToast`
- In the PowerShell, execute `Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser` and also `Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope LocalMachine`
- Remember to install [Make](http://gnuwin32.sourceforge.net/downlinks/make.php) and [Grep](https://netix.dl.sourceforge.net/project/gnuwin32/grep/2.5.4/grep-2.5.4-setup.exe)
- Afterwards, add Make to your PATH: `"C:\Program Files (x86)\GnuWin32\bin"`
- Then install bundler with `gem install bundler`
- Finally, execute `bundle install --without mac, linux`
- The last step is to create a file in your user-directory (C:\Users\<your-user-name>) named `WohnungsSuche.bat` with this content:

  ```SHELL
  cd wohnungs-job
  rake wg:job
  ```

You can then press Windows-Key + R and type in the following command `cmd /k WohnungsSuche.bat` and press Enter. Done!

## Execution

- Execute using `bundle exec rake wg:job`
- Execute `bundle exec rake wg:job[email]` if you want to send emails instead of notifications
  - For this, execute `cp .env.local .env` and edit your `.env`-File accordingly
