class Gup < Formula
  desc "Update binaries installed by go install"
  homepage "https://github.com/nao1215/gup"
  url "https://github.com/nao1215/gup/archive/refs/tags/v0.28.3.tar.gz"
  sha256 "1034788af0fb9049f4ad536a3f46c0dc3bd54ebcaa8df884bc897db5c47bc2d7"
  license "Apache-2.0"
  head "https://github.com/nao1215/gup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c43c614702f8e9d8ec477a5d9621e69aadf88f6fd24dc5833a1001aedf988777"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db550898df438a581b2708ef5e0cd702b145c64226b9c902929a3b4537a6ab57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80e5c3ae107730185f524de20aaed44e7e7a4527f7a361c235eecf755f189602"
    sha256 cellar: :any_skip_relocation, sonoma:        "25a887e8528e27e530fa28010482abc9d71d62513cf97744b2d301cf04f13bd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ceefab5209da52adaad495fbfc22f4f2a5c52791e56e2e2d2a4a5b89ee86e6f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ffd85743b6643f51fd8af7080aa028c45e8271503da24eed629635d89858109"
  end

  depends_on "go"

  def install
    ldflags = "-s -w -X github.com/nao1215/gup/internal/cmdinfo.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gup", shell_parameter_format: :cobra)

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
