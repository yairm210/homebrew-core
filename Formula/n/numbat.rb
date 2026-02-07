class Numbat < Formula
  desc "Statically typed programming language for scientific computations"
  homepage "https://numbat.dev/"
  url "https://github.com/sharkdp/numbat/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "db5d9c2c0ec113f6773c22e7c09c51c08a62a196ca28a2008ff11546c77297bb"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/numbat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2611ab81eeac8dcd7adf4088f05c58a1d53aaaeb3c12f1d886c4b705c510842"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eec03ffead194ae665d677a5c2651fe7c065be5c667b8137f13f13f35784fbc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0fa5a58437b9505052555122ad100067db1bb99b0dc211ca5dae5a91ec4860a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c09842f948a5f0afe89de501fc171aa12db744a06c645fd753ea41a84d2b8e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "866cf576a14265a23efe7e23f07d3cfe72cb9da4d71cdba6341d8b38cdbd811a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e0f6ab310cdb830e158a4a8de08f1fb55216b6cdb08681c14b667431c664f49"
  end

  depends_on "rust" => :build

  def install
    ENV["NUMBAT_SYSTEM_MODULE_PATH"] = "#{pkgshare}/modules"
    system "cargo", "install", *std_cargo_args(path: "numbat-cli")

    pkgshare.install "numbat/modules"
  end

  test do
    (testpath/"test.nbt").write <<~EOS
      print("pi = {pi}")
    EOS

    output = shell_output("#{bin}/numbat test.nbt")

    assert_equal "pi = 3.14159", output.chomp
  end
end
