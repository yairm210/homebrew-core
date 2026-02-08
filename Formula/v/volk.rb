class Volk < Formula
  include Language::Python::Virtualenv

  desc "Vector Optimized Library of Kernels"
  homepage "https://www.libvolk.org/"
  url "https://github.com/gnuradio/volk/releases/download/v3.3.0/volk-3.3.0.tar.gz"
  sha256 "89d11c8c8d4213b1b780354cfdbda1fed0c0b65c82847e710638eb3e21418628"
  license "LGPL-3.0-or-later"
  compatibility_version 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "0101fc34bd0194f1b696b1a18febd7e4e53784c9fac00bbd238839cebd818c80"
    sha256 cellar: :any,                 arm64_sequoia: "e11bbb09bdccdc73383832a358473a026e4e47df07403047173e0bc2a951ef19"
    sha256 cellar: :any,                 arm64_sonoma:  "c8a7cb1121c51fa06ac8c1549c1f3e51cc16f1eda40ef1234a4e83f24d0bd27d"
    sha256 cellar: :any,                 sonoma:        "71a9d3ea9e5aea62969977a769049643b60e8fcf60784dbb2baa7819072f8f8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e7a7b3d137b539988f0393dd47a6a4f118066252d1f2b06da93edb7a0eb9014"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f02bd47c23ba777669675e79e099e91047a23924cdb4a4f850a0fca6c19250c9"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "cpu_features"
  depends_on "fmt"
  depends_on "orc"
  depends_on "python@3.14"

  pypi_packages package_name:   "",
                extra_packages: "mako"

  resource "mako" do
    url "https://files.pythonhosted.org/packages/9e/38/bd5b78a920a64d708fe6bc8e0a2c075e1389d53bef8413725c63ba041535/mako-1.3.10.tar.gz"
    sha256 "99579a6f39583fa7e5630a28c3c1f440e4e97a414b80372649c0ce338da2ea28"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  def python3
    "python3.14"
  end

  def install
    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources
    ENV.prepend_path "PYTHONPATH", buildpath/"venv"/Language::Python.site_packages(python3)

    # Avoid falling back to bundled cpu_features
    rm_r(buildpath/"cpu_features")

    # Avoid references to the Homebrew shims directory
    inreplace "lib/CMakeLists.txt" do |s|
      s.gsub! "${CMAKE_C_COMPILER}", ENV.cc
      s.gsub! "${CMAKE_CXX_COMPILER}", ENV.cxx
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
                    "-DENABLE_TESTING=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"volk_modtool", "--help"
    system bin/"volk_profile", "--iter", "10"
  end
end
