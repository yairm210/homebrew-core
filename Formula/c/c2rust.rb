class C2rust < Formula
  desc "Migrate C code to Rust"
  homepage "https://c2rust.com/"
  url "https://github.com/immunant/c2rust/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "c9c8a36332e8bcde0bb9739cec02bd5263c5b25b7300428d8c6a8af094160d98"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "02b162aef7ff29ffb882c721e04343c576f9bc49b6f4b9855f4eabb3c7ef49a3"
    sha256 cellar: :any,                 arm64_sequoia: "d9735069362304a255413ceac888da9a16f24550fc5bc00c7e5b51f4e18a273a"
    sha256 cellar: :any,                 arm64_sonoma:  "e34dbaa9defa0abdda3206a6d3573f01e7189c000164ddd38bdd15cd6c925c5e"
    sha256 cellar: :any,                 sonoma:        "948673e7583c5a65587427d3d395512b62680e7052317a309ab41212eedbf139"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa0c7fb22f978f82ae62ad7836e694d824b8a3aa5023288edbaef78ff0fc5430"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a44f295e493931b12b56000900bf345cba3616415b6d7007b7829f5b27af39c0"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "rust" => :build
  depends_on "llvm"

  def install
    system "cargo", "install", *std_cargo_args(path: "c2rust")

    pkgshare.install "examples"
  end

  test do
    cp_r pkgshare/"examples/qsort/.", testpath
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_EXPORT_COMPILE_COMMANDS=1"
    system "cmake", "--build", "build"
    system bin/"c2rust", "transpile", "build/compile_commands.json"
    assert_path_exists testpath/"qsort.c"
  end
end
