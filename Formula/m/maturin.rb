class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v1.12.2.tar.gz"
  sha256 "fe5082a5dcbc36c98d9edace4dd8a6672e83cc1d1d069d8c77a07a618cc67959"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b3794611442f18ca96f43f99230476b924ba8bbcbbbe645cc33974c71f63e394"
    sha256 cellar: :any,                 arm64_sequoia: "c6915977122e6e2809825f02ef51df75700a1bd31c695a5433c5fa1ca2c94f73"
    sha256 cellar: :any,                 arm64_sonoma:  "cf99813d9613ec40159947eab88de9f35fc3d45b5951d7cfcc07fa415f28e6d3"
    sha256 cellar: :any,                 sonoma:        "109908b885651ce9da2a306c694f1a9ed76e63e7cf5ac80d804477992f74020b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "409b117764ba8b2755d854093aed307382048a53076d495682ed9ec5a375f91b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "917a4e3656c42cc9c9cb43a5cf28b50255b2d01672b43f60f2d44a0cab97cd3c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => [:build, :test]
  depends_on "python@3.14" => :test
  depends_on "xz"

  def install
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    if DevelopmentTools.clang_build_version >= 1500
      ENV.remove "HOMEBREW_LIBRARY_PATHS",
                 recursive_dependencies.find { |d| d.name.match?(/^llvm(@\d+)?$/) }
                                       .to_formula
                                       .opt_lib
    end

    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"maturin", "completions")

    python_versions = Formula.names.filter_map do |name|
      Version.new(name.delete_prefix("python@")) if name.start_with?("python@")
    end.sort

    newest_python = python_versions.pop
    newest_python_site_packages = lib/"python#{newest_python}/site-packages"
    newest_python_site_packages.install "maturin"

    python_versions.each do |pyver|
      (lib/"python#{pyver}/site-packages/maturin").install_symlink (newest_python_site_packages/"maturin").children
    end
  end

  test do
    python3 = "python3.14"
    system "cargo", "init", "--name=brew", "--bin"
    system bin/"maturin", "build", "-o", "dist", "--compatibility", "off"
    system python3, "-m", "pip", "install", "brew", "--prefix=./dist", "--no-index", "--find-links=./dist"
    system python3, "-c", "import maturin"
  end
end
