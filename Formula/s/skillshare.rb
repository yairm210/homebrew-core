class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.11.7.tar.gz"
  sha256 "b85290a19a4422d595c7e55187987b33ef63b5425ac50ed30dc6527f94feb0cb"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "efbf22826f86e49ec416b28fa96cc3ffbdfd2c60f8e615a192b4f2b0605be7c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efbf22826f86e49ec416b28fa96cc3ffbdfd2c60f8e615a192b4f2b0605be7c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efbf22826f86e49ec416b28fa96cc3ffbdfd2c60f8e615a192b4f2b0605be7c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0202b640425e1379c38824412580ddb81cfc0b1e7a721ec729779ca1d8999c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8c67e779232ec4f5ddda437772ed76224154f885e4192598d9ab2e5fed7ce31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e01518545f70be4c403a477e00b1761873979a35285b353342b7d85893fc090a"
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
