class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.49.0.tar.gz"
  sha256 "84de08128e67fa459ea9647371b5746176eddb29bd7be3c91401c27103238daa"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a0dea57cbb61aace139d13b002a574a008a8c1c62e4f77aaf179fb2cc6d279e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b32173b5c01e9c0ae8ea8b4fcf0864f12f0c49208e5ae60d9594c613cd8390af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afc9c53dbe85a1fe2f5513ebf076313ecc5e7ad93dcf7621fcc382a5aa808cfb"
    sha256 cellar: :any,                 arm64_linux:   "89bfe47127cc828061afb141d146bd6383e3812a07857b6c2ee78bca39499eef"
    sha256 cellar: :any,                 x86_64_linux:  "b625183d09800382681c4058712ec5cda8509b7770795b5112fa1c9089263abc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end
