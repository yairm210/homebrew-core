class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/refs/tags/5.0.tar.gz"
  sha256 "ace8e2c771f9c30e55f1a5e8b2b180b09fe29133e6ed1738032a6a7c3f74b22d"
  license "MIT"
  head "https://github.com/mikebrady/shairport-sync.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "447c5c992c4ad4ff74c204130ac70dc7342d2a63afd2c7d0e04f70e3ffb67ea2"
    sha256 arm64_sequoia: "d0b40af6d6416eddfe8705ee6940d60c5393bd3059420b25efc4e2111fd840e8"
    sha256 arm64_sonoma:  "af03fcf8f24c90998351820f7ccc379467ff06fd38c2989a0fecd3274113d062"
    sha256 sonoma:        "00b4a040ab219ef15622f06046be96254b5033beebdf73d97a1f051c7029e66c"
    sha256 arm64_linux:   "6476dfec263694efd858ea866f95b5ad2e95c53624e80666014a9875c279e1ce"
    sha256 x86_64_linux:  "0ad387fee8205804b6325c8ef73d8c67d7f77cda6f75129f31f708c93e9c4c5b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "libao"
  depends_on "libconfig"
  depends_on "libdaemon"
  depends_on "libsoxr"
  depends_on "openssl@3"
  depends_on "popt"
  depends_on "pulseaudio"

  # patch to fix version string from 5.0rc0 to 5.0, upstream pr ref, https://github.com/mikebrady/shairport-sync/pull/2144
  patch do
    url "https://github.com/mikebrady/shairport-sync/commit/6c71105e98af30a9b157a1534d0bed82f4e49de6.patch?full_index=1"
    sha256 "67edc2bcb8b37a1fffacf7499d42c8abfe44a7af0312f7407f056b677d7681db"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    args = %W[
      --with-libdaemon
      --with-ssl=openssl
      --with-ao
      --with-stdout
      --with-pulseaudio
      --with-pipe
      --with-soxr
      --with-metadata
      --with-piddir=#{var}/run
      --sysconfdir=#{pkgetc}
    ]
    if OS.mac?
      args << "--with-dns_sd" # Enable bonjour
      args << "--with-os=darwin"
    end
    system "./configure", *args, *std_configure_args
    system "make", "install"

    (var/"run").mkpath
  end

  service do
    run [opt_bin/"shairport-sync", "--use-stderr", "--verbose"]
    keep_alive true
    log_path var/"log/shairport-sync.log"
    error_log_path var/"log/shairport-sync.log"
  end

  test do
    output = shell_output("#{bin}/shairport-sync -V")
    if OS.mac?
      assert_match "libdaemon-OpenSSL-dns_sd-ao-PulseAudio-stdout-pipe-soxr-metadata", output
    else
      assert_match "OpenSSL-ao-PulseAudio-stdout-pipe-soxr-metadata-sysconfdir", output
    end
  end
end
