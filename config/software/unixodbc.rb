name "unixodbc"
version "2.3.11"

source url: "https://github.com/lurcher/unixODBC/releases/download/2.3.11/unixODBC-2.3.11.tar.gz",
        sha256: "d9e55c8e7118347e3c66c87338856dad1516b490fb7c756c1562a2c267c73b5c"

relative_path "unixODBC-2.3.11"

env = with_standard_compiler_flags(with_embedded_path)

build do
  command "./configure --prefix=#{install_dir}/embedded --enable-gui=no --enable-drivers=no --enable-iconv --with-iconv-char-enc=UTF8 --with-iconv-ucode-enc=UTF16LE", env: env
  command "make -j #{workers}", env: env
  command "make install", env: env
end
