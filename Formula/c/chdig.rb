class Chdig < Formula
  desc "Dig into ClickHouse with TUI interface"
  homepage "https://github.com/azat/chdig"
  url "https://github.com/azat/chdig/archive/refs/tags/v26.2.2.tar.gz"
  sha256 "8c6b236fc25289dc447b235b0c71e2a245f6307cad4851fcacb21846c1bedb95"
  license "MIT"
  head "https://github.com/azat/chdig.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "551125cbed5a7e71c71e583e6ff8f7703e184931983ef6374556e48b3ef994ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7f544f04cd69976afef437fa5a4bb248b8f7866b12e0d3e32225690d8c01a93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3352d40c014ebe7dee4ecda44b2bac9adbd9c28de1c6c44ab1e907dc95854767"
    sha256 cellar: :any_skip_relocation, sonoma:        "ddebcf31de98e18893fa05ffc3586a7794cb4977f59be2610e27af93d2950db1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ceaef923b722fc4fbb0ffc10817211ac2321c71af15fdf3f2dcf1df0b6e82564"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12b85e93bca544b2fa9d7670fb6c6c99cd6bfbb67668149c4d23052640fee415"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"chdig", "--completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chdig --version")

    output = shell_output("#{bin}/chdig --url 255.255.255.255 dictionaries 2>&1", 1)
    assert_match "Error: Cannot connect to ClickHouse", output
  end
end
