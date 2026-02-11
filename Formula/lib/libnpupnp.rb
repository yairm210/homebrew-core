class Libnpupnp < Formula
  desc "C++ base UPnP library, derived from Portable UPnP, a.k.a libupnp"
  homepage "https://www.lesbonscomptes.com/upmpdcli/npupnp-doc/libnpupnp.html"
  url "https://www.lesbonscomptes.com/upmpdcli/downloads/libnpupnp-6.2.3.tar.gz"
  sha256 "563d2a9e4afe603717343dc4667c0b89c6a017008ac6b52262da17a1e4f6bb96"
  license "BSD-3-Clause"
  head "https://framagit.org/medoc92/npupnp.git", branch: "master"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "libmicrohttpd"

  uses_from_macos "curl"
  uses_from_macos "expat"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    pkgshare.install "test/test_init.cpp"
  end

  test do
    system ENV.cxx, "-std=c++17", pkgshare/"test_init.cpp", "-o", "test",
                    "-I#{include}/npupnp", "-L#{lib}", "-lnpupnp"
    output = shell_output("./test")
    assert_match "NPUPNP_VERSION_STRING = \"#{version}\"", output
    assert_match "UPnP Initialized OK", output
  end
end
