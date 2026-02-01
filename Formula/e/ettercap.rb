class Ettercap < Formula
  desc "Multipurpose sniffer/interceptor/logger for switched LAN"
  homepage "https://ettercap.github.io/ettercap/"
  url "https://github.com/Ettercap/ettercap/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "1674c235b16b2048888b85a697697eb0c4e742f875fdaaef7acacc152568ad06"
  license "GPL-2.0-or-later"
  head "https://github.com/Ettercap/ettercap.git", branch: "master"

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "2244ce8f708f9889ff92f8861bbae03a92aac0a2cf7457bc0b334301f4bff2bd"
    sha256 arm64_sequoia: "6d98587a5e98e2db83bf85117ea496c15f114fab7d702459811591af756f3c7c"
    sha256 arm64_sonoma:  "a72d69fae20cd902444c9aed9ac7c2b34861319ffc2847b0ea2d23723bb8c181"
    sha256 sonoma:        "9c04bde58b1776e853b1b9092899d28d90270907cd644d889db1fc00f32f18d3"
    sha256 arm64_linux:   "8f7f88b2aa5083456ebaa7694d2ddafb83c46d0d8fad766e2ea4e583e3e0ffa0"
    sha256 x86_64_linux:  "e825ecc7c84a08331974048d31b39125c15c8d8d44d002744be0686a000a3b4a"
  end

  depends_on "cmake" => :build
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libmaxminddb"
  depends_on "libnet"
  depends_on "ncurses"
  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "curl"
  uses_from_macos "libpcap"
  uses_from_macos "zlib"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "cairo"
    depends_on "freetype"
    depends_on "pango"
  end

  def install
    args = %W[
      -DBUNDLED_LIBS=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath};#{rpath(source: lib/"ettercap")}
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
      -DENABLE_CURSES=ON
      -DENABLE_GTK=ON
      -DENABLE_IPV6=ON
      -DENABLE_LUA=OFF
      -DENABLE_PDF_DOCS=OFF
      -DENABLE_PLUGINS=ON
      -DGTK_BUILD_TYPE=GTK3
      -DGTK3_GLIBCONFIG_INCLUDE_DIR=#{Formula["glib"].opt_lib}/glib-2.0/include
      -DINSTALL_DESKTOP=ON
      -DINSTALL_SYSCONFDIR=#{etc}
    ]

    if OS.linux?
      # Fix build error on wdg_file.c: fatal error: menu.h: No such file or directory
      ENV.append_to_cflags "-I#{Formula["ncurses"].opt_include}/ncursesw"
      args << "-DPOLKIT_DIR=#{share}/polkit-1/actions/"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ettercap --version")
  end
end
