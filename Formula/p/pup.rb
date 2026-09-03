class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://github.com/DataDog/pup/releases/download/v1.18.1/pup_1.18.1_source.tar.gz"
  sha256 "0f4ef7aa1cefa251226092414c8d86cda882150ca154be5ada311e88b7bb913b"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c37b4f5197a94a8effb101723665ad9551f86f84c7d832955996adbac74010e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8d705e5c17629f0d9be43febd8bd0b61a72f0f5aefbce029c5a9f2d451efd5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9918d3c511388bc43af4a5234c2a6868f54c72d4d706dd1bbd2035cb7ccbf666"
    sha256 cellar: :any,                 arm64_linux:   "f1539125fa9204025585222087e847b3b5e8fb7e46bd32322ac797df9f96f8b3"
    sha256 cellar: :any,                 x86_64_linux:  "27333b63b10347e1340c9eeede67802e81b38439de233d0347aff424d3cb59ca"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pup", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pup --version")
    assert_match "Use pup CLI or generate code", shell_output("#{bin}/pup skills list")
  end
end
