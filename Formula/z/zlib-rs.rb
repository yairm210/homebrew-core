class ZlibRs < Formula
  desc "C API for zlib-rs"
  homepage "https://github.com/trifectatechfoundation/zlib-rs/tree/main/libz-rs-sys-cdylib#libz-rs-sys-cdylib"
  url "https://github.com/trifectatechfoundation/zlib-rs/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "b811e5de0e8bd43607b164a88f6bae063dd2f19b7d25e588e47f3c32e983322e"
  license "Zlib"
  head "https://github.com/trifectatechfoundation/zlib-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "19c8f5a8517752b647ecd3b853cfb01fdb46925ab12ca02bd65047e5c786dbc6"
    sha256 cellar: :any,                 arm64_sequoia: "43b10da1eab03efcb0e50bc277ba3b72715503c0a247a50c0f74d5799a8e776b"
    sha256 cellar: :any,                 arm64_sonoma:  "b85b8863dc0cd2e5d2098219006b75dc2cf3dd0e54aa7e3085e577c1b490e373"
    sha256 cellar: :any,                 sonoma:        "70faedde8a81552d859b118a10b685acc23cd46ddd9cd44275fd47060c73a0a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63eaf5c1cddf341784563a182dfd1ba5ac2f2609b359a73a950b149e6267111f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "364aae1b5ac613cca65411bdbc01c1222b506a3d2c4a1eb5cf6fb93926ee9ea6"
  end

  depends_on "cargo-c" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat" => :test
  end

  def install
    # https://github.com/trifectatechfoundation/zlib-rs/tree/main/libz-rs-sys-cdylib#-cllvm-args-enable-dfa-jump-thread
    ENV.append_to_rustflags "-Cllvm-args=-enable-dfa-jump-thread"
    cd "libz-rs-sys-cdylib" do
      system "cargo", "cinstall", "--jobs", ENV.make_jobs.to_s, "--prefix", prefix, "--libdir", lib, "--release"
    end
  end

  test do
    # https://zlib.net/zlib_how.html
    resource "zpipe.c" do
      url "https://raw.githubusercontent.com/trifectatechfoundation/zlib-rs/refs/tags/v0.6.2/libz-rs-sys-cdylib/zpipe.c"
      sha256 "4fd3b0b41fb8da462d28da5b3e214cc6f4609205b38aaee1e20524b57124f338"
    end

    testpath.install resource("zpipe.c")
    ENV.append_to_cflags "-I#{Formula["zlib-ng-compat"].opt_include}" if OS.linux?
    system ENV.cc, "zpipe.c", *ENV.cflags.to_s.split, "-L#{lib}", "-lz_rs", "-o", "zpipe"

    text = "Hello, Homebrew!"
    compressed = pipe_output("./zpipe", text, 0)
    assert_equal text, pipe_output("./zpipe -d", compressed, 0)
  end
end
