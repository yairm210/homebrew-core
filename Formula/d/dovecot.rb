class Dovecot < Formula
  desc "IMAP/POP3 server"
  homepage "https://dovecot.org/"
  url "https://dovecot.org/releases/2.4/dovecot-2.4.2.tar.gz"
  sha256 "2cd62e4d22b9fc1c80bd38649739950f0dbda34fbc3e62624fb6842264e93c6e"
  license all_of: ["BSD-3-Clause", "LGPL-2.1-or-later", "MIT", "Unicode-DFS-2016", :public_domain]

  livecheck do
    url "https://dovecot.org/releases/"
    regex(/v?(\d+(?:[._-]\d+)+)/i)
    strategy :page_match do |page, regex|
      major_minor = page.scan(regex)&.flatten&.last
      next if major_minor.blank?

      # Check the page for the newest major/minor version, which links to the
      # latest tarball (containing the full version in the file name)
      version_page = Homebrew::Livecheck::Strategy.page_content(
        URI.join("https://dovecot.org/releases/", major_minor).to_s,
      )
      next if version_page[:content].blank?

      version_page[:content].scan(regex)&.flatten&.last
    end
  end

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "7ee0d42eb5589016822004eca42ccf20be6811df08a1afc6789b732d8da0f369"
    sha256 arm64_sequoia: "d30709e7ecf049f407b9ca924a51f6d9aa201efa77b911936758be213ef75399"
    sha256 arm64_sonoma:  "141354a9aed401cc0eb78f30ca9b96603e39589ad020b7d4e89d184d47e0c97a"
    sha256 sonoma:        "21bf2f424e8ec257dea32b06a2b809de3e06b651a65462983fd97f9258f8973b"
    sha256 arm64_linux:   "19abd78ff29b936c1bd813225fdca2b1a1cb6afb3bbc906500e761eb9116421f"
    sha256 x86_64_linux:  "9118aafbb43e24aa3f46939bab11f8eee465732714e219406968afffa4b6272a"
  end

  depends_on "pkgconf" => :build
  depends_on "openldap"
  depends_on "openssl@3"

  uses_from_macos "bzip2"
  uses_from_macos "libxcrypt"
  uses_from_macos "sqlite"

  on_macos do
    # TODO: Remove dependencies with patches
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    # Backport fix for macOS build
    patch do
      url "https://github.com/dovecot/core/commit/0f3bd7404a5e09f087450255083a672a5f231a8a.patch?full_index=1"
      sha256 "b78cdee49eff5f18858fe1a32c33c8f58bba63b0824546c2d8b7f1b9c2f50e25"
    end
  end

  on_linux do
    depends_on "libtirpc"
    depends_on "linux-pam"
    depends_on "lz4"
    depends_on "xz"
    depends_on "zlib-ng-compat"
    depends_on "zstd"
  end

  resource "pigeonhole" do
    url "https://pigeonhole.dovecot.org/releases/2.4/dovecot-pigeonhole-2.4.2.tar.gz"
    sha256 "c2f90cf2a0154f94842ce0d8cafc81f282d0f98dfc3b51c3b7c2385c53316f97"

    livecheck do
      formula :parent
    end
  end

  # `uoff_t` and `plugins/var-expand-crypt` patches, upstream pr ref, https://github.com/dovecot/core/pull/232
  patch do
    url "https://github.com/dovecot/core/commit/bbfab4976afdf38a7fa966752de33481f9d2c2e5.patch?full_index=1"
    sha256 "f5a77eeaf5978b75a6c7d1d9d4b7623679aec047c3dae63516105774ae6c04de"
  end
  patch :DATA

  def install
    if OS.mac?
      odie "Remove workaround and autoreconf dependencies!" if version > "2.4.2"
      system "autoreconf", "--force", "--install", "--verbose"
      ENV.append "LIBS", "-liconv"
    end

    args = %W[
      --libexecdir=#{libexec}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-bzlib
      --with-ldap
      --with-pam
      --with-sqlite
      --without-icu
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"

    resource("pigeonhole").stage do
      args = %W[
        --with-dovecot=#{lib}/dovecot
        --with-ldap
      ]

      system "./configure", *args, *std_configure_args
      system "make"
      system "make", "install"
    end
  end

  def caveats
    <<~EOS
      For Dovecot to work, you may need to create a dovecot user
      and group depending on your configuration file options.
    EOS
  end

  service do
    run [opt_sbin/"dovecot", "-F"]
    require_root true
    environment_variables PATH: std_service_path_env
    error_log_path var/"log/dovecot/dovecot.log"
    log_path var/"log/dovecot/dovecot.log"
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/dovecot --version")

    cp_r share/"doc/dovecot/example-config", testpath/"example"
    (testpath/"example/dovecot.conf").write <<~EOS
      # required in 2.4
      dovecot_config_version = 2.4.0
      dovecot_storage_version = 2.4.0

      base_dir = #{testpath}
      listen = *
      ssl = no

      default_login_user = #{ENV["USER"]}
      default_internal_user = #{ENV["USER"]}

      # reference other conf files
      # !include conf.d/*.conf

      # same as 2.3
      log_path = syslog
      auth_mechanisms = plain
    EOS

    system bin/"doveconf", "-c", testpath/"example/dovecot.conf"
  end
end

__END__
diff --git a/src/lib-var-expand-crypt/Makefile.in b/src/lib-var-expand-crypt/Makefile.in
index 6c8b1ad..b721ad5 100644
--- a/src/lib-var-expand-crypt/Makefile.in
+++ b/src/lib-var-expand-crypt/Makefile.in
@@ -177,7 +177,11 @@ am__uninstall_files_from_dir = { \
 am__installdirs = "$(DESTDIR)$(moduledir)" \
 	"$(DESTDIR)$(pkginc_libdir)"
 LTLIBRARIES = $(module_LTLIBRARIES)
-var_expand_crypt_la_LIBADD =
+var_expand_crypt_la_LIBADD = \
+  ../lib/liblib.la \
+  ../lib-json/libjson.la \
+  ../lib-dcrypt/libdcrypt.la \
+  ../lib-var-expand/libvar_expand.la
 am_var_expand_crypt_la_OBJECTS = var-expand-crypt.lo
 var_expand_crypt_la_OBJECTS = $(am_var_expand_crypt_la_OBJECTS)
 AM_V_lt = $(am__v_lt_@AM_V@)
