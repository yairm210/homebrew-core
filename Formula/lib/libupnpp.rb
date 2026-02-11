class Libupnpp < Formula
  desc "C++ wrapper for libnpupnp"
  homepage "https://www.lesbonscomptes.com/upmpdcli/libupnpp-refdoc/libupnpp-ctl.html"
  url "https://www.lesbonscomptes.com/upmpdcli/downloads/libupnpp-1.0.3.tar.gz"
  sha256 "d3b201619a84837279dc46eeb7ccaaa7960d4372db11b43cf2b143b5d9bd322e"
  license "LGPL-2.1-or-later"
  head "https://framagit.org/medoc92/libupnpp.git", branch: "master"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "libnpupnp"

  uses_from_macos "curl"
  uses_from_macos "expat"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <libupnpp/log.hxx>
      #include <libupnpp/upnpplib.hxx>

      int main(void) {
        Logger::getTheLog("")->setLogLevel(Logger::LLERR);
        UPnPP::LibUPnP *mylib = UPnPP::LibUPnP::getLibUPnP();
        if (!mylib) {
          std::cerr << "Can't get LibUPnP" << std::endl;
          return 1;
        }
        if (!mylib->ok()) {
          std::cerr << "Lib init failed: " << mylib->errAsString("main", mylib->getInitError()) << std::endl;
          return 1;
        }
        return 0;
      }
    CPP

    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", "-L#{lib}", "-lupnpp"
    system "./test"
  end
end
