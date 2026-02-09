class LmSensors < Formula
  desc "Tools for monitoring the temperatures, voltages, and fans"
  homepage "https://github.com/hramrach/lm-sensors"
  url "https://github.com/hramrach/lm-sensors/archive/refs/tags/V3-6-2.tar.gz"
  version "3.6.2"
  sha256 "c6a0587e565778a40d88891928bf8943f27d353f382d5b745a997d635978a8f0"
  license any_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    rebuild 1
    sha256 arm64_linux:  "43d3fcb049210f0b67b6341f5e65645c69ddbfa3ecc8bf5926d612990f3fac35"
    sha256 x86_64_linux: "9edce5d98c2e1541cba56961443f4bdb01ea6ab8b7bfd8aa4515c7eec9d17541"
  end

  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on :linux

  def install
    args = %W[
      PREFIX=#{prefix}
      BUILD_STATIC_LIB=0
      MANDIR=#{man}
      ETCDIR=#{prefix}/etc
    ]
    system "make", *args
    system "make", *args, "install"
  end

  test do
    assert_match("Usage", shell_output("#{bin}/sensors --help"))
  end
end
