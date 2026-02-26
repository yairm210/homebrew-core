class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/mediawiki/images/pgpool-II-4.7.1.tar.gz"
  sha256 "9ee55642dd4450191a6452a0aa6de6d1c5f717ac64cbca0b9367b7c5808ae142"
  license all_of: ["HPND", "ISC"] # ISC is only for src/utils/strlcpy.c

  livecheck do
    url "https://www.pgpool.net/mediawiki/index.php/Downloads"
    regex(/href=.*?pgpool-II[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256               arm64_tahoe:   "8232572a85b6da2a588cf5674cb60b588d1608e0e08a14c4894bd8ec8d8648ab"
    sha256               arm64_sequoia: "33ceddee4ad0f216203d28cdcfa1f20c493e7388ec19ee2f4aa9d7c241bbad99"
    sha256               arm64_sonoma:  "d0c0ad252f8db75b1961712ec63c08eaf796dfaffa2a7a1a42a67ce0077eebdb"
    sha256 cellar: :any, sonoma:        "65ab1234098c05900398ae0355dacd53c1ded1f0dcb19e0b85c38b9726af1506"
    sha256               arm64_linux:   "f0dd3870692dea75462866977c5022c759e952b87c3ab8b15c1d1ed8bc763436"
    sha256               x86_64_linux:  "33cca1bb5660395149f84e2323a8620aca7be972a3e7928f8be184de3e2d2832"
  end

  depends_on "libmemcached"
  depends_on "libpq"

  uses_from_macos "libxcrypt"

  def install
    # Workaround for use of `strchrnul`, which is not available on macOS
    inreplace "src/utils/pool_process_reporting.c",
              "*(strchrnul(status[i].value, '\\n')) = '\\0';",
              "char *p = strchr(status[i].value, '\\n');\nif (p) *p = '\\\\0';"

    system "./configure", "--sysconfdir=#{etc}",
                          "--with-memcached=#{Formula["libmemcached"].opt_include}",
                          *std_configure_args
    system "make", "install"

    # Install conf file with low enough memory limits for default `memqcache_method = 'shmem'`
    inreplace etc/"pgpool.conf.sample" do |s|
      s.gsub! "#pid_file_name = '/var/run/pgpool/pgpool.pid'", "pid_file_name = '#{var}/pgpool-ii/pgpool.pid'"
      s.gsub! "#log_directory = '/tmp/pgpool_logs'", "logdir = '#{var}/pgpool_logs'"
      s.gsub! "#memqcache_total_size = 64MB", "memqcache_total_size = 1MB"
      s.gsub! "#memqcache_max_num_cache = 1000000", "memqcache_max_num_cache = 1000"
    end
    etc.install etc/"pgpool.conf.sample" => "pgpool.conf"

    (var/"log").mkpath
    (var/"pgpool-ii").mkpath
  end

  service do
    run [opt_bin/"pgpool", "-nf", etc/"pgpool.conf"]
    keep_alive true
    log_path var/"log/pgpool-ii.log"
    error_log_path var/"log/pgpool-ii.log"
  end

  test do
    cp etc/"pgpool.conf", testpath/"pgpool.conf"
    system bin/"pg_md5", "--md5auth", "pool_passwd", "--config-file", "pgpool.conf"
  end
end
