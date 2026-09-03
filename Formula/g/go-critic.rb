class GoCritic < Formula
  desc "Opinionated Go source code linter"
  homepage "https://go-critic.com"
  url "https://github.com/go-critic/go-critic/archive/refs/tags/v0.14.4.tar.gz"
  sha256 "03c19c7a0d1ed931ae1f2c227bd881725d520f4767ccbbac0085644f69069094"
  license "MIT"
  head "https://github.com/go-critic/go-critic.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9b91dd4268dcb70b12a7ad3782e20939e63fe4867838df07afb4dbd6d0d9644"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9b91dd4268dcb70b12a7ad3782e20939e63fe4867838df07afb4dbd6d0d9644"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9b91dd4268dcb70b12a7ad3782e20939e63fe4867838df07afb4dbd6d0d9644"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "899b0194642dc68d0419400f934f1f779c23b2c296c9322a5faaa224caefbc27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "faac973962087fad1f5a5f212a0f3fa9ef45798ff230782d2d021daefc282a74"
  end

  depends_on "go"

  patch do
    url "https://github.com/go-critic/go-critic/commit/0cd18ce8030e494780f72d6bf8db49cfe8ec0cda.patch?full_index=1"
    sha256 "e1b9934a2fb8c6ed675bbbd3e65a913cfe1c7514ad915b7a5b2b48c6fc18b44f"
    type :unofficial
    resolves "https://github.com/go-critic/go-critic/pull/1538"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=v#{version}"), "./cmd/go-critic"
    bin.install_symlink bin/"go-critic" => "gocritic"
  end

  test do
    assert_predicate bin/"gocritic", :symlink?
    assert_equal "go-critic", (bin/"gocritic").readlink.to_s

    (testpath/"main.go").write <<~GO
      package main

      import "fmt"

      func main() {
        str := "Homebrew"
        if len(str) <= 0 {
          fmt.Println("If you're reading this, something is wrong.")
        }
      }
    GO

    output_go_critic = shell_output("#{bin}/go-critic check main.go 2>&1", 1)
    assert_match "sloppyLen: len(str) <= 0 can be len(str) == 0", output_go_critic

    output_gocritic = shell_output("#{bin}/gocritic check main.go 2>&1", 1)
    assert_match "sloppyLen: len(str) <= 0 can be len(str) == 0", output_gocritic
  end
end
