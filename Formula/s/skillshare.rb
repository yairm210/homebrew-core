class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.11.7.tar.gz"
  sha256 "b85290a19a4422d595c7e55187987b33ef63b5425ac50ed30dc6527f94feb0cb"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "502a50ccfea284493f279fcbe8577d12a0f36b50e612006d87b6981998badec4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "502a50ccfea284493f279fcbe8577d12a0f36b50e612006d87b6981998badec4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "502a50ccfea284493f279fcbe8577d12a0f36b50e612006d87b6981998badec4"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e12f7ed743e0ffabb51ef5761e5e3adf89ac56a10f0a5dcb1f058bae6a3059c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69828313c30f230fec33cea0f1052282db9e5fa43f6ee77b53b9ae52c35de7b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe63b3712ad9b1caea21a3ed5da389accef30630aacc63dcaa7b443fcc63e0a2"
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
