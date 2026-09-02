class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://github.com/go-nv/goenv/archive/refs/tags/3.1.6.tar.gz"
  sha256 "d92a9e5a2d4859f79db3f746edda5a135f5fa5773b730bd64223090906f284c2"
  license "MIT"
  version_scheme 1
  # TODO: Uncomment when default branch is changed from 'master' to 'main'
  # head "https://github.com/go-nv/goenv.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f04fdebc8eae16e8d485162999ef53f5a64b9d0294c39e6d8fb4d54c2aadef9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f04fdebc8eae16e8d485162999ef53f5a64b9d0294c39e6d8fb4d54c2aadef9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f04fdebc8eae16e8d485162999ef53f5a64b9d0294c39e6d8fb4d54c2aadef9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccfdf52bfc063f5cca49c6dbcb9755d27a36e8ebe8c7edb1863c37693e367e9f"
    sha256 cellar: :any,                 x86_64_linux:  "024e2ef148dd81fb92e1653e9fcf963a8c68651e63fe34ea2cb42c432307867a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=#{tap&.user || "homebrew"}
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"goenv")
  end

  def caveats
    <<~EOS
      If you are upgrading from goenv v2, you may need to remove the stale shim:
        rm -f "${GOENV_ROOT:-$HOME/.goenv}/shims/goenv"
    EOS
  end

  test do
    ENV["GOENV_ROOT"] = testpath/".goenv"

    output = shell_output("#{bin}/goenv root")
    assert_equal testpath/".goenv", Pathname(output.chomp)
  end
end
