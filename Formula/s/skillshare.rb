class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "57758177df11ff323bea079ecfad4a6dbb6a632fd12cf7e8bbc04b10b786abbf"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91b787609bd4b70266fb90a19b6eac036aa807ba955869bfae4b62af7328c3b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91b787609bd4b70266fb90a19b6eac036aa807ba955869bfae4b62af7328c3b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91b787609bd4b70266fb90a19b6eac036aa807ba955869bfae4b62af7328c3b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ada20ce2beea3d425a4e0198ca160382cd9b6e42b6f0a0f7d2a4f777f866c89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4e7c271afae3b648cee7d2589d9ada8b380ccd43a0f1017b3167059a9e9e658"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18d7e4961c80d7800e13be291aeb60fc0e4cf350d7ad852d7844098b537647eb"
  end

  depends_on "go" => :build

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end
