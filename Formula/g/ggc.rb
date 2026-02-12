class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://github.com/bmf-san/ggc/archive/refs/tags/v8.0.1.tar.gz"
  sha256 "ce9f4a1d014e553b0e4123658c7e90cd397c0716d2ce6927f94a50adf52d651b"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48b4ad8efc3c3afa15456b4dbb8c38c45c4f1188959486b5b2131f2da9200e01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48b4ad8efc3c3afa15456b4dbb8c38c45c4f1188959486b5b2131f2da9200e01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48b4ad8efc3c3afa15456b4dbb8c38c45c4f1188959486b5b2131f2da9200e01"
    sha256 cellar: :any_skip_relocation, sonoma:        "549ed3afad3f310d23c170196ec1321c2ca9622afc5940e6a107bfe4668217c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "599dd3a81d1dc4f57b7823725d5e472f7886f7171c6c05db8ac9a27b7de2329b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1235d2547af72004911142e868ad81f319e703d77097927d564a64cd9a0192af"
  end

  depends_on "go" => :build

  uses_from_macos "vim"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ggc version")
    assert_equal "main", shell_output("#{bin}/ggc config get default.branch").chomp
  end
end
