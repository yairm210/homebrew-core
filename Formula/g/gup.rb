class Gup < Formula
  desc "Update binaries installed by go install"
  homepage "https://github.com/nao1215/gup"
  url "https://github.com/nao1215/gup/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "3b321e8ca9bd3b2d217bf3a2530d9ffb063a747caf616456fa925d511765b2ae"
  license "Apache-2.0"
  head "https://github.com/nao1215/gup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e94a228bb81e1fb9bc41d9216ae5afd0703c90e7894862f55f0f5367a9933a71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e94a228bb81e1fb9bc41d9216ae5afd0703c90e7894862f55f0f5367a9933a71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e94a228bb81e1fb9bc41d9216ae5afd0703c90e7894862f55f0f5367a9933a71"
    sha256 cellar: :any_skip_relocation, sonoma:        "d177a0e60f55574e8430930743c738b3e541512334f27dd7744160791eb1888f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03647d809c66473dda522d000d5801b4feab673ab52a1213fe9e5be89004f7b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e79fa23b34360f2253f62f614cf1b6d80fefa9f8a19b0ccbf51be1c89330ac9"
  end

  depends_on "go"

  def install
    ldflags = "-s -w -X github.com/nao1215/gup/internal/cmdinfo.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    # upstream bug report on powershell completion support, https://github.com/nao1215/gup/issues/233
    generate_completions_from_executable(bin/"gup", shell_parameter_format: :cobra, shells: [:bash, :zsh, :fish])

    ENV["MANPATH"] = man1.mkpath
    system bin/"gup", "man"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gup version")

    ENV["GOBIN"] = testpath/"bin"
    (testpath/"bin").mkpath

    (testpath/"hello").mkpath
    (testpath/"hello/go.mod").write <<~EOS
      module example.com/hello
      go 1.22
    EOS
    (testpath/"hello/main.go").write <<~EOS
      package main
      import "fmt"
      func main() { fmt.Println("hello") }
    EOS

    cd testpath/"hello" do
      system "go", "install", "."
    end

    assert_match "hello: example.com/hello", shell_output("#{bin}/gup list")
    system bin/"gup", "remove", "--force", "hello"
    refute_path_exists testpath/"bin/hello"
  end
end
