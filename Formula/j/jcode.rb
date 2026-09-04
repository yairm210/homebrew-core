class Jcode < Formula
  desc "AI coding agent harness for the terminal"
  homepage "https://jcode.sh"
  url "https://github.com/1jehuang/jcode/archive/refs/tags/v0.81.6.tar.gz"
  sha256 "d0990e9d85afb467a24e1b293d805f4d22cef80785d7a7dad73d6bf8b3d843d7"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be5e53683f44270cd599743d1f82543fb2ed8df04a733abbc7d98c44b9fa98ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42b70455fb21c9595d7ef908c73e1670f08a593d401d2adfeafd9de1427b4fb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84472b94c99e5be7c16a6c7999edc7d5c588218f30a9fbd05a5934a82c5c0d15"
    sha256 cellar: :any,                 arm64_linux:   "710c2d7bb9f2c403335cce2125f2ecf456b60a66152c1cfff5e80cd4d2f69efe"
    sha256 cellar: :any,                 x86_64_linux:  "1dde72725d4176d4df05a1667070e23217ca7736ef09c0c2166412d95c349952"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Disable background auto-update by default
    inreplace "src/cli/args.rs",
              '#[arg(long, global = true, default_value = "true")]',
              '#[arg(long, global = true, default_value = "false")]'

    # Redirect `jcode update` to Homebrew
    inreplace "src/cli/dispatch.rs",
              "hot_exec::run_update()?;",
              'eprintln!("Please update jcode using: brew upgrade jcode");'

    system "cargo", "install", *std_cargo_args
    rm bin/"test_api"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jcode --version")
    assert_match "Please update jcode using: brew upgrade jcode", shell_output("#{bin}/jcode update 2>&1")

    system bin/"jcode-harness", "--cwd", testpath
    assert_match "alpha2", (testpath/"sample.txt").read
  end
end
