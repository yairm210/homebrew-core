class Plutoprint < Formula
  include Language::Python::Virtualenv

  desc "Generate PDFs and Images from HTML"
  homepage "https://github.com/plutoprint/plutoprint"
  url "https://files.pythonhosted.org/packages/9b/a3/78151c5bc81abe3586ee09ef5ddd6ed193220641bfed10f1b07e467f8852/plutoprint-0.17.0.tar.gz"
  sha256 "361bb13f152c31d03023f91a0bc81706cda0637f795c43f5859725c1d94c9bb5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b18344be2134a76e5ef5d867693913b218da576681cfbbfab203b552633038c6"
    sha256 cellar: :any,                 arm64_sequoia: "8f0fcdc55db2428bd7359d6358b8d682fbbc881df6f0f57ed82897b77064baea"
    sha256 cellar: :any,                 arm64_sonoma:  "376306f1af47d5f7525d412a7260d96cdcec6b95dbf4c4289523d5d9d9b7f3f1"
    sha256 cellar: :any,                 sonoma:        "fccaae572319122325d9f092209191b04cb03b7c148b9d3d9dc3e85e3114750b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e6fa1df6ac3828ae8516cae0336c5632f719e5adb59d676886ed6766a28db3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5aa1e3d44d60de78cd075cc286a05cecbe94f18282a04819ff2a2e5bf16bc846"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "plutobook"
  depends_on "python@3.14"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1499
  end

  on_ventura do
    depends_on "llvm" => :build
  end

  on_linux do
    depends_on "patchelf" => :build
  end

  fails_with :clang do
    build 1499
    cause "Requires C++20 support"
  end

  fails_with :gcc do
    version "9"
    cause "requires GCC 10+"
  end

  def python3
    "python3.14"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/plutoprint --version")

    (testpath/"test.html").write <<~HTML
      <h1>Hello World!</h1>
    HTML

    system bin/"plutoprint", "test.html", "test.pdf"
    assert_path_exists testpath/"test.pdf"
  end
end
