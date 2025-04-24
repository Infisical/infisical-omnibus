name "freetds"
version "1.3.16"

source url: "https://www.freetds.org/files/stable/freetds-1.3.16.tar.gz",
        sha256: "bdf5b7427ab99b8065d15e22ca224dfcc34dde29473a02bc97fd53b3a3257517"

relative_path "freetds-1.3.16"

dependency "unixodbc"

env = with_standard_compiler_flags(with_embedded_path)

build do
  # Configure with unixODBC support
  command "./configure --prefix=#{install_dir}/embedded --with-tdsver=7.4 --enable-msdblib --with-unixodbc=#{install_dir}/embedded", env: env
  command "make -j #{workers}", env: env
  command "make install", env: env
end
