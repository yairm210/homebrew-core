class Termshot < Formula
  desc "Creates screenshots based on terminal command output"
  homepage "https://github.com/homeport/termshot"
  url "https://github.com/homeport/termshot/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "40abea3c9ae604f3c2cdc7e2a623bf6063c6b1c504a70c5e3a1b8457dbdd2fbc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b554f5ee4c06d23ecb91fb30c2af1a732c0abfb83ac9103b740ad675744b47d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b554f5ee4c06d23ecb91fb30c2af1a732c0abfb83ac9103b740ad675744b47d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b554f5ee4c06d23ecb91fb30c2af1a732c0abfb83ac9103b740ad675744b47d"
    sha256 cellar: :any_skip_relocation, sonoma:        "53a4df99f413053ae921baca6a74d69b6130e329fe244c6cc9a52621a5872d38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e099cc1869a8d7776e05a442a50b4032f16dd043a80864289a9a5f1cce1d1c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adcb922c10f4e10cbfa64393ffcddc8f2e84690f4ac9b3c3126c637448b2efbf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/homeport/termshot/internal/cmd.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/termshot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/termshot --version")

    system bin/"termshot", "-f", "brew.png", "--", "termshot"
    assert_path_exists testpath/"brew.png"
  end
end
