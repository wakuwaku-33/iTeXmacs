<TeXmacs|1.0.7.3>

<style|tmweb>

<\body>
  <tmweb-current|Download|Windows><tmweb-title|Compiling Qt-<TeXmacs> under
  <name|Windows>|<tmweb-download-links>>

  <section|Download and install the build environment><label|install>

  In order to compile <TeXmacs> under <name|Windows>, you need <name|Qt>,
  <name|MinGW> and a certain number of libraries. We have simplified the
  installation procedure for these dependencies by creating a single zip-file
  which contains all necessary stuff. Thus, you first have to download (462
  Mb)

  <\quote-env>
    <hlink|<verbatim|ftp://ftp.texmacs.org/pub/TeXmacs/windows/qt/TmBuildEnv.zip>|ftp://ftp.texmacs.org/pub/TeXmacs/windows/qt/TmBuildEnv.zip>
  </quote-env>

  This file must be uncompressed in the directory <verbatim|C:\\>.
  Uncompression in other directories is not supported. Copy the file
  <verbatim|C:\\TmBuildEnv\\MSYS\\MSYS.lnk> to your desktop.

  <section|Download <TeXmacs>>

  Click on the <verbatim|MSYS> icon on your desktop in order to launch a Unix
  terminal and fetch the latest <name|Svn> version of <TeXmacs> as follows:

  <\shell-fragment>
    mkdir ~/texmacs

    cd ~/texmacs

    svn co svn://svn.savannah.gnu.org/texmacs/trunk/src

    svn co svn://svn.savannah.gnu.org/texmacs/trunk/doc
  </shell-fragment>

  You will also need to download the <TeXmacs> Windows fonts and uncompress
  them in the directory <verbatim|~/texmacs/src/TeXmacs>:

  <\shell-fragment>
    cd ~/texmacs/src/TeXmacs

    wget http://ftp.texmacs.org/TeXmacs/fonts/TeXmacs-windows-fonts-1.0-noarch.tar.gz

    tar -zxvf TeXmacs-windows-fonts-1.0-noarch.tar.gz
  </shell-fragment>

  <section|Compile <TeXmacs>>

  Go to the directory with the <TeXmacs> sources

  <\shell-fragment>
    cd ~/texmacs/src
  </shell-fragment>

  Configure using

  <\shell-fragment>
    ./configure --enable-qt \\

    \ \ CPPFLAGS="-I/usr/include" LDFLAGS="-L/usr/lib"
  </shell-fragment>

  Build <TeXmacs>

  <\shell-fragment>
    make WIN_BUNDLE
  </shell-fragment>

  Run

  <\shell-fragment>
    ~/texmacs/distr/TeXmacs-Windows/bin/texmacs.exe
  </shell-fragment>

  The first time you run <TeXmacs>, the program will crash. Subsequent runs
  should work fine.

  <section|Creation of an installer>

  After building <TeXmacs>, you can create an installer using

  <\shell-fragment>
    cd ~/texmacs/src/misc/windows

    iscc TeXmacs.iss
  </shell-fragment>

  The installer can be found at <verbatim|~/texmacs/distr/texmacs-installer.exe>.

  <tmdoc-copyright|2010|David Michel|Massimiliano Gubinelli|Joris van der
  Hoeven>

  <tmweb-license>
</body>

<\initial>
  <\collection>
    <associate|language|english>
  </collection>
</initial>