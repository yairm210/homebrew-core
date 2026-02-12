class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.4.8.22.tar.gz"
  mirror "https://www.torservers.net/mirrors/torproject.org/dist/tor-0.4.8.22.tar.gz"
  mirror "https://fossies.org/linux/misc/tor-0.4.8.22.tar.gz"
  sha256 "c88620d9278a279e3d227ff60975b84aa41359211f8ecff686019923b9929332"
  # Complete list of licenses:
  # https://gitweb.torproject.org/tor.git/plain/LICENSE
  license all_of: [
    "BSD-2-Clause",
    "BSD-3-Clause",
    "MIT",
    "NCSA",
  ]

  livecheck do
    url "https://dist.torproject.org/"
    regex(/href=.*?tor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "c3d7da589e8ecf357fe137351eb18fc21877604c7df573f4ea7fecb89a35bfdc"
    sha256 arm64_sequoia: "13624ea1b1b7efc3d1f5657e14f7fb06a2b21bd7dc03711cf7f6e1f3b3dc7d67"
    sha256 arm64_sonoma:  "97c7bd0e6a621ff52ccd1b8b88744b713c3d170a202261b18debb23e1e5d58a7"
    sha256 sonoma:        "66d4480cae4f2adf09b7a5cd1dd88f2b71cb274911b420bac05fbeaafbdda8a6"
    sha256 arm64_linux:   "9b8229fd016a5d857ddb388fa8b0e3c77a424f38f501cf98d51d454a391f73c3"
    sha256 x86_64_linux:  "20e0f3ec9c8a238b9fe99aa1594da0b6295bd12d50d720e337e2253af1c4dbd5"
  end

  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "libscrypt"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %W[
      --disable-silent-rules
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-openssl-dir=#{Formula["openssl@3"].opt_prefix}
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  service do
    run opt_bin/"tor"
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/tor.log"
    error_log_path var/"log/tor.log"
  end

  test do
    pipe_output("#{bin}/tor-gencert --create-identity-key --passphrase-fd 0")
    assert_path_exists testpath/"authority_certificate"
    assert_path_exists testpath/"authority_identity_key"
    assert_path_exists testpath/"authority_signing_key"
  end
end
