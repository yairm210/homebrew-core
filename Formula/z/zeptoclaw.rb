class Zeptoclaw < Formula
  desc "Lightweight personal AI gateway with layered safety controls"
  homepage "https://zeptoclaw.com/"
  url "https://github.com/qhkm/zeptoclaw/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "8b3ce49e50929fdfd92aa488dd0484e256265547fd802d05750cb1168892fc2a"
  license "Apache-2.0"
  head "https://github.com/qhkm/zeptoclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4254d62b784493e1ef7fa7affee457242bba428cc695dfdda5753b1095e53837"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "105c349b62993182289bab8255265c06290cf63ee9f358ecb5c8725cc5bf20b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebe7c7af9db1b5fcaed44725323f95d5843c052e57586e22f6d7b82234e4eda6"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a6551e8728e397218991502057034e493710ae385b77dad1dcae008771abdd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "acbd5a393976ada02445c986098fc43c09ed4f7e0b0c4690d5b6cd7081b544fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a32f9f112d48badca40ba717156a40dad0d3df67f7dc93037ff10db4d89bf2fd"
  end

  depends_on "rust" => :build

  def install
    # upstream bug report on the build target issue, https://github.com/qhkm/zeptoclaw/issues/119
    system "cargo", "install", "--bin", "zeptoclaw", *std_cargo_args
  end

  service do
    run [opt_bin/"zeptoclaw", "gateway"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zeptoclaw --version")
    assert_match "No config file found", shell_output("#{bin}/zeptoclaw config check")
  end
end
